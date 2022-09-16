Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6713C5BAB26
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiIPKWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbiIPKVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:21:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E9AB0B0F;
        Fri, 16 Sep 2022 03:13:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C654E62A15;
        Fri, 16 Sep 2022 10:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E44C433C1;
        Fri, 16 Sep 2022 10:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323154;
        bh=fv+ekS6RWw8GsEUvlEw6OCT0A6j61vKae45X0UQT26o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oam9C0wOJhnCrgtkfDsPUaLHQiHaVJNy0Y1kXRo6EBCtFnoIMr0movfBEh9iO9rCa
         Gljq1OU5d7D36QFIqOXKt+U845o4vH2iETJ1AXssH6Jwy+xBYxG5yHVB9PC/X9W3r6
         rj1ZBkaAlzReW2PETxDaAPF+98KWGQvTLI4PPJH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Jack Pham <quic_jackp@quicinc.com>
Subject: [PATCH 5.15 32/35] usb: gadget: f_uac2: clean up some inconsistent indenting
Date:   Fri, 16 Sep 2022 12:08:55 +0200
Message-Id: <20220916100448.299002635@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
References: <20220916100446.916515275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 18d6b39ee8959c6e513750879b52fd215533cc87 upstream.

There are bunch of statements where the indentation is not correct,
clean these up.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210902224758.57600-1-colin.king@canonical.com
Signed-off-by: Jack Pham <quic_jackp@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -760,15 +760,15 @@ static void setup_headers(struct f_uac2_
 		headers[i++] = USBDHDR(&out_clk_src_desc);
 		headers[i++] = USBDHDR(&usb_out_it_desc);
 
-    if (FUOUT_EN(opts))
-      headers[i++] = USBDHDR(out_feature_unit_desc);
-  }
+		if (FUOUT_EN(opts))
+			headers[i++] = USBDHDR(out_feature_unit_desc);
+	}
 
 	if (EPIN_EN(opts)) {
 		headers[i++] = USBDHDR(&io_in_it_desc);
 
-    if (FUIN_EN(opts))
-      headers[i++] = USBDHDR(in_feature_unit_desc);
+		if (FUIN_EN(opts))
+			headers[i++] = USBDHDR(in_feature_unit_desc);
 
 		headers[i++] = USBDHDR(&usb_in_ot_desc);
 	}
@@ -776,10 +776,10 @@ static void setup_headers(struct f_uac2_
 	if (EPOUT_EN(opts))
 		headers[i++] = USBDHDR(&io_out_ot_desc);
 
-  if (FUOUT_EN(opts) || FUIN_EN(opts))
-      headers[i++] = USBDHDR(ep_int_desc);
+	if (FUOUT_EN(opts) || FUIN_EN(opts))
+		headers[i++] = USBDHDR(ep_int_desc);
 
-  if (EPOUT_EN(opts)) {
+	if (EPOUT_EN(opts)) {
 		headers[i++] = USBDHDR(&std_as_out_if0_desc);
 		headers[i++] = USBDHDR(&std_as_out_if1_desc);
 		headers[i++] = USBDHDR(&as_out_hdr_desc);


