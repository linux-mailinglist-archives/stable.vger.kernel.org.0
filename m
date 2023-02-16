Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC33698CD6
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBPG11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjBPG10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:27:26 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5E53431E;
        Wed, 15 Feb 2023 22:27:25 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2IsF7020328;
        Thu, 16 Feb 2023 05:21:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=qhaXE3o+mFMq5VMjbTCiLPnPq+z/9IJcmP3re09v+S0=;
 b=KQYb/5HElwMuN7MwgYOEFcLIZYl4FnEenqrHZY9xzRJwpeO1E9uvFZxeLzbNfBeRRadV
 LKoxkpB1HRq4p28ZmCKPayybL5EKZWK5eKocttn5sSspY8V2RG0gZ9+jr+I9oW0RwTml
 svxcFQTCJGKjTVvvPqyz2TXEiSELVkUDWEDB9VuRApDNVNNHfl2qjX5Pnn34NDo/OdUj
 pDOmHdJ2+F/XTiEdvPnZbyzG0cvqk4tuH2w8Z0PE0vUeKxvWqr4OafpLYB1YL64+RNj9
 KcQI/GkIlmcNgtbSzMOfYrju+rOlpBT4mDB1RQsIbN/hGxls2IZQfHZgWv+Hw2OWnLNE Bg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2wa289a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2j555003727;
        Thu, 16 Feb 2023 05:21:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f85eyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIWZ02S3Fw2E9JTBgirDEIUAmGsDTBs8oYQMWE83vQnRK+duraQeYJRfQ0d8e98eowzeJjgs4X6nX+6jVkkDE6uJykG7TG54S7auUqXmWH3JhuP2RauRketE4FaCXRfQrFNQPt9yCwpkRBzXwDY8WrmCKAumlu+wtm13K9pBb8m5IbykAh6YjEMxp1C3QQjKXmnMUH/62p1KrTOP5binio35lBvgTJ8T/H+Lsa0v6L1pIBwf9oj1HQpt8pdL3FytUI7T3E1IUZle1c+9ffoQ8tAdFJ3s3/JDGRXtfawBLZhUZgLIiTYt+BD4F4hL77myRqAQd6/vEgZRmgri0o8LbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qhaXE3o+mFMq5VMjbTCiLPnPq+z/9IJcmP3re09v+S0=;
 b=inh8dYzXc1wkWyxyrMXJbu4ZwGulqgWwo6JHdXTRj7+fMEz/S6U+LyQuxS7/IUlaL4hsnmb5+T6LQjdcmaYBNnVFwq1SlgeoHBgaRfTBEmLXx2VKysNcWnmcckNyBGzMxvMfGhiNNP89Sqtx3bG5HybRJMeJv+fxmgttGFT7Y4KGE4xDP+9BtqcllOZcOS+Tph87L5nBH8m9pdx5XGGx6E1xFHqA2wuoq8Ltl1C3uGgMXcOxljs6HJA3pIFmDfe39V8HSzgQAzLdd+4PpNIJfmMKZCwSBI0f7Vy2GOsU3wlAPQk21eX0jexiaZy/p2mB48zwOBxUBDFUsFaNiKnS+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhaXE3o+mFMq5VMjbTCiLPnPq+z/9IJcmP3re09v+S0=;
 b=lCYfQUR0CFngkAtpe3pettzCc4h2IRz58YpJI0FKBWXNhjQHCyIt0/vuyps3HaogFy463C4n6+U+RecSu75lWPay6ZsqY1jOcFNfrtxEArGJQ6/QtTKIiIlKOCVJkzkna17pHKStN6fHVJbHtvkdceWyMe0xTHD8ko63XntckpA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:21:30 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:21:30 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 09/25] xfs: log new intent items created as part of finishing recovered intent items
Date:   Thu, 16 Feb 2023 10:50:03 +0530
Message-Id: <20230216052019.368896-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0170.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c6::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: f93887d2-21f6-46b2-6d4d-08db0fdda8e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9O/QygxEdmPrs1k50VygFEKpAg/nPq7JIlxYWuOPQbdPEc/ZV5KMuCRm83aq1j+S9AsXsfbNPx1Z6tGDSwCP6IAHu40TvW6kccHb/UPXI/tQ8yaIG5eKlzWGqDLQ9Tup6MENgYZBtGWEsMi35xssAUBrI/aVVLW/CMStj5xog4PBtrA3IAhRtm8MdXbPPwspvMUHnvdOVdDSwXKjL9HaFucU5XqLdJndbgqHkvDroVfIFMbtsmJhW1u5oNWnwINCpYKk7TuQILvypvTt0PCUxdx9ShwhY3Aqd6QWHCJ0PdaxigIxp23y9/NGGjvGrcTcJJUK/eVXOumJA3ZDmL7HUfT/b4TqZ0nLLuACQkIKrLkswYy4TNPIgCAt/z4Hw+COswMwJ7TyE6fOh2/Kyk0D1hlHqRgBJ4vH/MEiRhHYFE9ariroAC9BqJnOE+xRpmk03RnBd/3aADUo7WzbyrKJpb9J5RBU6vLnw7sbh1QOJKrsSERfjk4FxRh4aYvTx8jvbtAxntHcvBCX5YAGcR491OzFrXyX9kZvm8f/8ECFui/6Ao3KapLxREx5fUXwUYkDlaO8XkLJTEws05Q2lCJbfqzrhURgT9SnjQDgd3yCxsZUW8Y4cOicc3uG9Ci4Ypy6NcSdhxUXjM4e1KpWF8lqFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(66899018)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(6666004)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bwi//MwqqJvoDflONbo9wlBG/nHT3LBQZyXb09wPu8tU+2TjFx1gGATeaCXd?=
 =?us-ascii?Q?ncNCljQ4I4ngW8LK0Gg2aSg9FY9ALLJKRx98ttt8oz6tjYm1qr/ziHBWu31P?=
 =?us-ascii?Q?QL9rdgeIzV868nVXcslvll5vUi4stKiLmD+sIuYy3yv9XYOkUHmjdpOjOkeQ?=
 =?us-ascii?Q?H1hx945VZqXAEwk2YUK/V5sJ8GJI8/wpug1D47O5Ewf10Q2h8LU4V0N2dBnr?=
 =?us-ascii?Q?iz51svPD8UT1SNNt2QtxoNpUq8SCLGkNTl1x+8pjrhfxOqs4Pb1Wu2ugS2UD?=
 =?us-ascii?Q?2LkSL+Iv0UiFoDvpW41jU98rUqDKi72eO6zmamVTi1Dbg+b4Bb5yKg6TeJaw?=
 =?us-ascii?Q?LCIK82H6LwHiqx1f215RVY1g4I/stdvTv8nXbkA45zy1vcIsHMDmTd4JW2M0?=
 =?us-ascii?Q?vqGCo/IgB1FqmE67jOUqUcH9pfojfJVkRhb5w3QKZe0tNdb1RtorJpHPdQ6n?=
 =?us-ascii?Q?Vt4NB1dCnRgp1xIE1lm//g6XS8Nvn5d6hc7+xL21fLjWpmAJLUKa2gm6BQ28?=
 =?us-ascii?Q?Zu5hpWHz5KDmMh6r3bjS4xltgDAwwb1Guwgc075M/GwjMv8xjUxYhdFd5hqu?=
 =?us-ascii?Q?w7QM/hxGCU+S6YK6R/ZFV6KC22iauu+OJGF9m3q0AdKE4uvI0npmR8lBhPDK?=
 =?us-ascii?Q?c2QlIfp4axvDJcyBUil7Isgx+620h+4vbzqkkOVbzb4lNvJyrwNJ0iz5jate?=
 =?us-ascii?Q?g0BSAtjFaXyoIKJCEpdCNo7GZ0qptD6vwSihpHyaXZf2g1SLX1DAPZgpx0KJ?=
 =?us-ascii?Q?ewQZ7T4SkhSydsv/Wu2q9pA0pA6TGN9ueS4O8s6ZL+GVzVRJIWBujKb31NqI?=
 =?us-ascii?Q?covmUKe3lp5z/8pgHz1xA9aeMY7OwLAw+9I6fYZhnaKNMsHPSYMMRgHmcP/9?=
 =?us-ascii?Q?5WZFUNH7YL3U7SIYmXOzIktRhSktbZqTAFg1zavwCilHf71X2peRodftLNlI?=
 =?us-ascii?Q?vKEmrfVXRcwRqBXoFBBJQTG9JDiYYzP73E4L7LQ67+KFLcALVaVNwjQ+q5NV?=
 =?us-ascii?Q?uq3QD79xfpbSh0W+aPXpGHxEGvTQJ4Kh9ie261+3rZ3vAo5aMr4gkGgIqfsl?=
 =?us-ascii?Q?9bSf35+7BwFfn6eBOE2nDhsE7DP+bFXqLPgLu5QnTCzxQwyIfLaLLmUaVtcT?=
 =?us-ascii?Q?78G6/Z+MSA9p7fQZ2LJIAEXO59EIZKnp2arBQl7YSO/m59lsK8jG6pm5nrTV?=
 =?us-ascii?Q?WrIbvFu97oKhLLgzp9inOjGYWY9RmntLIynJ0aOVd1WYwqcrZkaHslBkK4qq?=
 =?us-ascii?Q?2e3vmr+uq+109bXPa/1hHlmvcBLBbIahoD+8ryqCZNtylrjusaVnRGR/3MS/?=
 =?us-ascii?Q?0FVf6WRjpBRIX6DOAAYrN9njP2QZM4SLwgEH+xjftCAQ+bYNWC/8eMpedR2z?=
 =?us-ascii?Q?QdVJbKugT7+kujm4jpYBiMcH97PbSm4HrGf7txnChT2Fqf0j4zFxJEnIT9uX?=
 =?us-ascii?Q?IQtY5j6X8UHVjP6jvasvbPC63ggyZbYWqnUQXoUf5XbXJsANOHrc+V+88Ypa?=
 =?us-ascii?Q?6wG28XY1rVHHm3ybB7s7FHbfOAYdYZKMUVJ2xdP3NLseB5fVbTYmIvNK0swe?=
 =?us-ascii?Q?PgdD9I1ucSVVyCsAGdHO4m+52MPbqIAX+0o8yl170CXbXjMjSpUJb/Jh8VYy?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SEqQTdS8NHlbaREeXLDB0/VsoxF/xo441b+j6mWUbYg8qaKX1FqjDBkKjjCjmHwthOZArkbDzFgUl82bdxavC4FLjd4uzNl8U76wtaq5FQAsCf3kAxFKsd9/RQTwLEbo/vSuAs4yFFyygXZMO724bBNDDAfB7tvqZNH2ZvFcanvMMzxA0Mb2/riVwgDPt8ITjl7WFxJq8z2mwaEnZu83pXcr/OInTf+9UEnFWo2y0zrKRdkiRimXUEXDm3TIBdekBtYZCRPMoyLLws0hYM9ARVc1QPGcguH/sV2RqAxvZiVyWcU+qN9SOOcWYlVJOwMY4jV/ZcJjJv0bojoBW4XMRkS9S0j/mmOBizFColqp3L2TWGN4ktsKI0xSK5JPpGRJF3HeZS6s2MMweBHPM1JQIYlhWib7gc4VXgvW7k08fW5X8FXfC1O+77IDcXUy0UEALpjzGcM+SsJIzsJhUoCCAOKeakTJ3Gdttx89xOl5wVph4bjoRT7EuMi2zOZEp5TrxRpyIzrKFbgo2xsec2dr8QA61UNcQjatiTjxoI+Ztes7OzwpeJomR86uDtUJZtRzaSHHD04AXgQrQfxP7q2tDgSnaz3mwxSNfw29Uu740/Hy6O64YiLpHrSl/+fgcancn0duz5YXu3cddXJBIkYImx6Wd2TMcZI25Avc9MTmwjSvI1BMehxZdc13jrgobuLTMveeGeiU1zhnTv7psm/eHD1s6OaO2ojHVvkVucGcdVJa0vJoR66VF4rT6widjL8qJYMP1CxfQzlKEC7FtC5lCtl4DXofjki7tXDTFdBaxPyLg6pYZNYKv0TgOGLk6F4lqKjkiV5ep/C59pgj14UyabaJCHAxCMXhq2f7yxn7+sCHgX60E0aOEuNl6xdsUMb8
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f93887d2-21f6-46b2-6d4d-08db0fdda8e5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:21:29.9947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vxNof6EC67hsNiX0dBSH3SMfoXBPC7/WtJ2hRHvRR3A1mvuMUUlyDj0K5JXVLZ7iyAVGjUF57lELOgujV993jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-GUID: kSA7zaeUMxeNFAYW71V6YUsCU2lckc4h
X-Proofpoint-ORIG-GUID: kSA7zaeUMxeNFAYW71V6YUsCU2lckc4h
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

commit 93293bcbde93567efaf4e6bcd58cad270e1fcbf5 upstream.

[Slightly edit fs/xfs/xfs_bmap_item.c & fs/xfs/xfs_refcount_item.c to resolve
merge conflicts]

During a code inspection, I found a serious bug in the log intent item
recovery code when an intent item cannot complete all the work and
decides to requeue itself to get that done.  When this happens, the
item recovery creates a new incore deferred op representing the
remaining work and attaches it to the transaction that it allocated.  At
the end of _item_recover, it moves the entire chain of deferred ops to
the dummy parent_tp that xlog_recover_process_intents passed to it, but
fail to log a new intent item for the remaining work before committing
the transaction for the single unit of work.

xlog_finish_defer_ops logs those new intent items once recovery has
finished dealing with the intent items that it recovered, but this isn't
sufficient.  If the log is forced to disk after a recovered log item
decides to requeue itself and the system goes down before we call
xlog_finish_defer_ops, the second log recovery will never see the new
intent item and therefore has no idea that there was more work to do.
It will finish recovery leaving the filesystem in a corrupted state.

The same logic applies to /any/ deferred ops added during intent item
recovery, not just the one handling the remaining work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  | 26 ++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h  |  6 ++++++
 fs/xfs/xfs_bmap_item.c     |  2 +-
 fs/xfs/xfs_refcount_item.c |  2 +-
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index ad7ed5f39d04..4991b02f4993 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -186,8 +186,9 @@ xfs_defer_create_intent(
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 
-	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
-			dfp->dfp_count, sort);
+	if (!dfp->dfp_intent)
+		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
+						     dfp->dfp_count, sort);
 }
 
 /*
@@ -390,6 +391,7 @@ xfs_defer_finish_one(
 			list_add(li, &dfp->dfp_work);
 			dfp->dfp_count++;
 			dfp->dfp_done = NULL;
+			dfp->dfp_intent = NULL;
 			xfs_defer_create_intent(tp, dfp, false);
 		}
 
@@ -552,3 +554,23 @@ xfs_defer_move(
 
 	xfs_defer_reset(stp);
 }
+
+/*
+ * Prepare a chain of fresh deferred ops work items to be completed later.  Log
+ * recovery requires the ability to put off until later the actual finishing
+ * work so that it can process unfinished items recovered from the log in
+ * correct order.
+ *
+ * Create and log intent items for all the work that we're capturing so that we
+ * can be assured that the items will get replayed if the system goes down
+ * before log recovery gets a chance to finish the work it put off.  Then we
+ * move the chain from stp to dtp.
+ */
+void
+xfs_defer_capture(
+	struct xfs_trans	*dtp,
+	struct xfs_trans	*stp)
+{
+	xfs_defer_create_intents(stp);
+	xfs_defer_move(dtp, stp);
+}
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 7b6cc3808a91..bc3098044c41 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -61,4 +61,10 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 
+/*
+ * Functions to capture a chain of deferred operations and continue them later.
+ * This doesn't normally happen except log recovery.
+ */
+void xfs_defer_capture(struct xfs_trans *dtp, struct xfs_trans *stp);
+
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index f4d5c5d661ea..8cbee34b5eaa 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -541,7 +541,7 @@ xfs_bui_recover(
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
-	xfs_defer_move(parent_tp, tp);
+	xfs_defer_capture(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index a8d6864d58e6..7c674bc7ddf6 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -574,7 +574,7 @@ xfs_cui_recover(
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
-	xfs_defer_move(parent_tp, tp);
+	xfs_defer_capture(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	return error;
 
-- 
2.35.1

