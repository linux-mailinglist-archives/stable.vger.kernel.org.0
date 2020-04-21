Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DC01B30B8
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgDUT4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgDUT4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 15:56:07 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 419C0206E9;
        Tue, 21 Apr 2020 19:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587498966;
        bh=e/y1RzWTH/jAmTOq05OhNkKHqXsGv85OPvpjqcUvbQw=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=fB2VYdgfGec/irgcgVTEKzgTioW8tCwD9mHcUzPOtuIRskbjWDqI4cs2VC+pVXISj
         yUN3QrxqAsNpk1iylifEaa/2xFBGechmEufgPnP1BD2gMct/hAO5RiHxJnJd83gA4a
         plo+WNRcSgYvauqSy2ADDWq8yQNE6AMXxOTMbrr8=
Date:   Tue, 21 Apr 2020 19:56:05 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Luca Coelho <luca@coelho.fi>
To:     Luca Coelho <luciano.coelho@intel.com>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 v5.7] iwlwifi: fix WGDS check when WRDS is disabled
In-Reply-To: <iwlwifi.20200417133700.72ad25c3998b.I875d935cefd595ed7f640ddcfc7bc802627d2b7f@changeid>
References: <iwlwifi.20200417133700.72ad25c3998b.I875d935cefd595ed7f640ddcfc7bc802627d2b7f@changeid>
Message-Id: <20200421195606.419C0206E9@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.14+

The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33, v4.19.116, v4.14.176.

v5.6.5: Build OK!
v5.5.18: Build OK!
v5.4.33: Failed to apply! Possible dependencies:
    39c1a9728f93 ("iwlwifi: refactor the SAR tables from mvm to acpi")

v4.19.116: Failed to apply! Possible dependencies:
    0791c2fce3c8 ("iwlwifi: mvm: support new reduce tx power FW API.")
    17b809c9b22e ("iwlwifi: dbg: move debug data to a struct")
    22463857a16b ("iwlwifi: receive umac and lmac error table addresses from TLVs")
    2d8c261511ab ("iwlwifi: add d3 debug data support")
    39c1a9728f93 ("iwlwifi: refactor the SAR tables from mvm to acpi")
    48e775e66e2d ("iwlwifi: mvm: add support for 32kHz external clock indication")
    4c2f445c0f49 ("iwlwifi: mvm: skip EBS in low latency mode while fragmented scan isn't supported")
    68025d5f9bfe ("iwlwifi: dbg: refactor dump code to improve readability")
    8d534e96b500 ("iwlwifi: dbg_ini: create new dump flow and implement prph dump")
    a6820511f193 ("iwlwifi: dbg: split iwl_fw_error_dump to two functions")
    ae17404e3860 ("iwlwifi: avoid code duplication in stopping fw debug data recording")
    c5f97542aa06 ("iwlwifi: change monitor DMA to be coherent")
    d25eec305c97 ("iwlwifi: fw: add a restart FW debug function")
    da7527173b18 ("iwlwifi: debug flow cleanup")
    ea7c2bfdec6d ("Revert "iwlwifi: allow memory debug TLV to specify the memory type"")
    f130bb75d881 ("iwlwifi: add FW recovery flow")

v4.14.176: Failed to apply! Possible dependencies:
    1184611ee88f ("iwlwifi: acpi: move code that reads SPLC to acpi")
    1c73acf58bd6 ("iwlwifi: acpi: move ACPI method definitions to acpi.h")
    2fa388cfeb1a ("iwlwifi: acpi: generalize iwl_mvm_sar_find_wifi_pkg()")
    39c1a9728f93 ("iwlwifi: refactor the SAR tables from mvm to acpi")
    45a5c6f68b26 ("iwlwifi: acpi: use iwl_acpi_get_wifi_pkg when reading reading SPLC")
    45f65569e0d9 ("iwlwifi: acpi: move function to get mcc into acpi code")
    48e775e66e2d ("iwlwifi: mvm: add support for 32kHz external clock indication")
    813df5cef3bb ("iwlwifi: acpi: add common code to read from ACPI")
    ed1a962db760 ("iwlwifi: acpi: make iwl_get_bios_mcc() use the common acpi functions")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
