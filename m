Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832E335B895
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbhDLCXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236623AbhDLCXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C4826120D;
        Mon, 12 Apr 2021 02:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194209;
        bh=HDjx4KxAiBYeniGXSThyF+IkcqMb8jw3bdTh819I/tg=;
        h=From:To:Cc:Subject:Date:From;
        b=CvdRCNQ7j7SjbRfL7SGadl78Iz61diUo0kpWdU2vI838qAfFNHOGO02Q5/jFHJG9F
         kAWr+Im8q2LSJOm2Jb0Of/7XgowtJkbO0sPQfxROysIQ/ck+dPAhTO0oPRmoPVa3Ff
         mtvqS/RBEsNv3bpZ5OTv9xh/xty8nyfYEeQ36KCsVWaTX6ve1fz9tMXVkBNsC4jau9
         K0wfsedQ1GP/DYNeemQAzd4+poPxI/A3vEJHib+NAO/YQ66q+TOJ9dA7x1sgh1i3NA
         GsCn4OVZWUpTE+j1cdPu4gg7WP1NUvItxIBFbxVspdea+kgnGuo64xdiFdGYx8u118
         N2oH3ExBeAQvg==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, mateusz.palczewski@intel.com
Cc:     Dawid Lukwinski <dawid.lukwinski@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: FAILED: Patch "i40e: Added Asym_Pause to supported link modes" failed to apply to 4.14-stable tree
Date:   Sun, 11 Apr 2021 22:23:27 -0400
Message-Id: <20210412022327.284462-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 90449e98c265296329446c7abcd2aae3b20c0bc9 Mon Sep 17 00:00:00 2001
From: Mateusz Palczewski <mateusz.palczewski@intel.com>
Date: Mon, 4 Jan 2021 15:00:02 +0000
Subject: [PATCH] i40e: Added Asym_Pause to supported link modes

Add Asym_Pause to supported link modes (it is supported by HW).
Lack of Asym_Pause in supported modes can cause several problems,
i.e. it won't be possible to turn the autonegotiation on
with asymmetric pause settings (i.e. Tx on, Rx off).

Fixes: 4e91bcd5d47a ("i40e: Finish implementation of ethtool get settings")
Signed-off-by: Dawid Lukwinski <dawid.lukwinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index c70dec65a572..2c637a5678b3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1101,6 +1101,7 @@ static int i40e_get_link_ksettings(struct net_device *netdev,
 
 	/* Set flow control settings */
 	ethtool_link_ksettings_add_link_mode(ks, supported, Pause);
+	ethtool_link_ksettings_add_link_mode(ks, supported, Asym_Pause);
 
 	switch (hw->fc.requested_mode) {
 	case I40E_FC_FULL:
-- 
2.30.2




