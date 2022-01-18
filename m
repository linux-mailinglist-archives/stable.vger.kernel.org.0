Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A89E492A1F
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346252AbiARQHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:07:06 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40184 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346321AbiARQHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:07:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E76B1CE1A2C;
        Tue, 18 Jan 2022 16:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5212C00446;
        Tue, 18 Jan 2022 16:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522020;
        bh=khdVEhDTKGq6dOsRJscNJWgQwxfZX4xYhgiF9DUQrc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RqaatXWgr8U5Zts+xtPQJoei6WwORjfTMPT0vhounuBp/3d79T9aKUC51LDua4vbP
         /0jVZD88whAKbOM284kRtK1aYJZdbFOOxWbBpGCz2sf0+m+8VfkSTW5ir51xCqRNq/
         iyj5QGnc0UubNN50OLDer2atyd6WCrEDf5WnZ7LE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        kbuild test robot <lkp@intel.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 5.4 15/15] ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN depends on !LD_IS_LLD
Date:   Tue, 18 Jan 2022 17:05:54 +0100
Message-Id: <20220118160450.554692446@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160450.062004175@linuxfoundation.org>
References: <20220118160450.062004175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 28187dc8ebd938d574edfc6d9e0f9c51c21ff3f4 upstream.

LLD does not yet support any big endian architectures. Make this config
non-selectable when using LLD until LLD is fixed.

Link: https://github.com/ClangBuiltLinux/linux/issues/965

Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -743,6 +743,7 @@ config SWP_EMULATE
 config CPU_BIG_ENDIAN
 	bool "Build big-endian kernel"
 	depends on ARCH_SUPPORTS_BIG_ENDIAN
+	depends on !LD_IS_LLD
 	help
 	  Say Y if you plan on running a kernel in big-endian mode.
 	  Note that your board must be properly built and your board


