Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24819698BCD
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 06:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjBPFXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 00:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBPFXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 00:23:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302B137540;
        Wed, 15 Feb 2023 21:21:49 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2Inxf025495;
        Thu, 16 Feb 2023 05:20:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=FYEi1+/4rD+fRGESwkIhE1cqtzgePlkvrkU0bhYn9HA=;
 b=xgqJ23HKwIiNxiOqMUmUMg9mu9KDEKz/83w8/qNugj4c3mWpiY+TbgzJZnTNZlpOa9It
 IlcU6V8/m5poz/eepqiy/KsujbVjrQQtjxpSK7WWoq31NfLxyklTGs44DoQMtEuOrKGC
 MqhzL1AwEcJQi0gN8tDmilAKjCFJ6R1/quSlrGYI8H+w4iniIeyuJ5RlNo/QhDPIQ0fS
 q4Q8rcw3iwtSd9wsK227ml5k13SPaW3K44+5iZJQ7+6Y0Ropm2Yq+pHjUM7VQztuWX1Z
 Ysfk9A7RSCKaPlbG7PeYvL5JtL5REgkdz7xMP85Yojg3TVkDiWoOfS482kxgMbZPJE7y lw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1edj474-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:20:31 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2iBox015077;
        Thu, 16 Feb 2023 05:20:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f849kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:20:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KA5/NXeX/2U3AbTJGzjOyCez6mbwA7JwSyphhTfEZUpCG1HOA6orcVt37NGrAmizJbhFS5b0iIpJHVU7pgMuU8hwBtHDTzdjsNFYOg5tjxKpi6zTJoZyVJeWoc589gIkJRW5hagHNyrY/uYkMqH6TxaYZUFv7EjKD43bEI0GhgCpol+Er5GUF2M/AtM1txtQ9GJlKg1s20GRuqIFNu/ITQd6Pem1AMH4sLmv9Mi4kXWCndt80v27aXXpKL8C0ZWTSMosLaM93JQsjirXnLhMvt4a1ILoNctiHdzUnnEJw8jlkqCnNO7YFm+9ZuSSQ+0nUTx/rWCBPNSNSh5KT/UsaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FYEi1+/4rD+fRGESwkIhE1cqtzgePlkvrkU0bhYn9HA=;
 b=lUGEGNGIPt75d8enDdgN3YfO+MG89VNsv2Atsr5OYf3/REsMFDO+EHQuvyCf87ipqo6RFkRbQpjy+vz7bQu1Jk/LxlUuxj9NZ1mUuMuJe7iCZp+GDADPKOnn+Fegx2wfBA3P19A+ul7ixJkjTAyiPwQHfVVmoUVT0NKwH65VKQC03cCWxFBnaY5slxN4Xyh6PhyQdheGUAaLX2SMcrfFlChITTUaWw+thRjgxKPh1CNoNWfMMdHczKClsny4GZx5CokLWNrr9f2lCDkYSQ2Y/12KZDg4U/6P15buTCSokfCuLphBWUYyeraw2o945eMt0orx3aMBZAouiWHZ1lkZ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYEi1+/4rD+fRGESwkIhE1cqtzgePlkvrkU0bhYn9HA=;
 b=SgkKefq/B4HaX9OZfC4vQkUqHWsEfSnpujGH9VhV5kZ99wt4bLPlnY42RQAdoyjcf1ecJ7tOO0GX7R9+ArMryY5Z9TQUBEtwrrHW11J1KKrwtaj98ks27ksZk5LKe2lgWf1REAwrcGmzrjkU2q1/rfmj/gzEUCS5sybZj6Hh0/I=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:20:28 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:20:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 00/25] xfs stable candidate patches for 5.4.y (from v5.10)
Date:   Thu, 16 Feb 2023 10:49:54 +0530
Message-Id: <20230216052019.368896-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::17) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 339933ff-f295-46ac-3c28-08db0fdd83dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RkTtRo0MRQ6leocbaepYoth/SQUo4suzXmJqFFEFkXhD/Vcvo7f+Ukd2DrBcegHjWZD5OYaF1KMwEwDdO8QtZ5N/spPk9cFLOVTpxF7Uw8e9TTr3I4Y5b27XuHD4CvTHcRZKDcWxOkOj2jUxAmLT8Emv3XOhxiWj2ch2hev+IDMeZjGx2sHpgWno7zq2Y77dV9mxIn6Pd2yDuh3AGtWIvKTSPZ4EGl9K39WJqBXu2i+MzK8QkSZoGT2gY9P0kh92/kb6tCfdvQ7/TFNSsi9eEzwWxc6Icd+dT8eSAjfJSztkRi5XgbYpUmSZeqAyFOa3A+XVFWqMPieMGDz3ntcMjvQ1UhblWbb10Q62iWY+Nsk7FJhigl4MbDNmvqMrPWMyK/piLD/63zqoh29mSPGdY1pxiCdRDrxOZwee8vWB+LMfcoNKCdP+NZCHm1BZZGsu8zKtyGYPrD+IGZu3PRUgnwt8ekrvtn2TMJrETlynfDNWJhlay7i52X6M8oqzwAixq1it+w4HsDxFDWJPTCCP2jXwU8xRcg298ujMHg8g/mk5cL+XNGhlRq9IxN7RtI9VJVkyOwj4sAyttAWnLrw+iFAKw/1g6taqJ9LYNZXH0J5WhWbGM/+Ja30pyP0R/JwPhdFafibhd5ZyIHeL+We8Cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(6666004)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6btoD+ZYhNtWQTmCIjZRo4sNTjssOb0g9kaluLQW5QkMGEsKM6YRq0uG4LFq?=
 =?us-ascii?Q?tC4p9SqApfYKM4YNWrJ8mKqe/LdIINWUebNL5Asx5kndOWugc4u6j6QDNyQW?=
 =?us-ascii?Q?Ug+WDFg8t+vLhbf89llU3TpCqfEjCswXl/vFI6/RwIwQXhLGIRJ9cnG+n8my?=
 =?us-ascii?Q?jA8RlGeR/C5f5Rg1gB5R+M7ZVq+U35zMWHmy9X5tNPLyd/qjOHaawksQhykc?=
 =?us-ascii?Q?EFpMIjhBIz2f2gWLaLp3zcui/8SkUNhdpLQMcwzeNVyKPyqQGbTl8X7plHio?=
 =?us-ascii?Q?3gspt5maAlxhesmFiTU2bgDNpBE+PyDha+4Qn/lFnS3DdeP0AimJNyTZdCOJ?=
 =?us-ascii?Q?VSpYohActxdOcudF0tLgwIt2FMEbLVWEsZzow5DsjqfIviUOc2L9SZsAEyrc?=
 =?us-ascii?Q?0XvCBehmNlOcg4/cKGr2mpdQdGk2OA0omVz6vT9cZ5xuPpT6za/6ks02GDxr?=
 =?us-ascii?Q?zDdsUvrBPvv/oXUxkpby4X13tl3PjjIuHrPZPhNIt5m+gRofHXdzNcjiCVIm?=
 =?us-ascii?Q?phTditxvdHVhY7Hq90Lwmm/VfLPD72ASKq75Ra1CjD11wk84Etetv1gwiQrK?=
 =?us-ascii?Q?AYIVBlGbTjW/atGDKPhATvPI3C4zbZsObb166jucFVfd0ei7Ad1okYUzV1z+?=
 =?us-ascii?Q?PqjiSbVztqulotmbOPfzauujYPrhHwd1BP4NQB9D8Q9nIgDYlrcAMelycdkt?=
 =?us-ascii?Q?QG4ooII+b64rwS/Fy6ZxI+AJrbi9R0k2XC4BP5OMVHlKjUufhuqVxqXoyC1S?=
 =?us-ascii?Q?TXyDp3V/w3cCjDTO83iDrnUHJT3yUAHYCOZ/c0dYmAeUs5d8nNZ6teDvO3+z?=
 =?us-ascii?Q?aW56HWQ2Rmz59rkyhnp4cK0WCbPw6maJIx47J2cC+cz4aQyXllrbSt3wcZeQ?=
 =?us-ascii?Q?5T3vdKFEi0Cq4q5YbBS/+3wcYF7H7Txwo2Nuq8tLGf4Z7i4g7pWv5jZUuQkt?=
 =?us-ascii?Q?pCbgjuraq8kOh8FjgNQSslAMRrqHq18IhouKBSqmEp/pQ2/OR4hW3v3pZM16?=
 =?us-ascii?Q?Pxn7NW5pVXAhm92htpAeDVW5U/rZ7HT21+iELUxoNMCKJky8iA7d+G6i/VRA?=
 =?us-ascii?Q?iXuMOWbPtDPeqoWGwx27Vd4K9kMPeC3fvh1XDJZzctESvTLgaqpcTE6d3ILg?=
 =?us-ascii?Q?miaho/Wdgll/EqvJOYpRR/adw8lUiNv4s9jntBuZxGdW4/OtIuqgxfl69Jkq?=
 =?us-ascii?Q?Kw5nNfdQ04crR3v3kpKpnPzFurSxMYma4iaIQq5zw15lU7w+IFqlE63Bc+GI?=
 =?us-ascii?Q?66bHhIHcnkQxGtDFHxdvPxTLvIyENlzJJ1hmWUa+ppHBceT0vMg1+u+MKF0j?=
 =?us-ascii?Q?I9p6Vm4yckMcF6ogDG6v91rxIdJrA7mqSPKFbGSX6dmmqdUc+Sdhl8h/e5Q3?=
 =?us-ascii?Q?GcQtlWGAxUCyEzh84FUSFH8hzwLWTLRxEM28SLuwImUYJyYRY1mVCmIRr+H2?=
 =?us-ascii?Q?Bqf3XeC7yeueLzs+PKQjGcW3rBypGmprsr4VcezD3hZsg5uA7ukqK/reU50t?=
 =?us-ascii?Q?xzTjvw6xb/HEq2LvGqulPWp73ob/5+KAhJ933mfXi/hewydF+UuIElZikJwL?=
 =?us-ascii?Q?2CDn0xy0LQRjtVAKYQYwqs5mO/SLGheiCVv6ubuEkf/Fs9GlvarAlLNeo4x4?=
 =?us-ascii?Q?qQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4EAXUG8hParmcdSDIg0Gl74qdj+AHPYrGwoSjdb19zwlqY6wN59RLZLLg045NskGnhqyXDNdTk3PM6Y4FhE9IICDDnUauzBRlemsixG1/6YvFHI1oD6i6UfzQ9bOZvJ8g86zt+QI+yFlG1q2P1+TUw5dIEda0z6ty4TcaGIoH7LhEGiqUoSkOUfhOOhSvY62gADUQFV4irGr3ZhysLB9CMgKtrj6je6HLMYNhYJmYuqZrTvyqZMpaqgFJBM+IEvM77BxAsRsGfEuuyc9yY+FKDv10lHPSXYflh2f5o/0xiux3IrIZKfGgUrmCD2bqrtkCIE0wZwp8cSogZBWHEbS8q2Zcfc9W5EvEHFTbLKAY6gJlszlciNb90Tx/ElAMHCmDtWspcvjKhbehQrDnFjrUN9lzSBtnhG8sCDiytS8wZHlpoNb27uyoz0WqZQatECavkX5Z64SyJeKJ5AnZtGN8HZI7Xko0+HB0NUCEaWRXfFjxJVQ+R02Ncjdo2fkawReJUtLq8kJjkVeVpc2SFK5adFuLjRpqOICJ1iH0VUl1rld8ERai8jPddqx2g3SaKU2JZrg2s0azok2c/o8yAVe8tJLYtabtEiEMCDEj95PN2vBa6G/ru83ka0L4T38kmV4bmr8gJrgf7X9Th9iF7Fz4038tOY/yosHwrI1l9milzclX/GPg7tGWzma979EJ3Ba1QNFwZjVI8Zl8fwzKq5HCh1PyYkFyYJWPfhlXlb85zy016Jw0+2+tAg6L+7jDoZMESJeIU5BztQIQ/3HQq0W1IohHudKIAenz/luFGwzs22TUxiks0NaccxOxprl7klR57A2BXfqqjZl4fTzNvzNsmfCDR2REiy3CbtXp9t+VqM8pNDhB0XN+de9GzG5zyqJ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 339933ff-f295-46ac-3c28-08db0fdd83dc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:20:27.8744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kAos8FXel3lmBsa/8HVF3H6vMuFTUa4gfq/gYQgROszH7m5EBzsFiJxvazNydsX7LiG9Wa8+XYIcMMKsMGaqSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-GUID: V_x8neD-AHOsPhS6Yx4HgzHlKcs8I15_
X-Proofpoint-ORIG-GUID: V_x8neD-AHOsPhS6Yx4HgzHlKcs8I15_
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

This 5.4.y backport series contains XFS fixes from v5.10. The patchset
has been acked by Darrick.

Brian Foster (1):
  xfs: sync lazy sb accounting on quiesce of read-only mounts

Christoph Hellwig (8):
  xfs: remove the xfs_efi_log_item_t typedef
  xfs: remove the xfs_efd_log_item_t typedef
  xfs: remove the xfs_inode_log_item_t typedef
  xfs: factor out a xfs_defer_create_intent helper
  xfs: merge the ->log_item defer op into ->create_intent
  xfs: merge the ->diff_items defer op into ->create_intent
  xfs: turn dfp_intent into a xfs_log_item
  xfs: refactor xfs_defer_finish_noroll

Darrick J. Wong (15):
  xfs: log new intent items created as part of finishing recovered
    intent items
  xfs: proper replay of deferred ops queued during log recovery
  xfs: xfs_defer_capture should absorb remaining block reservations
  xfs: xfs_defer_capture should absorb remaining transaction reservation
  xfs: clean up bmap intent item recovery checking
  xfs: clean up xfs_bui_item_recover iget/trans_alloc/ilock ordering
  xfs: fix an incore inode UAF in xfs_bui_recover
  xfs: change the order in which child and parent defer ops are finished
  xfs: periodically relog deferred intent items
  xfs: expose the log push threshold
  xfs: only relog deferred intent items if free space in the log gets
    low
  xfs: fix missing CoW blocks writeback conversion retry
  xfs: ensure inobt record walks always make forward progress
  xfs: fix the forward progress assertion in xfs_iwalk_run_callbacks
  xfs: prevent UAF in xfs_log_item_in_current_chkpt

Dave Chinner (1):
  xfs: fix finobt btree block recovery ordering

 fs/xfs/libxfs/xfs_defer.c       | 358 ++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_defer.h       |  49 ++++-
 fs/xfs/libxfs/xfs_inode_fork.c  |   2 +-
 fs/xfs/libxfs/xfs_trans_inode.c |   2 +-
 fs/xfs/xfs_aops.c               |   4 +-
 fs/xfs/xfs_bmap_item.c          | 238 +++++++++++----------
 fs/xfs/xfs_bmap_item.h          |   3 +-
 fs/xfs/xfs_extfree_item.c       | 175 +++++++++-------
 fs/xfs/xfs_extfree_item.h       |  18 +-
 fs/xfs/xfs_icreate_item.c       |   1 +
 fs/xfs/xfs_inode.c              |   4 +-
 fs/xfs/xfs_inode_item.c         |   2 +-
 fs/xfs/xfs_inode_item.h         |   4 +-
 fs/xfs/xfs_iwalk.c              |  27 ++-
 fs/xfs/xfs_log.c                |  68 ++++--
 fs/xfs/xfs_log.h                |   3 +
 fs/xfs/xfs_log_cil.c            |   8 +-
 fs/xfs/xfs_log_recover.c        | 160 ++++++++------
 fs/xfs/xfs_mount.c              |   3 +-
 fs/xfs/xfs_refcount_item.c      | 173 ++++++++-------
 fs/xfs/xfs_refcount_item.h      |   3 +-
 fs/xfs/xfs_rmap_item.c          | 161 +++++++-------
 fs/xfs/xfs_rmap_item.h          |   3 +-
 fs/xfs/xfs_stats.c              |   4 +
 fs/xfs/xfs_stats.h              |   1 +
 fs/xfs/xfs_super.c              |   8 +-
 fs/xfs/xfs_trace.h              |   1 +
 fs/xfs/xfs_trans.h              |  10 +
 28 files changed, 946 insertions(+), 547 deletions(-)

-- 
2.35.1

