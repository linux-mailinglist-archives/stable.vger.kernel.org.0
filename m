Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EACB4502E6E
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 19:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344214AbiDORwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 13:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344444AbiDORwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 13:52:31 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4985C678
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:50:01 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FGu3HH011441
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:50:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=/uyqyqGZYOS+dGaSz2ay4GlgI/lmeg9d8Ihj35x/KG0=;
 b=eQWhTJFVqyf5d/1MvFj6gqP/fmhn/nySYUbi04enFvXckgp2bZlkOuuJtVRrtJS/vOs8
 UNjUOtX7qojeCUFTsIgjLBa5PluuiWTUcyklZzqtThqAKLpbxql6CJ2PXLAmp/YIOwQn
 IDv1GAX0jVvjOh7I+I2rJXpdQYHx0yTEdRqnz8TdFki5DvWh3Va4W1EXjS07I1lGq9f8
 LOJZOlW5oZIjxH+ykp/NA7yhjJJJ/+Ge0RquybN9YelnoZFV7WvbwfrN/5Avep14wntH
 1iZPBTNKCDfQ49lVIZeN9VzauFuAOqyQMF96vWSSL3iphSGb4KuARCw7nppj8lPETsJe cQ== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb9nfvu74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:50:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkuqA6PUJ4yuj1PVCTLrZkPClJO5rYKEpxn9Y6s2nFcDgiDSa/MvEI8nAK8URrps3SzsBa8d4XjcZI9EWoJhrW2Jsr3ZobU4TvwWzbaOmmK9Nn8WHsJyaFAzeSRg2UMgeRfHM9l569XyAquanst7n/K0tiaoiOiZE7AHykocRyKGyVVqPmZEEOeFuYnQUPenOmm+6n4ilhG3nphOm0mAikjx4umvmdCPE8EjEnTLEWJykWZSLkf3L0vqIrHPv7hjAPBCws3RAYToiCFhrZ+0eMfg1WdM2tajNgKzvg3VgOkMMyvpOCqzfkPMMev404IdOuOYKvMLKtbY7jN+VjFQzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/uyqyqGZYOS+dGaSz2ay4GlgI/lmeg9d8Ihj35x/KG0=;
 b=FT/MZn6zkjC4oRiJ0iMi40M6n9Zx7WAmfNcW3AETINaUv0Ywf8N0vQKiqM+bWTpQcJu2wH7W6jaq9poRVAxRSblAtlaJiESHJgrJsmFxX/PQpFlpyXGTypLU/fQefG/hjQnyPIVidBqHPPWkxvbuI3fGoWbs099wyUVALsv+0Vn14FQ9cg3YVq3NUcKjm+qhrcLj5nfD2++iDCK4bHQolyTuZ1flQWsTG35bCnx3ryNE7OvVKKdbb+BiADQ1BxT1xDEsYGGTSltZyu55Fqhw8Lhneivyu9nRmuEhIkS5jRngbSa4lcbX7iHCsOrmAe2TdauymsJJt90Uq2U1VHyPhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2697.namprd11.prod.outlook.com (2603:10b6:5:c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 17:49:57 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 17:49:57 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 8/8] ax25: Fix UAF bugs in ax25 timers
Date:   Fri, 15 Apr 2022 20:49:33 +0300
Message-Id: <20220415174933.1076972-8-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415174933.1076972-1-ovidiu.panait@windriver.com>
References: <20220415174933.1076972-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0217.eurprd08.prod.outlook.com
 (2603:10a6:802:15::26) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ce6e1ef-3f4b-4cb7-feaf-08da1f085ad8
X-MS-TrafficTypeDiagnostic: DM6PR11MB2697:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB26974E170A086937B0F9DC6CFEEE9@DM6PR11MB2697.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N79auO2vCTvhfQ17gE42MIVxttiBiBN/ogoPPiOt2m7YBMKccn/9wGPJPoeyLcjFCHbhnnZ6xkSMe1khw0n0zAgZNw9Om9cTMXdpYo+aU+kRz4yr+MKrlgjc6UEUwp/T4CZDNMhpuKzeIPk+80rmgpJ7NX91IkJqwUMHFCtn0KUaqKzMR5QMqFxLHKFcvgtHEBXMhUAJKZ/KeARxI/RkclWzkcVopFk7/72htq4SU7rCWiI2h3OM6xXjSi00XtVf//2hsQH+IfVxYV8NcY/WgJmrLvWQ4UiU7jG6ZRPB1zlGeGSgU5VfF2nR5FtDmT2bSY46bZLua9ftoSGzLxPM4JHQY2JOp1QoEm6mxDA8LMCfNs6dYXN08NodqRIoUsNp0o/ArP50weUCcfieuaHJ6RTu8hHz35wLKid6nuUIaNrC4qc1hVAee1Rb9L7YAMYiq8EXIZUCrFkf7cPh0xECsD5SPI/Nx9O9SJDiD0aQAqPwqLFCrP2TTHFtGCuT9PFYPLEq04aKfq6MQSFxwfV2mu+ufbFzsqAdvqXxb1WJceLhMPYeOb0mpSlSvy9aPxa4mW6C/GDk7yQ1x0tKdukP7LklPurDO2aKn6OwSO9Dispxxd0ym8idl4w3atD7CqbyYQGUzYkNPSBLXjIfN7yDO+oAQ36n5UULaIknFvoPeL6ObbYmzuLxgPlWYT/4PL+8TxONHvGHwQ9n2v+7MiuUZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(6512007)(52116002)(6506007)(36756003)(6916009)(316002)(6486002)(86362001)(66946007)(508600001)(8676002)(66476007)(26005)(2906002)(5660300002)(66556008)(38350700002)(38100700002)(8936002)(44832011)(1076003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DbsXBhIjZx65Hcg3l5wl8BDlIrOdBvGTZUazT4xEhEkElVsYYiET2KJhGFDa?=
 =?us-ascii?Q?f7lM/fibUxP/Y2CTMt2Edxo2jsceXpVo54hSY8SOzDM+shMiXN8ZyUOo3ErO?=
 =?us-ascii?Q?28Qx1UpN1y0XkTxFGiioGhAcd5rr2YeUdzH0PKC0NiKBQJMKvpXhrQMitqv2?=
 =?us-ascii?Q?pWwHmusvlrxQgn6r3Bt+K7KoJZ0SdusDmF0RhoS6FmMxah4LiJ2e4qpo4YiK?=
 =?us-ascii?Q?VpaSYkEwpNioNFOjk/DpZC6dRwXxrzSBdsjPgCKJCpyI5XDu23QNNp53HbUn?=
 =?us-ascii?Q?ovxdDXnfCFpifQVqugTefns3S5/qjcXbVUGmzE4jpov+5hsoWeYamf0vKUoz?=
 =?us-ascii?Q?oi3evrHX+MlAZALE8Wvp+3t40n+cD6HKC6q5cfpNoTPQLGNXUUTZPersAPDM?=
 =?us-ascii?Q?o5T1SruqDCYyevrJnQDS41wjbL087IWOLttCfYzVkKFGQ71sbjldu5n/Ae/1?=
 =?us-ascii?Q?58VNbkqkiIVccv9oBPRBQ/p0FSQZWvLku62/yqZj9ZLqKK/A3W/i9FQXFuYz?=
 =?us-ascii?Q?eP1MLolAtAmB+LfRFNt2uUk+THqZgTHOxNN4du7N2K8ye9uZ4TC+1LbBZazt?=
 =?us-ascii?Q?zhYAy5yYAsTKkO+sf7mksrrEUQ0zOjWi4xcZ/RH3bI0nFTNylli0ELLnNe07?=
 =?us-ascii?Q?yXKzYNkcj1yJAPHYt0v5wiHoTbHcYqV9V9WfNr69Cx37Vg7dQHOYSMEfAC+v?=
 =?us-ascii?Q?1vUDbgdbyi6T/wgGtfUtk3j9vszwSqKuBT6Aqlob4LC8cxX2O4flQJJo/8/4?=
 =?us-ascii?Q?2eRVyfIo+qkqGgb/ccIX3uEF6AQvPAIjwLgFVsT6qyTO6bnH2FzqbOzfT6O1?=
 =?us-ascii?Q?xQgdWDmkVNn0poYFlvISRCJuzcBdEDotS3d1W39vDw9JKFKRLh6/EhuCgOpV?=
 =?us-ascii?Q?MabXsryfwVir4XwvaWoSbgu4DAu+KyeRaLxDsm9CuqPUTDwh1jLr2fT0hhYr?=
 =?us-ascii?Q?yaHGPflKHWwPJCAO45zLOzFZ2UgI/QWxm3N5il+jOINBwt+IpcXTDJ8Ik8mX?=
 =?us-ascii?Q?UVXSevUkpfrc5RR2ogCelvi6VChdaJiZZHY5yOe6zpwYxfh9IoX8NOffXvKv?=
 =?us-ascii?Q?pxA8mmhWLircKcAq/WftBaahLUDV5ps+p5GyIJSjgPQR65aJC4Bdgig9yAqL?=
 =?us-ascii?Q?fN8M9HY3j+L7BPFdmUYjWqNeBMWJpG2V0bsWFUCqCLrBUrQw1g2cNPp9t6Co?=
 =?us-ascii?Q?tTVXh2J9AB8V9dM/3I+dsEJhH3Lg7zx3ULOCEgn2KYjOivLhbGfgEkfNdScc?=
 =?us-ascii?Q?Q/umU5rUexcK4bWwKDZrts+iyVW4+bQLoVrEGGqdzFMv4i9SliqyOLsiZn24?=
 =?us-ascii?Q?miHDAu0ePtH+UhC8TjnM2I5/kIQbb58GjXDx+w+CwtNjq3a62TqoOkPQXJyR?=
 =?us-ascii?Q?RaUxl5xah+xyXmJH61ht1ykJoufyANrKycjpbgqDrdMuZn71HSll9vm+Q9Qk?=
 =?us-ascii?Q?oJGgPGWFpPk2JY4iaptBHevXTvWNqdjYKuxmSbWO0odLx9aK9kTS6pIadhM+?=
 =?us-ascii?Q?LEu340lXHybkFkM5RD24gGVUTtbBAGVqnVWHCSrJLuUwy/vU5MrGim4FUdQX?=
 =?us-ascii?Q?zdQ9wcTc+rOvEHZT/dqwan6I/4Y0WAe5RJcQrLtlIbrslx+DRzJEj4/OdXYs?=
 =?us-ascii?Q?7hvx/XDmV4waujbqZ5IRG0s0IUJ/VqBXpj6XJUEjl9eD/bMGdzHJvycBL0LX?=
 =?us-ascii?Q?3UMwXnVUxmq3z9n9fgmIZ0LnKI+PFpahiiYDbn7lpmD16f3eK7RsmvLKOC8r?=
 =?us-ascii?Q?9I1l56zofdJZiliW/NLtbHowCXmrFaQ=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce6e1ef-3f4b-4cb7-feaf-08da1f085ad8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 17:49:57.2122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J2/m8ey8Hm6vwZFS6vgNlgw5o0Vv4o4HCQD2RpofBpG1Lgu7ZnVWJI2nc5PbUgLvwBvr4/mFD0Z1HDe0+Jrs0roDbKBcRObaG4PNMDZol5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2697
X-Proofpoint-ORIG-GUID: QU600z_z-W11FjwvEKZYX5UJdPCQU2Lz
X-Proofpoint-GUID: QU600z_z-W11FjwvEKZYX5UJdPCQU2Lz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=631 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204150100
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
[OP: backport to 5.10: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index a665454d6770..5fff027f25fa 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1052,6 +1052,11 @@ static int ax25_release(struct socket *sock)
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

