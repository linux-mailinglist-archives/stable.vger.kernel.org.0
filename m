Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA325F5002
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 09:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiJEHBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 03:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJEHBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 03:01:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19E458158;
        Wed,  5 Oct 2022 00:01:21 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2956hl5k021397;
        Wed, 5 Oct 2022 07:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=lvMCQOFlvn14TCVbQ9PtB3MjsmTBepxYasEv9ppFWVY=;
 b=RItPU9Ko7fl+iEcclnNh61D6/jRHzShwlj3qMGp6ltMLQipg549i6olZlSzE9UN1Mwcl
 F3knEBhRCyoNYhLcga4vc1oNnZb0G7upzV6iMJJdUl7men0AvkeGtmkL9063oRXdLFED
 GLxjHKZWsJDm6Ipi8a6Szv0WNNQ9t2z2i+qB/j+c/5itAt/HUpm6/gnQt2KQ7cwt8BuI
 bfiaSPT9FHEhYAR4uU0sf1pHLaaxwa7DmwgmVGZSDWGbCG9iGazk1Fu2Qx4gSgKnyjgd
 JyDqCZfikZh+TUhzn+gXwiBG/Ph+6LNF3cyz4DY0bTqMZucdyZD6SzLeEvAEOcEwV7rx rQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc520q66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2956BAH6028313;
        Wed, 5 Oct 2022 07:01:15 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc0awt89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxjahnGcU/CRqS3CuszYg6xhKBa78byojGAPjhMgTUpHJxEFW+2lr4C3+PMTjVdHb5Pls2tfAYn1DyOxzv2Z569mCxawpKi7wV1H/FVNaBcNkw16QYW/YMwYDSidphTT1eFwDeoAs/GwIZUPZN7kRZeu4RiU5kzkAqDjFuR4JevFfZjk0westTV8SQ28JXsNuQGBFwoVNvxOb3dWW3c/WGuzQqGTgafnYGqE7l7kICloLW9qsTPRV2zbp4012PTSUE49SrXgT6Lakf9pcLbtx40A6I+At9LhiRAgqkbklJZZwceOkMXwl88Ww5MocUIF6aj110GIhFEF3JjJ1MOzvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lvMCQOFlvn14TCVbQ9PtB3MjsmTBepxYasEv9ppFWVY=;
 b=TowyVgTzd2+U8yExFfMOB1zPoqqxE0V7DajL/pgmdELT9DYIAMr/c0a4bUk6ZxRCp461PxHe0l7KtGNper/wqapeIKt1AAWg0HTJHNLYaq3C6yovvYLpRkZUcHft539Q+htMYjveMC3flm1ipQ8wwttJVArMuZn+b0ndRyr9+3NsqV1zhbcpb9j/pTVk1EgII30ZUJllEXnEj6bQRDAwAPrtc4QwtVXFrnZCSGE0yqHAuMfMy8hmjISzwozpI1WX1Bhlni1V5cu9mnX1RJhlIG66M29y5crmloXVGDhcW9+EA8LksAUEmn8IBYtQ86WAwAa9ibQywV+8t2LWh710pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvMCQOFlvn14TCVbQ9PtB3MjsmTBepxYasEv9ppFWVY=;
 b=OLKZ6lmaCyE2OSqBs56NFN915rcvY6rrn1xJkQm7lzzEYTlSEA8ObhYOUZ1ekmUsEIEoBOYo8ljv2nfKC8SRM6Qyz0+piG3H7JHwjnB6hPoNsbVC4Dxjrh3gWV0wkNy7RHYYITslNTFtbYH1oIGaq4uxoTrYWVNB64LwnnB0T8g=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.30; Wed, 5 Oct
 2022 07:01:12 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 07:01:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 00/11] xfs stable candidate patches for 5.4.y (from v5.6)
Date:   Wed,  5 Oct 2022 12:30:54 +0530
Message-Id: <20221005070105.41929-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:3:18::36) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 84ecb0bd-534d-4514-d19b-08daa69f6358
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGmk5E8M8TToai5R+GbGFZ72igF8BtMnIIVQ/98ojs1dcLXgBD5lainqONP6J8bRy79JWGYd9DfysJ/DEYKlcCWTxJi69S4zvhlgotu9ukjufIPSAZKI3LfY2K643KEMMyirmgxUiFvfryqSGqAFfYuqP2rfGvriSzTHLCYEDDSNLGk+xu4azEr7Au58ZvCBvYBgVsOQQlHSdIIZi8UIBpwr7VG8Q4zRlpgTYFzSBiKhgZTQv3dmlYDnTaOnwcACzaPDJ+csLCUQo/HxWl3DqdEL8m3GEziXis4VcBWnC0g9fdho1ZV8qlCbyp8sauC8ZoC9sJQTQVTfFgbemB3cmRUS6KlkpSw95YORtsywPa1f/OfB1oUkenzxvqQWhmR30Ffx242F5g6PgxyqTFM1CDSlyr8RnhiJFjGccef6CLB4cShsteX6YuGO5wYKjLknmStD7+E1AUCBAgT4ZgM+fUfBZVwsddiKvhO3yUOenaUHSQkeLJGL+nqjx+GRflHAdnK2f6GpOfI9jhAyuvBYSJ93D6EwIzoLsfPG2xFEGqaLvrl5wMVNAvyQw8mNJ3ydH1y8Y+aSSF1L/C653828HgnYeh1cySLnC4t/sEgc0pClEx18z2WDfljgcnpvTu8MGtTrNDMaqQL+yXJSctBGKQKhPR+0TvaoUzO7DNgTdxaGZWzYwIiBZVLkpp0HylYEBjaUZwr8SqHd+Q5/+vJo+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199015)(5660300002)(8936002)(8676002)(41300700001)(36756003)(6512007)(26005)(6486002)(66476007)(186003)(66556008)(1076003)(83380400001)(66946007)(4326008)(2906002)(6506007)(6916009)(2616005)(316002)(478600001)(38100700002)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y8s86U38pY3haoD9W4kxbaDlhW0lft1yqwyDZ80Wt85MMHtUJkEcy0uKFe2h?=
 =?us-ascii?Q?c+JyEvfgNLfKKC3/jwyNdSwBeSm1mn8vz3b94xZfI7xsEW16xq7+T3lHWSXS?=
 =?us-ascii?Q?7GfREGp3w5SSDZqUEz8dLxcRflQSvhxe7DjyeWwmS3gw7cuScdp4NAiAGskj?=
 =?us-ascii?Q?AKfr00PogyWyTwo2c/nasK/a5g0a7PrmSG27oaXpW+7oUapiFMcxPWKGM8ec?=
 =?us-ascii?Q?5rRCM+0jV6QGNvaHux2QGwjnpW7Ws0xhkGDHyLGVUKu3MBoJJ2v2iMhzo+iB?=
 =?us-ascii?Q?6tkY0vvM2e9//e2BqS9Ba7Z6bSHTxUE0mNY4ryYbVBWveSrf2USETweKdaYJ?=
 =?us-ascii?Q?RspqSAGY4uTBSzxFswvW/7kw6gDQRXYaCsuYmxmNmKlOo/UwLRSWbeBmzSb2?=
 =?us-ascii?Q?ekEOqF+/uOOWY3ut6pnt4taNua6s2JWcwnyWfe4vHowZ7kqw0xJUJvf/QuxV?=
 =?us-ascii?Q?L1Ac7d3jnwVfKFB3l8ZyMVtszOqmf2SgQqq8FP2BRwJbNxM4dZKYi3KUFRlf?=
 =?us-ascii?Q?xWB7STEQKOWn3+NWaoeHMHpyAx/h5RGmpoMiB1BF/diwmLs61STsr8J+yCmM?=
 =?us-ascii?Q?A3QLq0LZIb/0+5HyZKA0XMAujiAsLSwcmPLPaiPq97iuHKE3oPe63tgtUZmy?=
 =?us-ascii?Q?3NEzRNxMEBpTWBin0CjPr5zAGAA5lTSBTeQyliBk9jl+Qn0hmKLxPeadWSXg?=
 =?us-ascii?Q?kbRcNmZIL/D+JSCw1YDvvloXLLELPBVIWnGHB5BjmzD5CF0Px5I+e6MvHeV2?=
 =?us-ascii?Q?aijDm/u0/CdIJo63d604v2dBndWbuhXa/GJgTfKQTZ4LeteIgo66MI++JBIp?=
 =?us-ascii?Q?xBtASwplawy9Kyap8zEXYYQX6kBAv6MwYvASyE/GIjwynIWB+gt0Z1t6p29x?=
 =?us-ascii?Q?xrrt2tfwd94txDnMvDguQUtSbnUcaKTJurwxvYGqKQhhrGq/iu5UZObCt7HS?=
 =?us-ascii?Q?29M95MD0fh17NeZPDKXVNNEygcViQVtBm4d2lqWtfGktbaR+UDwx3tdvSkrc?=
 =?us-ascii?Q?QYxhBAi3l16xKajwMDdW8q6yn5JBf1wGxlJ3KUg/klUQZv1HhtudCA5srKcx?=
 =?us-ascii?Q?EATK3T5NE3Io/8iTqNkVfXtXYNmnenlOggLJxxBRWxlv1eCap0k6aSaUbYxW?=
 =?us-ascii?Q?bVhpRMtID4yCOFjfgxjBkt+lpe+U779WpZcXBkUWsQbGAUMLFEnlTFARt4lF?=
 =?us-ascii?Q?N5nfLzu/OATwTVDUy0txvhPjyNtiR1to+Zw9es/3c5mWlCmlM6Gh2ntup6Ah?=
 =?us-ascii?Q?5SJJuynoJWzMWsTVRKg20acm7JxqI5nNo0b+9tyvEKsSe7mtnaZI5jV1DFxU?=
 =?us-ascii?Q?y86OMyc5k+Zx9+M8BkmM8HFxug13Rer++8o19HnYxKmJFc80ahRE02MwuB+f?=
 =?us-ascii?Q?h2xFyLX5gzJCiKTy4gukfjQXLwQLr49fJS0weFppblMRtbKGn+BfK1ipJiiz?=
 =?us-ascii?Q?veDZhBX0mKTQXPTWRfQj8syu+udSfd/DTjQUJ4xG8++GNdJ/tOsPOvvSv178?=
 =?us-ascii?Q?bWwc3bX+HPi+x5CAvQDfakPJIzW7zPT/BvIyfOqWMEWNtrrQPIxRjbK4mnzP?=
 =?us-ascii?Q?0YAKAxy47vO2oFijy7EFFWSJOMhZimVMeIB3VeQ3mPXQ51wDBFklZWNf+IC4?=
 =?us-ascii?Q?Jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?D8xowgsHR22dpo+QVzymCR1Ty8n5kHIR8KlRLBcGIac/Y6CfLDovumqZMVW1?=
 =?us-ascii?Q?WbPq2eBoPEIjfgoGej9Loo26xHUrWkO3ROOyKRwJkzcz+6Q8ZgmyxAjyki7W?=
 =?us-ascii?Q?yszxvbL8sDvcIugIUNmE6dyPoEtZQt2wImj/3l2DHRGsYP6fpUA3YySojeXZ?=
 =?us-ascii?Q?BkpM6r1lZTfJukBpmL2ss+ILOY7OPCHf46loN0Xg0It4XDWz+rIwZeTi/7UF?=
 =?us-ascii?Q?xPRoFH+u1NQJJQP6IXakOTzawwsWtChrWMOD9R2LDSehN8joibKVznRh5dCx?=
 =?us-ascii?Q?BDQ2keadBM5dF/NxiHuPO1wFIm8bdek5SqRwBE+bKVm0pOk8V2vZ9VQ1y3XL?=
 =?us-ascii?Q?g+Leikxv2GzbK3xl+x8T8/KR5sbWSsbKLnRjOYou1+xv/4p97jcWXylt2yYx?=
 =?us-ascii?Q?ADhPQ68MGG3wE6lX9GhlQspn8DRvDEpVlKUY7d8h9m11Pkp5LfiPX6M2eYIz?=
 =?us-ascii?Q?dMfz2I4n6msMqfx9XpjCD5b801PEbDyniL1+pNRIC/J71HnDXG+BW2YZ+YAk?=
 =?us-ascii?Q?177rLm9s+thzdn25DSCD12spVnfvROFOTqfT+Bo4edO98FjV8c9Ypik7ZQvt?=
 =?us-ascii?Q?GwZMQJ+7X9Ybmif3C43jxvDuaQoYV5E90gmZa9Vr+4xTD/pIamlEaB29DE07?=
 =?us-ascii?Q?M24rqYizhUiBOStCAqoLyg2bjUQhE2xTV/a81ak9Hu0lEnWojWmsiUF4GKlQ?=
 =?us-ascii?Q?tMwjrlJsm6YCjk+NP6Z21ExAr+eASsWPLctCsWlBBrOTRvzoWs20hZ/Vm6OA?=
 =?us-ascii?Q?l2lTx2sdY75FymBDVsTrlMlQjbjwlYg9WDLmX1xEHQHQWXRmi/OTAk1qgxtI?=
 =?us-ascii?Q?wqP8E8in0zlYtD4BdD4ZFbu0QaqzIatQ0bMlEpzLEeWMXNYay2ZtsN4Ks9F+?=
 =?us-ascii?Q?u9iOpNSxBxDZJXS3L7d1MjNP8rgOm5NVZqYIT3FockB2goPNPnn5SO1XT35X?=
 =?us-ascii?Q?UjE0FICvRx1XlbW9h8GI9+4y/OpvKo2MZMFmjBVfrgrFQ9Q9/sQrI/nxmc0U?=
 =?us-ascii?Q?PSKN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ecb0bd-534d-4514-d19b-08daa69f6358
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 07:01:12.6090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iEoTyF0WmZpYHcROXbhWIpPAa/WFoAdB0zR1qLSPCupJ9Dfpws09UDm9hMYSZ/1GjjsF8QhNpuXpXHPnPu+ZIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=866 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050043
X-Proofpoint-GUID: DhcKlxwWjQDrK2p5iFiRFQTom2P1pWEa
X-Proofpoint-ORIG-GUID: DhcKlxwWjQDrK2p5iFiRFQTom2P1pWEa
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This 5.4.y backport series contains XFS fixes from v5.6. The patchset
has been acked by Darrick.

Christoph Hellwig (3):
  xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag
  xfs: fix IOCB_NOWAIT handling in xfs_file_dio_aio_read
  xfs: move incore structures out of xfs_da_format.h

Darrick J. Wong (7):
  xfs: introduce XFS_MAX_FILEOFF
  xfs: truncate should remove all blocks, not just to the end of the
    page cache
  xfs: fix s_maxbytes computation on 32-bit kernels
  xfs: refactor remote attr value buffer invalidation
  xfs: fix memory corruption during remote attr value buffer
    invalidation
  xfs: streamline xfs_attr3_leaf_inactive
  xfs: fix uninitialized variable in xfs_attr3_leaf_inactive

YueHaibing (1):
  xfs: remove unused variable 'done'

 fs/xfs/libxfs/xfs_attr.c        |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.h   |  26 ++++--
 fs/xfs/libxfs/xfs_attr_remote.c |  85 +++++++++++++------
 fs/xfs/libxfs/xfs_attr_remote.h |   2 +
 fs/xfs/libxfs/xfs_da_btree.h    |  17 +++-
 fs/xfs/libxfs/xfs_da_format.c   |   1 +
 fs/xfs/libxfs/xfs_da_format.h   |  59 -------------
 fs/xfs/libxfs/xfs_dir2.h        |   2 +
 fs/xfs/libxfs/xfs_dir2_priv.h   |  19 +++++
 fs/xfs/libxfs/xfs_format.h      |   7 ++
 fs/xfs/xfs_attr_inactive.c      | 146 +++++++++-----------------------
 fs/xfs/xfs_file.c               |   7 +-
 fs/xfs/xfs_inode.c              |  25 +++---
 fs/xfs/xfs_reflink.c            |   3 +-
 fs/xfs/xfs_super.c              |  48 +++++------
 16 files changed, 212 insertions(+), 241 deletions(-)

-- 
2.35.1

