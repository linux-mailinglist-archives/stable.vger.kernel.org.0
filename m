Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB90428F92
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237197AbhJKN7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238306AbhJKN6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CD65610CB;
        Mon, 11 Oct 2021 13:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960501;
        bh=DNpiTyfL2JEkm/BLd1B4NDGJ2vAbpH7UuSwQoHvzm54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irtVlQVaZS6kh2LEy6xOmU+ibp0umjr51T9awsKSoTcn1e7qDoIb0E41SqC2D3f2c
         pC4WcacS0Qpw6WFUnPM/K4E29sm0hilrZiaL+TarD5Fdhoy1M0koqi1PkCdEZKbLIF
         pmTHsmgTnPC+kZdLedPm94JeyIlF6tgbB0TBdxis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 78/83] x86/Kconfig: Correct reference to MWINCHIP3D
Date:   Mon, 11 Oct 2021 15:46:38 +0200
Message-Id: <20211011134511.064068025@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1415,7 +1415,7 @@ config HIGHMEM4G
 
 config HIGHMEM64G
 	bool "64GB"
-	depends on !M486SX && !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !WINCHIP3D && !MK6
+	depends on !M486SX && !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !MWINCHIP3D && !MK6
 	select X86_PAE
 	help
 	  Select this if you have a 32-bit processor and more than 4


