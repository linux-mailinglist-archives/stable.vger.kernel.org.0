Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72FC1B30BD
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgDUT4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgDUT4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 15:56:10 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21AD4206D9;
        Tue, 21 Apr 2020 19:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587498970;
        bh=924lvXzCXKkSPRSH+MA3LZtGOo8EqpC62prdDvQJSoE=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=grBGZAOBtz67+Dl/HlvtKoJiLpKamU55hiDWWi9CqxjJlNwdchhzly0PSg2PSWZ9O
         OiKKE3b6DJNHWhT3yQUErQMWO9g3bXrcDk+Xc4o02MLY1TEPA0yF8n7qgM0+Ho/UQF
         x2gPs3yRz1J33s8fqzFVMF6KD1ksVctL//agnqZ0=
Date:   Tue, 21 Apr 2020 19:56:09 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Luca Coelho <luca@coelho.fi>
To:     Mordechay Goodstein <mordechay.goodstein@intel.com>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 v5.7 2/6] iwlwifi: mvm: beacon statistics shouldn't go backwards
In-Reply-To: <iwlwifi.20200417100405.1f9142751fbc.Ifbfd0f928a0a761110b8f4f2ca5483a61fb21131@changeid>
References: <iwlwifi.20200417100405.1f9142751fbc.Ifbfd0f928a0a761110b8f4f2ca5483a61fb21131@changeid>
Message-Id: <20200421195610.21AD4206D9@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.19+

The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33, v4.19.116.

v5.6.5: Build OK!
v5.5.18: Build OK!
v5.4.33: Build OK!
v4.19.116: Failed to apply! Possible dependencies:
    17b809c9b22e ("iwlwifi: dbg: move debug data to a struct")
    22463857a16b ("iwlwifi: receive umac and lmac error table addresses from TLVs")
    2d8c261511ab ("iwlwifi: add d3 debug data support")
    33bdccb71aa6 ("iwlwifi: remove FSF's address from the license notice")
    58d3bef4163b ("iwlwifi: remove all the d0i3 references")
    68025d5f9bfe ("iwlwifi: dbg: refactor dump code to improve readability")
    8d534e96b500 ("iwlwifi: dbg_ini: create new dump flow and implement prph dump")
    a6820511f193 ("iwlwifi: dbg: split iwl_fw_error_dump to two functions")
    ae17404e3860 ("iwlwifi: avoid code duplication in stopping fw debug data recording")
    c5f97542aa06 ("iwlwifi: change monitor DMA to be coherent")
    d25eec305c97 ("iwlwifi: fw: add a restart FW debug function")
    da7527173b18 ("iwlwifi: debug flow cleanup")
    ea7c2bfdec6d ("Revert "iwlwifi: allow memory debug TLV to specify the memory type"")
    f130bb75d881 ("iwlwifi: add FW recovery flow")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
