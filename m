Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E301E1014
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 16:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390794AbgEYOF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 10:05:57 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:39389 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388862AbgEYOF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 10:05:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C6D361940C73;
        Mon, 25 May 2020 10:05:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 25 May 2020 10:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uOAHtq
        9psUVyfIx2OW6dQ60pzBXje+GmWlUWME5LPwk=; b=Jae9Kbr2jYrZ0ynkeKy8fB
        BvmSuYb/F4OUGmBXYurrblr1zFwHYdNP369Knjk69oJ7FVjeDHsjM4MaFxsEPBmX
        V4lwSgtvC6j+VumwElxnYTmgTyhLU7/TnBTa5Cb2/oFxz3OB62V94R8HmfMAmNc4
        ouPRyzwW3MQzBfJJUih12CH2lU46QiwFYJxQTBsctRGOlo93WtSs2MnNxjLanN2o
        AI4pam1NN2j9Mk05pY/DaimPD2Xo325CadJxaPAS0ZcgChxeGBjEhebfjl2BT35T
        3Laj/UjRxNYk2o61k3kz3qkEKvys5k3yLscwlkZ0BbzDHmZrC8tBcUG0l1LN4mnQ
        ==
X-ME-Sender: <xms:w9DLXuEnBYwiovfF_vzqAyMj0ahBHWlUdd4kPSKfVvahaWPiNoXAlQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:w9DLXvU8aGns81zKfkDxVWmaC7im9cQ5cD_3KRefzVfhKMdq6QhFxQ>
    <xmx:w9DLXoJqYiccyMKiZzfk3RetSwod6eq_UPUYAxPMOhvXyurmJrwsgg>
    <xmx:w9DLXoGRU2EjXj9y1tobdxD1G2jXkiZzwMwWlXKouQPji_EiRVC-cw>
    <xmx:w9DLXteV7X6qBX9dUKxtcFaZB8RERyHjwc032B7gQPVNj6UhSyLSQQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 659E9328005D;
        Mon, 25 May 2020 10:05:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iwlwifi: pcie: handle QuZ configs with killer NICs as well" failed to apply to 5.6-stable tree
To:     luciano.coelho@intel.com, kvalo@codeaurora.org, vicamo@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 May 2020 16:05:45 +0200
Message-ID: <15904155453239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f92f26f2ed2c9f92c9270c705bca96310c3cdf5a Mon Sep 17 00:00:00 2001
From: Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Apr 2020 12:20:08 +0300
Subject: [PATCH] iwlwifi: pcie: handle QuZ configs with killer NICs as well

The killer devices were left out of the checks that convert Qu-B0 to
QuZ configurations.  Add them.

Cc: stable@vger.kernel.org # v5.3+
Fixes: 5a8c31aa6357 ("iwlwifi: pcie: fix recognition of QuZ devices")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Tested-by: You-Sheng Yang <vicamo@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20200424121518.b715acfbe211.I273a098064a22577e4fca767910fd9cf0013f5cb@changeid

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 6744c0281ffb..29971c25dba4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1092,6 +1092,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			iwl_trans->cfg = &iwl_ax101_cfg_quz_hr;
 		else if (iwl_trans->cfg == &iwl_ax201_cfg_qu_hr)
 			iwl_trans->cfg = &iwl_ax201_cfg_quz_hr;
+		else if (iwl_trans->cfg == &killer1650s_2ax_cfg_qu_b0_hr_b0)
+			iwl_trans->cfg = &iwl_ax1650s_cfg_quz_hr;
+		else if (iwl_trans->cfg == &killer1650i_2ax_cfg_qu_b0_hr_b0)
+			iwl_trans->cfg = &iwl_ax1650i_cfg_quz_hr;
 	}
 
 #endif

