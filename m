Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21E611AF27
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbfLKPL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:11:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730931AbfLKPL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C01E72465E;
        Wed, 11 Dec 2019 15:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077087;
        bh=7UVAZ7gxEN90st/uMx5OYFi4SnNcFg3kdCwkpBG6f+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BS23WU+G5fUWsTz7Ky15VPsm9g9kOXOmiRYXOw794EYbZyLsTafzld5gUNa7ilJpY
         3u09u3TVMO0aHwBvs3bB1/yiQP1XtogANKAX3qdm1LXbKtBQ1JnjmVu/egw/5t6hXI
         eIjGvCRtudG1Lo5ltmCg7NNLRhjPSjEtRdLTZLS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Tuowen Zhao <ztuowen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.3 004/105] sparc64: implement ioremap_uc
Date:   Wed, 11 Dec 2019 16:04:53 +0100
Message-Id: <20191211150222.473096155@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuowen Zhao <ztuowen@gmail.com>

commit 38e45d81d14e5f78cd67922596b1c37b4c22ec74 upstream.

On sparc64, the whole physical IO address space is accessible using
physically addressed loads and stores. *_uc does nothing like the
others.

Cc: <stable@vger.kernel.org> # v4.19+
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Tuowen Zhao <ztuowen@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sparc/include/asm/io_64.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -407,6 +407,7 @@ static inline void __iomem *ioremap(unsi
 }
 
 #define ioremap_nocache(X,Y)		ioremap((X),(Y))
+#define ioremap_uc(X,Y)			ioremap((X),(Y))
 #define ioremap_wc(X,Y)			ioremap((X),(Y))
 #define ioremap_wt(X,Y)			ioremap((X),(Y))
 


