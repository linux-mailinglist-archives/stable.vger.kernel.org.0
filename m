Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF4E3A032F
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235989AbhFHTNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:13:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236613AbhFHTLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:11:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A02B761949;
        Tue,  8 Jun 2021 18:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178152;
        bh=I3s/PZzHm2c8bRnjRR6mNjB/fa8D0WA/MpcjFZ/dgc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vL1PZAUZ6g3iDcqO/+082sPDKdNBd2cDP3Xcg72U4ILjYQ3Vf+E6YKfv8cANB7Nyj
         uMzOl2k8t2qDv3dJgTDOT6v2bIYziHE12OBven5zj+yzlvrpPtUeInKZt/K7ZDuyre
         o71e59saoPjnidzJLmDLvQw2zl9sm48N2s1J8A1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Salvaterra <rsalvaterra@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 097/161] wireguard: selftests: remove old conntrack kconfig value
Date:   Tue,  8 Jun 2021 20:27:07 +0200
Message-Id: <20210608175948.739553465@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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


