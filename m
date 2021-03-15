Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737B233B5A1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhCONyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231449AbhCONya (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7246E64EE3;
        Mon, 15 Mar 2021 13:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816466;
        bh=KA5lgiQDxsghnz5TVajIikeYslzRNzr57tlHqw7sVAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8g/LjJ8ZoGlbFmfD3lL7FkD/KWahRFdPZGHKl2Po+ruXknDLHaSXtXEMM/ldI54R
         tX/DCxr5Kb1a27JKuuzcNEVmW8gkK3J+raYhh3+xBL1U9GbA2M3JmJmfM0O5b3Ht5l
         04afIHG5C2ihPLLeyAVV2nvzbPffA5ft6TMkwd5I=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 61/75] alpha: add $(src)/ rather than $(obj)/ to make source file path
Date:   Mon, 15 Mar 2021 14:52:15 +0100
Message-Id: <20210315135210.252431959@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 5ed78e5523fd9ba77b8444d380d54da1f88c53fc upstream.

$(ev6-y)divide.S is a source file, not a build-time generated file.
So, it should be prefixed with $(src)/ rather than $(obj)/.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/lib/Makefile |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/alpha/lib/Makefile
+++ b/arch/alpha/lib/Makefile
@@ -46,11 +46,11 @@ AFLAGS___remqu.o =       -DREM
 AFLAGS___divlu.o = -DDIV       -DINTSIZE
 AFLAGS___remlu.o =       -DREM -DINTSIZE
 
-$(obj)/__divqu.o: $(obj)/$(ev6-y)divide.S
+$(obj)/__divqu.o: $(src)/$(ev6-y)divide.S
 	$(cmd_as_o_S)
-$(obj)/__remqu.o: $(obj)/$(ev6-y)divide.S
+$(obj)/__remqu.o: $(src)/$(ev6-y)divide.S
 	$(cmd_as_o_S)
-$(obj)/__divlu.o: $(obj)/$(ev6-y)divide.S
+$(obj)/__divlu.o: $(src)/$(ev6-y)divide.S
 	$(cmd_as_o_S)
-$(obj)/__remlu.o: $(obj)/$(ev6-y)divide.S
+$(obj)/__remlu.o: $(src)/$(ev6-y)divide.S
 	$(cmd_as_o_S)


