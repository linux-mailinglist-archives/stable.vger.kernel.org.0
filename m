Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BC73DDA08
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236386AbhHBOGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237018AbhHBOE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2D0D61246;
        Mon,  2 Aug 2021 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912675;
        bh=mtAyM5L3tHxPRG8Xun/z/inxFpSPyTVOTAv0BBc/6Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBWm6vf7CAYOt9PBzs1IuoeJ8hctm40hxsbsPpqmGo5Ck3pldGALgwxkkilkARUpT
         F8D9o/n9/LgfkRPsIaARAFyFWgxQLTbz/9m37alRuwsQYSNKvG9uh4BIctvf94Xf7x
         /HFIAnEwdiYHGBIfU5b8SntHeNIKjHcH5r3jB73s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lukasz Cieplicki <lukaszx.cieplicki@intel.com>,
        Michal Maloszewski <michal.maloszewski@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.13 101/104] i40e: Add additional info to PHY type error
Date:   Mon,  2 Aug 2021 15:45:38 +0200
Message-Id: <20210802134347.326654469@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
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
 


