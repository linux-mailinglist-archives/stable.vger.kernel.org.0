Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8EF2A50D1
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgKCUWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:22:02 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42325 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727688AbgKCUWB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 15:22:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9C77E5C0120;
        Tue,  3 Nov 2020 15:22:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 15:22:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=mfz/RQI+EEqHmxY6j4//GMrCh8U
        8faBjBrtKjmFkdpI=; b=4L8VE7YImAo3QwkBLKyjyNKz4JCfwCzntZV5F9lsFLa
        yrBAMPYsxkmhmjD5QcfO53DF8Ezav21f9ZlcL0Tx4MQCRCCn55MI+l5xbiJWi6Q7
        IDgqE3hP+tlivN1eWfqY1bTFCmlTCT8qokwOEtw2Y0yNbpNyb7QfjhvSeJp+MiSP
        +BYs6x0eu87QayHEWjTBU0QqofrfpzchpzFc18cDTfeY9Wt45iWfZQj/u275m/I7
        sIi2oKQWQt8JKuC//8K3Bg7eRlw8PavtCsLVmlRRl/3A40dRi/9yvdOaxWQfcf2N
        3Hodd9ntC88ePClesr2jxfK67X8izN5uhWN126rUqmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mfz/RQ
        I+EEqHmxY6j4//GMrCh8U8faBjBrtKjmFkdpI=; b=FSCOkH9sOXKycxfNoBHbX6
        jZsoVqICI5jSKkp6kC8XzHKgEmCgROqeJ0BnPWsr7ouwRJGNl7XJdo1Xe5oF4h0w
        J1Y1teXoQKwXSll7eauOmNZ+8mr71uj9o5t5z9tqO7pqw/h2N0CCOCn2scX7igpg
        7w2d5qp43lPzBjbT37UXe0KUQaamgtJHm/nlucrcuGzlq1kR9FSSziYtDczJY66G
        paI5VR7xLCfvRknvICjlOlNTolFkEet8AgF7jI6z1GMbuZKtVBXkVJA23bhwEtWe
        31uw6VY4Kxu7hRbPfYT632TsN78K3tK0n9VhVl8O31tyCgtVxmlvGYTRN3Fr3Tyw
        ==
X-ME-Sender: <xms:6LuhX93n3_keexrOfPopWh8MZJZBo1H-16ZuUE4TTz5CAJ2BPftCVg>
    <xme:6LuhX0FjWDxYsrQCgA2IUVraPkIZZ8T_b8DRqh8wuPx0vs_b0bFhM7YsiezN-z4lJ
    2NWiKfOqDCy5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgudefhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepfeeihf
    elffejffekteetudegfeeihffftefhveeuffffjeehvefhveegjeetuddunecuffhomhgr
    ihhnpegrrhhmrdgtohhmpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrd
    eigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6LuhX94AG_C4tgywLcBCaF_sbHEhwwuUh2d5ysStdYH3u-PFqcDwLA>
    <xmx:6LuhX60-0hPeLE8MNVnReosj2emo5I8FEkrYb9VHfyrUmOpxSAuWuw>
    <xmx:6LuhXwHik16ks3okoIR_Fvcrp4M7C-A-H7XWRPxGrHdRdxz0937xRQ>
    <xmx:6LuhX8j5cX74jNShJuBiUvZHD-uRvYdvtUrQVKj2nM6sgpTfJDoHLA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E30F332800DB;
        Tue,  3 Nov 2020 15:21:59 -0500 (EST)
Date:   Tue, 3 Nov 2020 21:21:57 +0100
From:   Greg KH <greg@kroah.com>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>
Subject: Re: [PATCH stable 5.9] KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1
 doesn't return SMCCC_RET_NOT_REQUIRED
Message-ID: <20201103202157.GA470743@kroah.com>
References: <20201103201526.372590-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103201526.372590-1-swboyd@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 12:15:26PM -0800, Stephen Boyd wrote:
> commit 1de111b51b829bcf01d2e57971f8fd07a665fa3f upstream.
> 
> According to the SMCCC spec[1](7.5.2 Discovery) the
> ARM_SMCCC_ARCH_WORKAROUND_1 function id only returns 0, 1, and
> SMCCC_RET_NOT_SUPPORTED.
> 
>  0 is "workaround required and safe to call this function"
>  1 is "workaround not required but safe to call this function"
>  SMCCC_RET_NOT_SUPPORTED is "might be vulnerable or might not be, who knows, I give up!"
> 
> SMCCC_RET_NOT_SUPPORTED might as well mean "workaround required, except
> calling this function may not work because it isn't implemented in some
> cases". Wonderful. We map this SMC call to
> 
>  0 is SPECTRE_MITIGATED
>  1 is SPECTRE_UNAFFECTED
>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
> 
> For KVM hypercalls (hvc), we've implemented this function id to return
> SMCCC_RET_NOT_SUPPORTED, 0, and SMCCC_RET_NOT_REQUIRED. One of those
> isn't supposed to be there. Per the code we call
> arm64_get_spectre_v2_state() to figure out what to return for this
> feature discovery call.
> 
>  0 is SPECTRE_MITIGATED
>  SMCCC_RET_NOT_REQUIRED is SPECTRE_UNAFFECTED
>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
> 
> Let's clean this up so that KVM tells the guest this mapping:
> 
>  0 is SPECTRE_MITIGATED
>  1 is SPECTRE_UNAFFECTED
>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
> 
> Note: SMCCC_RET_NOT_AFFECTED is 1 but isn't part of the SMCCC spec
> 
> Fixes: c118bbb52743 ("arm64: KVM: Propagate full Spectre v2 workaround state to KVM guests")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Will Deacon <will@kernel.org>
> Cc: Andre Przywara <andre.przywara@arm.com>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://developer.arm.com/documentation/den0028/latest [1]
> Link: https://lore.kernel.org/r/20201023154751.1973872-1-swboyd@chromium.org
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  arch/arm64/kvm/hypercalls.c | 2 +-
>  include/linux/arm-smccc.h   | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)

Thanks for both of these, now queued up.

greg k-h
