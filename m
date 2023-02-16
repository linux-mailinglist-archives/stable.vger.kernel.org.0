Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80005698BDB
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 06:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjBPFZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 00:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjBPFZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 00:25:15 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AEEEC49;
        Wed, 15 Feb 2023 21:24:24 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2IpNk010193;
        Thu, 16 Feb 2023 05:23:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=8bGzliM7fXsARjhvqCVJnaYsV0qr1Rxe9kuEjlgM/o4=;
 b=hYuISnyMGG0KiEQWd0fclqp9ZD3obhf5ret01ZFwA1fzN2Hoop/uPnePkRv2mYRhhqnp
 b+i6VbF3tIOwFCgmq3GwxSwdwqvQBPsABPs8ysB+Kg88BO9Nlq9uKx1r7wLabJ4W3bXf
 KJt4Ly/u+ftFjSfN46it5v8/+s8Is77fJiWJob9JoZ8yG1i+8/6EhnrhCVTXuNkM4Kxw
 EOPN2b27mDxmIEHmyVAq4KlikjYIoLviI6XfCtOU0pJwAbzxm2A151KyWeZDKH5lSivv
 /JYt7nebKWYIMuSmz5r8ee99qqOBVlEIJYspF8NGGtHT5xmpnA/uik1Nxzw1ZxCJOBZm Fg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1t3j55f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:23:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2eZWc015039;
        Thu, 16 Feb 2023 05:23:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f84brq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:23:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DnBw4Ygg5PoJ3iy5xn8DyrpE7Yu++XSIv/7iD3OWHai6Wqmj34WuBjm+prvdb4TPtuD1yPyyqQu5mpOnuahm8y5zGLsB7J5fDtL7g7bKOGokUytF3YxqlYu6qkezO7oTkx7zFYn5AYAcPShZN3jQlMiRTznXVDfummN8n97ynVIZPId1qSFOYT6hiTYbdsK+11DpQePH64WT0xypJ8wUsLShwWTJMA5I/AxrvEu73bBEtPuiSnhhQI7sX9A6qNT9UitZJwS0wJ2UEk+SpeT3Tv5kqVtsbMCTcYuM9m5n5Ek2OwAu+T2MeGV/OHvDnPV7MSCoocb7F1S/tJnwR+kLCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bGzliM7fXsARjhvqCVJnaYsV0qr1Rxe9kuEjlgM/o4=;
 b=U25kbMHoqr9NZaDn7MAn0HJUcQKAERtthqY7IO4EI5v6ncXd6hIH3lYQILKEHTadB0hOS5lGtO35kaxRw1Oz2nJQGKctxa0OXYz2ef5SoUh0cm5bkp8v3Yje6AwLPFlcMFhUCu/pC27FMAqjS0IxxerFHFr6huEJtsIob3b2P6vSv9U34Jx+MFP6rX8jgUcvn02TctJTPaHgIHI65FohZIytBvF8dg7QVm3+D4NnaEx71RMDH2SUgetX0pq1gtLez8Mt2ieTAkFLz7oRC0Y9zjuJbXbjex0XTIdY4Pz8kEOiJBczSPi2F+wAu1wMaH+DJ/W9wlHPKRoTZGm8JdniZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bGzliM7fXsARjhvqCVJnaYsV0qr1Rxe9kuEjlgM/o4=;
 b=qCCz/9HBl9MsIpdS54cDvWn+ZHVo9wNRqSPEiUeyNwsd694ODeE0CS8NIzABkf8oRPTpP224+lRJr/bq7+cOnrR7HfiyWBwuogPwqIWuHxrmm8zRqO1CuWxpUVMmq9bNQ+cyvvH1/Q4HYTGkSOY7X+HqZvPXc8L7YXn8ybiwsH0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW4PR10MB6631.namprd10.prod.outlook.com (2603:10b6:303:22c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Thu, 16 Feb
 2023 05:23:01 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:23:01 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 21/25] xfs: fix missing CoW blocks writeback conversion retry
Date:   Thu, 16 Feb 2023 10:50:15 +0530
Message-Id: <20230216052019.368896-22-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0012.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:26c::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: a9eafc84-da3a-4289-3dce-08db0fdddf77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GqGx5tv/OfHrjxIHoXmCYhObIyV/IlaFufGQj6btxHaU+mFqnq7s/4NCWPbOci8RlTGobtMXUu25O19yipxNRSrQmNbkaHN1yQhdU9OW7TuiAevnrGr2AYWCzAxwHgltBHInmpJw6icfYJZzXNK+GKu8dcQ4tQ9xObmNovjcqoZmLM/oun1otXlD0LEixcKkQY47OBBpctK8zBlDYW/paxuUYPh1PiBs3Png0aChf4Z70kUAma9TMuq2QAUuAdZXYxQqseidqZ/CbMl5bT6hLIZhF+iUN050+e1zTKfTt3/Kf7rc4rW8+zJc0jv+kI13UlrMylOr8qJkgwCyzEmBxqnbJySP6qgZL7dnxehBYKmWSHSs3uShWpHHkKiAaLrRNjWpu/f/3FyxqokZ65IRtrZr9RiOEPVFm+MNTJR3hG3l5WT9GGozU+lYZSGMpK+d0qkJJyjbBGuHa25G2umsZEiCNikX10GabWRyu/w7Ymqj+HAJJC0NmtYtf+lnPQOVBoFYMY9vN9w/qAawu1ZB+XRi0UVbdkTElpQAQBuNSAvN6NCathiGyhm1+z7WbrXRJPoVSw8tJ5Df/34seKyOVdwDy0Gox8cZDLjpJzr3QW1PIMpMlXEHWSf5Ayv5dC9W7lCU3wj+wE1TIW+ISf+ftQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(26005)(186003)(6666004)(1076003)(478600001)(38100700002)(5660300002)(2616005)(2906002)(6486002)(66899018)(6506007)(86362001)(36756003)(8936002)(66556008)(83380400001)(6512007)(66476007)(41300700001)(316002)(6916009)(66946007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?afHbIwKAzG3+wEB4EbQj7o/I1UrGhLaVGFsNbOzzBLrIYcdZMCRSiLUavRxd?=
 =?us-ascii?Q?ne4gKj2B2p0+vMXbVocblYv5uslep5Q+jq5CiirQ3+Lnbzez5FAGHpQnefWP?=
 =?us-ascii?Q?hIRIfw4vxDQ0Oo+xDIzjBMvxrYpAL5Xuktkj93yJrpH0i+xPtzZfHBnXEP/5?=
 =?us-ascii?Q?h2zd3AbSH8Wpe5XT/jX3hKPk8YxaAW/cmoLxpiNztjWWbs53LMuDxKl9faPQ?=
 =?us-ascii?Q?ki9bF2vs7+F36ABvzMtZ985IoFxhdMa87ze/f7+8RNKgJ7mFDBei9SPjOzHa?=
 =?us-ascii?Q?GKkPRsFhPhCvmn8BCG4qjMK6iV1xDsphkjj2Tz28CI0TY3bW0KwXnySxJNX8?=
 =?us-ascii?Q?mK7TXnJOI5Y0ZXuQVarvyT109XBUH71PY97058V+C4dmE7ZGj5CAMuC5iQ1v?=
 =?us-ascii?Q?xLFsiCRodjVDxp0VIBw+l2XuBe75qUx/mkcWL+6cNzKkmzoDFIE0YaRWPSRE?=
 =?us-ascii?Q?zZTJfwdSsDU0+EhO2g5qnwUlbocotEL8v5o8ohhYdeRTM5h4H3xrRusHSFyc?=
 =?us-ascii?Q?HKYx3iM/rF0o/KPF9vFFpBIO8WOpI5A+DiwVl/4mSMAYH8W3e1VvlHuzr1KD?=
 =?us-ascii?Q?yMHJaeVUM0Tr7J1lqTBjww9Qww6AlbBogU6HWRjFf/tFqiSW1VmtvKxfDiMY?=
 =?us-ascii?Q?ZV1V3xs4HQNbi1fpOAbO6dZtok+c5Vb39/s+YdKSAGL/ePbd6tm5Uj8kmZNQ?=
 =?us-ascii?Q?KnEKp1JzQfsn/XbWvo6kjL1u/ByLzn2R4+vtUWTswNN02wBiUiRMq7WoRLWO?=
 =?us-ascii?Q?JQqMDuqTblb7cgTZPEghjk9RuZTQmLU4fV5NCw2oQL3zn1M/61U0JALVbxuw?=
 =?us-ascii?Q?ztR5dCGUZ2f3dA5R7O11YrXq8aFTsyTtVfX60pA6HZZ/M6d5YbnD91b1pkzJ?=
 =?us-ascii?Q?xyXwUgwm+9WtHvOJHro/rca1fon7Fn0Cun46J+di1Hq8u/xqTRC2V7cE0M+g?=
 =?us-ascii?Q?Jrytja7Awmup4jMXbmzEY/B42IOlphAeo0PT2NpJ1bYWhAbQ7vcKrTvzKPpN?=
 =?us-ascii?Q?nxgveEi32nn5ELq3smySUJ8lbtW5v1MU8AtCn72F/JOnm8NW+4b7JIYcDRDS?=
 =?us-ascii?Q?pFMMTr2iCkF9a3PaMwKJWtop0nLNOAitUq3RqMIGrfov1tR2FkGmorkSDzAc?=
 =?us-ascii?Q?6eNgHBuxbN1mYmyMRjRDkvdOtpYvY2m++O2yx/hmzJiQh7TaOJeD1HrR3UPs?=
 =?us-ascii?Q?5xXt1E6+JPHYO1xN/EqennDZFMdEj4hcYD00IU+qyvIL7aFnFJccTfb1vFWH?=
 =?us-ascii?Q?v052JDrAGlvwIXsq4vA6m87tSbN4bJMKsU4baVrGjkAJPMnN4RjMyH8epuId?=
 =?us-ascii?Q?VNeVkTKHT1+OqhEe+0epyNJc2C5NVkPiMzCvtZ+8rBtek6GNS0JRfS3jycLy?=
 =?us-ascii?Q?i6wXfAPaAhKK8nwWl/RuU12F9v9U40J9LdM+Mr1RRgl0/MmUPbsLK+9HhzTC?=
 =?us-ascii?Q?4/OipGmBLhvujjc759YUbjk1NkSOjfU2pvC6nGngMY2EoA+c2/cl+9JY9Z1W?=
 =?us-ascii?Q?XjGSREv0sZrlk9T8lIolgXlu8/BPglyGTi8m6/rNSeNSwhanmaFTl5FZboyt?=
 =?us-ascii?Q?ZDdvU0IRgfKcdolMpJIfw+HlikGYHfqG6LziX6fWQCsr8k93zMQSUwbx9Vd3?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: c8+zpjWz92ZklV7pSy4jD1tYcUgJn2BfpvhuygfwC6Nn+iTYPFIzogDNL+9wsP0fx05I86jDkDxmq951ubGOA2zdCOoNech59JJznTuhtn6e7vi4Bx1v0RcPPepa0uSqzaNGSL+H6maawSpLhFi70l01wiSTew8YY84FuMSsdXI6iQdnElYx3QAU4Y3oikXG5OzdPoRRvsWwNM8UvmGeiLJWJjrapGxb2ZE6MLVkZL4VEZO7hwJMWlzD+W7+LlbJIHmRXe0avSKeZviKR2X9eN713wnGEQU/0U+qaRy8uDjtymtwdXUccbeqx55NfIJ6g3nweRTbPfrzBleWWZCCJO0E4b7c1IekVZY2ykw81rBhTnR20YekdwCf2VP4TNk9lE0LmbVdqGiMW/zOVcgUjWVGddYJsnQQgVu2gJc2pTAx4sFOjfKGc0GxwqwlBGnQ6vFBMTgU5NCSHRo1ayGlZ18OJaW357YXiTI/tpY/7KXRVIQwLnBQBv2kHCAe5AFndu3PU5IIVtH0vc0wMzNsFq7Q2p9u4BhywYmw2AblDICzRP2cDbjOmyw3UTXIs0bQOxwIlsJsxFkccMLLJxRXE6cmSzNHwRQ//tMgt+GlwesxWSnGpOCOtgIVfgOwsGHBP7OwF8u9lr1PWlypQ78ao+bx2ycU0J8BAZSfsLxHD3P76rDEAGunE8xd4xK2vF72GlKh2EHWnFiW4RElk2nzccTCyt017+ib6Ek0jq89UrJl7EFMWUeQlKEP7XKpmzovem2TwDO9+lHwu0I4kkHsd+ObTObF+yPcJMF0LXnFHHM3Vg4LFAQHQvVCf/7C+aQ2wcoa76KPlZyXdzz9IvOzYLe5TQnSA4MGLgC5KfV9B+u2N4rv+bvCODs67O0hLj2B
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9eafc84-da3a-4289-3dce-08db0fdddf77
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:23:01.6566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c4iSjKN7RqENxjdiO/7omzkgLaOFgtGsWFrV/JlFdYspOoz0TpwpYNWEgM2BnfkIIPDMu1NYPnfygppIdgalQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160044
X-Proofpoint-GUID: HR_fDeFw48OK_ZvV5_P2qnxoW3GlOZ5c
X-Proofpoint-ORIG-GUID: HR_fDeFw48OK_ZvV5_P2qnxoW3GlOZ5c
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit c2f09217a4305478c55adc9a98692488dd19cd32 upstream.

[ Set xfs_writepage_ctx->fork to XFS_DATA_FORK since 5.4.y tracks current
  extent's fork in this variable ]

In commit 7588cbeec6df, we tried to fix a race stemming from the lack of
coordination between higher level code that wants to allocate and remap
CoW fork extents into the data fork.  Christoph cites as examples the
always_cow mode, and a directio write completion racing with writeback.

According to the comments before the goto retry, we want to restart the
lookup to catch the extent in the data fork, but we don't actually reset
whichfork or cow_fsb, which means the second try executes using stale
information.  Up until now I think we've gotten lucky that either
there's something left in the CoW fork to cause cow_fsb to be reset, or
either data/cow fork sequence numbers have advanced enough to force a
fresh lookup from the data fork.  However, if we reach the retry with an
empty stable CoW fork and a stable data fork, neither of those things
happens.  The retry foolishly re-calls xfs_convert_blocks on the CoW
fork which fails again.  This time, we toss the write.

I've recently been working on extending reflink to the realtime device.
When the realtime extent size is larger than a single block, we have to
force the page cache to CoW the entire rt extent if a write (or
fallocate) are not aligned with the rt extent size.  The strategy I've
chosen to deal with this is derived from Dave's blocksize > pagesize
series: dirtying around the write range, and ensuring that writeback
always starts mapping on an rt extent boundary.  This has brought this
race front and center, since generic/522 blows up immediately.

However, I'm pretty sure this is a bug outright, independent of that.

Fixes: 7588cbeec6df ("xfs: retry COW fork delalloc conversion when no extent was found")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f16d5f196c6b..5d9f8e4c4cde 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -495,7 +495,7 @@ xfs_map_blocks(
 	ssize_t			count = i_blocksize(inode);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
-	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
+	xfs_fileoff_t		cow_fsb;
 	struct xfs_bmbt_irec	imap;
 	struct xfs_iext_cursor	icur;
 	int			retries = 0;
@@ -529,6 +529,8 @@ xfs_map_blocks(
 	 * landed in a hole and we skip the block.
 	 */
 retry:
+	cow_fsb = NULLFILEOFF;
+	wpc->fork = XFS_DATA_FORK;
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
-- 
2.35.1

