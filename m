Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC61601AB5
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 22:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiJQUzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 16:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiJQUz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 16:55:29 -0400
Received: from mail1.bemta33.messagelabs.com (mail1.bemta33.messagelabs.com [67.219.247.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5465E6C97F;
        Mon, 17 Oct 2022 13:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1666040125; i=@motorola.com;
        bh=CCyVpHMdxR921PsDSRTyY9XE1PLOTC+3bCOgY+h5ZEU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding;
        b=Cwi+SUutrAX3vQd6zLT1yGVpUEEwlIjIqaie2p/bX/+aIJ03eTdx38BY0XSGC92xK
         RBysAPX8D4fC3+cXK6uOo9MSa//KgQPzwCaoNxdz1vDtE5JgrFKBrpVdadTWhL7X3l
         rh9lW2rCbKrs5tbQLTV9ZFRWOzOLG6GWvguGn860uOiFbQHEKzYSEPWboEB86oxUfd
         fwnVxFO3KVdcXPr6Pw7A7pNQ2Mtlgw3Sf6PC+aWURlbEC1h8JOCOxSHu4fGSOMjc24
         A9YuHjmeDBdN6uGMjqHB+wPgjuFWByGQfCEaBNsZQq1XorP1svndpyk3SqiObArM6r
         bAV8yaMth46CQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRWlGSWpSXmKPExsUyYU+Ds67NQd9
  kg9X9WhbH2p6wWzw50M5o0btsD5tF8+L1bBadE5ewWyxsW8JicXnXHDaLRctamS22tF1hsvjx
  p4/ZYsHGR4wWqxYcYHfg8ZjdMZPVY9OqTjaP/XPXsHss7pvM6tH/18Bjy/7PjB6fN8kFsEexZ
  uYl5VcksGYsXVpasJ+jYtdjtQbG+exdjJwcQgJTmCSuHSvtYuQCstcySRy4v4kNJMEmoCax4P
  UqZhBbREBW4vCV32A2s0ADi8Tma8EgtrCAm8T3LUcZuxjZOVgEVCWegVXwClhKrLr9lgXElhC
  Ql9h/8CxQnIODU8BKYsNUdYitlhKbD2xhhSgXlDg58wkLxHB5ieats5knMPLOQpKahSS1gJFp
  FaNpcWpRWWqRrrFeUlFmekZJbmJmjl5ilW6iXmmxbmpicYmukV5iebFeanGxXnFlbnJOil5ea
  skmRmDQpxS5h+1g/Lb0j94hRkkOJiVR3o4ZvslCfEn5KZUZicUZ8UWlOanFhxhlODiUJHh/7g
  DKCRalpqdWpGXmACMQJi3BwaMkwtu5DSjNW1yQmFucmQ6ROsWoy9G5v+sAsxBLXn5eqpQ4749
  9QEUCIEUZpXlwI2DJ4BKjrJQwLyMDA4MQT0FqUW5mCar8K0ZxDkYlYd77+4Gm8GTmlcBtegV0
  BBPQERn7vUCOKElESEk1MBl1VFWwBvQqT+WV9j8yOdL1nZiO15mj747fCli4/eyyBR1GITNf/
  a/9sz7d5Vmfjmp6+bmsUKetf+znaL5SfzL56N0AnTTzJ5tvJdvfnXbiSO58Pn+7pYYhOhPE/r
  glVm+pWnO2cP9yC3Nn3t/inYuN3naaa58xbru/e4lsU+zn4gt3Lc7fFjCZU7tddN25B49+lEa
  lu90KXvj13Ye5s1Sz/Nu+nBXMCljBHDDvX3RQRJPpJZ0L2mGPnsfYzp4//7hny6ybvbv2N/cW
  +IVFJsTrLTL4sH0mk27T7lXp/cz2+nYm2ozLNtRW7vzGdkx7p7fs7tt2FTkLWvOFAgXOXFlfF
  jLLKlNBcabSs8vek5RYijMSDbWYi4oTAUDV8JaBAwAA
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-3.tower-715.messagelabs.com!1666040124!35180!1
X-Originating-IP: [144.188.128.67]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 27401 invoked from network); 17 Oct 2022 20:55:24 -0000
Received: from unknown (HELO ilclpfpp01.lenovo.com) (144.188.128.67)
  by server-3.tower-715.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Oct 2022 20:55:24 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by ilclpfpp01.lenovo.com (Postfix) with ESMTPS id 4Mrq581pvxzfBZq;
        Mon, 17 Oct 2022 20:55:24 +0000 (UTC)
Received: from p1g3.mot.com (unknown [100.64.172.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4Mrq581dmpzbpxx;
        Mon, 17 Oct 2022 20:55:24 +0000 (UTC)
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
Subject: [PATCH] usb: gadget: uvc: fix dropped frame after missed isoc
Date:   Mon, 17 Oct 2022 15:54:39 -0500
Message-Id: <20221017205446.523796-2-w36195@motorola.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221017205446.523796-1-w36195@motorola.com>
References: <20221017205446.523796-1-w36195@motorola.com>
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

