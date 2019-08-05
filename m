Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE1D815C7
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 11:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfHEJp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 05:45:26 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:34072 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726454AbfHEJp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 05:45:26 -0400
Received: from [91.156.6.193] (helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1huZYQ-0003TU-GL; Mon, 05 Aug 2019 12:45:23 +0300
Message-ID: <f6d6c216e20d5179964b0d5afb92affe3318d639.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Sasha Levin <sashal@kernel.org>, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date:   Mon, 05 Aug 2019 12:45:20 +0300
In-Reply-To: <20190720122332.E229E2186A@mail.kernel.org>
References: <20190720102545.5952-2-luca@coelho.fi>
         <20190720122332.E229E2186A@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH 01/16] iwlwifi: mvm: don't send GEO_TX_POWER_LIMIT on
 version < 41
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2019-07-20 at 12:23 +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.2.1, v5.1.18, v4.19.59, v4.14.133, v4.9.185, v4.4.185.
> 
> v5.2.1: Build OK!
> v5.1.18: Build OK!
> v4.19.59: Build OK!
> v4.14.133: Build OK!
> v4.9.185: Failed to apply! Possible dependencies:
>     1f3706508395 ("iwlwifi: mvm: support unification of INIT and RT images")
>     42ce76d615e7 ("iwlwifi: mvm: spin off SAR profile selection function")
>     6996490501ed ("iwlwifi: mvm: add support for EWRD (Dynamic SAR) ACPI table")
>     7fe90e0e3d60 ("iwlwifi: mvm: refactor geo init")
>     a6bff3cb19b7 ("iwlwifi: mvm: add GEO_TX_POWER_LIMIT cmd for geographic tx power table")
>     c386dacb4ed6 ("iwlwifi: mvm: refactor SAR init to prepare for dynamic SAR")
> 
> v4.4.185: Failed to apply! Possible dependencies:
>     13555e8ba2f4 ("iwlwifi: mvm: add 9000-series RX API")
>     1a616dd2f171 ("iwlwifi: dump prph registers in a common place for all transports")
>     2f89a5d7d377 ("iwlwifi: mvm: move fw-dbg code to separate file")
>     321c2104f2f1 ("iwlwifi: mvm: Support setting continuous recording debug mode")
>     39bdb17ebb5b ("iwlwifi: update host command messages to new format")
>     42ce76d615e7 ("iwlwifi: mvm: spin off SAR profile selection function")
>     43413a975d06 ("iwlwifi: mvm: support rss queues configuration command")
>     4707fde5cdef ("iwlwifi: mvm: use build-time assertion for fw trigger ID")
>     6c4fbcbc1c95 ("iwlwifi: add support for 12K Receive Buffers")
>     854d773e4ab5 ("iwlwifi: mvm: improve RSS configuration")
>     92fe83430b89 ("iwlwifi: uninline iwl_trans_send_cmd")
>     9e7dce286595 ("iwlwifi: mvm: allow to limit the A-MSDU from debugfs")
>     da2830acf15a ("iwlwifi: mvm: read SAR BIOS table from ACPI")
>     dcbb4746286a ("iwlwifi: trans: support a callback for ASYNC commands")
>     dd4d3161d0f2 ("iwlwifi: mvm: fix RSS key sizing")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Hi Sasha,

In this specific case, the patch does not have to be applied on 4.9 and
4.4.  What is the right way to handle these cases? Should I simply
ignore them, so they won't go into those kernels by default or do you
want me to follow up somehow and let you know that those kernels can be
ignore?

--
Cheers,
Luca.

