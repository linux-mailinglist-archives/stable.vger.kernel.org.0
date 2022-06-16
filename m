Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7461454D8CB
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 05:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354540AbiFPDMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 23:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348243AbiFPDMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 23:12:00 -0400
Received: from mail1.bemta35.messagelabs.com (mail1.bemta35.messagelabs.com [67.219.250.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8EB5A16B;
        Wed, 15 Jun 2022 20:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1655349117; i=@motorola.com;
        bh=xeAothptBJEhe76/WHzGYVzyKqvRIjL5oS+hZFSa6SI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
         Content-Transfer-Encoding;
        b=kXaSpJmuu4KDe9MfdThrboiacqy1OLCbaiEiBs5bZhezqzc4zJdEpZcIDN5ZBXRC+
         RzUCaLmQrmfw31g9bYiKpXsCesJkt6NAr2ZsCxj74/RQbneNMTmSfEN/zvm17+YyYR
         5EIoeE2wGf79oNtJSn3WYNb4v06DjzoLAv6gc320gZLyt4WurT6/JvpZqvGTnbXDOI
         taug7TSeUel84YSNglq10UcMCZSYguuCLUZ0ypVMkAA8AS8//W9qEC8b41rI7X1MW8
         ciebX23t/ebzSKCRO5+l1SXq4xTOtLcJ1UhUHzEk3odqXbPqBppO4UG9sA03ZcYWNk
         4o5NHc6SCeNow==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRWlGSWpSXmKPExsWS8eKJqG7N/FV
  JBqcmS1sca3vCbtG8eD2bRefEJewWl3fNYbNYtKyV2WJL2xUmix9/+pgtFmx8xOjA4TG7Yyar
  x6ZVnWwe++euYffo/2vg8XmTXABrFGtmXlJ+RQJrxo9vvxgLNvFU7Jsyh7mB8ShXFyMXh5DAd
  CaJ/be3sUM4S5gkWnqPAjmcHGwCahILXq9iBrFFBGQlDl/5zQxSxCxwmEni3efzYEXCAp4S8z
  ffZgSxWQRUJW71zmEFsXkFLCU2bNkIViMhIC+x/+BZZoi4oMTJmU9YQGxmoHjz1tnMExi5ZyF
  JzUKSWsDItIrRJqkoMz2jJDcxM0fX0MBA19DQBEIbG+olVukm6pUW65anFpfoGukllhfrpRYX
  6xVX5ibnpOjlpZZsYgQGaUpRSvMOxiX9P/UOMUpyMCmJ8v7iWZUkxJeUn1KZkVicEV9UmpNaf
  IhRhoNDSYJXrR8oJ1iUmp5akZaZA4wYmLQEB4+SCG/zPKA0b3FBYm5xZjpE6hSjLkfn/q4DzE
  Isefl5qVLivJ4gRQIgRRmleXAjYNF7iVFWSpiXkYGBQYinILUoN7MEVf4VozgHo5Iw7765QFN
  4MvNK4Da9AjqCCeiIxn0rQI4oSURISTUw5Z92+dX64lhp5kEZnXCjK1+67Iz53X65Xd8lJrSk
  mOP5Czmno2dKTq6UXLzOd/NayV9bWa+8fPswc6mCk4PQwhO8/PLaT2+lJavtc746fQXDK7mZO
  nXOs+SMjPueTgh1uXtB6tIV0UfXGE9cffGHXeG2xnxDexHBP8e/fGvP9n6waw3n3k8Lb9e7M0
  rHvXOZvjzkBJfypLPTZK+lXnl6z+GItf7XdJ/++Ws+ztwuy3D0oGrAUrvjfwMm6f/hOCutedZ
  3T866+BnLLomznQj+Ubu+cIbm6RyL4PDEbGu/htj0WXJ+sdJqucW5PBZpHptffzPgVdn3baNr
  OsfvIraqk2lXj7tfMJdbH7zQST9WT4mlOCPRUIu5qDgRAIWNyedZAwAA
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-18.tower-636.messagelabs.com!1655349115!41653!1
X-Originating-IP: [104.232.228.21]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.86.7; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 4690 invoked from network); 16 Jun 2022 03:11:56 -0000
Received: from unknown (HELO va32lpfpp01.lenovo.com) (104.232.228.21)
  by server-18.tower-636.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 16 Jun 2022 03:11:56 -0000
Received: from va32lmmrp01.lenovo.com (va32lmmrp01.mot.com [10.62.177.113])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp01.lenovo.com (Postfix) with ESMTPS id 4LNnJq38TKzf6mg;
        Thu, 16 Jun 2022 03:11:55 +0000 (UTC)
Received: from p1g3.. (unknown [10.45.7.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by va32lmmrp01.lenovo.com (Postfix) with ESMTPSA id 4LNnJq0WgZzf6f0;
        Thu, 16 Jun 2022 03:11:55 +0000 (UTC)
From:   Dan Vacura <w36195@motorola.com>
To:     linux-usb@vger.kernel.org
Cc:     Dan Vacura <w36195@motorola.com>, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: uvc: fix list double add in uvcg_video_pump
Date:   Wed, 15 Jun 2022 22:09:15 -0500
Message-Id: <20220616030915.149238-1-w36195@motorola.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A panic can occur if the endpoint becomes disabled and the
uvcg_video_pump adds the request back to the req_free list after it has
already been queued to the endpoint. The endpoint complete will add the
request back to the req_free list. Invalidate the local request handle
once it's been queued.

<6>[  246.796704][T13726] configfs-gadget gadget: uvc: uvc_function_set_alt(1, 0)
<3>[  246.797078][   T26] list_add double add: new=ffffff878bee5c40, prev=ffffff878bee5c40, next=ffffff878b0f0a90.
<6>[  246.797213][   T26] ------------[ cut here ]------------
<2>[  246.797224][   T26] kernel BUG at lib/list_debug.c:31!
<6>[  246.807073][   T26] Call trace:
<6>[  246.807180][   T26]  uvcg_video_pump+0x364/0x38c
<6>[  246.807366][   T26]  process_one_work+0x2a4/0x544
<6>[  246.807394][   T26]  worker_thread+0x350/0x784
<6>[  246.807442][   T26]  kthread+0x2ac/0x320

Fixes: f9897ec0f6d3 ("usb: gadget: uvc: only pump video data if necessary")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Vacura <w36195@motorola.com>
---
 drivers/usb/gadget/function/uvc_video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 93f42c7f800d..59e2f51b53a5 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -427,6 +427,9 @@ static void uvcg_video_pump(struct work_struct *work)
 		if (ret < 0) {
 			uvcg_queue_cancel(queue, 0);
 			break;
+		} else {
+			/* Endpoint now owns the request */
+			req = NULL;
 		}
 		video->req_int_count++;
 	}
-- 
2.34.1

