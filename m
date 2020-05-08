Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECC31CB01C
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgEHNXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbgEHMhr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD0B9207DD;
        Fri,  8 May 2020 12:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941467;
        bh=bxj8mKoo5XMAehimjbYu3A/YMqmLED2vL3bovyybDMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTNc5Y/AlC9VyVyn2ivaAcs1ryWirSKJBe6PARU50nA0MVoEixTM3/9cJYH1uKnV9
         tK0tSnBu92c9B1um4ZefwkQMYbieS2I87qVULJ/1JKfLZT9UJYXq02s+g4FIMIyHkE
         vKZE6Qe/oVCZ3iXsDc3IfLlhNptrdJHjlSWVTa3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 4.4 043/312] ARM: dts: kirkwood: add kirkwood-ds112.dtb to Makefile
Date:   Fri,  8 May 2020 14:30:34 +0200
Message-Id: <20200508123127.585764495@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

commit fc5c796e12511a7c027b5a4438719dde2f796208 upstream.

Commit 2d0a7addbd10 ("ARM: Kirkwood: Add support for many Synology
NAS devices") created the new file kirkwood-ds112.dts but did not
add it to the Makefile.

Fixes: 2d0a7addbd10 ("ARM: Kirkwood: Add support for many Synology NAS devices")
Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -166,6 +166,7 @@ dtb-$(CONFIG_MACH_KIRKWOOD) += \
 	kirkwood-ds109.dtb \
 	kirkwood-ds110jv10.dtb \
 	kirkwood-ds111.dtb \
+	kirkwood-ds112.dtb \
 	kirkwood-ds209.dtb \
 	kirkwood-ds210.dtb \
 	kirkwood-ds212.dtb \


