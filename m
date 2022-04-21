Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A9A509DC7
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388465AbiDUKlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388463AbiDUKlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:41:02 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7036625580
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:38:13 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23L9auMG015749;
        Thu, 21 Apr 2022 03:38:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=NMfcFoueM+ioK7jtawOxFeyQgtmpQicflKDXZGoZvO0=;
 b=DMej2oF4VauWCttVIDhOjQQQKjOdmFGdjaijhutvKKjU0I8Ihbfi+zxeuqur8m1LNB/z
 18Po57AVahfc76F8u5+Lq69bxD+wbqKVhDVW0ACoaWo9cuREgUB35bNr3+rxaZhXLTtD
 mUlOxXTen0Ip8QMMf9spTFmtZKdXBHc0fOdYeZB2C627Z81NY7yTrtmbU9NnYhdS+/FN
 KF/D4PBN9eYgsTecY0hsGMELLTrLAfGkr+PuDxuSqtUtN4N18nE+xMhNKIL4Luf98pOf
 GsUC7qOYgHzL0kawt5/fugwCuevGKQOp9RtgF10bR+ZLuDavAVbIZ+n61cgDbBUjbYT0 Xg== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fhmfc1x5x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 03:38:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YoiisZOC9mqyN5u8QFJj2wdN2kI12Vhiuf81Fv9fTkU3oyQtmVW2oLNHnIUSchAxHA21hKXFR9benNpv15qyuk50Qm9AyGY/5AQ8JucJry5wnh+W3U8HcDdUW6vTZd04AIDMKnlCK7/f7FPfPVeYPsOpkaHR+7X5hFW0RcWncjyFcQaUr9fSFV+NUjnvJN5OSmqrF2Ht28j2coeljnjpDsqQ/UOaAOEEexrSmRnVwciwcKwluF/kn+y0lEmowpl8xDBVWj/WAWFmt0eCxjV4FCC7SIXgVk/vr+hkaBoH8btWkO8fv8U8lC1yWml9qPQpdLflcOOYnH612n/FOsCWig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMfcFoueM+ioK7jtawOxFeyQgtmpQicflKDXZGoZvO0=;
 b=kh2NU+GYpHqDqDq5LqmD/kG0UsVugn4EjUEfvzh3tLlvJeqh4NCh9jg9lnQX7TbqMVd4k5FzlwxJ1B3GsP8akHdBMflPY9TV8u74ndEh/OPyuQb6SyJnA5gKcO5a9g8/SD4CqyIxgyJQlLqmNitHvwFGxpKgmegxnB/t82Ot8NUvUN2hnWN4sB06r7U0tdObLXABboSAca1jOMvXQC5bOZOc3kvWL9XyyldXDvY6RyXuCd+pz+qb0yJnbzHqaEb+/Z8G1g6Q6z4LSDV7lOoo/LiLoAVovUwmXXlfRUSRuaHBFfdX2U7WH8ZWK+mbyEIcsY0UfMOLu3TJR8HXyNOIzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5406.namprd11.prod.outlook.com (2603:10b6:5:395::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 10:38:10 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:38:10 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>, Paolo Abeni <pabeni@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 8/8] ax25: Fix UAF bugs in ax25 timers
Date:   Thu, 21 Apr 2022 13:37:39 +0300
Message-Id: <20220421103739.1274449-8-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220421103739.1274449-1-ovidiu.panait@windriver.com>
References: <20220421103739.1274449-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0024.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::36) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2017bfb6-2aa3-452f-58a8-08da23830796
X-MS-TrafficTypeDiagnostic: DM4PR11MB5406:EE_
X-Microsoft-Antispam-PRVS: <DM4PR11MB5406F2D509D30BA46A9B1704FEF49@DM4PR11MB5406.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kifcS9yGfC2KLVgtudtjWrcxJJ8Ua0f1s8E7Rzrr4mkymfjCymePREAoKsa9FIgVV9+gnmwVhDCanBeoWy+ri9CU6bFLM7illMw5Wt6csTpizLsAHvGsC79MllV7hoLM/URbTQAmWWa90J1+vrFBd2rKxjR8DXEax7kJ9zDnfK4Kk1R9qj0wR0OurQPH59scgSjr/+pgPa7mk/fWEhyCvXbflAiDRgKeBk36z2SZ2pSaoqRBYU3PE58DVHYp0KbAfl+HxkD5rueiQ20Q0Ybp0SxM2/W+kIrExVb1eqiptjeJxHR8xfLOgUU/creU2NQNoFkvmtIe0JAYbwiidro+GjK3vi73809Y6lAev06xquhvGKRx1K54bnepBhQ1+030vZZjviLDG3F9FEQIL/yzMzUd4bNBcaI3NzkV1FZWEnTU6eD3Gae2kWgfIwAvek+J6WzNfIva1h9yS0JiGJmVXHMcp4o3jbGqOgRTBE15vXMpzfjjV81YQf8p84WxhgRoLyK78CAKl5bRLeO0o33Rf8XuGdgHbqb2nJ27VoGoCZihr43eH+/TGZKsyO1dkHTGtLELHM67vn8TMajeQq7I0SXZcx+Mtx9O6lxQfleKmXytKBG0O435jW19jGkuU72JZV7wV+wMblrY8VORGTrdLhSagveG4Le5hTUxqVMsAIrEQIyjN8BsbgSx6KXN9w70YG3fwxW0SSfMmRYY7DnpAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(26005)(508600001)(8936002)(86362001)(6916009)(316002)(54906003)(52116002)(36756003)(186003)(107886003)(4326008)(44832011)(66556008)(2906002)(6506007)(66946007)(6512007)(5660300002)(1076003)(66476007)(6666004)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NwV1R8qrI41sbLDTYtCVN9PYyTuUyQF5xNlp2I328q9ohaMTChPkd/pl73lQ?=
 =?us-ascii?Q?PHPRGDgqY1a+6fDl5U4YE6mJYJqhD0zu2PqthnU/KvccQbKLgxV6YRy92JuP?=
 =?us-ascii?Q?hT1OFwmM/uvzo5klTXyC+Sb2hAuM6bjy/LLd6AZfwmKBR4WJw3m4eaNgDiga?=
 =?us-ascii?Q?hZ3CtAHZgbGtM9qcqtLoyDbVP73Mo7fNrbmN8Z0p05Y9tkwprdQFVCcL7PNH?=
 =?us-ascii?Q?Buh5VtsRQYrrDdDrvsgKGl6BuufDwDFykEnSsKB5lI9Vm/wvzlg/eUp+a8tY?=
 =?us-ascii?Q?Q/PTW0ln1D/kbUBFYUVWz2tPL+fiYp0rFkdzZSih2YWLsZ7mDIRpZNyBq0US?=
 =?us-ascii?Q?e2JwUKS1yrrrKP2F7lWq88ZWXlIJuMsYKxHHWX9Bft+BXw5AjVnqJUT24fsK?=
 =?us-ascii?Q?B5OZ4UsNoTIYKbDsYCsJJdvqpRFdMx4ElN4w2Q6TZ48OQ5phsw1466S4myb+?=
 =?us-ascii?Q?rs8slFwXIP4H+b+nQs5zeiAr6TmTZqIxFvc1AIljkQRI2mY7R00zfu/Xcdk4?=
 =?us-ascii?Q?2u/4i9p+UO9FJ3mqdYPk2GRizsy9VEz9gx0AyE8ZFza4ohGGz6yIBfuwsERz?=
 =?us-ascii?Q?kLPJ8nnRmKeKT1L/zBBB7s9b8PpiV0Sx6ND02PtBfcvTjqoLQmFb3zE8I6jL?=
 =?us-ascii?Q?8xTKVGpa7dIW0KEwXAVDHGyKygJfcFIRdHcMPQlyKVLsZiGWCAXB6SRlO9oW?=
 =?us-ascii?Q?DifH+ZZY4YPLP0ezg7HzN9dtKB/6KstTbe/hsqVjQuURgr/7UXmVl0nsaFF2?=
 =?us-ascii?Q?Emm7H0qHesFAYT6Qlx8H4NY5adUzhZvdbgNVJEBN1erOml9BooNX3jUAcUtp?=
 =?us-ascii?Q?rONp/8nsu1cgsrQWpbsnAvqo32dXxTAca1Wqf7NlDp3U3Pcelf3aXy2MHm8W?=
 =?us-ascii?Q?OoGVeXpE8IsHElt+uUpy1hHqaofeivGfbiSBbL1AdrJMYAvR5T3PUmzGT8Pw?=
 =?us-ascii?Q?Sqs+bMPOB9moyaZOr53hHFCSiTqe7KBPZNQgojqrYXUjUd6d0UidxCsh+ftB?=
 =?us-ascii?Q?L/V+80Ct0lUzFZg+DJHH2AjcOAtGFhUHimVyrq6y8UxroFs20sLJ8eL5rpFX?=
 =?us-ascii?Q?zX8SZ7JdZcUzQ5H/VOQX/r97mY9V8jdUeJ1Tvn8NnZM3o6iAfPDJEPzuxMKs?=
 =?us-ascii?Q?mNePsBehpQ2PuxageshTxX0cEe7s+gax3/Suiys09V+Ipn0FRRBU4RRveT1H?=
 =?us-ascii?Q?Xkl9KPBijX9Di87pqfrOxgMau1mY20TGjGAGwtw/sOcrcaWdlAC2X/is97Fv?=
 =?us-ascii?Q?cYp0igcAgEIBSugUN/2jmbCkWDe0RYOcihXcHfDo6ClNX7rSY5KsoFj5NKej?=
 =?us-ascii?Q?XDs2cMSgL4il9rPiJQwMLk2PrHfx4w1iqskqNOiw+5uyZz84Z7n83g7APe7B?=
 =?us-ascii?Q?Xp5wON24ZiA4EXSY9IrCF/zrsCPZwzgLoXy2fPdawSORsZ1fgee5KVcAv7GS?=
 =?us-ascii?Q?xtbVWsi7DZa9ZQL5jDwCj81Gc/k0y82uWsZOffnmpLl4dR7PQL+o6wzuHmSG?=
 =?us-ascii?Q?0VJWHfU6Q5cG1/94n2Q53YP6MCKZMff49mlJk+w/RAMpzd+e66WFygEmFTCa?=
 =?us-ascii?Q?th2lrLt0m5e2cni+m293v00mXfkkfa7MmL1dUFd075Q8DSo9eMFot7+ycGKF?=
 =?us-ascii?Q?e64Utrq22lfXugOSO/V2JWstrliydCU7qvJtanZtUF6hyaDN+Ht6hEbKkhal?=
 =?us-ascii?Q?j9kY0v2aW9jOVnu7bhIAFvI9A+E3APFJ532GwDKoyHIcrG7/on4XJ4Se0mDp?=
 =?us-ascii?Q?5FxelreUpkHmIFGqxK57FF+QHYoheHE=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2017bfb6-2aa3-452f-58a8-08da23830796
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:38:10.2265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFH3yIZoU+mFOVOhgooxqLUglWyVtuEL4Gxvo3bSUQcYUTrKJW8M7fznQNm3CCCdAfbgMJ+/QrgARJNMTAlAms/MOWIMXR1c6nafevB4bM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5406
X-Proofpoint-GUID: UYe6W8ZMoQjONVYf6ikd0aDwdlW-8ftz
X-Proofpoint-ORIG-GUID: UYe6W8ZMoQjONVYf6ikd0aDwdlW-8ftz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=633 suspectscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210059
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
[OP: backport to 4.14: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 008b9403ab62..20babe8fdbd1 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1056,6 +1056,11 @@ static int ax25_release(struct socket *sock)
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

