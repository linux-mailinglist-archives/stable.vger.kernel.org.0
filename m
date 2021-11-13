Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B6B44F352
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 14:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhKMNVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 08:21:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230021AbhKMNVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 08:21:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80FE160F6B;
        Sat, 13 Nov 2021 13:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636809499;
        bh=dhAxNxZBibH/ZRZ+wmDAFIvUsu2t3Qk+xOjsGExbyUc=;
        h=Subject:To:Cc:From:Date:From;
        b=EdlXCkw0s7+EbU1ubss+tG6CXRglf5VSY6SjTeY2xscDsNeQw0mCSUqXIE2vS3/s0
         v31AkNVMSOn0whDl0uSpa/qA3h2wp80VeAzXMDkY/+9cXUVzNGS1rJNH+x66Lj5ceI
         WkvcejD1ZS2/PyFRrgs6nz7B2AzrNJRVhfHrXVxM=
Subject: FAILED: patch "[PATCH] platform/x86: gigabyte-wmi: add support for B550 AORUS ELITE" failed to apply to 5.15-stable tree
To:     zephaniah@gmail.com, hdegoede@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 14:18:16 +0100
Message-ID: <163680949618257@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 95384b3e47afa04d7dfa014f6a52662852645578 Mon Sep 17 00:00:00 2001
From: "Zephaniah E. Loss-Cutler-Hull" <zephaniah@gmail.com>
Date: Mon, 4 Oct 2021 21:48:55 -0700
Subject: [PATCH] platform/x86: gigabyte-wmi: add support for B550 AORUS ELITE
 AX V2

This works just fine on my system.

Signed-off-by: Zephaniah E. Loss-Cutler-Hull <zephaniah@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211005044855.1429724-1-zephaniah@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index d53634c8a6e0..658bab4b7964 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -141,6 +141,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE AX V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 GAMING X V2"),

