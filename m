Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB9C6DEA68
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDLE2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjDLE2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:28:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A25EE66;
        Tue, 11 Apr 2023 21:28:03 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLf6Px018019;
        Wed, 12 Apr 2023 04:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=xO6FoOuSdHwDVECauRtR1VfkGDyP/hcqDO2SVjzpMrs=;
 b=u+pXQr6bq41zdW3WAKct9VHb0Z/IyliMFaMB4vV2G1Q1O5zONtz1+WSdhAy5B6P4g4Jf
 m4rWlxwdAGmGzwCRlwwWuS4QZpTFCsI3MnLXcWTCSbB4a0ig+sNOjsOgw5E+HUEJZTlj
 sPkF7uKGksBSUytpRouKBF6rZOltsxLJXWaGdt3SgkJKHwvVhiUveCGjCUaBvv7/huFf
 q4+YHx/whBtHW5beRhW5PElZcTyOrE1r3gcVPMwVTNdggV90ib9mnmVqeRwXcb2+thh3
 bTlzpDu9T2Bi5v/3POvLZeYKjEeYywTHCOlvlRrJ6H2jgGkV/Qk1R64FYdp8WydvTVHG Fg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0etq0vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:27:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2paXX030930;
        Wed, 12 Apr 2023 04:27:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puwbp82d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:27:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOISWEVWwdPqLUhGZNG0m6CLf6vCY8ofZ3gWV4ykaJEr1OQFBrOVUshQgEpkTfwZN6o7UWa1oaliK+U7aQlGvw4clsqRsVw28x36FqKEL5a1XdlcfrHudehdu1Ah6lgF57RNfZBn/FRbOOTwsKQg7oSR3Qg2ONWQt9pwc0lO8j3mUHxS/Y/3a1fg3J/10PtMPvknZ0Y0PsixrDYxXxh7y+22KPLMQsjLZIfZ+9L3ZZgCDiLo2L+9ittIzOCMafkqRJQNjggBv1yVL8Kbxqlmx/Hu1Y/3Zok+csHO0tacPWBctQa19vHAT7pWJWOjjqBw+CzdCgGkzP5taJ2NSuxDPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xO6FoOuSdHwDVECauRtR1VfkGDyP/hcqDO2SVjzpMrs=;
 b=UrNqQKzYtkvFeBln7/4wOZ+Oce2HhyKn55xjRslpv99GOKqw7WKtPIGBpeI51r7A1K6ucXfTU7yzGAgRLn6FYGx8FH2w19XKoYkqhkrtDcMLY8ga57CE41KjXNCfqfms4ThWJz39wTgWWfbR/nq3GFZWV1MEX1b3XRlLcuz5oSFkcNQHSJ/5CCrbnLbdEltqGunDKM0M8c4PDwpzoYS1tAHcZlprBV+mH5Su0XiK3oQHePwJSBhXEZPPntY38Z5cmzyMlSknWnmpLZmrResMp1qYlKn+wmsQ0HDfZBvM+nlRhG+fl65rQES9We/CPq8+sIRmeAbjiPnwWWDK4q0a7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xO6FoOuSdHwDVECauRtR1VfkGDyP/hcqDO2SVjzpMrs=;
 b=ODbs+pmfDn+iZn8LPutEfptMUaBxVdZGV+c9T6wMEETp/brJB+v6os8DaQW/mKo3Qcw3NuiMGYvHpwDtUSo3Gv+keSyEzgiLF89Q3bV+uqBRnYGsaFhRHg3vPQsRdEKF+bCVaYqrgDZg2kq17GUaxVbK4U548nBuwk7Bpj5Ht2s=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB7363.namprd10.prod.outlook.com (2603:10b6:8:fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 04:27:56 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:27:55 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 05/17] xfs: remove the kuid/kgid conversion wrappers
Date:   Wed, 12 Apr 2023 09:56:12 +0530
Message-Id: <20230412042624.600511-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0209.apcprd06.prod.outlook.com
 (2603:1096:4:68::17) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: 71265109-60d2-42a3-bf4e-08db3b0e4967
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MaTjXKUzq7nvIdB+gOCeZk8nOFWWhIXr8+Vdqvz1GKRc9ARHcJayHRkQw54ozLsW3aiEGv2Xo84BNzICI4fWkWH+7Y4uiLSpdi0rqbP8u28R2stlr6RqzL1uW3Tvnik4rPisGaJaubmhbDkr+uoSX0a8FXW9APdAz0Y0P6JykX1mJ+MW9rEbJk0UKX5QzqYXkfS0XJZj5VOUN2MTptguUYQM58VvQ9/zWPtyo7ZGGobS/JkQsAxJqBl85yYsDwZTQSSh+hnME8LpUYfpMUQmhnTrJgL6nIJQCxb1VBO8V0rOiNzJG7fKOWBcr7COgBHzJSN2KfajaW+IvixnnD6XLTWF7T4++kQHlFas5cyk/B9ziMyXLDUDW4MCkftnE0lBAEo7UIRocy/JzQV6g8Ivsaj41vXCSDB082mXYnFSJejN8KwvEGYI/lHoEFE8JNPcOOKXm2puBCng2k98DsT0ws2j+5qV/iY9TyNrbpiRJ/aG5DpHrWGjc+DZaP0hk6+DgMm4KOxOS2hEXTDwWH921dGt+vW/bG5FbTjzml654vYzIxBS2fzyhjKxAmzqgtvR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199021)(6486002)(4326008)(41300700001)(6916009)(8676002)(66946007)(66476007)(66556008)(478600001)(316002)(86362001)(36756003)(2616005)(6512007)(26005)(1076003)(6506007)(6666004)(83380400001)(8936002)(2906002)(5660300002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zyk6P0BUAym6H3qDZdWhThvsMCauAELlWP4SiNFmzGzp8jXMer8mB0ZErj4q?=
 =?us-ascii?Q?3RfWwgtsx4z0ck1j5mlPw60vc4YxVI2jPqjpovtDXfr2ZfElV0MCu87sunrX?=
 =?us-ascii?Q?CkD1uEgW6hQlKL1zqnfAAFh/U1bQm02M+kPB4d8LQxSjxo/e0k5tqhhNygmk?=
 =?us-ascii?Q?QrqxzKhGe4YdZBTttcXeenjT+43FSR3CCYwSPLPAaUTaSQayZ7ybB3TpAhva?=
 =?us-ascii?Q?mWP9xb9fRCKQ1F2JweAwlsf/+R9NaZO7xd2i/c+Zvdy76EbKgcqNlZg4cZ5r?=
 =?us-ascii?Q?vPoMZaOeFgASHtMy+Il1UV7ZUb+ZT1sCCGuBVzoHBenIfOSwJehzfKbDoO9+?=
 =?us-ascii?Q?EKNfMjc3x6CRtLE/wZ2VKn7rKjhyf05tLPQUzwD2HeYbl/lur+/AdE1F4tS3?=
 =?us-ascii?Q?+r9z7jS2t9mck3al4rAnjAXV1F/zxzJTwWCjWrvDcY634ebdlNCi0QVngarU?=
 =?us-ascii?Q?68o/Zn6SWlgPT8pJH2UR060OY5PfTJDurnv2lbopjnp3lkeubwbkXpU0JTCQ?=
 =?us-ascii?Q?LUrz5ozIem4qI2RU+vPj/L9cd/9RtNIdHGtx6Nz132v7bRA1pRdSgbcgAl3a?=
 =?us-ascii?Q?iMvU91cGNlR+wHV4GJDtQXAHffLBIyQSXcAmyary7A24k6UI1q1WLCoU4ciW?=
 =?us-ascii?Q?r77QmfU+hE2ZjGT40v+Z/hSuyEqhK7Q62oWxOnD+aCcFkdyEGkj+WYes/9dk?=
 =?us-ascii?Q?CnhVHJdcwlIU2WLDR+clb/SaX74hRtY85/NPcdAIMHxjyP6ISUZe2o5PqNMF?=
 =?us-ascii?Q?dMob9dWVwIMGRGLaCMn5PaV7ccPoUX0zB1DGN83upCa6aGTa7WZVcNFmxpRd?=
 =?us-ascii?Q?mFYDJp0P7GA2umgLmIrnEvMQ1cjIRpavD8p1trxdUn3gCVUT5e5mBJAp0mEG?=
 =?us-ascii?Q?LnYXCO3fJbD+ijwec46RangNFFr3aRvOXxbMdgIhUivcRf8iYdPbUf2N0H+K?=
 =?us-ascii?Q?23JvulljshzVzP3YfsN8R9/mwZf5C7bFVX+lSh3DgNox8vD95tK5qvlDvcv/?=
 =?us-ascii?Q?0P9bsFLiUcTJHVVBEA+tDvVigCYxwHcQb/pZQP5u+grfiqS8X8UA0+O8EkQ/?=
 =?us-ascii?Q?G4Lz+ESkY9ytkzPzkQ5yL49AA3c2v1/XjFFFFM8+j0GrDHdHeuw0vb3zYTlV?=
 =?us-ascii?Q?4SJxYWSroOT2/hoZypPB+NyOnnXuNRYkxQJHTdpMt7UfS+axLwZTE/1bODqY?=
 =?us-ascii?Q?THTRbAzxphF/JhM/hTI1gmmEMgLAQhc9/g7BQt0uwOq4W8oCfAnMslzVirNh?=
 =?us-ascii?Q?tgHOBk2cqEGG7M3284Z81LOBarhl83KYqpzGUbHJrN6eCShRKcD8pRY85R/2?=
 =?us-ascii?Q?jrCpi9D3myt76MwdwRpUvFsrYnbthvgZHB1HLq8bOWenKAjVlwaSbyiAmls2?=
 =?us-ascii?Q?Jro+YuaK6+QGD2/3bbkbOt0WdRI4smub1yYU4Ejq8I7pR7wROiH3m0e6w6bI?=
 =?us-ascii?Q?ImL9L+FO+BGpQujiTlJgPFhzBuwyqY2r9v+KbrNqFfc5B+gHPLbZmN4H87wr?=
 =?us-ascii?Q?0K8faxmf/Dh23nJzEMn5kkV82tdCdHGqDN0/YOPOIJQmu9hrEVpNHOdEHKpl?=
 =?us-ascii?Q?I/0Km+ZECqHtusXhjCMPoKqTYlnsztVxEyt3x25TGya7soBlfQTthC44oOKs?=
 =?us-ascii?Q?Ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GDgIm4Zjgul/RRfKs3S3iSvP8b/bb4o5ewtpY8tEYdFw0NYAp6e3UYjZm4jsgbLpIe1dapVpcW3fHDla100VR7BkiF6PLZGWU4qC/XNRSDoW/tycxWTerWXr6LKlfOU/REx0DIMF4iD9EvHhl8EVmWhhMr9GB8H3ZUXep2zU5K79kxgbh39NHVKA4zMU7UQSpp1oqOEpgdOF4WjZGSy++2oI17rUBZjj1549A/sn9pYWq+KFpo7LO6eQ0arkVSo90v+sDw4+Jxb/mvvcRr8/rAvSkD0DwtH+TgvlYDurfNGJQJzZ9IJWzr6P5BvRHX7Qd/LKxkTfP8NF4rrKKm/CMvYQPD7mHRDao/yram7F0b0M/kzlFe9Hg9zAQK+wuhFRdbdMdBjdFj0FBtsQ7eyBXrghsAC30O1ix+po9xiXVTaqYoseCr9cax3FgB+u0X4UoEkfgdGLMp7Q7eX9JoxNTABm55QbgnURRaTJSl15O6c2AS5YTKcHmzvkuVcRoyemd5JxF8QiHlIFNKNJLVS9AmhEOiV/ncnQOxLrkxfyUCHqEVBJBOHeO4ZHVmmZEpAgk5y3kDXMP9DbsCh3hmcvN1yCdF6qJxzQf0el2flFhQW6xbnzdi+1m0gine5O+iBrx+kfh2LOc3jF62W4hkYjHgAEC6zuIB7xFLhMpLmpe8mODNyB0LgK2oxkxiNANKH5tRaA2U3Sheq1XbnoNo5WjcNvVO/XZLkApMPvETBturddsWJ+VU/c78MxsLe/vkIR1tYF8QMyYF0GA3u+rZlKJteGsy2/bt78mVxgfN41EcrUq1Hjj+VvsfY1KbE44sYtyVEly+fT326h8FL2VK1g29gPvA/ZwpyTXBCfL5Gw6myQpYDmgZTvw6LpqY1QX9+x
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71265109-60d2-42a3-bf4e-08db3b0e4967
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:27:55.3171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: weMc2CI2urSAnYsJWBBFG0vY0IyaPwipOuohNVAjZkMVYGAeGluNvmhp+wiWBT6p9GDm01ucLYvyf66fmEsv0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-GUID: M5hfICkkK_Q4JZrE8HiPu4F0rWrijOoW
X-Proofpoint-ORIG-GUID: M5hfICkkK_Q4JZrE8HiPu4F0rWrijOoW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit ba8adad5d036733d240fa8a8f4d055f3d4490562 upstream.

Remove the XFS wrappers for converting from and to the kuid/kgid types.
Mostly this means switching to VFS i_{u,g}id_{read,write} helpers, but
in a few spots the calls to the conversion functions is open coded.
To match the use of sb->s_user_ns in the helpers and other file systems,
sb->s_user_ns is also used in the quota code.  The ACL code already does
the conversion in a grotty layering violation in the VFS xattr code,
so it keeps using init_user_ns for the identity mapping.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |  8 ++++----
 fs/xfs/xfs_acl.c              | 12 ++++++++----
 fs/xfs/xfs_dquot.c            |  4 ++--
 fs/xfs/xfs_inode_item.c       |  4 ++--
 fs/xfs/xfs_itable.c           |  4 ++--
 fs/xfs/xfs_linux.h            | 26 --------------------------
 fs/xfs/xfs_qm.c               | 23 +++++++++--------------
 7 files changed, 27 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 94cd6ec666a2..947c2aac66bd 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -222,8 +222,8 @@ xfs_inode_from_disk(
 	}
 
 	to->di_format = from->di_format;
-	inode->i_uid = xfs_uid_to_kuid(be32_to_cpu(from->di_uid));
-	inode->i_gid = xfs_gid_to_kgid(be32_to_cpu(from->di_gid));
+	i_uid_write(inode, be32_to_cpu(from->di_uid));
+	i_gid_write(inode, be32_to_cpu(from->di_gid));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
@@ -276,8 +276,8 @@ xfs_inode_to_disk(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = cpu_to_be32(xfs_kuid_to_uid(inode->i_uid));
-	to->di_gid = cpu_to_be32(xfs_kgid_to_gid(inode->i_gid));
+	to->di_uid = cpu_to_be32(i_uid_read(inode));
+	to->di_gid = cpu_to_be32(i_gid_read(inode));
 	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 3f2292c7835c..6788b0ca85eb 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -66,10 +66,12 @@ xfs_acl_from_disk(
 
 		switch (acl_e->e_tag) {
 		case ACL_USER:
-			acl_e->e_uid = xfs_uid_to_kuid(be32_to_cpu(ace->ae_id));
+			acl_e->e_uid = make_kuid(&init_user_ns,
+						 be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_GROUP:
-			acl_e->e_gid = xfs_gid_to_kgid(be32_to_cpu(ace->ae_id));
+			acl_e->e_gid = make_kgid(&init_user_ns,
+						 be32_to_cpu(ace->ae_id));
 			break;
 		case ACL_USER_OBJ:
 		case ACL_GROUP_OBJ:
@@ -102,10 +104,12 @@ xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
 		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
 		switch (acl_e->e_tag) {
 		case ACL_USER:
-			ace->ae_id = cpu_to_be32(xfs_kuid_to_uid(acl_e->e_uid));
+			ace->ae_id = cpu_to_be32(
+					from_kuid(&init_user_ns, acl_e->e_uid));
 			break;
 		case ACL_GROUP:
-			ace->ae_id = cpu_to_be32(xfs_kgid_to_gid(acl_e->e_gid));
+			ace->ae_id = cpu_to_be32(
+					from_kgid(&init_user_ns, acl_e->e_gid));
 			break;
 		default:
 			ace->ae_id = cpu_to_be32(ACL_UNDEFINED_ID);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 14f4d2ed87db..672286f1762f 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -859,9 +859,9 @@ xfs_qm_id_for_quotatype(
 {
 	switch (type) {
 	case XFS_DQ_USER:
-		return xfs_kuid_to_uid(VFS_I(ip)->i_uid);
+		return i_uid_read(VFS_I(ip));
 	case XFS_DQ_GROUP:
-		return xfs_kgid_to_gid(VFS_I(ip)->i_gid);
+		return i_gid_read(VFS_I(ip));
 	case XFS_DQ_PROJ:
 		return ip->i_d.di_projid;
 	}
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 91f9f7a539ae..9d673bb1f995 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -308,8 +308,8 @@ xfs_inode_to_log_dinode(
 
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_uid = xfs_kuid_to_uid(inode->i_uid);
-	to->di_gid = xfs_kgid_to_gid(inode->i_gid);
+	to->di_uid = i_uid_read(inode);
+	to->di_gid = i_gid_read(inode);
 	to->di_projid_lo = from->di_projid & 0xffff;
 	to->di_projid_hi = from->di_projid >> 16;
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index a0ab1c382325..1c683a01e465 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -86,8 +86,8 @@ xfs_bulkstat_one_int(
 	 */
 	buf->bs_projectid = ip->i_d.di_projid;
 	buf->bs_ino = ino;
-	buf->bs_uid = xfs_kuid_to_uid(inode->i_uid);
-	buf->bs_gid = xfs_kgid_to_gid(inode->i_gid);
+	buf->bs_uid = i_uid_read(inode);
+	buf->bs_gid = i_gid_read(inode);
 	buf->bs_size = dic->di_size;
 
 	buf->bs_nlink = inode->i_nlink;
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index ca15105681ca..f4f52ac5628c 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -163,32 +163,6 @@ struct xstats {
 
 extern struct xstats xfsstats;
 
-/* Kernel uid/gid conversion. These are used to convert to/from the on disk
- * uid_t/gid_t types to the kuid_t/kgid_t types that the kernel uses internally.
- * The conversion here is type only, the value will remain the same since we
- * are converting to the init_user_ns. The uid is later mapped to a particular
- * user namespace value when crossing the kernel/user boundary.
- */
-static inline uint32_t xfs_kuid_to_uid(kuid_t uid)
-{
-	return from_kuid(&init_user_ns, uid);
-}
-
-static inline kuid_t xfs_uid_to_kuid(uint32_t uid)
-{
-	return make_kuid(&init_user_ns, uid);
-}
-
-static inline uint32_t xfs_kgid_to_gid(kgid_t gid)
-{
-	return from_kgid(&init_user_ns, gid);
-}
-
-static inline kgid_t xfs_gid_to_kgid(uint32_t gid)
-{
-	return make_kgid(&init_user_ns, gid);
-}
-
 static inline dev_t xfs_to_linux_dev_t(xfs_dev_t dev)
 {
 	return MKDEV(sysv_major(dev) & 0x1ff, sysv_minor(dev));
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c036c55739d8..6b108a4de08f 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -331,8 +331,7 @@ xfs_qm_dqattach_locked(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
-		error = xfs_qm_dqattach_one(ip,
-				xfs_kuid_to_uid(VFS_I(ip)->i_uid),
+		error = xfs_qm_dqattach_one(ip, i_uid_read(VFS_I(ip)),
 				XFS_DQ_USER, doalloc, &ip->i_udquot);
 		if (error)
 			goto done;
@@ -340,8 +339,7 @@ xfs_qm_dqattach_locked(
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
-		error = xfs_qm_dqattach_one(ip,
-				xfs_kgid_to_gid(VFS_I(ip)->i_gid),
+		error = xfs_qm_dqattach_one(ip, i_gid_read(VFS_I(ip)),
 				XFS_DQ_GROUP, doalloc, &ip->i_gdquot);
 		if (error)
 			goto done;
@@ -1642,6 +1640,7 @@ xfs_qm_vop_dqalloc(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
+	struct user_namespace	*user_ns = inode->i_sb->s_user_ns;
 	struct xfs_dquot	*uq = NULL;
 	struct xfs_dquot	*gq = NULL;
 	struct xfs_dquot	*pq = NULL;
@@ -1681,7 +1680,7 @@ xfs_qm_vop_dqalloc(
 			 * holding ilock.
 			 */
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, xfs_kuid_to_uid(uid),
+			error = xfs_qm_dqget(mp, from_kuid(user_ns, uid),
 					XFS_DQ_USER, true, &uq);
 			if (error) {
 				ASSERT(error != -ENOENT);
@@ -1705,7 +1704,7 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
 		if (!gid_eq(inode->i_gid, gid)) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, xfs_kgid_to_gid(gid),
+			error = xfs_qm_dqget(mp, from_kgid(user_ns, gid),
 					XFS_DQ_GROUP, true, &gq);
 			if (error) {
 				ASSERT(error != -ENOENT);
@@ -1832,8 +1831,7 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    xfs_kuid_to_uid(VFS_I(ip)->i_uid) !=
-			be32_to_cpu(udqp->q_core.d_id)) {
+	    i_uid_read(VFS_I(ip)) != be32_to_cpu(udqp->q_core.d_id)) {
 		udq_delblks = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
@@ -1846,8 +1844,7 @@ xfs_qm_vop_chown_reserve(
 		}
 	}
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    xfs_kgid_to_gid(VFS_I(ip)->i_gid) !=
-			be32_to_cpu(gdqp->q_core.d_id)) {
+	    i_gid_read(VFS_I(ip)) != be32_to_cpu(gdqp->q_core.d_id)) {
 		gdq_delblks = gdqp;
 		if (delblks) {
 			ASSERT(ip->i_gdquot);
@@ -1944,16 +1941,14 @@ xfs_qm_vop_create_dqattach(
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
-		ASSERT(xfs_kuid_to_uid(VFS_I(ip)->i_uid) ==
-			be32_to_cpu(udqp->q_core.d_id));
+		ASSERT(i_uid_read(VFS_I(ip)) == be32_to_cpu(udqp->q_core.d_id));
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (gdqp && XFS_IS_GQUOTA_ON(mp)) {
 		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(xfs_kgid_to_gid(VFS_I(ip)->i_gid) ==
-			be32_to_cpu(gdqp->q_core.d_id));
+		ASSERT(i_gid_read(VFS_I(ip)) == be32_to_cpu(gdqp->q_core.d_id));
 
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
-- 
2.39.1

