Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D65429169
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244128AbhJKOSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242787AbhJKOPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:15:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6391E60F35;
        Mon, 11 Oct 2021 14:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961143;
        bh=CxT8FJcid5jVjtA52Hgn3FG8wZr3aP8AN08C8P1h70o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXKzBB+eBwAQlWcskXcRP2SCwy3LybZw2Kb9kORRQYvLfJWBLBNaDqmhCsVQwG/vN
         yIeiwte8zM69E4NPR3mlIztOzM7q2I5eWriHZV16W8gVPIQB8nLEFHhbWeLeMhkiCu
         zH+fjxXG+j2ktViG9XieIzY+1Yt67pBQh+kUMifk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.19 28/28] x86/Kconfig: Correct reference to MWINCHIP3D
Date:   Mon, 11 Oct 2021 15:47:18 +0200
Message-Id: <20211011134641.621506661@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
References: <20211011134640.711218469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

commit 225bac2dc5d192e55f2c50123ee539b1edf8a411 upstream.

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
[manually adjusted the change to the state on the v4.19.y and v5.4.y stable tree]
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1387,7 +1387,7 @@ config HIGHMEM4G
 
 config HIGHMEM64G
 	bool "64GB"
-	depends on !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !WINCHIP3D && !MK6
+	depends on !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !MWINCHIP3D && !MK6
 	select X86_PAE
 	---help---
 	  Select this if you have a 32-bit processor and more than 4


