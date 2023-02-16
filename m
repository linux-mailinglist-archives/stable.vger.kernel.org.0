Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3414698BD6
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 06:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBPFZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 00:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBPFYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 00:24:45 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AF04617A;
        Wed, 15 Feb 2023 21:23:42 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2IuTd020334;
        Thu, 16 Feb 2023 05:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Pa4s1hlF86evwbON5ueqrqWOcJtbYV7XE01VujcIwC4=;
 b=urgB72nCvibrWzD+EaWn+WFJi/e117NwTWSqgkXcYID6dUUAvWajPm0uxLg05Z8FLOIj
 DgJd24QmxcrxwLCeM4CQ+fyP2drH+dQlwrhVJ1lgWtymmui975rcVe51VNfM+/PxSplg
 gLzLGjMZw8l4K2SOw9KQd3JvELPFp1c2rBOpqMmFN/0rqDLhcT2pELWxkGMYEaUdsIs9
 JkNimzZTiphzqkdrYVav1d+txNtdew+aXPmQ1r15mdvRK3br8rkqabDX1mhecfqeilJa
 vo6+dYQBVcf2tAQAFR4DnDNYb7R7rotJIOwRy8pFYM2XUvM6vTxmPctSIIZdInBEYbCM ow== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2wa28av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:36 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G33ewr015132;
        Thu, 16 Feb 2023 05:22:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f84bf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTW1sXTcXUQUByLlMhKcBcbB7/G0zO78at9B89aPv64zaSN/deJ3SOnXRP8I1a85oxVVrGPkcwiSAd4zC3Cc6Brs69j6ls/67HqyqQQaEPphSIWOvL8ReUEyyejmXH0nhikV+eygs3p6hNuWAwzLkV2RUv7pe8pkh1VpxPr8WmVXZdnVYoDwkkN6SiYJMfW7N0AFcMKISYNTJxhtuD3lnyk5jTnEvqGn8+6hasUGTB+jsh8UjzP+HIN9CAMtD49qqRV/ih6D7KEGHkCknR+s93538N8Ueo/6FUNpWcvv8lWv39hc0YZ6SHJG2QwaOfuQGd2dGVBmv0Dp9OlRxRisVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pa4s1hlF86evwbON5ueqrqWOcJtbYV7XE01VujcIwC4=;
 b=kFgnR75hV0quVhhA8LX/6hmX2/T00G8ZklgSaQ1myE9/TGwrtI+swoBSegthz1oqwLIn7p3ZB+w63hTmorfi9l+0YYOviyf4S0TvrHBTkQznnrCKT49BBdcqnn18PkMsvEZbjbG2WNyqXg4ceiitl1gVIDcqRFS1L2DFpZhAUfjqNAy2KpmzjxlvtCnx57u63Y5nhbY0WlwUlcuKe7ePT6DSxL42x4JIzijc3V0W/Nj10JWNPqnmJqQUOEgHRZ8QdAd5aCgnxmD8uPNRbrQoNCutFDBZqhzx/21vjGZ1mnC7lNsczTQZGUcgqbiW1Jjux4x+oOavV7Ryqw381RZZLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pa4s1hlF86evwbON5ueqrqWOcJtbYV7XE01VujcIwC4=;
 b=UvKGoQc1WVfaenLe8Oq6jDIP1TPwDG1DBaeDX96S/8uuuKVEw2kywkJgE9kMnZV5tcHiVJNjHK6k9qArg76cvroHMg1ZjJ2VGUWrmQvhRg80WdyRZPINKqtzieINO09/msR2e1XmMR+KCND6sY5m6v/ZGwMnq41IW6ROS7NAbO0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW4PR10MB6631.namprd10.prod.outlook.com (2603:10b6:303:22c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Thu, 16 Feb
 2023 05:22:33 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:22:33 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 17/25] xfs: change the order in which child and parent defer ops are finished
Date:   Thu, 16 Feb 2023 10:50:11 +0530
Message-Id: <20230216052019.368896-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:3:17::29) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: a244f8e0-90e5-4ac0-bf8d-08db0fddce9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z58tYCPRLn4wLZRuunkv6JjWIQeeP9gc57HpKCm54ceQuGkNNA6z371f2PwUhw7vk/Hdrp5iF32ZUS4tS3ro0s/P8DvVuWh9PgcOyWHqekagIaQK5dSt3ilBwYOIzGAH8TjkdVx65SjvDBSoDe3yhPOykCelWFz34ReawybeXWQAI6DKnriCR9QIClhV7gARfRYz78DFDQ2Pj+tvlN1pdJLMOOYDlaXHMq1pLsLKI3Yu2KgwRTjvXWZSWaUqmotXKLptdTmPM04mCdn411LEybtVQKzzaUkg1XqX56Db6TUK9KAT8NmtTURJxLaXkyfF1uzDS58UjTVLxbf0c2S4BDzVCSnZLnW91FsMfUmLsnOtwYKtI8/7zyAYFw2KJBIVknJg12P9bUb98IGoB1ll3T/dWv9A3ZvBtFgdXtCn4TG32VKngvfVFwIO2+yzWTX21p1bAu/06lKb53yImDMRMxlEzZpQusII/pa6fLdfBmKSWBCQMRzmbiKEMhE0SAQ1PENj9WdHHGOmIpa7oTvYedZTw2FgHLxoDyBpbP1cMg1DwZZ33wXSHU4r40aFkkYptnF+6qQMrKXxfDTNAwvaGyr1Lx7X4WuyYPwf1Gmufnkk1wTKoh9rZQ2FIPNR1HrX7UgZZRoOS3lQElzUvhLGTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(26005)(186003)(6666004)(1076003)(478600001)(38100700002)(5660300002)(2616005)(2906002)(6486002)(6506007)(86362001)(36756003)(8936002)(66556008)(66574015)(83380400001)(6512007)(66476007)(41300700001)(316002)(6916009)(66946007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YSKlVBJmCq2OqeplOQUozNWAC2koG/D2oRE4M/Jk86NXRuiYtja8jDZTqty2?=
 =?us-ascii?Q?CJ9ggOnKE8fgVAb8S2ufnhjNLVsUHgE6RGOmBEFiHbz/pFePM6zMR52l2mmg?=
 =?us-ascii?Q?miTP65fleeAO5gcStyHPROOFoES47ZdsviDttS1UBvNlKk88bQENiuH+/jWz?=
 =?us-ascii?Q?CQTD90u9GsH46ZvEPCT28518AtcLpCvYxyMHb4zp1wJ+9jV63RlZsYrlHn21?=
 =?us-ascii?Q?KwqFYIs30QXoH3VuFcd+Yfi/6g5jGQEyUCdZ8Yfiqd++gZgqzpL0HM33y4Ta?=
 =?us-ascii?Q?g8YwM9B4lY2GeCCQzUMQy/L1Cvc+xei0vFFRd7I1XaA/XXZIMN92aPHvCHPd?=
 =?us-ascii?Q?nFBWWLCZlb5qwFwZrQpgR5r/RqmyxtMkij8GV4wooJ0uDkTVP5YoEchJvMns?=
 =?us-ascii?Q?gWUYMpPrAbEM3oWvyzPWG8qpJDPrlIvkiM2yi6UxoaFyvU3ck3djRqX74g4W?=
 =?us-ascii?Q?cyUiI/Fr9QHia0C90sirnCRjwDpJIUyZmhx7WR+r0Y7Fx7mqCNfJHTQPPlKM?=
 =?us-ascii?Q?OX8JqX92kxO2JV8C65muyl/VwBt+Rlq3S+jWxlrBJ8N8jbUPV6F89TlYZkc1?=
 =?us-ascii?Q?zlevq5T6MO3drv8cdpsxpJMiEkDc+2TX8zf75L3Kryjuuel2RzzMRJuCA5cv?=
 =?us-ascii?Q?BVyh5LreMuCqiegUAxqx1cYR1xvCTo3J+dSEKxTjtZFj8RfcPW7e2R7k1lI4?=
 =?us-ascii?Q?XWH65LG3je91pmxbHfeivv/99JPptCvuCKY7ug++JiOYYb997+er5EPZyFfO?=
 =?us-ascii?Q?vPw5c/x2xIUHSJr7ytmynFee1/5u1fbWaKyOw89I5XK/Usat2q0WCnx89Ga+?=
 =?us-ascii?Q?BcJHzaUwSPmGVHGJj0NHej3ExLSx/6L9GGJI4bvddNcA7CzGdEao3hQg86hG?=
 =?us-ascii?Q?y0axHGeE3iyE9aeBcs87aMN/YN7kbUei5jQ2jRUlwuuqoBP18+EkVb53mrJi?=
 =?us-ascii?Q?7Qgf/s22tqkbD0Lw0uGeawNhurY4rnZMxHv4AgvrplIn3kI9pRCflfGM0CFr?=
 =?us-ascii?Q?wXD0qAH8Gq4vdesx7dAZ1+C+SejmB80zZrcqzMWs8/2e9YAUoub+0IhjVV/X?=
 =?us-ascii?Q?nlW7prZh8dweebN5hdVpj8g49N//35RDbSmhtnAfIiKVjDXD3blSXJvzNXF6?=
 =?us-ascii?Q?M0WxsPbSVwKvdmOWLMH6lkptT0VeN2cVOE8yApvZB9nQ+mToQ747zFTlOG4i?=
 =?us-ascii?Q?dRQ+hpo/tdetraw0YLRvpwBCpMGjewIoE9lfrysL/Yz43sBaS/rO3H2j+SBI?=
 =?us-ascii?Q?qB3Bf9gJnvv1oPjBaHJAj9xlIgD8wP/gmcebH6wnzPaHABoUQ2wE/Hf70iO5?=
 =?us-ascii?Q?nuDaol77IWzeNjFbKO/nDOqsJEnB7KHNK8lkBtiIC5Itbkd8FI5oxqyxrWMs?=
 =?us-ascii?Q?uRMBdtgyVJqXsXRw7i7LJnohzHs0wxKL6cvvMK9OREQXuP+6hcQcX1L8z1P3?=
 =?us-ascii?Q?KyFwI/gDVERVZehecvMwc6wXJ0tzhXvSi+pZKaOBysP/Qzb2TciWYTYqTB2i?=
 =?us-ascii?Q?tk5/c/8jGIWChND+QgnbZdtpOnUdyjWOIF6JxOSD5wLD64c/e7NUSchJnhYk?=
 =?us-ascii?Q?DahdpdcZqEJPYhvUNO7ehJZWYUCQ/GUykPp+u8diKu5S2P5XI7pDRji4buy3?=
 =?us-ascii?Q?hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Nx5RBKG2v6Ma7rNeGP9qQwq0IP15rHcS4dnyD3M26ZdQKXQjo9k4m2XUvdiLSDo03exXeLd7DLonfVtFSJ8M66xRDbaM51zz2zB8SUYJCJMg66CK6QnxPrnw5kX9kYKfo8vGA/cSK7xnKwHcH0Il4TwyhSEv4300vGthqYM8lpcKGb2pSu8DXkuwPaXjyuwoVsFwazplgEtrRwBPbJcrPaLX0kErp2vBclsdFR2aGLkCsBYfTfd61f/r6tBxi3Uya56pXLyPHsAxttucdVAZsLzXYbFuH1MZtGTGptY6i1vkVnwNEwQ0GNWyOdr/DNM70ewuGqKGnIgna8P11dwVSTqmn01DRVOaWd1154hkIhLpKAQo3RQfWdwhR424HMoKVFdHcSgc/VF9rTC2qvJHD8QU3Gs8pFelVjNMqZktb0dZLMTVnHBbkiOX209kLjYIAihL+uHOIKwOXh8vH+FuZfYiAgR+TOiaTCFLxtwoQ9hfpVZBqHBmN+iTvimd/R/8g1VyuimpUu0+qSz3j+fMxsrzlIZGxVj8D1xz79SiHjbMJD2u1+B61P8t0NSvAdShkfoxBiX8vuSLhRlF8pH3LgK4oSGCMa4xOGF14n0vHBaV9fTmEHJypeP5hyCVuxi0wXt1nRKJWPHzVP3n8GGL6WxdYNvNXvjgxcfFBmB+sbk+C/O1u5ZxdI17AJmcV1Fch0JF/0kT8UA4f4ZhNrZS9ZuY0gfU9/SO3A5drqqO6+AKOIEfuJ1mSENQZsaX8kPIsiq42ElNWz3ULIKD8dpJWWM2GZLcTBfGgpnNtedWaXf7LbQtPefZHOFCy5oprXEPxkSPlI7ptW1yU0gXBGjsGDhYk9Xra8pCdWvYbie3fCLAwtg9iGnJavxqT6JtFpsz
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a244f8e0-90e5-4ac0-bf8d-08db0fddce9c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:22:33.2718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Y/B7MQIXSVtabhVS2k8Cz91JdHnlcTEqT4qOjq2gcNNkmmh7ChQ9LN5A0WgDfv3D4PQOgSrxb7yN2bIzm+UPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-GUID: Mej4FbYiy46xYkwfFwgf8T2msHwE_5LG
X-Proofpoint-ORIG-GUID: Mej4FbYiy46xYkwfFwgf8T2msHwE_5LG
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

commit 27dada070d59c28a441f1907d2cec891b17dcb26 upstream.

The defer ops code has been finishing items in the wrong order -- if a
top level defer op creates items A and B, and finishing item A creates
more defer ops A1 and A2, we'll put the new items on the end of the
chain and process them in the order A B A1 A2.  This is kind of weird,
since it's convenient for programmers to be able to think of A and B as
an ordered sequence where all the sub-tasks for A must finish before we
move on to B, e.g. A A1 A2 D.

Right now, our log intent items are not so complex that this matters,
but this will become important for the atomic extent swapping patchset.
In order to maintain correct reference counting of extents, we have to
unmap and remap extents in that order, and we want to complete that work
before moving on to the next range that the user wants to swap.  This
patch fixes defer ops to satsify that requirement.

The primary symptom of the incorrect order was noticed in an early
performance analysis of the atomic extent swap code.  An astonishingly
large number of deferred work items accumulated when userspace requested
an atomic update of two very fragmented files.  The cause of this was
traced to the same ordering bug in the inner loop of
xfs_defer_finish_noroll.

If the ->finish_item method of a deferred operation queues new deferred
operations, those new deferred ops are appended to the tail of the
pending work list.  To illustrate, say that a caller creates a
transaction t0 with four deferred operations D0-D3.  The first thing
defer ops does is roll the transaction to t1, leaving us with:

t1: D0(t0), D1(t0), D2(t0), D3(t0)

Let's say that finishing each of D0-D3 will create two new deferred ops.
After finish D0 and roll, we'll have the following chain:

t2: D1(t0), D2(t0), D3(t0), d4(t1), d5(t1)

d4 and d5 were logged to t1.  Notice that while we're about to start
work on D1, we haven't actually completed all the work implied by D0
being finished.  So far we've been careful (or lucky) to structure the
dfops callers such that D1 doesn't depend on d4 or d5 being finished,
but this is a potential logic bomb.

There's a second problem lurking.  Let's see what happens as we finish
D1-D3:

t3: D2(t0), D3(t0), d4(t1), d5(t1), d6(t2), d7(t2)
t4: D3(t0), d4(t1), d5(t1), d6(t2), d7(t2), d8(t3), d9(t3)
t5: d4(t1), d5(t1), d6(t2), d7(t2), d8(t3), d9(t3), d10(t4), d11(t4)

Let's say that d4-d11 are simple work items that don't queue any other
operations, which means that we can complete each d4 and roll to t6:

t6: d5(t1), d6(t2), d7(t2), d8(t3), d9(t3), d10(t4), d11(t4)
t7: d6(t2), d7(t2), d8(t3), d9(t3), d10(t4), d11(t4)
...
t11: d10(t4), d11(t4)
t12: d11(t4)
<done>

When we try to roll to transaction #12, we're holding defer op d11,
which we logged way back in t4.  This means that the tail of the log is
pinned at t4.  If the log is very small or there are a lot of other
threads updating metadata, this means that we might have wrapped the log
and cannot get roll to t11 because there isn't enough space left before
we'd run into t4.

Let's shift back to the original failure.  I mentioned before that I
discovered this flaw while developing the atomic file update code.  In
that scenario, we have a defer op (D0) that finds a range of file blocks
to remap, creates a handful of new defer ops to do that, and then asks
to be continued with however much work remains.

So, D0 is the original swapext deferred op.  The first thing defer ops
does is rolls to t1:

t1: D0(t0)

We try to finish D0, logging d1 and d2 in the process, but can't get all
the work done.  We log a done item and a new intent item for the work
that D0 still has to do, and roll to t2:

t2: D0'(t1), d1(t1), d2(t1)

We roll and try to finish D0', but still can't get all the work done, so
we log a done item and a new intent item for it, requeue D0 a second
time, and roll to t3:

t3: D0''(t2), d1(t1), d2(t1), d3(t2), d4(t2)

If it takes 48 more rolls to complete D0, then we'll finally dispense
with D0 in t50:

t50: D<fifty primes>(t49), d1(t1), ..., d102(t50)

We then try to roll again to get a chain like this:

t51: d1(t1), d2(t1), ..., d101(t50), d102(t50)
...
t152: d102(t50)
<done>

Notice that in rolling to transaction #51, we're holding on to a log
intent item for d1 that was logged in transaction #1.  This means that
the tail of the log is pinned at t1.  If the log is very small or there
are a lot of other threads updating metadata, this means that we might
have wrapped the log and cannot roll to t51 because there isn't enough
space left before we'd run into t1.  This is of course problem #2 again.

But notice the third problem with this scenario: we have 102 defer ops
tied to this transaction!  Each of these items are backed by pinned
kernel memory, which means that we risk OOM if the chains get too long.

Yikes.  Problem #1 is a subtle logic bomb that could hit someone in the
future; problem #2 applies (rarely) to the current upstream, and problem

This is not how incremental deferred operations were supposed to work.
The dfops design of logging in the same transaction an intent-done item
and a new intent item for the work remaining was to make it so that we
only have to juggle enough deferred work items to finish that one small
piece of work.  Deferred log item recovery will find that first
unfinished work item and restart it, no matter how many other intent
items might follow it in the log.  Therefore, it's ok to put the new
intents at the start of the dfops chain.

For the first example, the chains look like this:

t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
t3: d5(t1), D1(t0), D2(t0), D3(t0)
...
t9: d9(t7), D3(t0)
t10: D3(t0)
t11: d10(t10), d11(t10)
t12: d11(t10)

For the second example, the chains look like this:

t1: D0(t0)
t2: d1(t1), d2(t1), D0'(t1)
t3: d2(t1), D0'(t1)
t4: D0'(t1)
t5: d1(t4), d2(t4), D0''(t4)
...
t148: D0<50 primes>(t147)
t149: d101(t148), d102(t148)
t150: d102(t148)
<done>

This actually sucks more for pinning the log tail (we try to roll to t10
while holding an intent item that was logged in t1) but we've solved
problem #1.  We've also reduced the maximum chain length from:

    sum(all the new items) + nr_original_items

to:

    max(new items that each original item creates) + nr_original_items

This solves problem #3 by sharply reducing the number of defer ops that
can be attached to a transaction at any given time.  The change makes
the problem of log tail pinning worse, but is improvement we need to
solve problem #2.  Actually solving #2, however, is left to the next
patch.

Note that a subsequent analysis of some hard-to-trigger reflink and COW
livelocks on extremely fragmented filesystems (or systems running a lot
of IO threads) showed the same symptoms -- uncomfortably large numbers
of incore deferred work items and occasional stalls in the transaction
grant code while waiting for log reservations.  I think this patch and
the next one will also solve these problems.

As originally written, the code used list_splice_tail_init instead of
list_splice_init, so change that, and leave a short comment explaining
our actions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 714756931317..c817b8924f9a 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -431,8 +431,17 @@ xfs_defer_finish_noroll(
 
 	/* Until we run out of pending work to finish... */
 	while (!list_empty(&dop_pending) || !list_empty(&(*tp)->t_dfops)) {
+		/*
+		 * Deferred items that are created in the process of finishing
+		 * other deferred work items should be queued at the head of
+		 * the pending list, which puts them ahead of the deferred work
+		 * that was created by the caller.  This keeps the number of
+		 * pending work items to a minimum, which decreases the amount
+		 * of time that any one intent item can stick around in memory,
+		 * pinning the log tail.
+		 */
 		xfs_defer_create_intents(*tp);
-		list_splice_tail_init(&(*tp)->t_dfops, &dop_pending);
+		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
 		error = xfs_defer_trans_roll(tp);
 		if (error)
-- 
2.35.1

