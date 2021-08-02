Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC303DD934
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbhHBN6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235225AbhHBN4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:56:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B22A6112D;
        Mon,  2 Aug 2021 13:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912470;
        bh=mtAyM5L3tHxPRG8Xun/z/inxFpSPyTVOTAv0BBc/6Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ia7rb0DontZwppcbz2NCS/e0H9tY1B7nTsto7AoZqjxzM2xTviDkIe5bq/2K7LSxF
         8owmZdYR3kLXgFsfILxMcWnfOc/pXo3dBodQ1Oia1XqiN4YOVlSS3i2PJekKaDiwVF
         zdMaELiubJxv3oWQqKX6GKFt36bba7XBU9xow2os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lukasz Cieplicki <lukaszx.cieplicki@intel.com>,
        Michal Maloszewski <michal.maloszewski@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 66/67] i40e: Add additional info to PHY type error
Date:   Mon,  2 Aug 2021 15:45:29 +0200
Message-Id: <20210802134341.302667404@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Cieplicki <lukaszx.cieplicki@intel.com>

commit dc614c46178b0b89bde86ac54fc687a28580d2b7 upstream.

In case of PHY type error occurs, the message was too generic.
Add additional info to PHY type error indicating that it can be
wrong cable connected.

Fixes: 124ed15bf126 ("i40e: Add dual speed module support")
Signed-off-by: Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
Signed-off-by: Michal Maloszewski <michal.maloszewski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -980,7 +980,7 @@ static void i40e_get_settings_link_up(st
 	default:
 		/* if we got here and link is up something bad is afoot */
 		netdev_info(netdev,
-			    "WARNING: Link is up but PHY type 0x%x is not recognized.\n",
+			    "WARNING: Link is up but PHY type 0x%x is not recognized, or incorrect cable is in use\n",
 			    hw_link_info->phy_type);
 	}
 


