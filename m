Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2502676FA8
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjAVPXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbjAVPXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71ED8F748
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C36860C58
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA0EC433D2;
        Sun, 22 Jan 2023 15:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401028;
        bh=323hNzAdHQZSrFG6frKIdVCgn0L2rNwLcntOQvOzxUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArZhR1FWJL55NmCin1CYX2HWYowYEumMEKpJmUVlr4kQEYyLqV9Ih+r+8DFHivjzb
         8KVn0AuIwYEAXB6+US5ki/5LwHJObzeDI3VT8b6sCzgITJnMVURY5c1L02mYbqUmJl
         Mq7CDyWjWSurck5eSfiTCR6sivszAYJnTsGxK0Ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Christoph Jung <jung@codemercs.com>
Subject: [PATCH 6.1 065/193] USB: misc: iowarrior: fix up header size for USB_DEVICE_ID_CODEMERCS_IOW100
Date:   Sun, 22 Jan 2023 16:03:14 +0100
Message-Id: <20230122150249.321793411@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 14ff7460bb58662d86aa50298943cc7d25532e28 upstream.

The USB_DEVICE_ID_CODEMERCS_IOW100 header size was incorrect, it should
be 12, not 13.

Cc: stable <stable@kernel.org>
Fixes: 17a82716587e ("USB: iowarrior: fix up report size handling for some devices")
Reported-by: Christoph Jung <jung@codemercs.com>
Link: https://lore.kernel.org/r/20230120135330.3842518-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/iowarrior.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -814,7 +814,7 @@ static int iowarrior_probe(struct usb_in
 			break;
 
 		case USB_DEVICE_ID_CODEMERCS_IOW100:
-			dev->report_size = 13;
+			dev->report_size = 12;
 			break;
 		}
 	}


