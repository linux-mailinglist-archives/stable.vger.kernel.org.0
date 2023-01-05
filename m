Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F08965E46E
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 05:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjAEEKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 23:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjAEEJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 23:09:13 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C772E7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 20:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1672891679; x=1704427679;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=8oXQug7m6cDdIHDMYqm56IHu4S4LsucUJ0yOU7dJwRQ=;
  b=C0Q9xxUX/8Whx5rRIMwR1S35dw6NFBhCglolgIS1OnIDjA6UN5F6giHb
   mfHXAQ9HtwnmQ6I0cfwwUw/H2ovBkuCyRCGW3SjCWmBj8kXlZ4LX4mGOQ
   cWgLAb/C243rTOz8rbQOtXYwO9kSQsT1d4t1HUhBKbLuziMsaw3UAe8Mu
   ofg32c1e9KMuHQnahRWC5DPn7TKyhSxqZP6fC6EmZRobBRCxtTvgvNbmh
   luBb1AVXS/NwmSY/ztIw0ss87KPt8Vr/nbFZZJ/FdYiC9ZdoiCB6BHSog
   1iu+loVN/7U4MQIu7DUU/2nZePZsZ0gL364Pvm/QHTC35+WHBzh0QR/y/
   A==;
X-IronPort-AV: E=Sophos;i="5.96,301,1665417600"; 
   d="scan'208";a="219945554"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jan 2023 12:07:59 +0800
IronPort-SDR: cwQGbjH5ADP1pNr/PbqhlSq8hO+T9S9M8HasUJkQzQ8uMjdNvPJp55YAyivsvJE78NNDuNWh7v
 EqzZY52w72y4d+uiJFKHNSr+rpPWSR2rpvubMNiEjAjLz86ihAUIyzXQMqE/K2j+V/ZhF+pwf0
 FI5nC1AvmNCCEZkGni2wp+BWJmc3C5PuIh2otG57IqmH6IlfvAPQ/oSQPrY/9Bqqd4m+JetR4a
 9MTHCQcBzO4RBsDgXI7+eS6mVxkTd7VUHQnWP0KN70QSTW6r7bBS5VJwK6fG9sQB16gU5XPArx
 5Cg=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jan 2023 19:20:11 -0800
IronPort-SDR: Q3jQMk+W+7SJZ6khAZfalegust1LKYR/YJRR+22TqjeUFOamB6Qw0c3ZBIDwdbgmQcvCECc4Hq
 /9KlBiuVgPZ1CUDyEFUl9xe7hqlt19j4IkuoGvdXlrg1wt3jnkU6BIraWBxcSbKmdwcNttXuOW
 8ltUemnJJ9kdSwPonwB6RQcs0fY7CKS605efH12klGeczrdQtYbnjF9A2+GmgFTUyNbMmBCL8P
 /b92XPHw3ibw1Ygnwabwv0whdgqTfsR/xm6BZq/l61WKB3dPyr2V22ta4izTKxUqd+gphsXHCM
 5T8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Jan 2023 20:08:00 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NnXxp6nGtz1RvTr
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 20:07:58 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1672891678; x=1675483679; bh=8oXQug7m6cDdIHDMYq
        m56IHu4S4LsucUJ0yOU7dJwRQ=; b=aDz+zn/NmLtA/oDdOSOJ6jPMudf7mwdZI5
        4LQcuwbsWWLSmHWwTQ3Zr945yZkJfXaq8T3q58HJIO5bjy3+wdvbLQkzwn04UZQw
        WruYCdCo0g4rmFtzVZ2DJpIg3YIXY+xpi78ZDuQ91B7sQZ8cH3hbxiUvfqDUpBti
        hHspPuS+75g2N2n47R8r9EPDU6WeieTxQHsmrafMaW+ckegEKtNJUz2cYCVkj8Ki
        5siUUrNMX7ivNEsGSQvoXI00NAHEaTp6wNxYxoH4CrxSIW+KCC5W5sF+xOBG71cX
        oGr3gB/z7dn9nf7F3SHAewG4Z0/KHd/o8EVp9bm8wLhs1GxMYj3w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Nzh3SBW01JuA for <stable@vger.kernel.org>;
        Wed,  4 Jan 2023 20:07:58 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NnXxn6Lxnz1RvLy;
        Wed,  4 Jan 2023 20:07:57 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH] block: mq-deadline: Fix dd_finish_request() for zoned devices
Date:   Thu,  5 Jan 2023 13:07:56 +0900
Message-Id: <20230105040756.579794-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <167284210313124@kroah.com>
References: <167284210313124@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2820e5d0820ac4daedff1272616a53d9c7682fd2 upstream.

dd_finish_request() tests if the per prio fifo_list is not empty to
determine if request dispatching must be restarted for handling blocked
write requests to zoned devices with a call to
blk_mq_sched_mark_restart_hctx(). While simple, this implementation has
2 problems:

1) Only the priority level of the completed request is considered.
   However, writes to a zone may be blocked due to other writes to the
   same zone using a different priority level. While this is unlikely to
   happen in practice, as writing a zone with different IO priorirites
   does not make sense, nothing in the code prevents this from
   happening.
2) The use of list_empty() is dangerous as dd_finish_request() does not
   take dd->lock and may run concurrently with the insert and dispatch
   code.

Fix these 2 problems by testing the write fifo list of all priority
levels using the new helper dd_has_write_work(), and by testing each
fifo list using list_empty_careful().

Fixes: c807ab520fc3 ("block/mq-deadline: Add I/O priority support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20221124021208.242541-2-damien.lemoal@ope=
nsource.wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/mq-deadline.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index cd2342d29704..a3f966ece0b7 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -733,6 +733,18 @@ static void dd_prepare_request(struct request *rq)
 	rq->elv.priv[0] =3D NULL;
 }
=20
+static bool dd_has_write_work(struct blk_mq_hw_ctx *hctx)
+{
+	struct deadline_data *dd =3D hctx->queue->elevator->elevator_data;
+	enum dd_prio p;
+
+	for (p =3D 0; p <=3D DD_PRIO_MAX; p++)
+		if (!list_empty_careful(&dd->per_prio[p].fifo_list[DD_WRITE]))
+			return true;
+
+	return false;
+}
+
 /*
  * Callback from inside blk_mq_free_request().
  *
@@ -755,7 +767,6 @@ static void dd_finish_request(struct request *rq)
 	struct deadline_data *dd =3D q->elevator->elevator_data;
 	const u8 ioprio_class =3D dd_rq_ioclass(rq);
 	const enum dd_prio prio =3D ioprio_class_to_prio[ioprio_class];
-	struct dd_per_prio *per_prio =3D &dd->per_prio[prio];
=20
 	/*
 	 * The block layer core may call dd_finish_request() without having
@@ -771,9 +782,10 @@ static void dd_finish_request(struct request *rq)
=20
 		spin_lock_irqsave(&dd->zone_lock, flags);
 		blk_req_zone_write_unlock(rq);
-		if (!list_empty(&per_prio->fifo_list[DD_WRITE]))
-			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
 		spin_unlock_irqrestore(&dd->zone_lock, flags);
+
+		if (dd_has_write_work(rq->mq_hctx))
+			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
 	}
 }
=20
--=20
2.39.0

