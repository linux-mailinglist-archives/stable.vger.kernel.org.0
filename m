Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D77119597C
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 16:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgC0PDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 11:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727505AbgC0PDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 11:03:43 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 252AF20748;
        Fri, 27 Mar 2020 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585321422;
        bh=uQAoIT8IYZGWS+wOzgrkceyj7G269FzTYD2h/MAKnqU=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=wlaPBjzGo6i8U6hWxrBx6wIHAae/ymc3Br8cAH38VefqRhkhHPsjMRJ2HqDd9kueA
         XJQOw44ShbRzzEoO7/5GEWt/lWLa64aob9DSCA9/OZdNKAx6+YU9+l3L9gtfuLQQQg
         v/7SFax8M8bsqDc1t37S8mcP/EupmWUuyUQBQKL8=
Date:   Fri, 27 Mar 2020 15:03:41 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Luca Coelho <luca@coelho.fi>
To:     Johannes Berg <johannes.berg@intel.com>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 11/12] mac80211: drop data frames without key on encrypted links
In-Reply-To: <iwlwifi.20200326150855.6865c7f28a14.I9fb1d911b064262d33e33dfba730cdeef83926ca@changeid>
References: <iwlwifi.20200326150855.6865c7f28a14.I9fb1d911b064262d33e33dfba730cdeef83926ca@changeid>
Message-Id: <20200327150342.252AF20748@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, v4.14.174, v4.9.217, v4.4.217.

v5.5.11: Build OK!
v5.4.27: Build OK!
v4.19.112: Failed to apply! Possible dependencies:
    03512ceb60ae ("ieee80211: remove redundant leading zeroes")
    09b4a4faf9d0 ("mac80211: introduce capability flags for VHT EXT NSS support")
    0eeb2b674f05 ("mac80211: add an option for station management TXQ")
    1c9559734eca ("mac80211: remove unnecessary key condition")
    57a3a454f303 ("iwlwifi: split HE capabilities between AP and STA")
    62872a9b9a10 ("mac80211: Fix PTK rekey freezes and clear text leak")
    77f7ffdc335d ("mac80211: minstrel_ht: add flag to indicate missing/inaccurate tx A-MPDU length")
    77ff2c6b4984 ("mac80211: update HE IEs to D3.3")
    80aaa9c16415 ("mac80211: Add he_capa debugfs entry")
    96fc6efb9ad9 ("mac80211: IEEE 802.11 Extended Key ID support")
    add7453ad62f ("wireless: align to draft 11ax D3.0")
    adf8ed01e4fd ("mac80211: add an optional TXQ for other PS-buffered frames")
    caf56338c22f ("mac80211: indicate support for multiple BSSID")
    daa5b83513a7 ("mac80211: update HE operation fields to D3.0")

v4.14.174: Failed to apply! Possible dependencies:
    110b32f065f3 ("iwlwifi: mvm: rs: add basic implementation of the new RS API handlers")
    1c73acf58bd6 ("iwlwifi: acpi: move ACPI method definitions to acpi.h")
    28e9c00fe1f0 ("iwlwifi: remove upper case letters in sku_capa_band_*_enable")
    4ae80f6c8d86 ("iwlwifi: support api ver2 of NVM_GET_INFO resp")
    4b82455ca51e ("iwlwifi: use flags to denote modifiers for the channel maps")
    4c625c564ba2 ("iwlwifi: get rid of fw/nvm.c")
    514c30696fbc ("iwlwifi: add support for IEEE802.11ax")
    57a3a454f303 ("iwlwifi: split HE capabilities between AP and STA")
    77ff2c6b4984 ("mac80211: update HE IEs to D3.3")
    813df5cef3bb ("iwlwifi: acpi: add common code to read from ACPI")
    8a6171a7b601 ("iwlwifi: fw: add FW APIs for HE")
    9c4f7d512740 ("iwlwifi: move all NVM parsing code to the common files")
    9f66a397c877 ("iwlwifi: mvm: rs: add ops for the new rate scaling in the FW")
    e7a3b8d87910 ("iwlwifi: acpi: move ACPI-related definitions to acpi.h")

v4.9.217: Failed to apply! Possible dependencies:
    01796ff2fa6e ("iwlwifi: mvm: always free inactive queue when moving ownership")
    0aaece81114e ("iwlwifi: split firmware API from iwl-trans.h")
    1ea423b0e047 ("iwlwifi: remove unnecessary dev_cmd_headroom parameter")
    310181ec34e2 ("iwlwifi: move to TVQM mode")
    5594d80e9bf4 ("iwlwifi: support two phys for a000 devices")
    623e7766be90 ("iwlwifi: pcie: introduce split point to a000 devices")
    65e254821cee ("iwlwifi: mvm: use firmware station PM notification for AP_LINK_PS")
    6b35ff91572f ("iwlwifi: pcie: introduce a000 TX queues management")
    727c02dfb848 ("iwlwifi: pcie: cleanup rfkill checks")
    77ff2c6b4984 ("mac80211: update HE IEs to D3.3")
    8236f7db2724 ("iwlwifi: mvm: assign cab queue to the correct station")
    87d0e1af9db3 ("iwlwifi: mvm: separate queue mapping from queue enablement")
    bb49701b41de ("iwlwifi: mvm: support a000 SCD queue configuration")
    cf90da352a32 ("iwlwifi: mvm: use mvm_disable_queue instead of sharing logic")
    d172a5eff629 ("iwlwifi: reorganize firmware API")
    df88c08d5c7e ("iwlwifi: mvm: release static queues on bcast release")
    eda50cde58de ("iwlwifi: pcie: add context information support")

v4.4.217: Failed to apply! Possible dependencies:
    0aaece81114e ("iwlwifi: split firmware API from iwl-trans.h")
    13555e8ba2f4 ("iwlwifi: mvm: add 9000-series RX API")
    1a616dd2f171 ("iwlwifi: dump prph registers in a common place for all transports")
    1e0bbebaae66 ("mac80211: enable starting BA session with custom timeout")
    2f89a5d7d377 ("iwlwifi: mvm: move fw-dbg code to separate file")
    39bdb17ebb5b ("iwlwifi: update host command messages to new format")
    41837ca962ec ("iwlwifi: pcie: allow to pretend to have Tx CSUM for debug")
    4707fde5cdef ("iwlwifi: mvm: use build-time assertion for fw trigger ID")
    5b88792cd850 ("iwlwifi: move to wide ID for all commands")
    6c4fbcbc1c95 ("iwlwifi: add support for 12K Receive Buffers")
    77ff2c6b4984 ("mac80211: update HE IEs to D3.3")
    92fe83430b89 ("iwlwifi: uninline iwl_trans_send_cmd")
    d172a5eff629 ("iwlwifi: reorganize firmware API")
    dcbb4746286a ("iwlwifi: trans: support a callback for ASYNC commands")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
