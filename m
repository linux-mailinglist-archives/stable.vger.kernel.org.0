Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18DE49A9DA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323741AbiAYD3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376383AbiAXVFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F101C0619D2;
        Mon, 24 Jan 2022 12:05:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8561C60989;
        Mon, 24 Jan 2022 20:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632F3C340E5;
        Mon, 24 Jan 2022 20:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054737;
        bh=Kg6lB8gyFX7ICKo3+KWCWKtc2SOVkFcVpBWAYHfLIk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/Fiyx4yIFqqnSTXfOvdj+OH+KMTomjInsjXyYLRssrg6eNi2rWeTkDs5EM+iVafd
         qb0EsZZcXX5M3kU37UVx9FZytHzxj6U3CZ5sDWi3kMQcQog8okTfY/eG/tctitM8dm
         uhoq4jglXblG+Y35bJkOtCxE4VEGHND6uAM/yups=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julius Werner <jwerner@chromium.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 486/563] firmware: Update Kconfig help text for Google firmware
Date:   Mon, 24 Jan 2022 19:44:11 +0100
Message-Id: <20220124184041.256076466@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

commit d185a3466f0cd5af8f1c5c782c53bc0e6f2e7136 upstream.

The help text for GOOGLE_FIRMWARE states that it should only be
enabled when building a kernel for Google's own servers.  However,
many of the drivers dependent on it are also useful on Chromebooks or
on any platform using coreboot.

Update the help text to reflect this double duty.

Fixes: d384d6f43d1e ("firmware: google memconsole: Add coreboot support")
Reviewed-by: Julius Werner <jwerner@chromium.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Link: https://lore.kernel.org/r/20180618225540.GD14131@decadent.org.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/google/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/firmware/google/Kconfig
+++ b/drivers/firmware/google/Kconfig
@@ -3,9 +3,9 @@ menuconfig GOOGLE_FIRMWARE
 	bool "Google Firmware Drivers"
 	default n
 	help
-	  These firmware drivers are used by Google's servers.  They are
-	  only useful if you are working directly on one of their
-	  proprietary servers.  If in doubt, say "N".
+	  These firmware drivers are used by Google servers,
+	  Chromebooks and other devices using coreboot firmware.
+	  If in doubt, say "N".
 
 if GOOGLE_FIRMWARE
 


