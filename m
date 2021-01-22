Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A71300BAF
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbhAVSn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:43:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728538AbhAVOWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:22:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BAA723AF8;
        Fri, 22 Jan 2021 14:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324978;
        bh=QbgaV8qTx959Oh2XOlCMlZHRt+0U8dHoNXiXXyuFuOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/ikN2jCqi9ZYk2hZiVIqY5ptQfN7IPowAu228m6HsduxGllu1ZTVLcqIctZheNYN
         bzFL7iNurkRy1WKtm1OPrLfGrWFw6Iil1CH58eByyE4+ZX97UGGfcGgaPpYy0ZNu9t
         zBqwfY5ZXdUvEjPeu9qucgCwb6Bi1Qxs7eXcnW6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 08/22] net: mvpp2: Remove Pause and Asym_Pause support
Date:   Fri, 22 Jan 2021 15:12:26 +0100
Message-Id: <20210122135732.249256333@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.921636245@linuxfoundation.org>
References: <20210122135731.921636245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

[ Upstream commit 6f83802a1a06e74eafbdbc9b52c05516d3083d02 ]

Packet Processor hardware not connected to MAC flow control unit and
cannot support TX flow control.
This patch disable flow control support.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Acked-by: Marcin Wojtas <mw@semihalf.com>
Link: https://lore.kernel.org/r/1610306582-16641-1-git-send-email-stefanc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4266,8 +4266,6 @@ static void mvpp2_phylink_validate(struc
 
 	phylink_set(mask, Autoneg);
 	phylink_set_port_modes(mask);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
 
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_10GKR:


