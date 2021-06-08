Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C02C3A024C
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbhFHTCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237508AbhFHTAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:00:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20FD66144F;
        Tue,  8 Jun 2021 18:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177835;
        bh=I3s/PZzHm2c8bRnjRR6mNjB/fa8D0WA/MpcjFZ/dgc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYjgqaLfxwGcYM/oR166uF3coTgvyoY8db/7cF1BrS0PM+PsHGaUv1XC8v/Gg/0yd
         UN7QK/ttAsG8+t1tJmWNhgbB9cILAEgNBLpNUfu7hRHl/V6v4i4eI8JvARoXcBYsjY
         +Q1GxQyJc2K73D05Zxd5ny6LXQeLhiLyupY2wV78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Salvaterra <rsalvaterra@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 083/137] wireguard: selftests: remove old conntrack kconfig value
Date:   Tue,  8 Jun 2021 20:27:03 +0200
Message-Id: <20210608175945.179696014@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit acf2492b51c9a3c4dfb947f4d3477a86d315150f upstream.

On recent kernels, this config symbol is no longer used.

Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/wireguard/qemu/kernel.config |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -19,7 +19,6 @@ CONFIG_NETFILTER_XTABLES=y
 CONFIG_NETFILTER_XT_NAT=y
 CONFIG_NETFILTER_XT_MATCH_LENGTH=y
 CONFIG_NETFILTER_XT_MARK=y
-CONFIG_NF_CONNTRACK_IPV4=y
 CONFIG_NF_NAT_IPV4=y
 CONFIG_IP_NF_IPTABLES=y
 CONFIG_IP_NF_FILTER=y


