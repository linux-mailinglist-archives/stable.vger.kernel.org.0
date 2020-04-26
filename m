Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450A01B9106
	for <lists+stable@lfdr.de>; Sun, 26 Apr 2020 17:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgDZPDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 11:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgDZPDj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Apr 2020 11:03:39 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B769E206D4;
        Sun, 26 Apr 2020 15:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587913418;
        bh=i7CuN56YMVao2EEHlvF/iwomtHEgWLVGaff+VKRVhD4=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=N+wn6M3cH1m9myySmDhvzQBgRXj5vAwl8TK4F30F8jzlDyBhLHoZkFnmZaFaMbNH5
         cgXfKSnEWcrUx4b5tNUAMNAYOwhhobYM4zJPEx10aMYZbHAmuSp0J3bEnINyCcgvWD
         I9zLJw5u5L+jm3v2qBbDZMGUTBwHos8WoTxHiM2g=
Date:   Sun, 26 Apr 2020 15:03:37 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Luca Coelho <luca@coelho.fi>
To:     Luca Coelho <luciano.coelho@intel.com>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5.7] iwlwifi: pcie: handle QuZ configs with killer NICs as well
In-Reply-To: <iwlwifi.20200424121518.b715acfbe211.I273a098064a22577e4fca767910fd9cf0013f5cb@changeid>
References: <iwlwifi.20200424121518.b715acfbe211.I273a098064a22577e4fca767910fd9cf0013f5cb@changeid>
Message-Id: <20200426150338.B769E206D4@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 5a8c31aa6357 ("iwlwifi: pcie: fix recognition of QuZ devices").

The bot has tested the following trees: v5.6.7, v5.4.35.

v5.6.7: Failed to apply! Possible dependencies:
    32ed101aa140 ("iwlwifi: convert all Qu with Jf devices to the new config table")
    56ba371a5288 ("iwlwifi: move the remaining 0x2526 configs to the new table")
    5e003982b07a ("iwlwifi: move AX200 devices to the new table")
    67eb556da609 ("iwlwifi: combine 9260 cfgs that only change names")
    95939551e28c ("iwlwifi: add GNSS differentiation to the device tables")
    d6f2134a3831 ("iwlwifi: add mac/rf types and 160MHz to the device tables")
    fe25b1518f72 ("iwlwifi: move TH1 devices to the new table")

v5.4.35: Failed to apply! Possible dependencies:
    32ed101aa140 ("iwlwifi: convert all Qu with Jf devices to the new config table")
    3681021fc6af ("iwlwifi: remove IWL_DEVICE_22560/IWL_DEVICE_FAMILY_22560")
    3b589d5624ce ("iwlwifi: dbg_ini: use new trigger TLV in dump flow")
    593fae3e5e90 ("iwlwifi: dbg_ini: add monitor dumping support")
    69f0e5059b09 ("iwlwifi: dbg: remove multi buffers infra")
    bfc3e9fdbfb8 ("iwlwifi: 22000: fix some indentation")
    c042f0c77f3d ("iwlwifi: allocate more receive buffers for HE devices")
    c9fe75e9f347 ("iwlwifi: dbg_ini: use new region TLV in dump flow")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
