Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8471B3155
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 22:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgDUUkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 16:40:03 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:57378 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725850AbgDUUkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 16:40:03 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jQzH3-000MvI-6A; Tue, 21 Apr 2020 23:13:41 +0300
Message-ID: <c548cd4416cfe6f1e9c6824a60edf11de3ee6e43.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Sasha Levin <sashal@kernel.org>, Ilan Peer <ilan.peer@intel.com>,
        kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 21 Apr 2020 23:13:40 +0300
In-Reply-To: <20200421195608.CB7EA2074B@mail.kernel.org>
References: <iwlwifi.20200417100405.53dbc3c6c36b.Idfe118546b92cc31548b2211472a5303c7de5909@changeid>
         <20200421195608.CB7EA2074B@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP autolearn=ham autolearn_force=no version=3.4.4
Subject: Re: [PATCH v2 v5.7 5/6] iwlwifi: mvm: Do not declare support for
 ACK Enabled Aggregation
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
>     57a3a454f303 ("iwlwifi: split HE capabilities between AP and STA")
>     80aaa9c16415 ("mac80211: Add he_capa debugfs entry")
>     add7453ad62f ("wireless: align to draft 11ax D3.0")
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

