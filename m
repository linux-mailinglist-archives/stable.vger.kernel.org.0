Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4048601AC1
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 22:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiJQUzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 16:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiJQUzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 16:55:40 -0400
Received: from mail1.bemta33.messagelabs.com (mail1.bemta33.messagelabs.com [67.219.247.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246546E8BA;
        Mon, 17 Oct 2022 13:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1666040130; i=@motorola.com;
        bh=n8k50yaYBoXsDKl3qy5CXt9sKetRc8UVBOWgkeQ1R/I=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding;
        b=XC5YVEW0U9fgYsvdQqz7J5LuB3fhXt03kGy4yYqrUbjI3RX11CIguVS+EZ+InfUSS
         qaUY538yOBlLwgFvFjD+MYcX4xcPF8UgA4gEJZSUcQl1XMSkXebf0ynxT0X+5NYxVP
         DlEMGAqukXlXc0wa9tPtOyEmNPUyddHckdAzLx2XLaXEv+aEmdmAxVlkRDQ3sarV4t
         ZZG6CEz6L7dH7TQ+T+dWIxFU/ZccBvXgFk+iPvYifS+4xHo7vpZuqggOFt4W7zQ4E4
         EoXkeEHuuoWU46i0K3ibHFmi+0DGuSB9uKT4j9UxPNqmkwnFpphWnLrxaokbTku7jy
         tvC33YprjUNpg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRWlGSWpSXmKPExsWS8eKJqK7TQd9
  kg6cdTBbH2p6wWzw50M5o0btsD5tF8+L1bBadE5ewWyxsW8JicXnXHDaLRctamS22tF1hsvjx
  p4/ZYsHGR4wWqxYcYHfg8ZjdMZPVY9OqTjaP/XPXsHss7pvM6tH/18Bjy/7PjB6fN8kFsEexZ
  uYl5VcksGZs733FXnCfq2L3tx/MDYyLOLsYuTiEBKYySdz6M5kNwlnLJPHg3FfWLkZODjYBNY
  kFr1cxg9giArISh6/8ZgYpYhZoYJH4sPEJC0hCWMBXYsuJe2wgNouAqsSnWUfYQWxeAUuJ67O
  ugzVLCMhL7D94Fsjm4OAUsJLYMFUdJCwEVLL5wBZWiHJBiZMzIUYyA5U3b53NPIGRdxaS1Cwk
  qQWMTKsYzYpTi8pSi3QNzfWSijLTM0pyEzNz9BKrdBP1Sot1UxOLS3SN9BLLi/VSi4v1iitzk
  3NS9PJSSzYxAmMgpcj97w7Gvcv+6B1ilORgUhLl7ZjhmyzEl5SfUpmRWJwRX1Sak1p8iFGGg0
  NJgvfnDqCcYFFqempFWmYOMB5h0hIcPEoivJ3bgNK8xQWJucWZ6RCpU4y6HJ37uw4wC7Hk5ee
  lSonz/tgHVCQAUpRRmgc3ApYaLjHKSgnzMjIwMAjxFKQW5WaWoMq/YhTnYFQS5r2/H2gKT2Ze
  CdymV0BHMAEdkbHfC+SIkkSElFQDk4i466Kq60VGr56kzg3ZG/Bl+z23DXNmiL1VXe4j2J7MX
  xnDGbPg9R/5ZTrRprPXt2f+PHr7fzaDfiJPdcIZVQdp//3H7+go7FwWuKTwcDKzaN/UwLvxn0
  rPVE7PW/xO4eya3MPdv4sT5iZ0O2wpmrlobYx6wdnUz+ZRVvsudvvOtbjk3bN16k2Ts2LPjKV
  uZzfZPoywdWpomc/v5V0RYVOwh9HkptDFaffKV/1aED7dyjCbjW3XObVVWmY80Zf4jm3LW/Zn
  c+DnrM/aiedF9cwrsjr2Pj4i8/h4Oedfv7nK9ROj7x4LUY7eptv5S10kdccR03jr7bMXm+RF8
  SQql1UaetbLTV3kWTNT3yVaiaU4I9FQi7moOBEAMRQ0l4gDAAA=
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-19.tower-715.messagelabs.com!1666040129!105306!1
X-Originating-IP: [104.232.228.21]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 12036 invoked from network); 17 Oct 2022 20:55:30 -0000
Received: from unknown (HELO va32lpfpp01.lenovo.com) (104.232.228.21)
  by server-19.tower-715.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Oct 2022 20:55:30 -0000
Received: from ilclmmrp01.lenovo.com (ilclmmrp01.mot.com [100.65.83.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by va32lpfpp01.lenovo.com (Postfix) with ESMTPS id 4Mrq5F4mHwzhSZf;
        Mon, 17 Oct 2022 20:55:29 +0000 (UTC)
Received: from p1g3.mot.com (unknown [100.64.172.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by ilclmmrp01.lenovo.com (Postfix) with ESMTPSA id 4Mrq5F2cJtzbpxx;
        Mon, 17 Oct 2022 20:55:29 +0000 (UTC)
From:   Dan Vacura <w36195@motorola.com>
To:     linux-usb@vger.kernel.org
Cc:     Daniel Scally <dan.scally@ideasonboard.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jeff Vanhoof <qjv001@motorola.com>, stable@vger.kernel.org,
        Dan Vacura <w36195@motorola.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Paul Elder <paul.elder@ideasonboard.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v3 4/6] usb: gadget: uvc: fix sg handling during video encode
Date:   Mon, 17 Oct 2022 15:54:42 -0500
Message-Id: <20221017205446.523796-5-w36195@motorola.com>
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

From: Jeff Vanhoof <qjv001@motorola.com>

In uvc_video_encode_isoc_sg, the uvc_request's sg list is
incorrectly being populated leading to corrupt video being
received by the remote end. When building the sg list the
usage of buf->sg's 'dma_length' field is not correct and
instead its 'length' field should be used.

Fixes: e81e7f9a0eb9 ("usb: gadget: uvc: add scatter gather support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jeff Vanhoof <qjv001@motorola.com>
Signed-off-by: Dan Vacura <w36195@motorola.com>
---
V1 -> V3:
- no change, new patch in series

 drivers/usb/gadget/function/uvc_video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index dd54841b0b3e..7d4508a83d5d 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -157,10 +157,10 @@ uvc_video_encode_isoc_sg(struct usb_request *req, struct uvc_video *video,
 	sg = sg_next(sg);
 
 	for_each_sg(sg, iter, ureq->sgt.nents - 1, i) {
-		if (!len || !buf->sg || !sg_dma_len(buf->sg))
+		if (!len || !buf->sg || !buf->sg->length)
 			break;
 
-		sg_left = sg_dma_len(buf->sg) - buf->offset;
+		sg_left = buf->sg->length - buf->offset;
 		part = min_t(unsigned int, len, sg_left);
 
 		sg_set_page(iter, sg_page(buf->sg), part, buf->offset);
-- 
2.34.1

