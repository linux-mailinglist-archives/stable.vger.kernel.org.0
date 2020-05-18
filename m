Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8E61D86E8
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgERRke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728456AbgERRkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:40:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93CF2207C4;
        Mon, 18 May 2020 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823633;
        bh=hvR9PGMW0+0i+AIKy5t6gOSeg6h2dDfOUwDLAe8jPwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGI1tppAZd2xFXVw7junM8PrjDY9KCrbLSEPFMR5NVnCllXAzRkOcqOa1bdribgZ6
         et2WHEi2Pu1POCLlvFt6pLIJIkuAGBPyE57KV7d1muJyt6lHR3qd3H68PsQoaCOhqM
         T8jMyN2+gD/a7wrcJoIUf7HaUbaxu4Pkc7FS/rd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 61/86] gcc-10: disable stringop-overflow warning for now
Date:   Mon, 18 May 2020 19:36:32 +0200
Message-Id: <20200518173502.783417822@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 5a76021c2eff7fcf2f0918a08fd8a37ce7922921 upstream.

This is the final array bounds warning removal for gcc-10 for now.

Again, the warning is good, and we should re-enable all these warnings
when we have converted all the legacy array declaration cases to
flexible arrays. But in the meantime, it's just noise.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/Makefile
+++ b/Makefile
@@ -798,6 +798,7 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 # We'll want to enable this eventually, but it's not going away for 5.7 at least
 KBUILD_CFLAGS += $(call cc-disable-warning, zero-length-bounds)
 KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
+KBUILD_CFLAGS += $(call cc-disable-warning, stringop-overflow)
 
 # Enabled with W=2, disabled by default as noisy
 KBUILD_CFLAGS += $(call cc-disable-warning, maybe-uninitialized)


