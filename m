Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EE03CD504
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbhGSMEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:04:35 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:45915 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236571AbhGSMEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:04:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5C7BA3200947;
        Mon, 19 Jul 2021 08:45:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 19 Jul 2021 08:45:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=K
        hSjEHlHQwDF3RC9HIiNLOMrNeVg+ij6e5xk9o3mEpk=; b=c1pQLbWFeZCvfm4Z7
        URpjftGRix8f/bov0VxA2Iv5iOk4UtOTkJAZ37nVA1T8MSToSxQr7+42ugUh9dgQ
        /LeDAtvlx0N/YdJqr40jCYM1jkC+/1VIsXwSnQIn/A/3MPozy6Vlr5eBfMaxkons
        fF1JBaFUFmUlJwP51mXRvcRl3DOD27wtmdWOwLXiNsak5R0gxUDkkWi2p7PZxFp4
        +GR3ASPqNv6GqN+bOtSdR+OCKt2LGJMVmmmWdNM9BoniQM3vl9YI7luJQ7Br9Bnv
        5EfTztKcXqAIhpknmEKlYW3rGSflIsMYTkLQf0F+ZnAKXGNTlEdFSCdPWOMjsXOm
        iKehw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=KhSjEHlHQwDF3RC9HIiNLOMrNeVg+ij6e5xk9o3mE
        pk=; b=F35rDhZn7PREGGlr9P3Uy/tfiV8BbFT5qt5yizdJHsqjOf4JtnW3n//qJ
        DpA2f5i5n4XjqbVt3y1KmEGUcChPi0M6p65sqbidhDO01Ae+cRhh3+dmJ7Dq7SSu
        m9pDCy/3E4ve/U+Ff+3Lz+YGCgDfFDBGq8E4ZeHBrW1lSgnlN3xqWc63oXwgsGgv
        0G9fZCqHzkGfrCMr+2CF310BRm6fLNOg7wLYJM9N4B/4Axgd93Y2WRvEe7AqoC7w
        2LNCpZT9Hp5OzpUJ1SlCtLGzZkxto+wzuEjp5f5vhcXKtFRsC72LI6YVW0xrTOTH
        aH7gyS/6GHAniA9qVwZvxsWBe3dbg==
X-ME-Sender: <xms:2XP1YIjgNLp6srjua_dFVU3hjP--j1xKKeTurthhEglPdXeL2JJPxA>
    <xme:2XP1YBDmk_8P3bzXYDaQOutbdbWqsYCaKAdbMSOVyoBazsevNwgLDxM5plpdSNSZ0
    Er5FfM3Db9ZUw>
X-ME-Received: <xmr:2XP1YAGty6B3y7hosYCANlv9pOcSbmpoSwls2MGDOeRXI60Z6r1xRfBLbdA6VXrHmarmfuEIhd5RiBzv3MXGIodlYXzG2yUl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfedtgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeigfdtge
    eghfegjeeigfdvtdegtddttdeggefghffgtdelhedutedvteevgfffkeenucffohhmrghi
    nhepthhruhhsthgvughfihhrmhifrghrvgdrohhrghdpkhgvrhhnvghlrdhorhhgnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehk
    rhhorghhrdgtohhm
X-ME-Proxy: <xmx:2XP1YJT79hMUIcFgrRWrdYNU3hlviq_UztxCbhwsELyvRNJpr3I4BQ>
    <xmx:2XP1YFza4-ahwJCVsmT9jAtm9wVcfpLfFFF4g_pHhleZtwcuMuuwRA>
    <xmx:2XP1YH496ZpuJFc3NDWvq2-RYovmLwnGTy_v3W28CiYmIHGkpI7W0Q>
    <xmx:2nP1YA9XFbguIpIoOtI7ukF2YBolutL7ctLfOFjFLQiTFA8DeuFrfA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jul 2021 08:45:13 -0400 (EDT)
Date:   Mon, 19 Jul 2021 14:45:07 +0200
From:   Greg KH <greg@kroah.com>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable-4.19] PCI: aardvark: Fix kernel panic during PIO
 transfer
Message-ID: <YPVz0xkG/fT+lZoQ@kroah.com>
References: <20210716122504.22976-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210716122504.22976-1-pali@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 02:25:04PM +0200, Pali Rohár wrote:
> commit f18139966d072dab8e4398c95ce955a9742e04f7 upstream.
> 
> Trying to start a new PIO transfer by writing value 0 in PIO_START register
> when previous transfer has not yet completed (which is indicated by value 1
> in PIO_START) causes an External Abort on CPU, which results in kernel
> panic:
> 
>     SError Interrupt on CPU0, code 0xbf000002 -- SError
>     Kernel panic - not syncing: Asynchronous SError Interrupt
> 
> To prevent kernel panic, it is required to reject a new PIO transfer when
> previous one has not finished yet.
> 
> If previous PIO transfer is not finished yet, the kernel may issue a new
> PIO request only if the previous PIO transfer timed out.
> 
> In the past the root cause of this issue was incorrectly identified (as it
> often happens during link retraining or after link down event) and special
> hack was implemented in Trusted Firmware to catch all SError events in EL3,
> to ignore errors with code 0xbf000002 and not forwarding any other errors
> to kernel and instead throw panic from EL3 Trusted Firmware handler.
> 
> Links to discussion and patches about this issue:
> https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git/commit/?id=3c7dcdac5c50
> https://lore.kernel.org/linux-pci/20190316161243.29517-1-repk@triplefau.lt/
> https://lore.kernel.org/linux-pci/971be151d24312cc533989a64bd454b4@www.loen.fr/
> https://review.trustedfirmware.org/c/TF-A/trusted-firmware-a/+/1541
> 
> But the real cause was the fact that during link retraining or after link
> down event the PIO transfer may take longer time, up to the 1.44s until it
> times out. This increased probability that a new PIO transfer would be
> issued by kernel while previous one has not finished yet.
> 
> After applying this change into the kernel, it is possible to revert the
> mentioned TF-A hack and SError events do not have to be caught in TF-A EL3.
> 
> Link: https://lore.kernel.org/r/20210608203655.31228-1-pali@kernel.org
> Signed-off-by: Pali Rohár <pali@kernel.org>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Marek Behún <kabel@kernel.org>
> Cc: stable@vger.kernel.org # 7fbcb5da811b ("PCI: aardvark: Don't rely on jiffies while holding spinlock")
> [pali: Backported to 4.19 version]
> ---
> This patch is backported to 4.19 version. It depends on commit
> 7fbcb5da811b as presented on Cc: stable line.
> ---
>  drivers/pci/controller/pci-aardvark.c | 49 ++++++++++++++++++++++-----
>  1 file changed, 40 insertions(+), 9 deletions(-)

Now queued up, thanks.

greg k-h
