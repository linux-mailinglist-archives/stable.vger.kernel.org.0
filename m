Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250EB2F15BC
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731758AbhAKNo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:44:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730728AbhAKNLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:11:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C14D22ADF;
        Mon, 11 Jan 2021 13:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370669;
        bh=ET2wxzi5UgiaIU6JDQJsTia5Pr4gbBgi/Vb0hAAtxpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQ9DSxLL2L7w8ZBiyyGC3llQtnofuGZ03oLc1IIDlB9vjWtWAnNM+76QmXiVoqEVQ
         dQGhCP20s5KtKgaFIUXrxs/+5+M5ksG3OIsEwjZMLPnmCqQade1EI0yaY9Mcj/keaW
         RGFW3neEG4mlLLQiwG87SEGrqoosPczFgJBVVua8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 46/92] kbuild: dont hardcode depmod path
Date:   Mon, 11 Jan 2021 14:01:50 +0100
Message-Id: <20210111130041.362751481@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -436,7 +436,7 @@ LEX		= flex
 YACC		= bison
 AWK		= awk
 INSTALLKERNEL  := installkernel
-DEPMOD		= /sbin/depmod
+DEPMOD		= depmod
 PERL		= perl
 PYTHON		= python
 PYTHON3		= python3


