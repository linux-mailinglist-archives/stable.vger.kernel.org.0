Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E804118B41B
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgCSNGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgCSNGq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:06:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05B6620740;
        Thu, 19 Mar 2020 13:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623206;
        bh=q390SVG5ckUli8fEFOkZeHkbrMjr8jATJVyyi1c6Buo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4YqPNL7oxnxSoH08tayIRQxbtQs2oOTwBM7wMf8nFbWiKRwHBK55BuZ/OSpGWPDM
         oJ/+kAfu3H0WXVLiaqTbhaWEvvcGKWlPVJvUfD9BobbuX+r8h5KeY274yjpZpe0d5c
         fEiPmeDpBsKy+oS94pePyaJKCYNgAtZr30Bfj40U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 44/93] batman-adv: init neigh node last seen field
Date:   Thu, 19 Mar 2020 13:59:48 +0100
Message-Id: <20200319123938.976226957@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Lindner <mareklindner@neomailbox.ch>

commit e48474ed8a217b7f80f2a42bc05352406a06cb67 upstream.

Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
[sven@narfation.org: fix conflicts with current version]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/originator.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -483,6 +483,7 @@ batadv_neigh_node_new(struct batadv_orig
 	ether_addr_copy(neigh_node->addr, neigh_addr);
 	neigh_node->if_incoming = hard_iface;
 	neigh_node->orig_node = orig_node;
+	neigh_node->last_seen = jiffies;
 
 	/* extra reference for return */
 	atomic_set(&neigh_node->refcount, 2);


