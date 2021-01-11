Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D422F12BC
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbhAKNAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:00:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbhAKNAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:00:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEDE12225E;
        Mon, 11 Jan 2021 12:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610369999;
        bh=EiqiSi/7X41k0XusjMohbecQeF/YDvZoNeJhw/wmuCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ibkVVDs8vYSoS2n781HtTf9W2IdKcFCUS7FBglO4s3s9egZMtA+r0C85R3vp5RPEy
         ZoncILyi+uFR8HbZcddUh2AsszIJ5wDBgyw1uVq7XO3PIpBhlwU9/KavgF8Ri/6ViF
         tAbOIjDDPB02J/HFS3YhKKOptJr8lRciLZS2PIcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.4 01/38] kbuild: dont hardcode depmod path
Date:   Mon, 11 Jan 2021 14:00:33 +0100
Message-Id: <20210111130032.546513287@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130032.469630231@linuxfoundation.org>
References: <20210111130032.469630231@linuxfoundation.org>
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


