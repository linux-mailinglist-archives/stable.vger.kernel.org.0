Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471944287C6
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 09:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhJKHlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 03:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234129AbhJKHle (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 03:41:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A093C60D07;
        Mon, 11 Oct 2021 07:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633937975;
        bh=u0HI/InnDy9OyLwK3KKjRJpmNaTKCFlh9cKLqp/tA3M=;
        h=Subject:To:Cc:From:Date:From;
        b=WMR48HUJD1IA7zDXRDwn76hDSwTXFJ9OZI15RCZnMZnax8JL8Iuch+miG85MbbaKu
         iACN7eS+7kp1bBvK6TMqGHD7qe/bc9fJ4Vc/FP6mgFaLPrHaz5ZSG2Tpa5L6qbUHz1
         +eKemLJcFfN9Q44iUCWOBrNz3cbVyQ69rjHbzcJQ=
Subject: FAILED: patch "[PATCH] x86/Kconfig: Correct reference to MWINCHIP3D" failed to apply to 4.19-stable tree
To:     lukas.bulwahn@gmail.com, bp@suse.de, rdunlap@infradead.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Oct 2021 09:39:24 +0200
Message-ID: <16339379649423@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 225bac2dc5d192e55f2c50123ee539b1edf8a411 Mon Sep 17 00:00:00 2001
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date: Tue, 3 Aug 2021 13:35:25 +0200
Subject: [PATCH] x86/Kconfig: Correct reference to MWINCHIP3D

Commit in Fixes intended to exclude the Winchip series and referred to
CONFIG_WINCHIP3D, but the config symbol is called CONFIG_MWINCHIP3D.

Hence, scripts/checkkconfigsymbols.py warns:

WINCHIP3D
Referencing files: arch/x86/Kconfig

Correct the reference to the intended config symbol.

Fixes: 69b8d3fcabdc ("x86/Kconfig: Exclude i586-class CPUs lacking PAE support from the HIGHMEM64G Kconfig group")
Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20210803113531.30720-4-lukas.bulwahn@gmail.com

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ab83c22d274e..8055da49f1c0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1405,7 +1405,7 @@ config HIGHMEM4G
 
 config HIGHMEM64G
 	bool "64GB"
-	depends on !M486SX && !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !WINCHIP3D && !MK6
+	depends on !M486SX && !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !MWINCHIP3D && !MK6
 	select X86_PAE
 	help
 	  Select this if you have a 32-bit processor and more than 4

