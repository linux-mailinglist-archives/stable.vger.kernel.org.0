Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9229E411A25
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243170AbhITQra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240024AbhITQrV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:47:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0093460F38;
        Mon, 20 Sep 2021 16:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156354;
        bh=WVdzr/fvn3Ok1gVQMMWVCaCXO0ernf2/um3q3qc3oVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3hPkQR5Z31mVdRB3qTkgHn8a0722qjRrhcUeak72oi3FG2U1GCJ1bnaDXhV6NKuW
         3jOQL2ZlmqwRcB7tFH0qagOtLWzum2BeJWIgt/5GuZU4Kol6DX98CK2DfJQ5GVG5d7
         2Xpdo7KZOVgMNMYi5t14mjlZvdj3CV1kNuGn5+SQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitrii Kolesnichenko <dmitrii@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 4.4 003/133] ARC: fix allnoconfig build warning
Date:   Mon, 20 Sep 2021 18:41:21 +0200
Message-Id: <20210920163912.718308913@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

commit 5464d03d92601ac2977ef605b0cbb33276567daf upstream.

Reported-by: Dmitrii Kolesnichenko <dmitrii@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -23,7 +23,7 @@ config ARC
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
-	select HAVE_FUTEX_CMPXCHG
+	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES


