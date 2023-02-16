Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C155698C92
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjBPGG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjBPGGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:06:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28AE4614C;
        Wed, 15 Feb 2023 22:06:23 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2Jebg020929;
        Thu, 16 Feb 2023 05:23:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=BVJdzotDGKBWAbGPMp0b1kX8mj6///+dvg13YM8zLl8=;
 b=Onl215UE/gwG2iVnR4OwGJMQ76x7kyD1kMIHAoX0GLB73fBz/Fr5PT8MoWA9vn6tJl5x
 ppzOS0rFgUwAGBlBEbhpJKaZ5OeZfj3onbevc0EhUioB2/ez4GUtT6l96dIRUrFL80IF
 RjUUlWMIPN+MlP/a/bRiu7yQBVV6USzSfkQzhFMZ7CndgNfyQoJM8eBA2DX+hmEi8PDP
 6PwYT7gOMoBuzsGsB1LZUm4P6pgRrGfr6ERI56rKPfFBbYgM71Y6W5Le+Gwzy+By1bqW
 ex4ZdBrKMchhVvz0BjDcofZtwH2cIhLBQvUMjD0MJQnfb1SNcarz4cDoU551ZlxUUklE iQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2wa28bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:23:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2nr77015086;
        Thu, 16 Feb 2023 05:23:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f84c66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:23:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLwXarCnc1D+IjZnnBgW/yHdFRW72pi3p3qU0laP5EHtMt4Go1a9SvjNwscrpY/v8McOitWFR04rjZ+dhgYPo/8EHKhhnZ/E6MaGyJDtRLcfadSSbGxySllG4YY3QtQPQxj6l/YVAjyfH2gUjZccTtMR0lfrIdLBU1jt9X0Vo8rOOOaPUQZox5rEVq+OffWTS5WxCFhCLERDwIkNfPHk+WMF8fJdV9wsMwifP+vTizFfRTKuUZcA7DpgrOQzG0SplWmTY5t+JvR9+lKhupJzEkzxPOwEGJNN5Mivrp2kIfEzTvNUmdEVZBtF7M5zcjH7Ce/e7FzfL78ZR+YjiWFLVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVJdzotDGKBWAbGPMp0b1kX8mj6///+dvg13YM8zLl8=;
 b=ogDZM4x0E1FkG3rihr8XHBw1DCW13P+2u2FpGvR/KYd+THfPFoLvxTlejiCom3DECRm44m6vpPSpDkCt806t2H1MQMPV++/pyEM2yD1oX51RhXkk7JXXVa2Jno7gn3r4l/ZGoIMxs1jley+igNH9ILqIvmvf/zT3dVuKOHPd/s3FS+56QGgO0zuBuG3sC1rcMDOwIbZkBhpENp1POcAsCR7CBa5YpWIYSIDnHd30Jwv3Z+upx9p/ah61SljlKchGGBpYlPhcqNqpYAT7uxKevfm7K6zYCqaHgkXoysFkoadLvDoC2yihRFt8DcN2oGVSFGSGUCiXFEcJNInd9LDgFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVJdzotDGKBWAbGPMp0b1kX8mj6///+dvg13YM8zLl8=;
 b=0Swsz9RnmvwBI7yM4oy5WswfCwylPBfQw+SpYCG1xNmwpD18Mh9vaK/iYUbVuUpZSn4I3LfDQn33hSv5aT/xd7jPh3A+5w3CM6l8aEt2OW/MPu2F2AuhrkvCnvXaNXE/JqtUoetouZkAHzmjGKZdQq8pwG3GJ2hlbIj4vpF69gI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW4PR10MB6631.namprd10.prod.outlook.com (2603:10b6:303:22c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Thu, 16 Feb
 2023 05:23:29 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:23:29 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 25/25] xfs: sync lazy sb accounting on quiesce of read-only mounts
Date:   Thu, 16 Feb 2023 10:50:19 +0530
Message-Id: <20230216052019.368896-26-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:4:196::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 826cc7f5-ddc3-456d-7c9f-08db0fddeffa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uiNoMylLKuH+LotLOafocr9b2FMSSBDgqM+2b1wac2lB9q/lmq+CXSr0CNMbPJcMN6pumwJ/Ds/Flf6pSgb//vUKhFzn91l4ADFTYX7c43RGN9OxWdLWOcfghLpDcFQkDIxh79Z41UUw8l/UB7j8HFEvZm+VVCiXvO9xr+XZY3q+354MHT7nbfG4sncCVZOYYqyKJslNjrRCOw8GvppJP3CCJUTuydMTiYLRd/ujwAjkvyEN+kv+PTeeas4TX6UYwzfQSnlUcB5cvZnJqW5qYuH/pJx+CUQ1osTINKQHk/aeCwYW+HACtDAS8sQZJ0tpd51fQY1TVx0Qv72qULAVRhcWnPti2gA1UGI9kAAy7jikmWJnUilO0bd/wD3/lQJDjuA1CftoyOERgfV6xQ9HXqDhfZch1+V3Ep6O7hJ5N4L93Nrj1QzPk2mYbXWHG/s0DMz7u9TfYKt+CaWDlAf3Be7u/8P6L/hqAxrncav/BrEH+SPtT9FC2oMzF8B6ynpOOz9LYQXVwqkBARSIA00gcsL9A4UBNRG1s39isosPEvdTOpnyAHS04g933LxfFoQLm+vJw7QXtNtti/VhkT8bpOIeuCK6ZKkA9/AGvUao2i8PDeTDxc/PlwRNSu1wS9ps1wFJ4V19mHVcAayrlu6KrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(26005)(186003)(6666004)(1076003)(478600001)(38100700002)(5660300002)(15650500001)(2616005)(2906002)(6486002)(6506007)(86362001)(36756003)(8936002)(66556008)(83380400001)(6512007)(66476007)(41300700001)(316002)(6916009)(66946007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o4QkWcQImeXAWVTW1HuxbQ4BS6YbISki8M1WGyoI1CYpfINtjoSc/QtOYK5Q?=
 =?us-ascii?Q?z+mjSHBvrgy8vRBOqK25qi8Yumat8D/Irf1k/Q8xa3rmtZpdjFL4mSjEoGtC?=
 =?us-ascii?Q?Hh8W6UnrkikHXjM39PGZijt7nzoytc/fx6uMwb0wJ+c7FkSMyk9ci1LU8paB?=
 =?us-ascii?Q?B2CyjDwmcXhR+ApXRAa6g2UbbRB4HNVUhJ5n7eSY0tNumbgpLeHgwqI61d7Q?=
 =?us-ascii?Q?oX1LQ/nmtHtSf2wVYPoM0fhmBCBYdSPzoXzPm+HNi9X+APvlyJETmoTDUvPd?=
 =?us-ascii?Q?V8bKLJXlTfSX0FHSgWNfCUPpA8Ew4vk/ne7JmWS+k6riSTyzK1cCJn7U4tk4?=
 =?us-ascii?Q?ap1UBU58Npkk8b3//evcI89jdWvyTFteY4nc+6ck7yMEA4MUoPSmhSp2dOMz?=
 =?us-ascii?Q?BFnU8GtWwKWunnYSJseD3MitEtS4a1WsE3sKy102wH4C5SfHzW/rg8LjdDGR?=
 =?us-ascii?Q?dNxk3bP6Y4imGcjcQZQclQCO9FMILQt+V6ZlMVf76p7QsMwZQ0kb9ljafQuz?=
 =?us-ascii?Q?jD0dEpSlJU9sElNv3zQyeBfxc99485zLjowk3cFI708ybuw/d4q+jix7DQOP?=
 =?us-ascii?Q?gVajaJUeLJFnPiWi2NVfUXHpW/ysApa7H9LjrHcsX3R3yZWw4zMfex26biWi?=
 =?us-ascii?Q?3WajMHosSydqRx6tr8kf5KVyIGgTPsZp62fsl5q11zxiV3bM+BZng6XS0M5V?=
 =?us-ascii?Q?KeU/nGDo0P8y0KhLKq1dbHUpN/w3aU2Iko8Zvj+s8SNAOXqh3+4lahRCT03T?=
 =?us-ascii?Q?4GQlBlQtjhlccN3xOfupAiq4AK5S3Xlb4CaC48FBPRXhg9WcoBOtWlNdQxk3?=
 =?us-ascii?Q?/YmyS0XLrvF620tSypoMZ1n51oQxPKTgGAuc0d9W5+NGzEHJ2gBj9/+Rj5nz?=
 =?us-ascii?Q?8IMPfndmqDRRvrpo0Ho2+k2BdWuw80PFDK/kiBBXp96mRVQnHlZy/JCVNm0p?=
 =?us-ascii?Q?8J0TACeV4kLn9J36hc/aNLN6ytwWKfBqdwGzd0kHDkQXgsHbWIQGRPe3fy0o?=
 =?us-ascii?Q?9Dh6vuGA7vInveloNZIYMJQvc7zvkybxXQtuM/g6Ozx2QxV7Bjfk+/BHMviy?=
 =?us-ascii?Q?A51ZhHd3/P+c5R2CZo9kFXZrrpaSgFnlKHGS5e1U7DHmzTd0uV6DxXw4i6df?=
 =?us-ascii?Q?9usKMXgUiLu4Tzr+1JjsJzMQYs+JCeMM/aYCH9cAAwd8Zo7HH/D/XHyr0I1Q?=
 =?us-ascii?Q?tSPY8+vOjPXq+6TXwjZedeRR+Fq+30HYoA+p/QHGPMoR2L4H/thL2StRfMmk?=
 =?us-ascii?Q?LIXvrwI6H16x4YIcaG+mmOC0pZQZWYwQQmJVzcD6AGCXTbRwI7i3zBBJSWaY?=
 =?us-ascii?Q?T3yXlVx7bUyq6rBnPZN7cM0L1RC1wCfruitU5TfZWIDEbq/Yg1v7r6/ovGMR?=
 =?us-ascii?Q?iJbsPQLUpEVZJaNEhKnI74QCu41bvhSc1zoamfpdeyNT3bb6FMlQaDczdUyF?=
 =?us-ascii?Q?QdZBFszPDao3QlrLdMwo22CxNnecYNFn73nGO8zh0gGwd2YKBWI4IYmYe09G?=
 =?us-ascii?Q?yHT7fS4uEegH6tUk2CIS/5m1dS0csS96DIYhltAvMx+a4zG8cwXT48i9PSBT?=
 =?us-ascii?Q?YHfc6xGJKPynmVRRqVlXfcCn4rC9WbZmFovwbIlwNMsWMPQAw2YTbWSVY/oa?=
 =?us-ascii?Q?KQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: EsQSbI0k6ZkcOJGmthmSNE2GWL0uY9pOPBX3nidIP702tsABodQWA3suCXZWaWKOgRBpDiygupSOx20xszBv3lRgRU8sDr6CSMspShFWZwOJ7i+Hm7+p460s3w07Qjwgxugtpcm6CEUnltsyzIxbNg+Bxm0s8qn4fOmzfg9kVGZ1XGoZ8xEeiP7niqR1HsFk2onmUGWfnnDDsJScy0bl014IHGLX9i4cscZ7GL87sEeVUEFAhNvblzj/8/WtlTpaqkyuk6AMPT2dJhaLGFjYv0yilwY/bbp4hoU7ILpdloYwLYTkUCbFflyaYWumbZPv6PAMrGgt6o6FT/m1BGZGcyPnr2TiWTsw04TlbesgnLoAI2YYS8+kQQLvE4sw5CojwQ8Btji7dPLncshqxBtqS5nF8ndKiYgU/Q8TMazEVyOjjLXhSMqz0fZdRUPwxEkIhPYiIzaXNT/uNNmFYTqp0YFyjQs7x9+0J/jiC48mJLvAxANSxfIHXedHz5cquEvpaYG7DF8oeALEfJuC058SzxKbdMslArgRlIpWYU5NdwBoZ9DeFEV7umbVBnK0cvnFpDfkHGrlNH7u78XVtj9y0R+NUByMYtVz3LW8p9TnTm4FLh+M/448+YYp56M2Bdj9762BUQyL8z+wYs3uT8sQ8YTN1wstf4/QwVfQMZkUFVBrETUibq+hpeoPIcZFIss3/UoUIlrujdFuUiuICOmXFJGwKl/HYkwEwHo4AlsFMzg4mInNgVm9FYNDMWICIlGaBBG2I5Q74O6LwIXQLVfDhYUCBDqtNiYmWGgQM2vwH82lbHQr2P+t4qf2cyzWZDnjv7qGkQxHZqc9n/U+wS+x8ro9a5vm7Bt5rbHnHq5ydlqdXMFv+Sfq8TN3Fe7I8h3v
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 826cc7f5-ddc3-456d-7c9f-08db0fddeffa
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:23:29.4228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qn7dtHIunqRGZhPv7F8+fCOvkYR7D92r9YXXycuD2kHU+pAXBcv0eFZyn9gUJ1F5GU9H3KMqwB1LC1q2SgLuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160044
X-Proofpoint-GUID: 8JrGmlgkF3uazNwy8usbYum5M-zXycYH
X-Proofpoint-ORIG-GUID: 8JrGmlgkF3uazNwy8usbYum5M-zXycYH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 50d25484bebe94320c49dd1347d3330c7063bbdb upstream.

[ Modify xfs_log_unmount_write() to return zero when the log is in a read-only
state ]

xfs_log_sbcount() syncs the superblock specifically to accumulate
the in-core percpu superblock counters and commit them to disk. This
is required to maintain filesystem consistency across quiesce
(freeze, read-only mount/remount) or unmount when lazy superblock
accounting is enabled because individual transactions do not update
the superblock directly.

This mechanism works as expected for writable mounts, but
xfs_log_sbcount() skips the update for read-only mounts. Read-only
mounts otherwise still allow log recovery and write out an unmount
record during log quiesce. If a read-only mount performs log
recovery, it can modify the in-core superblock counters and write an
unmount record when the filesystem unmounts without ever syncing the
in-core counters. This leaves the filesystem with a clean log but in
an inconsistent state with regard to lazy sb counters.

Update xfs_log_sbcount() to use the same logic
xfs_log_unmount_write() uses to determine when to write an unmount
record. This ensures that lazy accounting is always synced before
the log is cleaned. Refactor this logic into a new helper to
distinguish between a writable filesystem and a writable log.
Specifically, the log is writable unless the filesystem is mounted
with the norecovery mount option, the underlying log device is
read-only, or the filesystem is shutdown. Drop the freeze state
check because the update is already allowed during the freezing
process and no context calls this function on an already frozen fs.
Also, retain the shutdown check in xfs_log_unmount_write() to catch
the case where the preceding log force might have triggered a
shutdown.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c   | 28 ++++++++++++++++++++--------
 fs/xfs/xfs_log.h   |  1 +
 fs/xfs/xfs_mount.c |  3 +--
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ebbf9b9c8504..03a52b3919b8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -369,6 +369,25 @@ xlog_tic_add_region(xlog_ticket_t *tic, uint len, uint type)
 	tic->t_res_num++;
 }
 
+bool
+xfs_log_writable(
+	struct xfs_mount	*mp)
+{
+	/*
+	 * Never write to the log on norecovery mounts, if the block device is
+	 * read-only, or if the filesystem is shutdown. Read-only mounts still
+	 * allow internal writes for log recovery and unmount purposes, so don't
+	 * restrict that case here.
+	 */
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		return false;
+	if (xfs_readonly_buftarg(mp->m_log->l_targ))
+		return false;
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return false;
+	return true;
+}
+
 /*
  * Replenish the byte reservation required by moving the grant write head.
  */
@@ -895,15 +914,8 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 #endif
 	int		 error;
 
-	/*
-	 * Don't write out unmount record on norecovery mounts or ro devices.
-	 * Or, if we are doing a forced umount (typically because of IO errors).
-	 */
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
-	    xfs_readonly_buftarg(log->l_targ)) {
-		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
+	if (!xfs_log_writable(mp))
 		return 0;
-	}
 
 	error = xfs_log_force(mp, XFS_LOG_SYNC);
 	ASSERT(error || !(XLOG_FORCED_SHUTDOWN(log)));
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 4ede2163beb2..dc9229e7ddaa 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -132,6 +132,7 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
 int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
 void      xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
+bool	xfs_log_writable(struct xfs_mount *mp);
 
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bbcf48a625b2..2860966af6c2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1218,8 +1218,7 @@ xfs_fs_writable(
 int
 xfs_log_sbcount(xfs_mount_t *mp)
 {
-	/* allow this to proceed during the freeze sequence... */
-	if (!xfs_fs_writable(mp, SB_FREEZE_COMPLETE))
+	if (!xfs_log_writable(mp))
 		return 0;
 
 	/*
-- 
2.35.1

