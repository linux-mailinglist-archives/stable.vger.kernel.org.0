Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1451881F4
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgCQK5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgCQK5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:57:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFB7520738;
        Tue, 17 Mar 2020 10:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442653;
        bh=wDd3r7LxR7N9t+4wfc5nCP7or8WBo0XPakCwLcF0A5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFOShmN6VAw60OsICExML8vqJCix6EGjmTJshwiQFrkAn0ab06VZ85qgcK73Uqwwc
         Aqj53vTUpKe/iHDFLpeq/w8l3zdBcq7DAWV3iWkuomTPF7yzOS6z4246qqfqlbR8gH
         Fv8YEkWG7C0vzAtmpDxb+BRe7ywMm5dwkn7l76+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 29/89] macsec: add missing attribute validation for port
Date:   Tue, 17 Mar 2020 11:54:38 +0100
Message-Id: <20200317103303.232045378@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 31d9a1c524964bac77b7f9d0a1ac140dc6b57461 ]

Add missing attribute validation for IFLA_MACSEC_PORT
to the netlink policy.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2995,6 +2995,7 @@ static const struct device_type macsec_t
 
 static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_SCI] = { .type = NLA_U64 },
+	[IFLA_MACSEC_PORT] = { .type = NLA_U16 },
 	[IFLA_MACSEC_ICV_LEN] = { .type = NLA_U8 },
 	[IFLA_MACSEC_CIPHER_SUITE] = { .type = NLA_U64 },
 	[IFLA_MACSEC_WINDOW] = { .type = NLA_U32 },


