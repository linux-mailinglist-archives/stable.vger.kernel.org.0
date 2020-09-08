Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61819261CF3
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731818AbgIHT27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731048AbgIHQAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:00:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CFF6246F0;
        Tue,  8 Sep 2020 15:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579626;
        bh=8NdyMr0qdCkBqkHhbsdLzyk7q5G2WaeawI26KLzIdkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huTy24YQU8zcGoPGUQoPScqVn8Op+wxuPAAXxrrrOMdq8I7m+aGqRopuaj5za5GRr
         2PP023RefNpy24tKPLzo8NYTG4V4EhAxCwTfLoPc5X9NsoBfSOuMv0KfM+f6b0AWxc
         4Uo8QxipIVer/m447LdgLr2SsiQLpu4muxrqOQoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.8 156/186] s390: fix GENERIC_LOCKBREAK dependency typo in Kconfig
Date:   Tue,  8 Sep 2020 17:24:58 +0200
Message-Id: <20200908152249.222776843@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

commit 114b9df419bf5db097b322ebb03fcf2f502f9380 upstream.

Commit fa686453053b ("sched/rt, s390: Use CONFIG_PREEMPTION")
changed a bunch of uses of CONFIG_PREEMPT to _PREEMPTION.
Except in the Kconfig it used two T's. That's the only place
in the system where that spelling exists, so let's fix that.

Fixes: fa686453053b ("sched/rt, s390: Use CONFIG_PREEMPTION")
Cc: <stable@vger.kernel.org> # 5.6
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -30,7 +30,7 @@ config GENERIC_BUG_RELATIVE_POINTERS
 	def_bool y
 
 config GENERIC_LOCKBREAK
-	def_bool y if PREEMPTTION
+	def_bool y if PREEMPTION
 
 config PGSTE
 	def_bool y if KVM


