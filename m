Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B125B469EA8
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385862AbhLFPn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388140AbhLFPcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:32:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EDDC08E84F;
        Mon,  6 Dec 2021 07:19:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB9C26132E;
        Mon,  6 Dec 2021 15:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5D4C341C1;
        Mon,  6 Dec 2021 15:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803959;
        bh=w3szSjw2J7ql5NwA+A7W4Kel3hZgWbWjD6AHnWZ+Ez4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ld+bstHlTO/B//BT+/N5+4HFhEqAFI9X9WERzVLzSuckUQD7M+TXEHfCRpReLhJUD
         3UHUsN6cNXuJM0onPo0+nSepL/P8sXIHLEEroB0YvyUAQIizv9tRVCQXn5tjy2g+ZZ
         Rof5B1F52vSjwy8Iap2HmTlYR/5aw82Ida5Y7hh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameer Saurabh <ssaurabh@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 100/130] Remove Half duplex mode speed capabilities.
Date:   Mon,  6 Dec 2021 15:56:57 +0100
Message-Id: <20211206145603.102999013@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Saurabh <ssaurabh@marvell.com>

commit 03fa512189eb9b55ded5f3e81ad638315555b340 upstream.

Since Half Duplex mode has been deprecated by the firmware, driver should
not advertise Half Duplex speed in ethtool support link speed values.

Fixes: 071a02046c262 ("net: atlantic: A2: half duplex support")
Signed-off-by: Sameer Saurabh <ssaurabh@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -65,11 +65,8 @@ const struct aq_hw_caps_s hw_atl2_caps_a
 			  AQ_NIC_RATE_5G  |
 			  AQ_NIC_RATE_2G5 |
 			  AQ_NIC_RATE_1G  |
-			  AQ_NIC_RATE_1G_HALF   |
 			  AQ_NIC_RATE_100M      |
-			  AQ_NIC_RATE_100M_HALF |
-			  AQ_NIC_RATE_10M       |
-			  AQ_NIC_RATE_10M_HALF,
+			  AQ_NIC_RATE_10M,
 };
 
 const struct aq_hw_caps_s hw_atl2_caps_aqc115c = {


