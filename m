Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3353D65DBB8
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 18:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjADR5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 12:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240168AbjADR4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 12:56:55 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93483E0EE;
        Wed,  4 Jan 2023 09:56:53 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304FPeLp020752;
        Wed, 4 Jan 2023 09:56:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=qNtKodlYZ2qO13drn1n3crHjP+yMfgGR0q7i0tIE0bY=;
 b=Ld2t34OvcJ+SFSelEbIzf6Op+bnUgmDBqacaDfzZwji0t+ra1Z9+TZh7Qx6liOuoPiLZ
 mix7me76U/sFifKDKqqfjKuEHLjFpoAoeS0flOg+LRvG+Vna3mh+5wC9UsyfKwQEaPJQ
 H0+J5lC8d9eyWYLIIugUc9+FCLpY1SqEsx2al7MIuqTkWNULdDnuHQ0V0NJmBHdvnD1e
 w38TSOz16/ze4Vq82yagMctCZ2R8lND9eEWsLWq1pFp8gVaxTwyW68gm9OIZQJdjpNfN
 1iqQUIYpr4SOFHBIkpNEA4vsdFqe8gm2WiHQzPYH2juyqYpI4SMFqqYxHCwHWdpozUg3 TA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3mtnfrtfff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 09:56:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MsAx45y/tdePbLNwHx9TLrP/9uhXqYkqUIy4xeMrGMZTcFbbegiflRkiveUsQKwNM1mFPahN8BPjZTvDH1404ggw+o9AaeJ0NwWP95MBdJBWrg6C1UBdSOeUvuTswva2+5ZEqwRDPHMdeQcmL1f/ob2XLtCvmpxin8gBxIXassKuhqxfqwog9kTMlQtb6J8Oqq3mEP869I0LFSbEm1KkGPJLBprb+4KXzuctgyg3pDQraQd4rgiILuaW1RAxPpo7bADAIE4znOcEF52GH7OtscS5z0XlQ/khn/ELAa/LB8xV5tg9p84xO6XtFXiFH/erKWujKZ5SjK1we8diypfjjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNtKodlYZ2qO13drn1n3crHjP+yMfgGR0q7i0tIE0bY=;
 b=gHIno9yWjOYsgRz4YhMDwIivR4qbTaQ5u3BcdCM7ntr6PHunIF5wx5yAjaP8tIVEpmKppDo+jqNXj+PeY+0rAw6O91D401hjJEQ/htFhgQncKss8dA7bNJGECiZq6dULPitcDqnDFdJJIWKUhXD+VGV7Vz0b4XgJ2CdGbZbiVGZdO7L2Qc4slP/wUXvAHDz27dUWJGq0MMkOY8HFHKnzxWss+fsWKWQoM2oOKZt77Wsd2B4W3hAitAl/ODCE9OUUeQgVC4RPKGbCo7tMj8SkaaKPQKsJ6szGc8ZVaRmyu8Yb7vqntUfVzxoE2pIT5GJD+2hRbQ6dqk0FAEQLhfHNKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by BL1PR11MB5462.namprd11.prod.outlook.com (2603:10b6:208:31e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 17:56:44 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::52f4:f398:b983:2380]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::52f4:f398:b983:2380%7]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 17:56:44 +0000
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kent Russell <kent.russell@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.10 0/1] drm/amdkfd: Check for null pointer after calling kmemdup
Date:   Wed,  4 Jan 2023 19:56:32 +0200
Message-Id: <20230104175633.1420151-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:803:118::48) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|BL1PR11MB5462:EE_
X-MS-Office365-Filtering-Correlation-Id: 5361a79f-5074-4ae6-0c6e-08daee7d0a68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SG6mwZugglmWlZlhQRI9IEHVJmdyporJFKcrXvLW76x66wCyBwOqza50IgkvudCIAPmMVBhFOYfOSuSInYuhWImbJDdtf3VcRizoeeeI+m6q/4e/+gqP0AVGgE7KqID2FleJ+vjlr+1YnCjxAYGL1Mwoe8UtCMfHVSeAa3O7ciXW+qDSAZPYFmKYgeLcwpYGUHB7joUlHspx8AKOY9tx+a6teX/ogqqK0c0mlHpzToUa4+O5jpk5j4iJCXkETJaEax1XL8/RRUCIApMpTDKivKFE1p9RSk0YCahGx0A2ar1BwBnfkqMkW6S8/HR30feANTf1pcRQP//YV2c1yxkXRk5mgAIAc9QLB1wqPL/YLAEcQhPouFrDBAgBI0fhPIY1MGdx1ofF/+C4zYNWFYJMH6xZpqdEu9LfrOGnrLE1/gquRvEM08BWE6tf6JZp/zQ9u6pGhO99ZSIFJnfu8PAvBJchd1Jgup9JQk/NuQEM5Smc1GOhXP4GUeWBGKICKGEgm6wDWEUU2d6P/24Ezpj8IWBLc15UAGQIrq4xW+0JQBDtTTarzDGan78rvP499cESvr5VUkEVj47z5Av6x8ylk5lceEEFjKuAytD5T9TShEDWTKC3VGJq5WVx11M/5r4a8sZCmnJtdU4zi6p4nIxPV+XXnoaexCOysezZRWKvuPy5e8IdLR/CnjTNgXH05Iu7ApfXfsx+deEU7G7a2Ie8D0eAYavl3eVRkfqjCREA5a4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(136003)(366004)(346002)(376002)(396003)(451199015)(8676002)(4326008)(66946007)(66556008)(6506007)(66476007)(478600001)(966005)(6486002)(36756003)(52116002)(86362001)(54906003)(38100700002)(6916009)(316002)(1076003)(2616005)(38350700002)(4744005)(7416002)(41300700001)(5660300002)(6666004)(186003)(8936002)(2906002)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NaMdy1w8tuqqCZ5Ny/WJO5C3DenoBdt3skUCF8U4U6qn9JKAeKMD6ulsNx5+?=
 =?us-ascii?Q?cPswf3UkOwmvbp6jYaIt/qnBhibaRTIZclF0xLdT+GevpQkIwfaq0HlDWy50?=
 =?us-ascii?Q?9M2zCa0Wwp1uak0nxgYWEFAzYWrjxwRb4VC2dbt/mXVICxsa01YT9NPT2cT+?=
 =?us-ascii?Q?La9/IhOR4g0EwixkhbtuXIIdz2cR5e0ghe6i2sXD8iUcF/JIuanBBeXM21fO?=
 =?us-ascii?Q?DqXvQ4vmA9s4aamS0iU+9Q/Nt9BGp/mtfjDrraZUV2Uvu1+xrNhAxp4xtvh6?=
 =?us-ascii?Q?uxso4G0h/y/OdfEt/2YJtQOVM95IY1smUiFvJWZ9x5gFLZE7qY7JOgWJregQ?=
 =?us-ascii?Q?iPQTKq58t3JsMFVJDohAwnUJefQ8GxbT99KUoqOuQE0SjXYEqE6fV6eSkiYV?=
 =?us-ascii?Q?NM02OcQennb3bBbEozcgi5fBAMxl+ZZNPSnmvwDOmy88tJCW+1r+yiyPJOWd?=
 =?us-ascii?Q?7Wvpi2W8GuJxaX/LNfk4A0zhkVdFY9e/5uT4y5af6KZ/4JcLt3WFQvOyg/rM?=
 =?us-ascii?Q?dWQutkc/4Dfu4F+XKsGOXa94WJ5hiDWjS6VWt8sYhDYG+39gXbnwnfIXuZBy?=
 =?us-ascii?Q?G3HNYsaCIWdujnCo1KHh7ihm5N9loXfCB486y+Xu8vywp0SsYnzuDa2Hd52Z?=
 =?us-ascii?Q?/C3HqPqkzvMoGmqf1rZuyEoH0Ye9EdTp4ZdeYjhJNrN38WYcdq+GQNAzLFXr?=
 =?us-ascii?Q?nY8BEnvwRLZmd65P/8VO8xd8DtJbGwZ14K+ZhjNDtw97FqqWhzTphBr3OTgR?=
 =?us-ascii?Q?0K3HIZt+ZRbZH69Pz7aTfPlDPg5dhHgvCPHNmM97eygpD6AI1tGiJFpnJnII?=
 =?us-ascii?Q?4E58Vi8uVqUkO6s2mJTIQiMrlwz/R/T+Mi1pGVWcu4sqmHJvfgiezh0wbznN?=
 =?us-ascii?Q?linhBRhUya01qbjaHxVkCgmD2SznkspgS74EFPFLlSrXzY5wmOdq+AC0S2T1?=
 =?us-ascii?Q?JPbxLxxog32Zk+wfLbd2m9yBAAkOMjn6H7gzyX2nPbVzTRIJxNW22LI0ke+S?=
 =?us-ascii?Q?NLxxAG8JtX75M+fxdbBH4Cl3MvFgwDJMimnZxE/eRd5yGV1qjjHqi2tkdw+f?=
 =?us-ascii?Q?v+OIQJnGMEqrqlKLw80a3dJDza40apGYrNYIkWoNWCcWpwYTuZDcERLTZpRv?=
 =?us-ascii?Q?2vEEJhZPKds4MQRT6+q9HAxhoKwr6HjbsaLF5JKi66eyun5l7zLQAqourHvp?=
 =?us-ascii?Q?g00VpM+LsWDf3s+Wsl4g8pWlDzGGFdXgHQqLgPDEQyebPU6FHFbhuE/WxFGN?=
 =?us-ascii?Q?75LJ0+6ZtuA2oXEFcBqx9V5nBbAF03zyJ+AnpVFe82VYL8MlnCe6MmiMmLLJ?=
 =?us-ascii?Q?A0K9vNvM9pZ2lhNubwbsWm8T6ROlLLzYTM3Ebe2uoMN71RAKuKlqrJpYDYXT?=
 =?us-ascii?Q?/8VNFkiTf5uuOgdIahlB8WT9LOwnL1FurFYmajKmkxL8qWwdQxBG9ocDohK4?=
 =?us-ascii?Q?kyway4hmf7A6/LalKSAxcNYHqI6CWwFsn0jVhJis38DnBl+F5mPo95xmbPDS?=
 =?us-ascii?Q?BNmMHng/2v5yUTE4WfkORkEySkh+wgWRBmuHKDvN0Ot8iwukKDg4vc7iK20N?=
 =?us-ascii?Q?ULyrVo+fM8JNGh6/oZFhYrI5GluhnB4phUxrO5P9a36UPLfcXiR21MqGWIm0?=
 =?us-ascii?Q?qQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5361a79f-5074-4ae6-0c6e-08daee7d0a68
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 17:56:44.2552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rXom+AxwYjXZM35h9vd1+qfSFeEuSb/UvXSDf5kUQBN+9za687elHxrilzsU5c0YZ7mDqK0HukVxA0harDgUnuH7MbaEWii4pWpae7Lg1mQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5462
X-Proofpoint-ORIG-GUID: qJ8upN-k10C69ms2tui1v13Wh51tMqlr
X-Proofpoint-GUID: qJ8upN-k10C69ms2tui1v13Wh51tMqlr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=643
 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301040150
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit is needed to fix CVE-2022-3108:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=abfaf0eee97925905e742aa3b0b72e04a918fa9e

Jiasheng Jiang (1):
  drm/amdkfd: Check for null pointer after calling kmemdup

 drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 3 +++
 1 file changed, 3 insertions(+)


base-commit: 0fe4548663f7dc2c3b549ef54ce9bb6d40a235be
-- 
2.38.1

