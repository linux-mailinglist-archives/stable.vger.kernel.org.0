Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBBBD0B4D
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 11:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbfJIJdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 05:33:14 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47441 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729616AbfJIJdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 05:33:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7EF5A22110;
        Wed,  9 Oct 2019 05:33:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 09 Oct 2019 05:33:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=lCiamSyW3XM5U9D8CQ9oP8IN4Gb
        tzjaXmEqHDoIAoQ8=; b=X7iXaYCsaL7gGQ9iwwhERZ3sxcKGjnFqR7Xlg94369U
        wBMg2Yb4OemC8qyD2Qc5VrR1oAk4TEMTs5PMgNfgoZRQYw+Yt7PNh0VvVRVblvEu
        HSKFQDRP47pOqoJdITRbCfceYCH44aWOCLGcAyMJ/Oqw2NSvNbTehK+urlyYDtxz
        PWckoDwKY6QuG5OLgR59xIwtitx1kH9jJu2CZhxOmcl65Vr/j8OAHKpIZ3sZi9Ny
        4XL/zM0gdbYvdkx3PJf+AmjtMXnjyMwwdcYAk+fct9FiZZFoX2x+27X75WQeyzgB
        imjYbWk9KgJ+PXFFJxQLqT3hEPZIW2K5J5eMr9jGKug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lCiamS
        yW3XM5U9D8CQ9oP8IN4GbtzjaXmEqHDoIAoQ8=; b=CdCdMojoGSRay15GOoed6V
        2qM6FEPr66E5izq0x9VOwY9uEalbgl82pE5WwChq6qt98xpjK1404HOeQv/AtU3N
        L1cvPWfGfXSFmjOhAJ85BPzwnzYo+w89p/iH6Ro0C02a8AiUl4cRtuE8MpuQEd2a
        Sc4jd/0d5IGpTLDX4Z8b72mAan8J6joV0VGhfk6yfSPpBluB03INKg9f1dcZuL2c
        1cCeFpS2zDix/SNxmh2AzAE9Vz0cZgyRN/aLCl0IZVvnZ/MyhNVUyDn/ETfYVkls
        yJPnTwyIXssOP0mx5qIlxIrtVnUIONJm43+VKdB9uxfeLIY9ODFnilOiMZ87wBqA
        ==
X-ME-Sender: <xms:WamdXf94uiD0KGjd2loxPQToXQJb21-vmptlRat3JXjJylXiabss4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedtgddugeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:WamdXVDQjBZC4odrMhTRKE6u16xFLRjcM9n-HlcCpTkE_1ZQ2PzacA>
    <xmx:WamdXVD7rdAAsnHgeN_rcZXeRhv-N-FBBtqULwioaZLpK477tM9BAg>
    <xmx:WamdXVJArXvuVg6Rwe69-RcIp_g0mtKlpnbiWo9hT2_9WRWcq4diqA>
    <xmx:WamdXXlaS8YB7evKWMBN9MM3tkTwlyHCQrLWJ9qX9TEMIAM5RQeb6w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D27BF8005B;
        Wed,  9 Oct 2019 05:33:12 -0400 (EDT)
Date:   Wed, 9 Oct 2019 11:33:10 +0200
From:   Greg KH <greg@kroah.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     stable@vger.kernel.org, jeremy.linton@arm.com,
        catalin.marinas@arm.com, Josh Poimboeuf <jpoimboe@redhat.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH for-stable-4.19] arm64/speculation: Support
 'mitigations=' cmdline option
Message-ID: <20191009093310.GD3901624@kroah.com>
References: <20191009091121.19434-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009091121.19434-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 11:11:21AM +0200, Ard Biesheuvel wrote:
> From: Josh Poimboeuf <jpoimboe@redhat.com>
> 
> [ Upstream commit a111b7c0f20e13b54df2fa959b3dc0bdf1925ae6 ]
> 
> Configure arm64 runtime CPU speculation bug mitigations in accordance
> with the 'mitigations=' cmdline option.  This affects Meltdown, Spectre
> v2, and Speculative Store Bypass.
> 
> The default behavior is unchanged.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> [will: reorder checks so KASLR implies KPTI and SSBS is affected by cmdline]
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Now queued up, thanks.

greg k-h
