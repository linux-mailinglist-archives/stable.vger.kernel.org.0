Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CE960353F
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 23:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiJRVvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 17:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiJRVv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 17:51:28 -0400
Received: from mail1.bemta35.messagelabs.com (mail1.bemta35.messagelabs.com [67.219.250.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2363BBE2F5;
        Tue, 18 Oct 2022 14:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=motorola.com;
        s=Selector; t=1666129887; i=@motorola.com;
        bh=sRQxZis6uCJYVoJAnHknw5dTcE1MWsQ1xSYk7VRSQkM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Transfer-Encoding;
        b=J8RVRD+t/ZOLfV4xw6PbYaduZsKrrq6d01ANwX8eMn19amTViOxmsz4fMm0HIge/x
         wjpnv+snKMgESPP1fdjBzbpbCtDMyoYVloGtHOTk1xk5Yja7H3p1s1C9oFLzQ7YY+g
         OKuOgk+E7fzpbvxNmdk/xFgA7nSy54NUnOu83IulPLP273QHOjm674l5IB9mNHMKwZ
         I3FfC7F9O9MezRlvKkaX+Iy+AS/74/a2I9SezbevTFZc1Xksf/FcYjZkmRON9VvX2b
         6TAiPwzvR/de4yAxYMFxJzejSJbJSOSEmE+Alz+JqKacx3ezkcu1NSUMdKOt6+vMOx
         5jeQNOH5A2rlQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRWlGSWpSXmKPExsUyYU+Ds+49ef9
  kg461ZhbH2p6wWzw50M5o0btsD5tF8+L1bBadE5ewWyxsW8JicXnXHDaLRctamS22tF1hsvjx
  p4/ZYsHGR4wWqxYcYHfg8ZjdMZPVY9OqTjaP/XPXsHss7pvM6tH/18Bjy/7PjB6fN8kFsEexZ
  uYl5VcksGbsaj7PUvCVq2JZ2y7mBsZNnF2MXBxCAtOYJDbP/MjexcgJ5Kxjkph7wRrEZhNQk1
  jwehUziC0iICtx+MpvZpAGZoEGFonLPddZuhg5OIQFfCWmTzECMVkEVCUmL00GKecVsJS4cmE
  1E4gtISAvsf/gWbAxnAJWEl0P21ggVllKPG69wgpRLyhxcuYTsDgzUH3z1tnMExh5ZyFJzUKS
  WsDItIrRrDi1qCy1SNfQQi+pKDM9oyQ3MTNHL7FKN1GvtFi3PLW4RNdIL7G8WC+1uFivuDI3O
  SdFLy+1ZBMjMPxTihJ6djBuX/ZH7xCjJAeTkijvnG9+yUJ8SfkplRmJxRnxRaU5qcWHGGU4OJ
  QkeDml/JOFBItS01Mr0jJzgLEIk5bg4FES4U2TAUrzFhck5hZnpkOkTjHqcnTu7zrALMSSl5+
  XKiXOyy0LVCQAUpRRmgc3ApYWLjHKSgnzMjIwMAjxFKQW5WaWoMq/YhTnYFQS5j0AsoonM68E
  btMroCOYgI4w3eIHckRJIkJKqoHJ9u+xvb/2ZVtfvXRGgPP2nrRnzxiNjkWqGQaHuoQ7l3Qy3
  VSfo8zU2KTExjmBRye09onuzceJStJ/nq650nz/FcdT/tq9Te8Kvc5lrFcs8K/3e5y8onCC4K
  41TSdre65WPvt5nNcj9sSfyncXf1pN8y/5kth05UjAq8sTt88xkr4t1P9a5+a0lpXZTC7c1mW
  aHO+slxqKrE1iq3lfPHXjQdv800s/COkqWU7NcT67q3Qqw7fPNxre317C/8VParHoGs55Jw+J
  HFPNPb/s0yatGVYTTs87ZMqdVu+o4Xd9o/7dHVrOscqLv+72fSLK9C7w62/pqo0vLG1+N5itf
  2u8huWkmlfY+lqnlwknVnuoK7EUZyQaajEXFScCABQo1EOGAwAA
X-Env-Sender: w36195@motorola.com
X-Msg-Ref: server-19.tower-655.messagelabs.com!1666129886!235534!1
X-Originating-IP: [144.188.128.67]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 25603 invoked from network); 18 Oct 2022 21:51:26 -0000
Received: from unknown (HELO ilclpfpp01.lenovo.com) (144.188.128.67)
  by server-19.tower-655.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 18 Oct 2022 21:51:26 -0000
Received: from va32lmmrp02.lenovo.com (va32lmmrp02.mot.com [10.62.176.191])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by ilclpfpp01.lenovo.com (Postfix) with ESMTPS id 4MsSHL0mqwzfBZq;
        Tue, 18 Oct 2022 21:51:26 +0000 (UTC)
Received: from p1g3.mot.com (unknown [100.64.172.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: w36195)
        by va32lmmrp02.lenovo.com (Postfix) with ESMTPSA id 4MsSHK56klzf6WS;
        Tue, 18 Oct 2022 21:51:25 +0000 (UTC)
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
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 4/6] usb: gadget: uvc: fix sg handling during video encode
Date:   Tue, 18 Oct 2022 16:50:40 -0500
Message-Id: <20221018215044.765044-5-w36195@motorola.com>
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
V3 -> V4:
- no change

 drivers/usb/gadget/function/uvc_video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 5993e083819c..dd1c6b2ca7c6 100644
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

