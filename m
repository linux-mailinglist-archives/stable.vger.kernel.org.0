Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869441B3156
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 22:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgDUUkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 16:40:05 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:57382 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725850AbgDUUkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 16:40:05 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jQzHB-000MvR-Qc; Tue, 21 Apr 2020 23:13:50 +0300
Message-ID: <2e47b8a5826591461247e6247a9a158c9ed62973.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Sasha Levin <sashal@kernel.org>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 21 Apr 2020 23:13:48 +0300
In-Reply-To: <20200421195610.21AD4206D9@mail.kernel.org>
References: <iwlwifi.20200417100405.1f9142751fbc.Ifbfd0f928a0a761110b8f4f2ca5483a61fb21131@changeid>
         <20200421195610.21AD4206D9@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP autolearn=ham autolearn_force=no version=3.4.4
Subject: Re: [PATCH v2 v5.7 2/6] iwlwifi: mvm: beacon statistics shouldn't
 go backwards
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-04-21 at 19:56 +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: 4.19+
> 
> The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33, v4.19.116.
> 
> v5.6.5: Build OK!
> v5.5.18: Build OK!
> v5.4.33: Build OK!
> v4.19.116: Failed to apply! Possible dependencies:
>     17b809c9b22e ("iwlwifi: dbg: move debug data to a struct")
>     22463857a16b ("iwlwifi: receive umac and lmac error table addresses from TLVs")
>     2d8c261511ab ("iwlwifi: add d3 debug data support")
>     33bdccb71aa6 ("iwlwifi: remove FSF's address from the license notice")
>     58d3bef4163b ("iwlwifi: remove all the d0i3 references")
>     68025d5f9bfe ("iwlwifi: dbg: refactor dump code to improve readability")
>     8d534e96b500 ("iwlwifi: dbg_ini: create new dump flow and implement prph dump")
>     a6820511f193 ("iwlwifi: dbg: split iwl_fw_error_dump to two functions")
>     ae17404e3860 ("iwlwifi: avoid code duplication in stopping fw debug data recording")
>     c5f97542aa06 ("iwlwifi: change monitor DMA to be coherent")
>     d25eec305c97 ("iwlwifi: fw: add a restart FW debug function")
>     da7527173b18 ("iwlwifi: debug flow cleanup")
>     ea7c2bfdec6d ("Revert "iwlwifi: allow memory debug TLV to specify the memory type"")
>     f130bb75d881 ("iwlwifi: add FW recovery flow")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Same thing as with the other patches: We definitely don't want all
these dependencies.  Some functions were moved around and that's what's
causing the failures.  I'll rebase this patch for those kernels where
it failed and submit separately.

--
Luca.

