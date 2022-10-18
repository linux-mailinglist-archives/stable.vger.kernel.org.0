Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3704C603531
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 23:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJRVvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 17:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJRVvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 17:51:25 -0400
Received: from mail1.bemta35.messagelabs.com (mail1.bemta35.messagelabs.com [67.219.250.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAF0BE2F5;
        Tue, 18 Oct 2022 14:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1666129881; i=@motorola.com;
        bh=3wnBijYe1mOYpew+cIYD6PmHE6UxFYuZtEBkN5jGAfo=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding;
        b=IsisYXdpthplP9kffU1By4DZtdES3sfO6IjrNbb/naAKo/g1RvHuegGkuUumxnCY/
         trUJRQ0tPGkq/NpZwL02zkWpX+RO5i3iR8aqGKso1+y0lg0+q8pl3jUnxId/23arDw
         VCL1uS1MPLxOHx1P+X/IQBZMWR/Y5fRbA/OFWrX4tv/ob/Z0zFeFNequH3nk2bJsNO
         B4yy/lReFVt+se1waxuqB5FJ10F3tkk/bcNkjNh/egoRnaArTIOS0x5jm0xgnyJiiu
         mFDC2Q87AWTXOhG2sYbIiRGrRN6TKVjJY2W8qAG7e4jbfY+kuPYqvMEmPYCVbROsVj
         EUu1tOqIzv/Vw==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRWlGSWpSXmKPExsWS8eKJhO4Nef9
  kg7lnuS2OtT1ht3hyoJ3RonfZHjaL5sXr2Sw6Jy5ht1jYtoTF4vKuOWwWi5a1MltsabvCZPHj
  Tx+zxYKNjxgtVi04wO7A4zG7Yyarx6ZVnWwe++euYfdY3DeZ1aP/r4HHlv2fGT0+b5ILYI9iz
  cxLyq9IYM2Yt2oRa8FVjorVG18yNjCuZ+9i5OQQEpjOJLF5sm8XIxeQvY5J4u61zywgCTYBNY
  kFr1cxg9giArISh6/8BrOZBRpYJDZfC+5i5OAQFvCVOHVVEiTMIqAq8W3xbxaQMK+ApcS0W3w
  gYQkBeYn9B8+CdXIKWEl0PWxjgVhrKfG49QoriM0rIChxcuYTFojp8hLNW2czT2DknYUkNQtJ
  agEj0ypGs+LUorLUIl1DM72kosz0jJLcxMwcvcQq3US90mLd8tTiEl0jvcTyYr3U4mK94src5
  JwUvbzUkk2MwOBPKUop38F4ZdkfvUOMkhxMSqK8c775JQvxJeWnVGYkFmfEF5XmpBYfYpTh4F
  CS4OWU8k8WEixKTU+tSMvMAUYiTFqCg0dJhDdNBijNW1yQmFucmQ6ROsWoy9G5v+sAsxBLXn5
  eqpQ4L7csUJEASFFGaR7cCFhSuMQoKyXMy8jAwCDEU5BalJtZgir/ilGcg1FJmPcAyCqezLwS
  uE2vgI5gAjrCdIsfyBEliQgpqQam3UZ5Wi8NAlts2Hmrnk71+/X+aEuKs0qg4p+oTV+O7HmeY
  t8j4dIep7o3bvb2LsVGzXiBgEwxBl0t7hNXZP/LzmgO3/ykOP6C1fzOCPMbS+yizzJGHXe90G
  eoteZEbsjWgo2bY75Offz81Jv/M2TOXQ8M23nw98VyFaO4ggu78xfufeU/8+cCW6bkLAeG6oW
  BbotL1vxQPS317JbJNjPmxe2i/4Vnt6lwRrmKp8WqMEQomE75/3xCTkJVX8KjRXOOrO+b+ju7
  7kXunRdJYia2c+enev2auV9lQZcOxz8vnfXWS572rS48a2inWWQp+e1F/SvxY8+6RPVDZk5dU
  vkywO/9mdK1nfsfxW74XK6ixFKckWioxVxUnAgA9UiGKYUDAAA=
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-18.tower-636.messagelabs.com!1666129879!642371!1
X-Originating-IP: [104.232.228.24]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 29871 invoked from network); 18 Oct 2022 21:51:20 -0000
Received: from unknown (HELO va32lpfpp04.lenovo.com) (104.232.228.24)
  by server-18.tower-636.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Oct 2022 21:51:20 -0000
Received: from va32lmmrp02.lenovo.com (va32lmmrp02.mot.com [10.62.176.191])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp04.lenovo.com (Postfix) with ESMTPS id 4MsSHC1SMgzgK7f;
        Tue, 18 Oct 2022 21:51:19 +0000 (UTC)
Received: from p1g3.mot.com (unknown [100.64.172.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by va32lmmrp02.lenovo.com (Postfix) with ESMTPSA id 4MsSHB6Z49zf6WS;
        Tue, 18 Oct 2022 21:51:18 +0000 (UTC)
From:   Dan Vacura <w36195@motorola.com>
To:     linux-usb@vger.kernel.org
Cc:     Daniel Scally <dan.scally@ideasonboard.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jeff Vanhoof <qjv001@motorola.com>,
        Dan Vacura <w36195@motorola.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Paul Elder <paul.elder@ideasonboard.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 1/6] usb: gadget: uvc: fix dropped frame after missed isoc
Date:   Tue, 18 Oct 2022 16:50:37 -0500
Message-Id: <20221018215044.765044-2-w36195@motorola.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018215044.765044-1-w36195@motorola.com>
References: <20221018215044.765044-1-w36195@motorola.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With the re-use of the previous completion status in 0d1c407b1a749
("usb: dwc3: gadget: Return proper request status") it could be possible
that the next frame would also get dropped if the current frame has a
missed isoc error. Ensure that an interrupt is requested for the start
of a new frame.

Fixes: fc78941d8169 ("usb: gadget: uvc: decrease the interrupt load to a quarter")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Vacura <w36195@motorola.com>
---
V1 -> V3:
- no change, new patch in series
V3 -> V4:
- no change

 drivers/usb/gadget/function/uvc_video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index bb037fcc90e6..323977716f5a 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -431,7 +431,8 @@ static void uvcg_video_pump(struct work_struct *work)
 
 		/* Endpoint now owns the request */
 		req = NULL;
-		video->req_int_count++;
+		if (buf->state != UVC_BUF_STATE_DONE)
+			video->req_int_count++;
 	}
 
 	if (!req)
-- 
2.34.1

