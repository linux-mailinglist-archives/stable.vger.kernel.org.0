Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0312FEA8E
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 13:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731209AbhAUMrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 07:47:37 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47805 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730662AbhAUMrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 07:47:18 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7FB135C0037;
        Thu, 21 Jan 2021 07:46:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 21 Jan 2021 07:46:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=NLlv6KYS+HOWe386rmowL0hFhUA
        d2kz4tguzFpiNW8M=; b=QF2+0UXl7ZwrsPuMExhCVu1gmcNvbTULDJkcoaICxAn
        ESmcGNZWO4yskmUzZn4IDY6l+2guKr+/XiBzWcco3rmq/QipOLsKPauW8qszNpMI
        /lSb+s1GsQy1AOCUtvQSgStgqi5qabNS1xnfnqWJrO2pvS9yuRR7+X8ayqp7jn4V
        QiFqJh/qp5WmSVsUGwKvr9Ebvp7j01Sb961ExQFsT+r5sNzLc6V2OhVeHRILVva1
        8JM3jtmaFlUzEPFqd91Xt96fq5YG0NFAj5xJH3C3k7I//R6GHnyEHh9jD+Bm9xwG
        x/P7yEaQiEzk0+oBo5dZPazw0oN4LArS/isuwOPYXPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NLlv6K
        YS+HOWe386rmowL0hFhUAd2kz4tguzFpiNW8M=; b=dI0/ngQCDJzYhDKjJlzle3
        mmMhBMa4QqibMBTB408XlFHUuuepXPjqHV8Fgv5zIwgt0m3euGPfk6iZhPRHqnfQ
        L2i2rSmrdOc3ldSfk6Fd54mnMkQylUA0YbiJxPfaOlfz1XqJflnqr2QeWZ19zN9k
        Kf2jHukcKXFejPDv2zSSg5eCGqMS0JZ8h/AmWWnDJ3rk+sR+hNINe4wNmA5DwjYG
        wT+r+8tymU6h8m0qJDF6LnC6spE0jlVD8/PU/9UFGqYLhm3ny0X00QxetTWShliQ
        G/4WIfm0pZKfpm92p+SCA6MAtRPgPPVBIul9XACEIMgvCMnEzFXwVuoN4uk6igdA
        ==
X-ME-Sender: <xms:oHcJYGwgMUtehIlNZ2f-OkQdk9dgOVeQCTHO0gHP5x8s3D3TsW2cFg>
    <xme:oHcJYCTykfoT1cu0_bRz5kVtLsWWmYGgzR6CgZ8DPBOyEbF0-0ORdmQ1TCLyecK1U
    JyEi_Ots-Dduw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:oHcJYIXJQDgBC1fGVcVS05zfYNKX0B9HPELrBstPRWvUnCwISHSGfA>
    <xmx:oHcJYMi3IoqQZqF76MOSwGTdqXv-T7Y13cQs4TxGs2w0z1hkTo84GA>
    <xmx:oHcJYIC0iRpk_VdQrjK831XAMyKPJrfuhUZHymDsLQe2q7zn4P5ePg>
    <xmx:o3cJYLMk8ViuCIvEZduec0pwmJqSrrw9sIgcjh5a4oGxVU5EU1bC4g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 498191080068;
        Thu, 21 Jan 2021 07:46:24 -0500 (EST)
Date:   Thu, 21 Jan 2021 13:46:22 +0100
From:   Greg KH <greg@kroah.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        amd-gfx@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH -stable] drm/amdgpu/display: drop DCN support for aarch64
Message-ID: <YAl3nv41xcTY+Vef@kroah.com>
References: <20210121092040.110267-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121092040.110267-1-ardb@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 21, 2021 at 10:20:40AM +0100, Ard Biesheuvel wrote:
> From: Alex Deucher <alexander.deucher@amd.com>
> 
> commit c241ed2f0ea549c18cff62a3708b43846b84dae3 upstream.
> 
> >From Ard:
> 
> "Simply disabling -mgeneral-regs-only left and right is risky, given that
> the standard AArch64 ABI permits the use of FP/SIMD registers anywhere,
> and GCC is known to use SIMD registers for spilling, and may invent
> other uses of the FP/SIMD register file that have nothing to do with the
> floating point code in question. Note that putting kernel_neon_begin()
> and kernel_neon_end() around the code that does use FP is not sufficient
> here, the problem is in all the other code that may be emitted with
> references to SIMD registers in it.
> 
> So the only way to do this properly is to put all floating point code in
> a separate compilation unit, and only compile that unit with
> -mgeneral-regs-only."
> 
> Disable support until the code can be properly refactored to support this
> properly on aarch64.
> 
> Acked-by: Will Deacon <will@kernel.org>
> Reported-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> [ardb: backport to v5.10 by reverting c38d444e44badc55 instead]
> Acked-by: Alex Deucher <alexander.deucher@amd.com> # v5.10 backport
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> The original commit does not apply cleanly to v5.10, as it reverts a
> combination of patches, some of which are not present in v5.10.
> 
> This patch is a straight revert of c38d444e44badc55, which is the only
> change that needs to be backed out from v5.10, and amounts to the same
> thing as the original mainline commit.

Now queued up, thanks.

greg k-h
