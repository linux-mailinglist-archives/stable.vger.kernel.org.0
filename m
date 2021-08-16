Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991C03ED550
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238898AbhHPNKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237145AbhHPNJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB32F6112D;
        Mon, 16 Aug 2021 13:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119279;
        bh=hwVmEFbbT420DKstMQ3U4HIUxIuft8eStwsMc0Cor94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCy2te1e+GTRm2dEQ0err24gZbgixOT51PKJKQSlVavWnOdba97d9PmBd3cC1eVBS
         nEW+86gzGRO19fQnGaMUm0Y0OMKs1ThVnmb+eiAD4n/ioUnUUkgcJoZH4zNOWSXSuX
         I2Pu9BVwQRuacZF/eKyTYNxqUmteaMWeiCnsF0gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/96] net: dsa: mt7530: add the missing RxUnicast MIB counter
Date:   Mon, 16 Aug 2021 15:01:44 +0200
Message-Id: <20210816125436.086477472@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>

[ Upstream commit aff51c5da3208bd164381e1488998667269c6cf4 ]

Add the missing RxUnicast counter.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 190025a0a98e..3fa2f81c8b47 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -45,6 +45,7 @@ static const struct mt7530_mib_desc mt7530_mib[] = {
 	MIB_DESC(2, 0x48, "TxBytes"),
 	MIB_DESC(1, 0x60, "RxDrop"),
 	MIB_DESC(1, 0x64, "RxFiltering"),
+	MIB_DESC(1, 0x68, "RxUnicast"),
 	MIB_DESC(1, 0x6c, "RxMulticast"),
 	MIB_DESC(1, 0x70, "RxBroadcast"),
 	MIB_DESC(1, 0x74, "RxAlignErr"),
-- 
2.30.2



