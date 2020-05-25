Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091381E1012
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 16:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390786AbgEYOFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 10:05:49 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:58939 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388862AbgEYOFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 10:05:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C3C151940ABB;
        Mon, 25 May 2020 10:05:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 25 May 2020 10:05:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nNfp7O
        LNxdK7RH/8y7K1M6v8lQ4VxnUbqzsS/6pDYno=; b=Ub8mjMVHUMFTWPkuRa0a9T
        +J2KeSH8jqFSbpGEy4kJ2s/i2A9hzB6GPamkI/dNghfbHIrF+Dzg/rSH3d3xizM4
        fcdwo5j6Sz46XuGtw5VPZdrS0nz6udHNbMf8aPUchNQletYw/kZeaWEB9D4ENTFh
        sr+C/YaIuHgRJB2YqGEQuKY8dFLlmcKWZbHIA3zFkdnThrkwYFfrxJ2dApzSwhU9
        mjhQTrM4LYSzpxWyLw+/32FU6Aa7GPPfNyrtMECajK6zQq2Hie0o2EpfXoJ1GcRv
        g9LvrcUjknFfoGnot1JGCC16IEKcupbiulKsPH/qAsf7M8HYNWdkurCi60BMQRcQ
        ==
X-ME-Sender: <xms:u9DLXtLORW-8yYtuNCtl1t3WQDvjqKDOl6QZdk5vzcnTyxrPFN7ylg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvtddgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:u9DLXpLXFyaTenuDudW_Aevh7ng9q2r7zhHQfH2wAy87vGpB-o4H6g>
    <xmx:u9DLXltNzPFH-m4T40Yj0io6G9ZUmNhq7VzX0cyVuV5SjTr4OI-L4g>
    <xmx:u9DLXuYdRAArhAHbKHg2dxsoEapsMRDmlv4PyE4O_FWMe8tbHwf0ww>
    <xmx:u9DLXtCa1epgyTX0ydE364F-NfuJ4DtbD7AoKFOybARuY9Q-TpaN8w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 14E573280064;
        Mon, 25 May 2020 10:05:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iwlwifi: pcie: handle QuZ configs with killer NICs as well" failed to apply to 5.4-stable tree
To:     luciano.coelho@intel.com, kvalo@codeaurora.org, vicamo@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 May 2020 16:05:45 +0200
Message-ID: <159041554510231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

