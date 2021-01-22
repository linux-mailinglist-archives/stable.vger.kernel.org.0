Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CDF300654
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbhAVO5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:57:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728594AbhAVOXV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA77023B7D;
        Fri, 22 Jan 2021 14:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325065;
        bh=8yte+74tAdLf+T6sJiZH32aVHILKOE4mwLsC4+Db5Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMhCTREjAd4kHWoMdETSAgkDP1PXRw/WLV++T5Yq+IMnd6Ush7OpfnCoJ+rU4ybzG
         4zl9C/UhfQzwcDSfLkDURPi5z09M7gLOaw3lYul4tKn3gYETdfGb0NDoM8HJuqVT14
         rgrz/dJGzZhBVjTCieuboahD0zFWT0ECYmELvcEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 19/33] net: mvpp2: Remove Pause and Asym_Pause support
Date:   Fri, 22 Jan 2021 15:12:35 +0100
Message-Id: <20210122135734.366752292@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
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
@@ -4790,8 +4790,6 @@ static void mvpp2_phylink_validate(struc
 
 	phylink_set(mask, Autoneg);
 	phylink_set_port_modes(mask);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
 
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_10GKR:


