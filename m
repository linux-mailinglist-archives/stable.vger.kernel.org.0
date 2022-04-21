Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969DD509DA3
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388377AbiDUK2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388534AbiDUK1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:27:49 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7082B2DC2
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:25:00 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23LA8WLO024294;
        Thu, 21 Apr 2022 03:24:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=x6DoE+R7VRU9KtrS/JflUb1WueV0u9wpC5YzsH/0ZFI=;
 b=Gq80i3UlUStURyS47D58f/H6uCv9DFnTbkYcHEzcS/ANnuzmTCPiaOUVu3SDVWCEe/ZP
 jpxDhTsiCHRRHKWndXNacjJ/O6cBcZPolJYqp7QoU82AeDzZiXz9WTTlf8QFhHbAaXm6
 Y//88PoSAYS/qsOF0oq7/0UllHj9292yY1ICpgTosDBpiPi0aqF+Ho1RPVLqJdFRYR7t
 E7S4UBnco6SffTNsu4pTC2b7hBPnd4AM63FxTEp3K1Nbq5YjAeQ2iPJLsb8XzeZ1jmr8
 UEFBP6gUyUzcGEDAb1myK7eq8fXXlOx0DNW/PjMB3LJSfMZaagx68REnANXTfbbKWzhc HQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffs313ngq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 03:24:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAlvSncHwNqMLo2y647FsgatrkJPNKo+Nzii4X0O6IuTHa5B2/zY3yB4Ib0DZUkEs18GLD8/N8FNgkJUb7okKzxeAoZAoBqYVPxEghB1gsDOMza2a7pz1YPxPuUrjbbjTrDugZJIeb5m2ocwGEx2sVSYcwgwY34LBY5HZRsWuNKXvWAoSQ5shE6OLVaUSZwVYF00D8A42Ham0MK7dowzEz5F54c8Z3M/oFqb1jLO4NdhSzWvOKlAJ2130zIgbrQKidIqpm4AYG+6xxVzNF6Tz4zGta7KJjjHycQtYlt9BN6XePPFVGl9UTe3KL+brQQRP7tCYIRbNwPcpfxF1I1wqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6DoE+R7VRU9KtrS/JflUb1WueV0u9wpC5YzsH/0ZFI=;
 b=etW6+qBe6uHNtKYdy2fsVQAEz2QbIIzJrx/6+jTWeU7kOIm6dLMnrMzcsIp2GePSg74NfZVusTT0T9ZZOXeCUuvzsJcEs9QXwhHvT0BIUYR8C8q3FNMQpcFUz+jxkfcLw1++OIGeFrwc0XFXZtiAqRjcipQTJ2kKPF28BXfFz2wC/6InMow1GtmM4ZNxSH+G20Uv30B1TNv4ZupVcEY7nnlkmzzbrEg8Py9jWd/b6cVE9TjakVSMT7FkbPkM6N4S+HsR18ZNTao71edWfy/A7vItZsT0rpVbnUQRPEGZQL4YfgdFeRW1L3ZlyoQA08L7eoA8RzR6h4RFJkFenrH8Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 10:24:56 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:24:56 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>, Paolo Abeni <pabeni@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 8/8] ax25: Fix UAF bugs in ax25 timers
Date:   Thu, 21 Apr 2022 13:24:22 +0300
Message-Id: <20220421102422.1206656-8-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220421102422.1206656-1-ovidiu.panait@windriver.com>
References: <20220421102422.1206656-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0092.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::45) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e6a4310-3b25-4d2d-f49c-08da23812e5b
X-MS-TrafficTypeDiagnostic: SN6PR11MB2640:EE_
X-Microsoft-Antispam-PRVS: <SN6PR11MB2640CCEFA9D02962F35AF2C7FEF49@SN6PR11MB2640.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ebqg7e/ri4wwhSswKtI0mhcp7lmmvkZ+TY5yWBC3oQxVKnTrd8PpJt19T6ZslG1V1quhthVwvH+pp4wUujL1zam4hmn5Gg3LkVCpwsE+G7cMNRAtJmn3cDACyuJ+CGnOgXuwBzihj320UdzmIFucJPnGfdYmSIb3KlkFlMtaY3wFP7/0IehTDVHEVaBfPZUCqqfOR/A9I8xpgweq38JXJQHwFTIN1Yqbj/XjxcuBb9yp0Cgv5/yPewNBFEE6pBohOkbNdecro/QodRtpEie+Sj8B3eUrgyPlMf+V4Vci60TtL7honPqrGAtJrQA703tctLBEIlJ7wKOIJDojqSAvOPmJ2WTBhUAJ2t1E4uSSo4SNaplmqpbi2UV7GUwQaqZST06l7mvQAo6DgmLR6lMsQPs14OaSGw+uSX3V1OGr3Or01/J7Zz3I8KXnCthAf0CKmUmqEoPtFOpQxx8Vk7QvBFsycXGh3TQsGrcUTLVFbA37l+G9J3G7bdJDqz9b+8mT9QD+JwFZQv6/tm1SUlZqKw72xGG/u4EpvrxDJM+5IRDgiXFXmUAF4nyvnLo5BtSZtTnY9f3NxmbTQjzd3ggZ65/LNhpuMLw3+eB/qpnFi5U9FulXIQkaajyFLtHNmbDUqGNG+BB+/Sd3D/SWQCkqpDlL10z/S6F6AkpSAZ9HN0YCAkeBOarjn21GSUejM1n/RDf2fzsLBNr9y/7wPRjrTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(66946007)(36756003)(8676002)(44832011)(2906002)(4326008)(6916009)(5660300002)(6486002)(6512007)(8936002)(107886003)(66476007)(508600001)(6666004)(66556008)(86362001)(54906003)(1076003)(2616005)(186003)(26005)(52116002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cl/FeMrE+O8Rz77a5bgoahxc6ZkCyKB9PCMAZoelRVjk93SAJ0G9a695o1A8?=
 =?us-ascii?Q?rESb5ixxKio4X3210o6zY6JJsBwUfs1askMe5Neq0ftN7Ct0fcY1+tVIxnCn?=
 =?us-ascii?Q?la4MGMQoNuRcOp5GWYattxNhWnMGZqlXRO/krPqs12mkHpHRxCmB0egBrgFq?=
 =?us-ascii?Q?89eFvlp89RCsk9cykAPGOcFw0bG75kQ5U1pEqv3oOKZ0bh24MVQDh2qz7bps?=
 =?us-ascii?Q?z/kmYiksYhbMUHbrWOubovCqWvLYHU6JhIIbnGrCDBUu8GkYm0M304ng+F6J?=
 =?us-ascii?Q?OoyWAf/vze+i3Dt8CAlkv86zPDpAO1kpdE6gDpGI5PJbbIgs6KGYtznGWP/v?=
 =?us-ascii?Q?aTzrMvSC1O1tB8f2vCuApyNn8nz/JCCnfEr8OG5C2J/8Rr9xL66VGGs3xyFM?=
 =?us-ascii?Q?HKiKe3fSZJw2ofsHo/K9Z+Y/ihdhiMNYAZZonoBEg2fS4cnWb+WEQlxNFlbV?=
 =?us-ascii?Q?tOQNM+Pr0DONbnWWH3i2cReV47481fhR5+tzWbzW/Dogougj24TInXFWsv5v?=
 =?us-ascii?Q?ivdGox0SUio2XqVoN7lY4pOFErR+RsI/hW0ZP01RjzYpUcsS7xqyWUdHCeJS?=
 =?us-ascii?Q?H9ilYFm7RZkMUEpsUvSn7VN22aRjBsLo2vUYZjnc9kJfv2GzvcLjoQoWlHb6?=
 =?us-ascii?Q?Hrv6fKdw4z8w9S6sL2t57V2wOIv+FridTb+tSuHYzw/3P6jycPvGfhCVectJ?=
 =?us-ascii?Q?tJRbXMZuiIooISAtegk50I0Dy0pBpL3w0TKu7WkLnC2uujOrCInJO1cY6yoK?=
 =?us-ascii?Q?UHjFGabx0C7K9RvH9o4NWmBm+usuRNytpHZg2JDSZnXN3taVE99Rv5EgkNb8?=
 =?us-ascii?Q?tw2MjdnjeIMomHDjEKUxFMTmpQwaSdSZvVji66K8hc2cgAXZ5MPEKrO/lmak?=
 =?us-ascii?Q?uGVmc1q/ICjq7xEKxVpgP2/E3wnDkL8ZDYWGRGcZblmmReW5m9OcsLc4qRIt?=
 =?us-ascii?Q?xOOZV2BI/XwYGnVg1WvpFfxO2z8Qc2N45NI7GywrLwFNwCyPlKISZo41nk5l?=
 =?us-ascii?Q?FhkaMAwuPEnaeaAtcGCLb1UgdjTfQ/dCaxH7cTB3ixkA44999ptetkf5eLQx?=
 =?us-ascii?Q?S8A6xtbzjChjR5FLSgsX1I/EgWGCr9RjfnYUxCqLT+O9FdeGkxTBWTGNifB4?=
 =?us-ascii?Q?PrWA7uFnSDwRRHznDojRHHr/KziMmSP2g9NbA1ikyMnr53xo6gKaYVpMjXrn?=
 =?us-ascii?Q?MGZ5M3LhSA8WlID1+CxlE4vZ6IBgntUhLMXeXvgrQX901IrcdwM0HpRQx8Kk?=
 =?us-ascii?Q?3NvpBVBSh1uZ41XMfZDjr+bHZMmcZanGcz1VSNPgc5G8UVXkX+/LpTorhFSI?=
 =?us-ascii?Q?CBMLjL0liE6lTk/mqudOc4QlHbeM401FOmpo3i0YBKia5OFZCpHa5o2M7ILd?=
 =?us-ascii?Q?Fe3m8q2HblI6j4koSSysD4l8zyORrxXNHEL1s8q62T7LgmXMro0VmGD8bD0c?=
 =?us-ascii?Q?o1K9tS2IPexuV21dm/B1sZFZCI2tgMx7TdDNMrLrMneht4LamMr7LzEHVb6J?=
 =?us-ascii?Q?ut7cqWMCe0Cr9xYTa8hW5M04GTxKnj2vgeGeDlqXsn4DTmfKfuKnxaNvh1OO?=
 =?us-ascii?Q?tDm2LNAVM6dgD8nmF/p6zZ2SSU/9nq1matQKdY+DeYx42I/7rVkcbxMPKS2T?=
 =?us-ascii?Q?BbwDY144LKKpOyOXdnvFn162/NzQozg3eNGmbzSqpARp6ku9lAXuT/Gr7KmA?=
 =?us-ascii?Q?MtHycA2R72Pvg76Ysjc7isgivhE2821f9LUoRLcHCIzydN76OPQKpeSFhj3r?=
 =?us-ascii?Q?zk8GxxskzHRuu/fq4Q/SPA8Qu2ix6OA=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e6a4310-3b25-4d2d-f49c-08da23812e5b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:24:56.2815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +dgFdTajBdbmYWuX/KTA1RsQWaaXTs0SaZTzPz1JWgykTkreOom97Qotob6MKB6WAGEJORq/a2q4lSF9oDDFQ7uEqAjL5kVksj9gbEDoPcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2640
X-Proofpoint-ORIG-GUID: cA9-dMCZuDX9vsUNnf10mqQGD1bvxhLV
X-Proofpoint-GUID: cA9-dMCZuDX9vsUNnf10mqQGD1bvxhLV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=633 mlxscore=0
 adultscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204210057
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 82e31755e55fbcea6a9dfaae5fe4860ade17cbc0 upstream.

There are race conditions that may lead to UAF bugs in
ax25_heartbeat_expiry(), ax25_t1timer_expiry(), ax25_t2timer_expiry(),
ax25_t3timer_expiry() and ax25_idletimer_expiry(), when we call
ax25_release() to deallocate ax25_dev.

One of the UAF bugs caused by ax25_release() is shown below:

      (Thread 1)                    |      (Thread 2)
ax25_dev_device_up() //(1)          |
...                                 | ax25_kill_by_device()
ax25_bind()          //(2)          |
ax25_connect()                      | ...
 ax25_std_establish_data_link()     |
  ax25_start_t1timer()              | ax25_dev_device_down() //(3)
   mod_timer(&ax25->t1timer,..)     |
                                    | ax25_release()
   (wait a time)                    |  ...
                                    |  ax25_dev_put(ax25_dev) //(4)FREE
   ax25_t1timer_expiry()            |
    ax25->ax25_dev->values[..] //USE|  ...
     ...                            |

We increase the refcount of ax25_dev in position (1) and (2), and
decrease the refcount of ax25_dev in position (3) and (4).
The ax25_dev will be freed in position (4) and be used in
ax25_t1timer_expiry().

The fail log is shown below:
==============================================================

[  106.116942] BUG: KASAN: use-after-free in ax25_t1timer_expiry+0x1c/0x60
[  106.116942] Read of size 8 at addr ffff88800bda9028 by task swapper/0/0
[  106.116942] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-06123-g0905eec574
[  106.116942] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-14
[  106.116942] Call Trace:
...
[  106.116942]  ax25_t1timer_expiry+0x1c/0x60
[  106.116942]  call_timer_fn+0x122/0x3d0
[  106.116942]  __run_timers.part.0+0x3f6/0x520
[  106.116942]  run_timer_softirq+0x4f/0xb0
[  106.116942]  __do_softirq+0x1c2/0x651
...

This patch adds del_timer_sync() in ax25_release(), which could ensure
that all timers stop before we deallocate ax25_dev.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[OP: backport to 4.19: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index faa098faafa7..7861f2747f84 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1055,6 +1055,11 @@ static int ax25_release(struct socket *sock)
 		ax25_destroy_socket(ax25);
 	}
 	if (ax25_dev) {
+		del_timer_sync(&ax25->timer);
+		del_timer_sync(&ax25->t1timer);
+		del_timer_sync(&ax25->t2timer);
+		del_timer_sync(&ax25->t3timer);
+		del_timer_sync(&ax25->idletimer);
 		dev_put(ax25_dev->dev);
 		ax25_dev_put(ax25_dev);
 	}
-- 
2.25.1

