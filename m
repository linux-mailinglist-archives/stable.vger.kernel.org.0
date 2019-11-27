Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E772210BD13
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbfK0VBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:01:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731657AbfK0VBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:01:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60D9C2158A;
        Wed, 27 Nov 2019 21:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888463;
        bh=4z89RHmeFDHuAuKOgDLQ9eeVOAGtPmlhUw8to3NyyBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnV2uMIetOZVXRFS2pCG4Xw2OLVHJS4VjZqmuN7y3kO0Isb96BijJCWylrZM9tocL
         CMnlbYjVkJnucUVd6IXpwslzXzj+CmXizvXIj1UaAE4RpzfCCH3rzuodNfS7KZiwak
         ALSBJ0FCvhaM8j21CjZdVFdkfNt8L/6ei0KSyaNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/306] SUNRPC: Fix a compile warning for cmpxchg64()
Date:   Wed, 27 Nov 2019 21:29:11 +0100
Message-Id: <20191127203122.260968052@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e732f4485a150492b286f3efc06f9b34dd6b9995 ]

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_seal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/auth_gss/gss_krb5_seal.c b/net/sunrpc/auth_gss/gss_krb5_seal.c
index eaad9bc7a0bdc..e1f0571843c8c 100644
--- a/net/sunrpc/auth_gss/gss_krb5_seal.c
+++ b/net/sunrpc/auth_gss/gss_krb5_seal.c
@@ -63,6 +63,7 @@
 #include <linux/sunrpc/gss_krb5.h>
 #include <linux/random.h>
 #include <linux/crypto.h>
+#include <linux/atomic.h>
 
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 # define RPCDBG_FACILITY        RPCDBG_AUTH
-- 
2.20.1



