Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845F06AEE11
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbjCGSJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbjCGSJI (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 7 Mar 2023 13:09:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BD99F209;
        Tue,  7 Mar 2023 10:03:22 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327Hwr1C002962;
        Tue, 7 Mar 2023 18:02:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=6s0l3HDKNdzvcW4dZNtRdto/h1oy6jZgebk5zhU8s2w=;
 b=v5Fm8ymf5Aiq5MZwyj6QiHwBcW8RqbEi3i/HarOGUvY3bGrfbhW1BGOJBhQQ3eMeVgiK
 rVw7XSQhZVKV867B3Uz/Lc3t1loIlqoxB7TZxP3PqC4wV1Ol30JQ6Z8MipZAx6FXgAE9
 kA11fP2Emb3rNuXPbnbUqMxBoHgyD85296XFaEEgV3jjGrI1kqo8PVYWfE8wj4lTCSzb
 jsWhqulU2lSrBPWrd86oc5S6vwMXpqWeSs5g/H09jZGqW0zrik9ycpE3c6AXcQVPeo0F
 t01hHstYPtri1fLaJDTG7HC349bNr4fWetlKZ/SCEWN7ogD/VncZM9tpKLiii9M45EPE Lg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418xx88y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 18:02:54 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 327H1vbW015924;
        Tue, 7 Mar 2023 18:02:52 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p4turnan1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 18:02:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+QBFDen/rkJolU+MfiVeyhVH4PN2CCfsjpqk4TOht2ldM4Av8IAXpsbxcSI3bxidWjtnaFgJ30floV9RCgCOMChKiZoTsWK9l88DS41q+kyZSligU8sJX7w0tTPmvQvDZpQ8ahRiYDGioA+U77rGUTCrb+PNYQLcb3wYNoU1f4970mAbcyUFY/uyvEr0m1zc3KQbIou0slX5/aFxai+Well5kyxU9PKb1SsVeXZCa+Kz+gwr8F3zwDhtt0TNkPys4jl95ZZIRoDeiepNTd6Dm8G5wPGSrRQyxE3FE0Zkx8Z3B9MKsHF0u94Gtv4RO14ixgZIFemekx4H2HLPjVTLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6s0l3HDKNdzvcW4dZNtRdto/h1oy6jZgebk5zhU8s2w=;
 b=Q3pEtzNwI6X0raNuma2F+tHW6y4JBwEI5bCtmwmHBrjQQ5T/HvgIIAZLmJtRlDqwt1ojJSGFTrqPMqpjypgyf+tnfBImGFmydwJM2yrQaGTTOy89cTzSBFyX+3mWqcpxLTleUVduSIzR6HRKBdD/LbEMWkrNNCRCgerXoY9BmrI+zdVWJRnY1eaoTqibReA8BDXvJtAs8nCBvwZdJB/80Mfhlrafay2x8mbZInwA7TCIxkkHccPkyHFl/bj2I6wHVbSbcNghi4XIHm1zl4rm4BW2jbotnIYy50/Zzwz1N0peqD393BPdx84DGM+vYlNWKPk8IT50W9+lpznpV7T3yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6s0l3HDKNdzvcW4dZNtRdto/h1oy6jZgebk5zhU8s2w=;
 b=ZP92NEQX3KO3k8kFerwOj7Lq+EbaIBBxirBJcqbZGaRBDEelGv7nxYb2mwWscV8y3mFS6f/06YpTKZDU8N33eIkyTbGLJqRQwBLRO8No/i4Cjs3zFPV4In1y8YdZIG3h4J04yxScdf5C+S/BKJei8HcJFF7+ojSSVg/cAzwv8Gw=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SA2PR10MB4650.namprd10.prod.outlook.com (2603:10b6:806:f9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 18:02:50 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319%7]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 18:02:50 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stable@vger.kernel.org, zhangpeng.00@bytedance.com, snild@sony.com
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 0/2] Fix mas_skip_node() for mas_empty_area()
Date:   Tue,  7 Mar 2023 13:02:45 -0500
Message-Id: <20230307180247.2220303-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0005.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::25) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SA2PR10MB4650:EE_
X-MS-Office365-Filtering-Correlation-Id: c205f2a5-a536-4ed5-3240-08db1f362a77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ihPHXI4yYgFqf6Igt0lxbL4Fv1YnbaAFbYRT8exooulT0oiQ+tclxrKKN98BRY1kgvhqKcR21+WwTAFbRiIl6uSyHtr1LsSSqWaVwMT2/A1wmz5owhvkkyEAjadhwbAyvGAForhYAlgysj3q7jxIKOm6PsjFlBJPlEOCokVFKSMoqyN7VauEpKZOMzvchvOfwshHjwWlQXr7EMZTITrB1dVLCHCHivs7jhbdN506dxCjy+a2l1EWWZ06yzn7d5811DBJO35G/JXhRBB6xxFkZ66s/5xYMc9KgmgsajvFdWBf/PPQBmEt2aZMRL6xnmk5duzBzn0lPuRvKVHn6ttoeja/oxDAZkF5IJNAJ4hleqaJ4dgB9+Wd6BRfNwXKDPmizUQ7VFZGPCMMSKr9/DhBDpLiML/XkfFMUv0OUDQeKsSxHbldSbMozx60Vjr/Ox04Pu0IszBvFA5dxNQIRi+i2dZaUAxLy5EEjNQWIlFU3lG2aHOB/Ot0ykEaIVzdicg6fpdQeN+xpEcTVeIE7tX2V9X/vAnyG3DSGhhx4dD05e06FcPMaFo1Z4ahGGuX+A7m+BiqlvOhmUtgFhMX5aqPHbDwAnCnJ94B7IVCjcdFlW7VGbGAeHYVqDg3LEIsFGud/Yaanl/AFmhi049dJC95Vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199018)(86362001)(36756003)(2616005)(4326008)(66946007)(8676002)(66556008)(66476007)(316002)(26005)(107886003)(6666004)(6506007)(1076003)(6512007)(6486002)(478600001)(83380400001)(186003)(38100700002)(5660300002)(41300700001)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TvERcB8XUs8VWmKjw4/yDyoxGgify/GG7OI0gCYevBTGNqs0a2DmhwzmJ0BW?=
 =?us-ascii?Q?CNNg/zX/12Lo+MZUFcKgml5NkW2RRW/jBd6xrDS2Fv0TGAREsFcbZYx14nW2?=
 =?us-ascii?Q?j0uhA3k0Mq9hZFAwJY2kSIM7L4oa97lkq8s5oeKxPZSpcpQ7QpqpVVC3SBkZ?=
 =?us-ascii?Q?NJKMe5e7CHPQNAgE7t2F2cIAKePiNuXJvrpnCEE5vo34u35YIM5NdfRXPicq?=
 =?us-ascii?Q?v+PrwADIWJKShobuTpSUeOsbT9Wad5w+99uDnqo5He9hefsMDpeeC8TZvXrm?=
 =?us-ascii?Q?YQZuzRXITMdh27epJEpjAJeyZKs0AE8AXPBATEkFUAkGZcETqzXBOgiqoiiv?=
 =?us-ascii?Q?OBXkFValSMEm9WjNHNsC0OBLc/5s0sIu+FumDiiglv7ZW30cGaiVbhrjojn9?=
 =?us-ascii?Q?PArQ3hgJw0xgPUDlwVS+YRl0uB3D1qGtofeFiIg5TBx7wVE1kSnoKcnfSji5?=
 =?us-ascii?Q?YUSlz/CFCI16fKPKdyspWYlGaLKS6dnBxrQPTw951Sf3v+S1v3DZJRdUqN5r?=
 =?us-ascii?Q?bY1V8UO5Jn5qi82LYyzoUajZ7g7gkSroSuMOAJ9PpJ8GW1c1U7JtghEfCDrf?=
 =?us-ascii?Q?9gnrnWutzOCILxZKT4mOUYq1D+bpb8c2n79xGSl5r+Pf6FmW2Xu8SsoCy3Fx?=
 =?us-ascii?Q?qhsRxuvmiybw7+dgJmr0hl9r2Xz53uaDC0IPktDE/yqNlcykYOEbFMInH612?=
 =?us-ascii?Q?+Z0fbDwOLCJgh1tgrR7QvO9hpjtI9uyRCkmQh0MF9gW8S3SPtmMsuajnngby?=
 =?us-ascii?Q?cBTSr+pOb35LDvZj/dccDbuiJzNWWHJJ7/zwxcPz2LeAGpazBc8TjhiAjBf/?=
 =?us-ascii?Q?3KD9gAMGumICWzXNWuYuValItq9ocD4UEhSFzTPOts4lWCkEo+I683z2z/vj?=
 =?us-ascii?Q?K3ZWfoJbqr1OsXyCx6UhBzDnKP5GDEW/mKe9Iv0Q8Tbi2oQlk/7bbixU7p+P?=
 =?us-ascii?Q?pyiNEGbwmB6mSNtH7R45An2hRLw4qneaVOO/wOyMHw7rfLQTsh1QPD5X2/hY?=
 =?us-ascii?Q?OJHkX1oOvraOGVp1lJHHFSOAJm42v1sMNJ9wYDC5AwRFqmggPUfCnetCBXRV?=
 =?us-ascii?Q?uLtkS0Q1fgMZgSxuUiFr8Stp0NM8oF7TbPKIxxIkaLij87jGUwSqmacmtR04?=
 =?us-ascii?Q?crxQ6IcU1aqfYDiwH0vXS6Z7mNDJ0KKe0ICrIghR31pgQLjVYvdYfJITRaJg?=
 =?us-ascii?Q?lld7bD9v8x0UxtRbKKw5gpZ4KPOJxyVH7l/vuSV5TmCd6edTJUgbBlPj6lzx?=
 =?us-ascii?Q?Q1ChEut5cj5kY8gQa9i4/dr41YJyiT7GS1ULHl5z3PEBLkimaOLE+H3X7OIb?=
 =?us-ascii?Q?19RGh0d9+up544oVXewe9VI4nJXsN4TgzGRhf1XspTmtqJAtCTzfVmGhDL4b?=
 =?us-ascii?Q?QixeFUeE58AjjTAc54lT8/JdUJv3fDA5YgNutAZzKCFDiJ7GB5+Q53w7aQlW?=
 =?us-ascii?Q?rmx56v8TdXlZfBvywhc8d+PcDSGfx6JOZlkSNWcLWuSTsaVxg+zpz5hWcdI0?=
 =?us-ascii?Q?K4Ef3ECt6DIIqEfTkLmeufDEUcYVGS3nVut8byafnRqTf6HiXskntIDOIQW2?=
 =?us-ascii?Q?skX1uwIHVI0KljKJy3aeTjQi/4CPwUN4dxpS6UBel/LfMKsMPfmz3aB99S3C?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?5QrnFAASoD2gPu0oY5x/962LPjAdq1RqEnsG+bxkwdI9REkfSbRI/WcF7b/s?=
 =?us-ascii?Q?RD+S3fm3u7JLZE6QxYgmqe4XsUamRfLpglgyvDRz2qiylWMdSppRlk6CBGIR?=
 =?us-ascii?Q?NA/QNptvF8z8PB2jJe9WBKygrHBcTfdJNAkWtxu6dRSLt03+WaSNxKpPbRmN?=
 =?us-ascii?Q?d9ZK1ZSPBUo0Xoc5R6JAbNFcIVyjjdNcoAjLVU//dn80LmlMv1bYvBAG7Ksm?=
 =?us-ascii?Q?dACP8+ZQr3t3cbCKnmOJ7UQB6Ug6AJ1SDJGvj+CezHZZosZXBYo183lxcV4d?=
 =?us-ascii?Q?NBfALwWmEYavfVI1uo9JesOp9q2eyHmJHB504PgwSFPt9g9mNwOnZlJmDE6m?=
 =?us-ascii?Q?PnsQesV2tGRTLYtbiGaGGhSdq/kCFZdoYth8PB5wpehKv16jRzGgoCDqVFCw?=
 =?us-ascii?Q?/s6kxMC86rsWmBsEqf1IVEHVTuiBYqC7ZZuDhpKgXjPQg1IGHakBizbFdd+E?=
 =?us-ascii?Q?zWu4/nMwFW/PodJirnsgrJNmy3oczTh45Y1KbW4V6CfQ2SeIyZrl+alnYgPN?=
 =?us-ascii?Q?/sze4Glo5znLXTWCJHsXT/apfJ+jlxOcmxfZOyPy7vvZR5et5THgFF7QCElH?=
 =?us-ascii?Q?k8H4ZV7ksG6r0MkeVZ96jzESsfTSsOPKmQMHJKaeSeqXt+6qxS9d5ZaVVg1E?=
 =?us-ascii?Q?5E+ogXpqe2zuFzRGU2VHhnGMC4svAu/xnoR+pkHiSoLIILcc4uTpbOSrJ1ud?=
 =?us-ascii?Q?DoHC2h6TXTlrFLPQ35sieV3cUMlQJQLwZPGA+kmjdE+khRAQR6AlbmAQozRA?=
 =?us-ascii?Q?sPPhAcbG/5TyqZyg80g1X1PHSYA5sB3xwNb1UgRw1LitJigMXXpE2VDi3I+F?=
 =?us-ascii?Q?//1Bpa+OKXTBWAzPS2GtP1Hsw9td9fhtXrt4FjIHZ/mIeQe5ndPqgW96aItT?=
 =?us-ascii?Q?myY5qelprF71t0Cuq2Qg7daxAPYIEjvxahnue6M23xqKsvk1OOh8VA1Fa3UU?=
 =?us-ascii?Q?bD3rq79w2rbaz+tSgyXa1A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c205f2a5-a536-4ed5-3240-08db1f362a77
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 18:02:50.5925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 69UJPf5NtCw+v+S8JRTelZW5cM6bJvGhERNz4xPEjmboYueRKj0hFnbeEx1/Bg2y9rZYJB5RM8YJPpPkHHQ80g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4650
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_13,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070160
X-Proofpoint-GUID: 3z31rvH2ngIT-JZabPPdWx-tcfEceMsB
X-Proofpoint-ORIG-GUID: 3z31rvH2ngIT-JZabPPdWx-tcfEceMsB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andrew, this should replace these patches in mm-hotfixes-unstable:
400922513f30 ("maple_tree: fix mas_skip_node() end slot detection")
4d4ec28ef3a4 ("test_maple_tree: add more testing for mas_empty_area()")

mas_empty_area() was incorrectly returning an error when there was room.
The issue was tracked down to mas_skip_node() using the incorrect
end-of-slot count.  Instead of using the nodes hard limit, the limit of
data should be used.

mas_skip_node() was also setting the min and max to that of the child
node, which was unnecessary.  Within these limits being set, there was
also a bug that corrupted the maple state's max if the offset was set to
the maximum node pivot.  The bug was without consequence unless there
was a sufficient gap in the next child node which would cause an error
to be returned.

This patch set fixes these errors by removing the limit setting from
mas_skip_node() and uses the mas_data_end() for slot limits, and adds
tests for all failures discovered.

Liam R. Howlett (2):
  maple_tree: Fix mas_skip_node() end slot detection
  test_maple_tree: Add more testing for mas_empty_area()

 lib/maple_tree.c      | 24 +++++-----------------
 lib/test_maple_tree.c | 48 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 19 deletions(-)

-- 
2.39.2

