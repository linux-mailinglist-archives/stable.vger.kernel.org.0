Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D146A8F17
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 03:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCCCQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 21:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCCCQM (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 2 Mar 2023 21:16:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03D73B86E;
        Thu,  2 Mar 2023 18:16:11 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 322K41nw012588;
        Fri, 3 Mar 2023 02:15:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=YDE3WALRRHe8I0WUUJeyHEEvp2QgpUrS/DR/4OQ3WzI=;
 b=DFOU2jegSUlMeVhSLwuED1uR8eJxsSVtSZXzgGEgfNl6O3LmZ2unazghMo6PPTJp4WFc
 51S4aWpgVFjDjgJ63ZwWQVRAcX1R9EHFLxoCcBdxuoK2oXGIXCEVPprbPHzgQn9M8Xdp
 7UStEoHZbY0xg/EC1N6fCOOjjxCHYnidy8u+1hmrq+5JItycuqSB4NIac20eK/GKH2VO
 JEEK6w/FZAyF2DaNmESCcojTMP71uCiDIpu+IbeXuV7hpL0cOXcTvOjTLYQNIa1Ev598
 7+9sUKuAgl17WaVOPiAqnMjN61UEr3eoWoTnsQruMk87uFzw8yfV9U4Kz4bJkb+WDMT1 UQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb6enb6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Mar 2023 02:15:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32314HIU000577;
        Fri, 3 Mar 2023 02:15:55 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8savy1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Mar 2023 02:15:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihbMNdmSqom8kjFty0YpPPrjBCRoJg9tEIDcS8yyRpwDKZnuoYU//CmojyvKYy2rNVQQfotftHyg+4ZT2tI05+VqkZc7dAzWYll2eJ1jUfUQ0i41sFfPlNRMRNYH3Za803Za7WuzAKttt9ZCDE+AV9CH5nsy6jRGKJGBlc8dyX7Iz4AFPs8DItrYkK34/kNQL+0xeE/LL4BwR5FMYibv7hhsIS1orDgrITMa4ilZ+L+y4o+ryWE4hFAnyXurfP/m+I/RNA0frOKoMO1DJRfHV9KhMJ5trLlVQCLg0+eS0yBpo8NgEeoy0Meoy4ukEoKjbh6xwlvFG/aytBczJwGrpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDE3WALRRHe8I0WUUJeyHEEvp2QgpUrS/DR/4OQ3WzI=;
 b=m0lM57X14xLFO+pEd+wOPQizPnx9mJrtQWdqfuc2KMtq3+15NF9Ue18YAQuMtSEAmfWGq8NcfJGT97GKb5Qd9raLqOJlBOfzvJWcTLn7BaqFXFXr4lb7l/Ko4PlmbsNnrDB3gkPhf8bigbRHX1U5ud//ScXUKd2Cp8FoltRS7RCfTCVwIYAh9BRw/M18YbVVCWoq7DqFy6qJG1Jw+fkKoVgT/wlOEmyNqoHzww2xlRebk4P+nSeQHFyNN+zF86bDhYg0ZC/KlS76Wlut3MCWtHgNq/3r2goBB8Oaz5OvfJtYTT14hJG7YB8RvlY85avFB5nq+MnLgWPKjiJ3mZU5Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDE3WALRRHe8I0WUUJeyHEEvp2QgpUrS/DR/4OQ3WzI=;
 b=TOAOvXdOMn8tYGKnQl30zhPz1ETPZXzDr86EcJP9gFM4Uy4RENm7zRrvpoy3tifDfrrxSH5OfmHk+u8q/S49Zu3p38xWNm7dJlV0yqTalqf5UAwqGvyVbOUkBV6wDa06B5N+F7EVYJZVJlaQv5gK2LkjhnZaeCqXLcdIWWIqh8c=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CO1PR10MB4770.namprd10.prod.outlook.com (2603:10b6:303:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Fri, 3 Mar
 2023 02:15:46 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319%7]) with mapi id 15.20.6156.017; Fri, 3 Mar 2023
 02:15:46 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Snild Dolkow <snild@sony.com>
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>, Stable@vger.kernel.org
Subject: [PATCH 1/2] maple_tree: Fix mas_skip_node() end slot detection
Date:   Thu,  2 Mar 2023 21:15:39 -0500
Message-Id: <20230303021540.1056603-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0227.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::20) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|CO1PR10MB4770:EE_
X-MS-Office365-Filtering-Correlation-Id: 07a3cc3d-750e-49d4-780e-08db1b8d32f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bsRZADGHFYD/WrdqFZ1sJP9LT/tBerlIzBiiux7pPy5GEAoeC7N/vJvZMEBCRdpQgwwLw/bLY+jT772ZgTOI9PJfrLGxD6raV+AqO5UmSa3LmjiLPqezWg5pnSRfjuTvAHAZLDkgAss8/JDE/k1D0q/7UdaVZFFL+Shb+jje0kKhbKRReH2Mp5omMtn1F7beijA+JahcAnH5ycJ8imNsQtBG+XiAnpV/gmmudNwBtoJxLU/aQUvlv+R6H9xFveDgzWu0Of6k0pZcpe7N3Zu/UMsMyVgEBK3iDLfxikFFQhnpzAJAECfgDBN2b+sAM3Q09MpzK2suepDmSEq0uDYrjp3H+lM3+Dbw8ge3bsZTzRWpI35s8AjIC7wr5OmUWBQX285ziTi8QjRXsb4xT25tG5dJ5OV5JxgNPDAKu/5r2irBosb1Jq2poWOjWZeH7kVtFP80ifN6HpXxG1hFcJEAyiUkREQccbjXaUPmf57Q0QM2QC3qh4h8+F+rqKMxkBqUAbO4rOSYvL1g2kG+yVmv6hR6pHIFhM+LzxjB3Ci7nVdWrDGpsbfo+y7Mwr5yrYM2rACgVDK15ZfFMtLU7k+X3PnZDXi3gHmOz00SFJ3Z+e8ulpXQVXWJkbVyVdEX4ZTs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199018)(36756003)(6666004)(6506007)(966005)(6512007)(2616005)(1076003)(6486002)(26005)(41300700001)(316002)(110136005)(4326008)(66556008)(186003)(8676002)(2906002)(66476007)(478600001)(8936002)(5660300002)(86362001)(38100700002)(66946007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AiMgp3gnnpnU2B1Zf5LkboraDp5H3+3jqUAz4zTfj5QHjbgcc9ShPPl/zv1z?=
 =?us-ascii?Q?+3udtSJrV9A4tMb1xPMOcC3/ylJvXZRZzcmYvs1d301ruzHrVom4f7/BNk8R?=
 =?us-ascii?Q?602RNkNYDDQGBddmG8e1Z2IFWxKu8Dglh6Ngpg5nagbKLQLWb7LxTwNEaO71?=
 =?us-ascii?Q?313oNimOsU3Yor5PGIsskNPEVHDRYAc71i5WDVoiO3rb2l9fMfGSse9NjNX5?=
 =?us-ascii?Q?eWXmrLczmUt53UJ83tTz6xM9Jm0UbsgIvOXEYJhkrzYt0F3YNxj1Ti+N3o3j?=
 =?us-ascii?Q?mLDbuG2vv7kk4vl0cqU2QioOVXiHMyLA1qNWd/ZCtAqNw2tcDcHHA4lDkE5g?=
 =?us-ascii?Q?frjerYpirKQeu8GPx5oYODPT6rqoRuK3Ubx/NS4/sxwYlXdof86SP55ESiEd?=
 =?us-ascii?Q?L1VvupnPDYYjMies17BifRU2htrioBglZlUzMQmKUY2RqGfMCO5ExI6L6zDA?=
 =?us-ascii?Q?+EDc//oQbxZQJ8fRBDBJfzb2bS2Sqp+1y/j4v6JDYKEsapu0uT5Ibycohp3z?=
 =?us-ascii?Q?tN+ZNjm6EilmEDCNb4y8NdBPIMqqiZztM9IO2X2jv0nbYBiOBZHcBsW3Hzll?=
 =?us-ascii?Q?51VmeONAj+xTDVakKY18t5vKBkG2lrFQFsJaExKE3qt1Eo6PSh8Ojgw4r2UJ?=
 =?us-ascii?Q?Jb9zfzPT1NTEullW1DuJvK+leAw/I9uxejIuCn8fnK8QZpxQRZURUAjHvyde?=
 =?us-ascii?Q?wcdW1BZ5qt24BKlMzypsjemUWnahImcO0lT+4jo9WMriRt5XvQSTUDS+aE1h?=
 =?us-ascii?Q?it+p20m8zCzyf/vtRydqmp7O75/GrFau6/rvyxdG7SUCUUVhxvY0M6K9+964?=
 =?us-ascii?Q?D45IBDSncX3W9ftX6K0Fp45zjiF5ytmgFmRxSwq/qEVL+E7y5+CfV9suzBAS?=
 =?us-ascii?Q?XHBCBTVYAa7mXWCXyVOnCHT/jkd/bgJgJ0zqcWpBQoiygLAiTA3m12wzCHm0?=
 =?us-ascii?Q?v4yrK6wt7e82le2ZJ5ee5O44x7hNjL9sFRLLWSPG5natlAIRtYpQSn0KWFdB?=
 =?us-ascii?Q?KNT7J4e7hkxTChLnBbvW4ibkWab9qF4Q/9gaWdnOg0Ua6dpnGa+xivDCFw6/?=
 =?us-ascii?Q?UHjM5QAzIMpS2XOuZ69j1//UrrRzi4YZ6W5aVzGVJAe09RZ6wsMz/R8ILvSI?=
 =?us-ascii?Q?WpLV5qHvfvnl9NyOCHkJEOpnIy4uaaqmTmEXR182Dce+fa+T32+l+UVf2CRe?=
 =?us-ascii?Q?e/1AqcY/ZrnBJ/P5aJvbdERZeeR5siS8IeFnuDRjnq6Kq/vrcKiD5SrNUomn?=
 =?us-ascii?Q?6/JEq9AHs7BL0LZ5z5BTqPkvk00jP7TlG4TdEfBrE1Ua8hvETMmGIwUmQhot?=
 =?us-ascii?Q?HMBe4bDPexZekC/tZ/PZp+oIWthLk+SfaekLAGOT5ZOJuLq0nkd/1rddtJu3?=
 =?us-ascii?Q?uiYKYCBkSYWGvhg9tjSwTETH/njFhGPImHa/EXnT47bIC38BMfMexcWtJ4K8?=
 =?us-ascii?Q?6A4DoL+FGJuiAjO6gnTyRir9i+71ltsJS9dgBmcynK2i0gPKQCFOP/N3xZZC?=
 =?us-ascii?Q?14CSNs4JD3eaeKQLnuKEXKCMmwN1emo9R/0rZE0YmmFoIA0fjvlBeO/IpEcB?=
 =?us-ascii?Q?lWqiVZ54d/rIge/7g5PMNMn2B7L1EpqJ8N9/knGhHxEJyFrQCaO1TWZ4mWsT?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Cp6heSx+Z7BikkrEq5GSG2HIL5UgfbyABT4EOEr7Afxtdgfp3En8mCa4zIuyAct513VREdFVxyTd5Eo3WMVYA6gqH3lAgeTY4g8HJkWdxXYvfetHQI890XdPJ2JjtvXglnvh2w5cVVkNCGq93rLVeF3m/t02Kr00kWI4zX5tvnbq/6anah6znmbVvSzV4Kk5fHrEYY4H1mGloErT0baNduwpe4g/3wVfkF2vNiAkLfLom/4T3ZHwJ3QLHh0X5zv0hZjPL2k8UGQrVRX4J1Nff0gUP+f/qFOzZR0GVmGPF9gXU3dvt8TABlryTw1FHEmbYTqLKMGUIzO+TBH1cyyDXq2YtE5isGAsJnAb3tHNtEpCgjexF2BV54gu8cNJwWRYpa9Psb+FCgUINnAmYsAnnoKwyeyljq/Jd9e2iK2IQR7+7MvmYhgGDLWtYMqq1CmVAi7N2eJghdnkgOUIm6H9OhRY21Jlio0zTWNHUZPraZqbhmN3Oyu3n0tYuP0Vjz+v57XM5RNW5k93/mU+aMqxZ2njVQnWYOdHs4sGCEYg5fwr85reRZsvoZPE/r1FcjpFb6i0Y7nTwA0ryVttLgKs6095HEyH/NipaPwzWIATJOCe0OdUHk7tZ1EZ8Xo2jjjHhCXa7fx8juza0+HWFMXO5TrxtxGyIltSGF/QYh5uLCBYLuPcidn949s26C0bZmWIeAYxfkCeTw6gt6YroFHNbLmaxEm1RuHHm0ApOEYZmjqoLHpZfoBYcP54gpTIzWt6qSYTggmv1fMGjKuoUm1YGgRoy+7lxIDSH3vptJvzr/bwv4wAlVTo0m1OhHARnsDJJrNMuymiFjO1h59KkDxpRiCgfjV3D9CvXijdc09+HYD/ruK2yyaRgt1cKGqdVSsdxT3ckoe60MfR/Kr27yP39Or0P+apibLiAymcI1k/9YE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a3cc3d-750e-49d4-780e-08db1b8d32f4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 02:15:46.3215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yl3Ahr3ctmNi/3y9IVPQ6VNdWk0BSZprHfItBb2C9A0xyKjQSBd4qC1xf88Wl73bPIDdibbKITSI49Yrq8Atsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-03_01,2023-03-02_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303030017
X-Proofpoint-ORIG-GUID: nnRtIVLR-Oof6Q6iO2MNSfy3hW1WTQhO
X-Proofpoint-GUID: nnRtIVLR-Oof6Q6iO2MNSfy3hW1WTQhO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

mas_skip_node() is used to move the maple state to the node with a
higher limit.  It does this by walking up the tree and increasing the
slot count.  Since slot count may not be able to be increased, it may
need to walk up multiple times to find room to walk right to a higher
limit node.  The limit of slots that was being used was the node limit
and not the last location of data in the node.  This would cause the
maple state to be shifted outside actual data and enter an error state,
thus returning -EBUSY.

The result of the incorrect error state means that mas_awalk() would
return an error instead of finding the allocation space.

The fix is to use mas_data_end() in mas_skip_node() to detect the nodes
data end point and continue walking the tree up until it is safe to move
to a node with a higher limit.

mas_skip_node() may also be passed a maple state in an error state from
mas_anode_descend() when no allocations are available.  Return on such
an error state immediately.

Reported-by: Snild Dolkow <snild@sony.com>
Link: https://lore.kernel.org/linux-mm/cb8dc31a-fef2-1d09-f133-e9f7b9f9e77a@sony.com/
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 2be86368237d..2efe854946d6 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5188,34 +5188,29 @@ static inline bool mas_rewind_node(struct ma_state *mas)
  */
 static inline bool mas_skip_node(struct ma_state *mas)
 {
-	unsigned char slot, slot_count;
 	unsigned long *pivots;
 	enum maple_type mt;
 
-	mt = mte_node_type(mas->node);
-	slot_count = mt_slots[mt] - 1;
+	if (mas_is_err(mas))
+		return false;
+
 	do {
 		if (mte_is_root(mas->node)) {
-			slot = mas->offset;
-			if (slot > slot_count) {
+			if (mas->offset >= mas_data_end(mas)) {
 				mas_set_err(mas, -EBUSY);
 				return false;
 			}
 		} else {
 			mas_ascend(mas);
-			slot = mas->offset;
-			mt = mte_node_type(mas->node);
-			slot_count = mt_slots[mt] - 1;
 		}
-	} while (slot > slot_count);
+	} while (mas->offset >= mas_data_end(mas));
 
-	mas->offset = ++slot;
+	mt = mte_node_type(mas->node);
 	pivots = ma_pivots(mas_mn(mas), mt);
-	if (slot > 0)
-		mas->min = pivots[slot - 1] + 1;
-
-	if (slot <= slot_count)
-		mas->max = pivots[slot];
+	mas->min = pivots[mas->offset] + 1;
+	mas->offset++;
+	if (mas->offset < mt_slots[mt])
+		mas->max = pivots[mas->offset];
 
 	return true;
 }
-- 
2.39.2

