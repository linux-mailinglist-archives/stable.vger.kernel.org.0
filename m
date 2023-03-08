Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFB56B14BA
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 23:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCHWES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 17:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjCHWEN (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Mar 2023 17:04:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C00953DA7;
        Wed,  8 Mar 2023 14:03:48 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JxuMM026699;
        Wed, 8 Mar 2023 22:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=XNjFE7ugEbEoGanxvRzh3GI+ofuLIBB6BVPMOdjIQww=;
 b=JgTqkC9rpG45rO1e1O16G40eOj6bECipNKbh2bvui10yMdTkfsa+WEM8hRiT9+GVZkc9
 NDFEsUsQF6Bp2EV340srAohznEb0x3+XHWmdb8AZRBqNBBbErfeULxw5hmFCss/O4iFD
 Fk87tBpA6aFwzOVr0wYpxkgl5WuaiHdCY0yE9jmg/5MrftWnnuW5pAU2HxstYTXoMcAm
 tPt2sNNOvuLC6YQVlGdLLsvqCE39nThd6i6mgHy/Hu7oo7gzT0gAnYxJjOWRsxC1xUHZ
 ZXYPeswZ90ZpMTT2B3SCdrsbVmE8JmmsJgsc4illpT/nr3G6Aa+EymLcKPX0pLVgHxHm aA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn95npf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 22:03:30 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328Lt6bq036616;
        Wed, 8 Mar 2023 22:03:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g463u8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 22:03:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrQmWQ/9VcoINv/2kNhbAf6b7L9RxVEp6Sb/2PElpuKC8vBmwuWdzmdvinRfDAXlRZzEsZbswewHUzWekHySvx8jFB9jvFnVSYb/L+IA7q++Qopoke7KX40r0Sng3eGofDETOiazv9M+rQ3baBvwxGYRQ7aA/7aLdO9U09iGRigZZvZDVZ7EuD6ecSJzLWBnGfgatwT+Ym/mvh2G6l0xDCAMlEaALzOKXrvzaTaza+H7tTuzwDB4TlrQ3qfxfaaXi+nMz3aXica5HOGQVJ7APfEkfPGmhKRnEbxwfBbvNHZg70gSyhki6n1qLfrBb3U6X2YnwIJuoZzEAIOdRcuj8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNjFE7ugEbEoGanxvRzh3GI+ofuLIBB6BVPMOdjIQww=;
 b=b/Znxg/0ZhwRhw/qXcUsMcG0UEoFg4JN0j9Vv/EQtXsca4kW4GenIkOUi+v+0yKJkN0MpUYETQFsdT6FV8bsibvzuByljEbrSvB5n/DbR/t/TrP3x4SK+hj0D8Hexnj7mGjN39CwdW5waF5xOYR1ddyvxMTiDeY4p9wB++PVHP3F8UyYTmoACNgmVoAazxHjfbRjPpaSSkypP6jPUjFQ9BpT+TaA1FeMe8Rt85/Y2ttARhQjYNsZ8w26cTCHj3SxKtqO+rgbtvTkan7RlYC9g5ucAtG/cunAPz8v/KYtINy9Sm7YPj1pK5moSV6CazxuM3/F9FR8m1X2ZPbILnfBIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNjFE7ugEbEoGanxvRzh3GI+ofuLIBB6BVPMOdjIQww=;
 b=jkflsE56bJI7VKHCmnG0j95xlMnhXRpePAXGV+lmG8EQzvArD8afG/aJRgV6e19bGb5XoYtXK17UfYcJFH0aDYJtcKKbpqBb0M5nMd7fuu1UgRhLeBq38MzB7/sE4nGRuRliTnyp7v4MWMlJLIYf3ImaFD+bM6fDBD7lvlXxk5U=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by IA0PR10MB7301.namprd10.prod.outlook.com (2603:10b6:208:404::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 22:03:26 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319%7]) with mapi id 15.20.6156.028; Wed, 8 Mar 2023
 22:03:26 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Pengfei Xu <pengfei.xu@intel.com>,
        syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com,
        Matthew Wilcox <willy@infradead.org>, heng.su@intel.com,
        lkp@intel.com, Stable@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v2] mm/ksm: Fix race with VMA iteration and mm_struct teardown
Date:   Wed,  8 Mar 2023 17:03:10 -0500
Message-Id: <20230308220310.3119196-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0132.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::22) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|IA0PR10MB7301:EE_
X-MS-Office365-Filtering-Correlation-Id: 567ec452-98c2-4235-789d-08db2020f13a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jbe7BMIrpc21K3N/Vaqzw6GOqO6eLVV6kF1qYNbyV1KNm/bLVvVdwKa8Q5T5oK+U2UkXfMa2J2ij0nUieUq7PCDj4Ju7A2qAGnreh16k9k1peRpG7Fev5id55Ish+GTSK/e3qWlOh94LKJBZQEj6AO0vGxH57F/HWsB0V6xPhyh4vm91XbzsyoDuGGNODgYCc3af/81jn70r31Ab0iSjlg4LtIZ8tfqqIJLMoxJSeTTXM5P04gvJFjdo9Po9iz7qyuCjb+QvSxLqD/xyEQspA5vvwoe/Ax9Fg2jN0D1+XK/x7Ht506Yc7B1G/kfU1fGyQZT6/V9gvr2CZLtJuhsfPnK4QsqpCeTDG/IzBpVGnBPQhnOgrbfdaixMuLDOdXPDHsGUgBW1n/VVMDTgbn9rUaRdz95guKXZphkHCjLnp+ck09O14jWNhrYTu1QHkonKI09yuzFqfX1aE6ZCXSe0+UkWcBZI4Add/2/F+kAEupxhM2PAPCsrazWR782oFSgDRN6u2Ab6pQFEYpQWbN6nUzvsUWlfxoo2SjYC/pPXz5mLtYn7CDi+SxsO0hP4KHgsOW3srzxdqUW2U74xInFGywNgwj7OX2NP7bkN+ZCwpDpnEJp0jUtWLZTLShTmOg0dJTDWJLQDcVT6fTzINTCHyjllTHSRyGL4H50kV90FZkvu46bQsRkEC9E8460j98NtsJcn3U7TKmNrya9ZLQ7kuMJYlzntK7V/x1kWhCXskvo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199018)(966005)(6512007)(6506007)(6486002)(6666004)(1076003)(36756003)(86362001)(83380400001)(38100700002)(186003)(2616005)(26005)(41300700001)(4326008)(66556008)(8676002)(66476007)(2906002)(8936002)(6916009)(7416002)(5660300002)(66946007)(316002)(54906003)(478600001)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qh17+71VHh9uP52+piWt+AMUAEvL3rJlu3JEwoDn3E39WyIzPr49iOvOK23J?=
 =?us-ascii?Q?EKKiFriRMoZ1NxueBETiePdFsZ2hcaVxQuG11s6gGClamcnwLMRaXEk/AyEO?=
 =?us-ascii?Q?I/F/6gFR/epzhjr6WnVBkoCudmFAef40nR3gnslyCbvHRUHUMoZxfT1TqKov?=
 =?us-ascii?Q?Q17IhEDp5G6NUBeAhmauR6a2RkZxknYmjVkK+0lzdOSrCk/tNv24mIwRyl5w?=
 =?us-ascii?Q?TaaZch+hDv8KdfLDjQSGJ4sbKxKH28ul/zVIQTdXSOPAVi3he9SQWa/DgtQ1?=
 =?us-ascii?Q?9jADhw6pzuovsaR6m5l5BX0/VVrUgcHnzzUdL91lfa5j3FzaHkR0wdWNsuHG?=
 =?us-ascii?Q?jz6VS1iKmq9CZr3DmtjQcyPsglwmEoY/3L1XPOkEkfxpIXeubSxpqOAw8cKg?=
 =?us-ascii?Q?iTwRF7PadwaYc44N7HnS+qE2GGihKZ7UhxfqfqkLb5ieHyVchodng9Tamqii?=
 =?us-ascii?Q?3RGJW94xTdwK+7D9fZ0uVBhgjCxv+begyRPXhKN7mmRy1e3pbUiUduivWWxu?=
 =?us-ascii?Q?nhCvpIC7y/uP8PIumnVHEnOqdHliCuSQq2QNVtoaCcewy6HxTSX6vUJfGmue?=
 =?us-ascii?Q?t0s899hEvtnmJF0+0fN0qS8JUmdKyetFJirxYyeA/+yMLIQVC362w7dpBaVD?=
 =?us-ascii?Q?cwFuKTTInmmM4I5NgRmMWUucoeCDd6zT2bSRoEuayAm+o+5ViQ5uxCeEFZNm?=
 =?us-ascii?Q?IaFbF+1Xq0WREE9fbIRQkTiUqTz6ES3LS5IBuYV57l0X39yckegDXkwjVEND?=
 =?us-ascii?Q?IJSHtHzCYOn+tsGPXz5ZAnDMG0kCiH8FM+ZwxNgrE/sYZj8sE+U8NHzFfPXD?=
 =?us-ascii?Q?ClMnWLHbnydPIPZkv89B2kB7/ArOfaPfFJKnFGBiwfS4ysStdtFxET99X7a3?=
 =?us-ascii?Q?vGn+zqCdGG2b709c7GtAYBxkRP51KME7J3ECgZjJ1vPcDAq+WH+muBX9lTe1?=
 =?us-ascii?Q?Z9Bn1LamZ9acCjTgURBwNIHpY6zEo5BO2nVL2ZThRrqczG3HuXshQGeW+Ajh?=
 =?us-ascii?Q?ogtqJWWKlV8FqQOJfUE8nW+ASeLX4Yn/h6xOvGPXei7sGj1ZEvcq9TwOyw8n?=
 =?us-ascii?Q?DoPH2YHkXgLLd+awOhARTcLDqyVfeLsQn6KsWuWf5GzebliwE85fsmizkumC?=
 =?us-ascii?Q?+VwMBfbxY+sRF/SC4/kZq1r8aAVYkkPI5RKvEmdyNcSDh8IY2AAids/ol0dy?=
 =?us-ascii?Q?o3sbpDMx25KL4E6dFXeLMifSmRuUCjT63lsvVpf3sGDsHGXqCAkQrjjnveq/?=
 =?us-ascii?Q?D8yLJuB+jPWOBUGpwW0X1ordlMoxOUZREz0DyBRVinS7t7p+zUq37MPYWtUU?=
 =?us-ascii?Q?TDH2dSzd34XkFZS10db7q3hKsGC4LKA5+e0dG8e7QbQGA1fvRWHFltc6krCT?=
 =?us-ascii?Q?Fspu2h1LJtrsY9GfVumlxK9o05RsJZaLQJQr/8LYWJzx35ZDzdCp+okmBrdH?=
 =?us-ascii?Q?zrGHfTWU6XwIgghdUC4/vJ0Ssu9LezMPjAPfIX054D7/+mFT1osyxnLAvS9/?=
 =?us-ascii?Q?p9HO12eCUygfYJTNDQG09ZoWSONE++jjSN3M46q6ttkRQ++HqQwoiOcFSGa2?=
 =?us-ascii?Q?tkp6DKb3g08LmPC9Aj/eRiyeECKBLhHISDTVrOz4ZHHyBHnVflGYewg/gWXC?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?gnLa5bm4+TGs2eQzrLYgJKO7uDxlK0cnkQuwqhHqVwVp/Ps7WTQfv1MshpmZ?=
 =?us-ascii?Q?W7kfdxy0hZXhPaIJutrap963Yz8e5bcxBpcWFW+FyoUUckxRHfqMfuuRVlK9?=
 =?us-ascii?Q?RcftvO0BEB4UJerwSbvk+61cq7JKFZAEK0pTC6pWncFbs9WbTI1hPtNpy78K?=
 =?us-ascii?Q?+fVunIio3+eA9l/YvBkr7VWTHK6dnBIoF+skb2Z1DAHLZLvcXNf5HyYshHUA?=
 =?us-ascii?Q?KeS6NeQeC8LBpwBgZGUv00vlfVAdr/j6UEM4ZXojdwvw6q7eEnMwVTe50jWq?=
 =?us-ascii?Q?VxtE36A/dMxYq26WWG7Ij5WI0bIFMNL+5JDw39ZhSUbmge74qYf6sXo+v9w+?=
 =?us-ascii?Q?nslR7gq35vQJXwbClfurL61y7SGIWO8uo8w2Ix3SL3km3lohxziAtLpyrwYH?=
 =?us-ascii?Q?rmOpi8HLWvDx/oxT/fd26PYXYw/QNduXUaWlNa3oj9pLyGCCzT6EqHAW5Z0a?=
 =?us-ascii?Q?lGjwaq2/TEueDQqcFh8n9MqkiKw/UwIvZjyiRzu4n60cNpUEWEMzVZKq2Sdj?=
 =?us-ascii?Q?U79Uc9W5Zb7DeI3eIPRroLm7LsPVnEt+xc0K92ardhnezPwI9Gi943AvCuOT?=
 =?us-ascii?Q?gm39nKBIxOx/P54EtWhimjhOKA1hxyRpKVaPEL43OgTdEvTvA2jG5wO18Gth?=
 =?us-ascii?Q?PIz/BaNRve9PPvNUcOpiGvuBEespMEgQEd3O3iC558rAH0S5zCnxsRgHEoBf?=
 =?us-ascii?Q?mXMrO4BMkTZLDq+iTvPNy3Dq57icvWTW855zWPCCLRBXj/dqwzoAzxPJGni3?=
 =?us-ascii?Q?1b6ibmG7fcj9XEmX76TgjpsivacMidiGt4TXi0SiCZhn8oUh/30J6O5/K+sE?=
 =?us-ascii?Q?BL40zVTGvVr8vhsjhu4wuVVJ42rK/uaL2ZC+7pzTkMPrcu00uJ+tAZJK3/R/?=
 =?us-ascii?Q?aqhtpYG9LpY67MrxO7nonSxXjot8iI9mB1GN0er/ORp5RdmmSgYhbYfX+AO1?=
 =?us-ascii?Q?//FjSOTHJsp5O3YHytpo2FpnH6zq9Hf1N1e6Ir7JCC/qeThw6p1zsG9SSNGH?=
 =?us-ascii?Q?pywIZEiZ0evtBiWImQxjGrS4Pzk3r+CR54nOvHRyBfgRLYtef8nMIcnE21bA?=
 =?us-ascii?Q?eZG2rzYV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 567ec452-98c2-4235-789d-08db2020f13a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:03:26.2802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IJHRYFfm1yyzNsedkbheSzPnKUDoNbVFLcRKg5MnVoxzMQFX2MZrYVY3W+mmveQFXVKBvEv4mIQR3MSZ5hQ97Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7301
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080187
X-Proofpoint-GUID: ZEFJUpJhx80-FXtwLLjB1Uoi_twLGwtk
X-Proofpoint-ORIG-GUID: ZEFJUpJhx80-FXtwLLjB1Uoi_twLGwtk
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

exit_mmap() will tear down the VMAs and maple tree with the mmap_lock
held in write mode.  Ensure that the maple tree is still valid by
checking ksm_test_exit() after taking the mmap_lock in read mode, but
before the for_each_vma() iterator dereferences a destroyed maple tree.

Since the maple tree is destroyed, the flags telling lockdep to check an
external lock has been cleared.  Skip the for_each_vma() iterator to
avoid dereferencing a maple tree without the external lock flag, which
would create a lockdep warning.

Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Link: https://lore.kernel.org/lkml/ZAdUUhSbaa6fHS36@xpf.sh.intel.com/
Reported-by: syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=64a3e95957cd3deab99df7cd7b5a9475af92c93e
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: heng.su@intel.com
Cc: lkp@intel.com
Cc: <Stable@vger.kernel.org>
Fixes: a5f18ba07276 ("mm/ksm: use vma iterators instead of vma linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
---

Andrew,

I've included this note because I've changed the subject between v1 and
v2.   This is for mm-hotfixes-unstable.

Replaces: b6d4338e8dd2 ("mm/ksm: fix race with ksm_exit() in VMA
iteration")

v1: https://lore.kernel.org/linux-mm/20230307205951.2465275-1-Liam.Howlett@oracle.com/

Changes since v1:
 - Commit log & subject.
 - Added Acked-by


 mm/ksm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 525c3306e78b..d6280b258ece 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1044,9 +1044,15 @@ static int unmerge_and_remove_all_rmap_items(void)
 
 		mm = mm_slot->slot.mm;
 		mmap_read_lock(mm);
+
+		/*
+		 * Exit right away if mm is exiting to avoid lockdep issue in
+		 * the maple tree
+		 */
+		if (ksm_test_exit(mm))
+			goto mm_exiting;
+
 		for_each_vma(vmi, vma) {
-			if (ksm_test_exit(mm))
-				break;
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
 			err = unmerge_ksm_pages(vma,
@@ -1055,6 +1061,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 				goto error;
 		}
 
+mm_exiting:
 		remove_trailing_rmap_items(&mm_slot->rmap_list);
 		mmap_read_unlock(mm);
 
-- 
2.39.2

