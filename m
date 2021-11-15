Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B93451016
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242608AbhKOSld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:41:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242583AbhKOSit (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:38:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F4143632E7;
        Mon, 15 Nov 2021 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999426;
        bh=1+oPHhv9ooizTkRRpdlMowCw+diLf8tTRIiP9pcc6aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNvEk/Ii/JOJRc/IGv+Z2conXhaJylczx0RWHC6fVyl2r7+n5owS9+6O8PfjHWe9t
         kfOhguZ4Lf8NsGnpQjGvMbw6+NfxBcPg8YFT8uEqfh7BT0/9kZVDPz+TUIyhA6DpmW
         NA4MXBzAmyMCqyS2ALfw0KOU4QztK2BjEE6vTc1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yaara Baruch <yaara.baruch@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 293/849] iwlwifi: change all JnP to NO-160 configuration
Date:   Mon, 15 Nov 2021 17:56:16 +0100
Message-Id: <20211115165430.178084082@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yaara Baruch <yaara.baruch@intel.com>

[ Upstream commit 70382b0897eeecfcd35ba5f6161dbceeb556ea1e ]

JnP should not have the 160 MHz.

Signed-off-by: Yaara Baruch <yaara.baruch@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20211016114029.ee163f4a7513.I7f87bd969a0b038c7f3a1a962d9695ffd18c5da1@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index be3ad42813532..1ffd7685deefa 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -931,9 +931,9 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_NO_CDB,
 		      iwl_qu_b0_hr1_b0, iwl_ax101_name),
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_QU, SILICON_C_STEP,
+		      IWL_CFG_MAC_TYPE_QU, SILICON_B_STEP,
 		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY,
-		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_NO_CDB,
+		      IWL_CFG_NO_160, IWL_CFG_ANY, IWL_CFG_NO_CDB,
 		      iwl_qu_b0_hr_b0, iwl_ax203_name),
 
 	/* Qu C step */
@@ -945,7 +945,7 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
 		      IWL_CFG_MAC_TYPE_QU, SILICON_C_STEP,
 		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY,
-		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_NO_CDB,
+		      IWL_CFG_NO_160, IWL_CFG_ANY, IWL_CFG_NO_CDB,
 		      iwl_qu_c0_hr_b0, iwl_ax203_name),
 
 	/* QuZ */
-- 
2.33.0



