Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1098140BF7
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 15:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbgAQOCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 09:02:44 -0500
Received: from fd.dlink.ru ([178.170.168.18]:55826 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728827AbgAQOCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 09:02:44 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 259651B21620; Fri, 17 Jan 2020 17:02:41 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 259651B21620
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579269761; bh=RWpyTHO35BgSnhvs+GSML3xeEVwMA5+QgcfBuIpPLY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Hbi9ym73ySbjio5cek87d9eFuAF4V6LTzMhwBvkFZ/pMUALtSDnXoNhw97ULo4nXa
         KE30Ypnr0+zTaG4rPtzk5eU8jgupV6fmzG8RAuIzPk9TABZMoaeDKnvXMQUDLFRzcq
         fAVmrgdWahyB1vCS3ea8IeITiYSGu0HvRSFAhq7Y=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 5712B1B2054E;
        Fri, 17 Jan 2020 17:02:31 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 5712B1B2054E
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 695FD1B2173A;
        Fri, 17 Jan 2020 17:02:30 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Fri, 17 Jan 2020 17:02:30 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Paul Burton <paulburton@kernel.org>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>,
        Alexander Lobakin <alobakin@dlink.ru>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH mips-fixes 2/3] MIPS: boot: fix typo in 'vmlinux.lzma.its' target
Date:   Fri, 17 Jan 2020 17:02:08 +0300
Message-Id: <20200117140209.17672-3-alobakin@dlink.ru>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200117140209.17672-1-alobakin@dlink.ru>
References: <20200117140209.17672-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 92b34a976348 ("MIPS: boot: add missing targets for vmlinux.*.its")
fixed constant rebuild of *.its files on every make invokation, but due
to typo ("lzmo") it made no sense for vmlinux.lzma.its.

Fixes: 92b34a976348 ("MIPS: boot: add missing targets for vmlinux.*.its")
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
---
 arch/mips/boot/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/boot/Makefile b/arch/mips/boot/Makefile
index 528bd73d530a..4ed45ade32a1 100644
--- a/arch/mips/boot/Makefile
+++ b/arch/mips/boot/Makefile
@@ -123,7 +123,7 @@ $(obj)/vmlinux.its.S: $(addprefix $(srctree)/arch/mips/$(PLATFORM)/,$(ITS_INPUTS
 targets += vmlinux.its
 targets += vmlinux.gz.its
 targets += vmlinux.bz2.its
-targets += vmlinux.lzmo.its
+targets += vmlinux.lzma.its
 targets += vmlinux.lzo.its
 
 quiet_cmd_cpp_its_S = ITS     $@
-- 
2.25.0

