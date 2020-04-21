Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C921B30C3
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgDUT4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDUT4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 15:56:13 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E5D42074F;
        Tue, 21 Apr 2020 19:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587498972;
        bh=jho+8NeJcPS9x7ZeQg0u8DxBOJux7l3yWm2P3sKGrzc=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Dk/kCOozQhQoFM64hEC+VbRX3u7BQ+JdlDkguj1317+bcG9LS79bwneyy5W7idG8q
         6A9LBXymu73dI21SoU43xdGhpCT7vbfNTSx8sfwLK61R8WrXruMuGL8FiGHObtat5F
         Kk26y48naC6z+MtJwstj9Ek9IMhREp92jwf4epqg=
Date:   Tue, 21 Apr 2020 19:56:11 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Luca Coelho <luca@coelho.fi>
To:     Johannes Berg <johannes.berg@intel.com>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 v5.7 4/6] iwlwifi: mvm: limit maximum queue appropriately
In-Reply-To: <iwlwifi.20200417100405.98a79be2db6a.I3a4af6b03b87a6bc18db9b1ff9a812f397bee1fc@changeid>
References: <iwlwifi.20200417100405.98a79be2db6a.I3a4af6b03b87a6bc18db9b1ff9a812f397bee1fc@changeid>
Message-Id: <20200421195612.7E5D42074F@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.9+

The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33, v4.19.116, v4.14.176, v4.9.219.

v5.6.5: Build OK!
v5.5.18: Build OK!
v5.4.33: Build OK!
v4.19.116: Failed to apply! Possible dependencies:
    1169310fa9a8 ("iwlwifi: refactor txq_alloc for supporting more command type")
    2d8c261511ab ("iwlwifi: add d3 debug data support")
    718a8b23ad04 ("iwlwifi: unite macros with same meaning")
    8093bb6d4fee ("iwlwifi: add PCI IDs for the 22260 device series")
    99448a8c1145 ("iwlwifi: mvm: move queue management into sta.c")
    9b3089bd820d ("iwlwifi: pcie: allow using tx init for other queues but the command queue")
    a98e2802a654 ("iwlwifi: correct one of the PCI struct names")
    afc1e3b4fc8f ("iwlwifi: mvm: use correct GP2 register address for 22000 family")
    b998fbbd531f ("iwlwifi: implement BISR HW workaround for 22260 devices")
    c30aef01bae9 ("iwlwifi: set 512 TX queue slots for AX210 devices")
    c96b5eec2105 ("iwlwifi: refactor NIC init sequence")
    cefec29ebdde ("iwlwifi: pcie: align licensing to dual GPL/BSD")
    ff911dcaa2e4 ("iwlwifi: introduce device family AX210")

v4.14.176: Failed to apply! Possible dependencies:
    0e1be40a45d7 ("iwlwifi: mvm: allow reading UMAC error data from SMEM in A000 devices")
    251985c92865 ("iwlwifi: mvm: use shorter queues for mgmt and auxilary queues")
    2ee824026288 ("iwlwifi: pcie: support context information for 22560 devices")
    2f7a3863191a ("iwlwifi: rename the temporary name of A000 to the official 22000")
    33708052993c ("iwlwifi: add support for 22560 devices")
    3485e76e7349 ("iwlwifi: define minimum valid address for umac_error_event_table in cfg")
    5369774c84ea ("iwlwifi: add TX queue size parameter to TX queue allocation")
    718a8b23ad04 ("iwlwifi: unite macros with same meaning")
    8093bb6d4fee ("iwlwifi: add PCI IDs for the 22260 device series")
    80b0ebd488b3 ("Merge tag 'iwlwifi-next-for-kalle-2017-11-29' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next")
    ab27926d9e4a ("iwlwifi: fix devices with PCI Device ID 0x34F0 and 11ac RF modules")
    cb8550e15bd1 ("iwlwifi: fix multi queue notification for a000 devices")
    dd05f9aab442 ("iwlwifi: pcie: dynamic Tx command queue size")
    e59a00f48848 ("iwlwifi: fix indentation in a000 family configuration")
    fb5b28469d2a ("iwlwifi: mvm: move umac_error_event_table validity check to where it's set")
    ff911dcaa2e4 ("iwlwifi: introduce device family AX210")

v4.9.219: Failed to apply! Possible dependencies:
    01796ff2fa6e ("iwlwifi: mvm: always free inactive queue when moving ownership")
    0aaece81114e ("iwlwifi: split firmware API from iwl-trans.h")
    1ea423b0e047 ("iwlwifi: remove unnecessary dev_cmd_headroom parameter")
    310181ec34e2 ("iwlwifi: move to TVQM mode")
    5594d80e9bf4 ("iwlwifi: support two phys for a000 devices")
    623e7766be90 ("iwlwifi: pcie: introduce split point to a000 devices")
    65e254821cee ("iwlwifi: mvm: use firmware station PM notification for AP_LINK_PS")
    6b35ff91572f ("iwlwifi: pcie: introduce a000 TX queues management")
    727c02dfb848 ("iwlwifi: pcie: cleanup rfkill checks")
    8236f7db2724 ("iwlwifi: mvm: assign cab queue to the correct station")
    87d0e1af9db3 ("iwlwifi: mvm: separate queue mapping from queue enablement")
    bb49701b41de ("iwlwifi: mvm: support a000 SCD queue configuration")
    cf90da352a32 ("iwlwifi: mvm: use mvm_disable_queue instead of sharing logic")
    d172a5eff629 ("iwlwifi: reorganize firmware API")
    df88c08d5c7e ("iwlwifi: mvm: release static queues on bcast release")
    eda50cde58de ("iwlwifi: pcie: add context information support")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
