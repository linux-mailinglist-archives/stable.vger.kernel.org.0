Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5492F177B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731507AbhAKOGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:06:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbhAKNDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:03:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2233722AAD;
        Mon, 11 Jan 2021 13:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370171;
        bh=EiqiSi/7X41k0XusjMohbecQeF/YDvZoNeJhw/wmuCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVCZA7u0peDfj3iWY3oLCbGGXZo7nZq84Kxll/Biixg1O0HOcwQ3XibWckJOBsjpD
         jYtmLxOK+n6k0SlxTJ/LT8BV29fyMNgwbkfwtLaBpn2CVdPZxtXC8YBExuUNrdyd0q
         fac63AoDWF0H+ylYT8GWUMdu2h0uywRsSRhtR9qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.9 01/45] kbuild: dont hardcode depmod path
Date:   Mon, 11 Jan 2021 14:00:39 +0100
Message-Id: <20210111130033.744578084@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

commit 436e980e2ed526832de822cbf13c317a458b78e1 upstream.

depmod is not guaranteed to be in /sbin, just let make look for
it in the path like all the other invoked programs

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -349,7 +349,7 @@ OBJDUMP		= $(CROSS_COMPILE)objdump
 AWK		= awk
 GENKSYMS	= scripts/genksyms/genksyms
 INSTALLKERNEL  := installkernel
-DEPMOD		= /sbin/depmod
+DEPMOD		= depmod
 PERL		= perl
 PYTHON		= python
 CHECK		= sparse


