MATCH (n)
DETACH DELETE n

// Nodes
CREATE
(:Department { name:'guatemala', coordinates: [14.639788003038683, -90.51421192347037] }),
(:Department { name:'el progreso', coordinates: [14.88846558034191, -90.09440187162627] }),
(:Department { name:'sacatepéquez', coordinates: [14.554420344932474, -90.7465858784179] }),
(:Department { name:'chimaltenango', coordinates: [14.663531937760325, -90.8243380548989] }),
(:Department { name:'escuintla', coordinates: [14.178873256124566, -90.99525382989177] }),
(:Department { name:'santa rosa', coordinates: [14.167209701151515, -90.37761235627983] }),
(:Department { name:'sololá', coordinates: [14.76514949567497, -91.18100902540884] }),
(:Department { name:'totonicapán', coordinates: [14.91584067194991, -91.36148934132461] }),
(:Department { name:'quetzaltenango', coordinates: [14.851348204496961, -91.52597659085522] }),
(:Department { name:'suchitepéquez', coordinates: [14.49425922294234, -91.41249310491362] }),
(:Department { name:'retalhuleu', coordinates: [14.538264510999534, -91.69614337980022] }),
(:Department { name:'san marcos', coordinates: [15.06589053351376, -91.96206338444526] }),
(:Department { name:'huehuetenango', coordinates: [15.326206184921684, -91.49537917828538] }),
(:Department { name:'quiché', coordinates: [15.443927750643372, -90.95628660365149] }),
(:Department { name:'baja verapaz', coordinates: [15.057896636808197, -90.43625531659339] }),
(:Department { name:'alta verapaz', coordinates: [15.706451596046026, -90.12260413652844] }),
(:Department { name:'petén', coordinates: [16.953062721265628, -90.08915074367579] }),
(:Department { name:'izabal', coordinates: [15.385710411665839, -89.22723213709669] }),
(:Department { name:'zacapa', coordinates: [14.967568812097642, -89.5342064225304] }),
(:Department { name:'chiquimula', coordinates: [14.791028254837709, -89.54455335182057] }),
(:Department { name:'jalapa', coordinates: [14.638150123271346, -89.99467850857566] }),
(:Department { name:'jutiapa', coordinates: [14.28937046612785, -89.88155451133409] });

MATCH (n)
RETURN n;

// Proyección
CALL gds.graph.project(
'departments',
{
  Department: {
    properties: 'coordinates'
  }
  },
  '*'
  );
  
// Estimación
  CALL gds.kmeans.write.estimate('departments', {
    writeProperty: 'kmeans',
    nodeProperty: 'coordinates'
    })
    YIELD nodeCount, bytesMin, bytesMax, requiredMemory;
    
// Algoritmo
// 8 clusters, 8 regiones
    CALL gds.kmeans.stream('departments', {
      nodeProperty: 'coordinates',
      k: 8,
      randomSeed: 42
      })
      YIELD nodeId, communityId
      RETURN gds.util.asNode(nodeId).name AS name, communityId
       ORDER BY communityId, name ASC;
      
// 8 clusters, con centroides
      CALL gds.kmeans.stream('departments', {
        nodeProperty: 'coordinates',
        k: 8,
        seedCentroids: [
        [16.965799564613636, -90.02484182168669],
        [15.684710208018545, -91.18425649655819],
        [15.279618458967013, -90.16803646280628],
        [15.270706470758894, -89.31348779806036],
        [14.699560742433171, -91.53531432639976],
        [14.458511008671637, -90.89734318554417],
        [14.676555011043822, -90.50114932228927],
        [14.403966422079824, -90.03309676845691]
        ]
        })
        YIELD nodeId, communityId
        RETURN gds.util.asNode(nodeId).name AS name, communityId
         ORDER BY communityId, name ASC;
