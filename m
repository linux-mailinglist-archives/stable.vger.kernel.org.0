Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15F049A8F4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1321627AbiAYDTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:19:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48310 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350254AbiAXTYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:24:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B69EB8122C;
        Mon, 24 Jan 2022 19:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE68C340E5;
        Mon, 24 Jan 2022 19:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052282;
        bh=64djAcdFOZX9lox2mWpaTdgR3LKocNI2zq5giDpMUEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UO5PPYXD240o8DvYSFmBoqyqQu5ooV1RJcbUqlIdwEP18RueMhAIUUvIua5NGINfR
         stUvh8EG9RYTY8EV2H4gaq9CSoWoNYzRCLqd1Y1qPuLzlenPsLqnh7MqszRm6+rRjV
         ja9U4k+aTMqCS/WvbAUs7JpF9UwgvNWpy7/ldfHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julius Werner <jwerner@chromium.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.19 212/239] firmware: Update Kconfig help text for Google firmware
Date:   Mon, 24 Jan 2022 19:44:10 +0100
Message-Id: <20220124183949.855915546@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
@@ -2,9 +2,9 @@ menuconfig GOOGLE_FIRMWARE
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
 


