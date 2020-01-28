Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C74B814B652
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgA1OEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:04:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:51154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728022AbgA1OEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:04:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D4162468D;
        Tue, 28 Jan 2020 14:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220249;
        bh=g2WSDlxo5RxUpQduXthRTFs/RfeO7stCcwZaTrhhb88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bfz31AWMwZsGPIOVn+5y5afTeM6p84dfXom1AJupRVxPJcrZk2w09tNurAZbKOdTy
         kqV0V2Y9eoWimIQNceHHD+WWTazyp5/kY8F7SHfJerbxSEF2L6hHHac6tBzjFpUHhj
         KnqNazPvcByF+kAPtE7iyhwWYBzFtuh0FXEDe/gM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "xiaofeng.yan" <yanxiaofeng7@jd.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 075/104] hsr: Fix a compilation error
Date:   Tue, 28 Jan 2020 15:00:36 +0100
Message-Id: <20200128135827.633270674@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xiaofeng.yan <yanxiaofeng7@jd.com>

commit 80892772c4edac88c538165d26a0105f19b61c1c upstream.

A compliation error happen when building branch 5.5-rc7

In file included from net/hsr/hsr_main.c:12:0:
net/hsr/hsr_main.h:194:20: error: two or more data types in declaration specifiers
 static inline void void hsr_debugfs_rename(struct net_device *dev)

So Removed one void.

Fixes: 4c2d5e33dcd3 ("hsr: rename debugfs file when interface name is changed")
Signed-off-by: xiaofeng.yan <yanxiaofeng7@jd.com>
Acked-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/hsr/hsr_main.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -191,7 +191,7 @@ void hsr_debugfs_term(struct hsr_priv *p
 void hsr_debugfs_create_root(void);
 void hsr_debugfs_remove_root(void);
 #else
-static inline void void hsr_debugfs_rename(struct net_device *dev)
+static inline void hsr_debugfs_rename(struct net_device *dev)
 {
 }
 static inline void hsr_debugfs_init(struct hsr_priv *priv,


