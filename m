Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14ACF2A524A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbgKCUsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:48:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729807AbgKCUsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41DA922409;
        Tue,  3 Nov 2020 20:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436516;
        bh=wRtCQnQdPDX6MWfLmB+AFzKXzPe8RgptgwFvsk/8nyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cPeouamohGBKw6ttYbaXzRFtA+BmR1LhGzMBOy2dKBPoune7eoNPx9ljl75liOXz6
         KQigcrkvy7kwa6ghwb4dA1+wzQSbMfk7/XCZHz5bL4NLGxaPww4jv8w3syaNrhCA6d
         7vZgIxrH3/58Hnliwgqh2q1dDfiLThb62G3J7pCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.9 284/391] MIPS: configs: lb60: Fix defconfig not selecting correct board
Date:   Tue,  3 Nov 2020 21:35:35 +0100
Message-Id: <20201103203406.206242761@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 7487abbe85afd02c35c283315cefc5e19c28d40f upstream.

Since INGENIC_GENERIC_BOARD was introduced, the JZ4740_QI_LB60 option
is no longer the default, so the symbol has to be selected by the
defconfig, otherwise the kernel built will be for a generic Ingenic
board and won't have the Device Tree blob built-in.

Cc: stable@vger.kernel.org # v5.7
Fixes: 62249209a772 ("MIPS: ingenic: Default to a generic board")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/configs/qi_lb60_defconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/configs/qi_lb60_defconfig
+++ b/arch/mips/configs/qi_lb60_defconfig
@@ -8,6 +8,7 @@ CONFIG_EMBEDDED=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MACH_INGENIC=y
+CONFIG_JZ4740_QI_LB60=y
 CONFIG_HZ_100=y
 # CONFIG_SECCOMP is not set
 CONFIG_MODULES=y


