Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E728454CAD
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 18:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238192AbhKQSCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 13:02:31 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:60889 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229678AbhKQSCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 13:02:30 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 3C9893200495;
        Wed, 17 Nov 2021 12:59:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 17 Nov 2021 12:59:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=B6QJljxm7uzt3IXxjjtyp53154b
        TTTeBAHyw6WLUca4=; b=ZHzJaqRdxbU0UIgqg955qhMluomLTegju6ZO1zGc1Eq
        /S1kZe2O76bHuqwJNgWhp/Gpz6RPQ+Uu+2tTMwD+QRhEMyixePDbVSihFOd3SxW/
        /7tV5og6A46BazYtJbESGIBf9obcSy3mFpMQQZA3+cP+pKs+ec2G3qxvIqRkQ8/S
        j4EFeHmG7eCikHIarR0+FA2BW8y+xMdWa5/GvBDwIQKPcbtEjEqq2KAbKjQ8Rf7H
        nT9hav7xH9ajuCFLFH6ic0Tw4Trx49G1x/tjubgAEzrDwuU1CgEoZszlLrpV1poW
        ts5QQ3XC5lY/eZsOSsbWS+rlBHIMGwetD+UO35x6WWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=B6QJlj
        xm7uzt3IXxjjtyp53154bTTTeBAHyw6WLUca4=; b=kqbn2JztIWPGUf4nRG6IlQ
        VxvMpDRTwlEnoCxXGmV74sgK/PrflM5TwEszZj0onzGjINJH4/ZW02fayRYs+l9P
        MbnD4HLembJZsTmVAPd9foJJ0axqXYvkFIcR+3l+UkWXPOqq1syvvFlzyJJN6bHz
        QFUK2QNIZ8dLlULjl+TLEp+JiGPsw2lZX0hf5B4HoMO8Bb5zMCSGJqxsTq7hhJT4
        6nWaZC4pZYHNKVWf72xs+dI/RDbyDVDeeh9qRYkY+zWZHCKpgJTOUAJoMEdJjSRV
        1gon2XHjcf47xJurL2cX3fTUzQX1ZwlDvq0MUyIwaIyPGSQnW8tBPABNJMtEegCQ
        ==
X-ME-Sender: <xms:AkOVYaw1I1abWxf9nc9KdTfXbftdZhtytrh3QqB1oCvd04rIuYbh7g>
    <xme:AkOVYWR-vDl3CtP_L97p4KEygFbkyLEw9m9Zyn3vNUxNg6s8kZpnqhtC0Nurk0ivY
    3kCPyFvN8TkOA>
X-ME-Received: <xmr:AkOVYcUAYCJrkLAVS8g2enas4pP5LdHLu-vczRzmL9YtDC5SL59G9793RPOXJPwAf1FPNkyS53aQWyzZDgQaX3GyQ5L_wDRN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfeeggddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehvedvje
    egfeektdeitdeikeetkeekveelhedtieehkeekkeeiueehvdfftdfgveenucffohhmrghi
    nheplhhinhhugidqmhhiphhsrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:AkOVYQi-ELTJfKAdJqjeMxHF_XVl65MfLLilRjkiOsPC1THpSkK8Bw>
    <xmx:AkOVYcDdfxFepePBtZr8LXTU3kkwZ_FQBlz_DXfg65tPQ_9c_wIYdA>
    <xmx:AkOVYRKHksIjCegq_auP15d-_jEx0syz0tE4-gS0swjLhrB3iHLzcQ>
    <xmx:AkOVYfPiwLViOXuikuitfEVI57wJQw925QoRezxGu_0TCI2DGoMxDA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Nov 2021 12:59:30 -0500 (EST)
Date:   Wed, 17 Nov 2021 18:59:20 +0100
From:   Greg KH <greg@kroah.com>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4] MIPS: Fix assembly error from MIPSr2 code used
 within MIPS_ISA_ARCH_LEVEL
Message-ID: <YZVC+Fm9DriBcgbT@kroah.com>
References: <alpine.DEB.2.21.2111152316210.19625@angie.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2111152316210.19625@angie.orcam.me.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 11:23:50PM +0000, Maciej W. Rozycki wrote:
> Fix assembly errors like:
> 
> {standard input}: Assembler messages:
> {standard input}:287: Error: opcode not supported on this processor: mips3 (mips3) `dins $10,$7,32,32'
> {standard input}:680: Error: opcode not supported on this processor: mips3 (mips3) `dins $10,$7,32,32'
> {standard input}:1274: Error: opcode not supported on this processor: mips3 (mips3) `dins $12,$9,32,32'
> {standard input}:2175: Error: opcode not supported on this processor: mips3 (mips3) `dins $10,$7,32,32'
> make[1]: *** [scripts/Makefile.build:277: mm/highmem.o] Error 1
> 
> with code produced from `__cmpxchg64' for MIPS64r2 CPU configurations 
> using CONFIG_32BIT and CONFIG_PHYS_ADDR_T_64BIT.
> 
> This is due to MIPS_ISA_ARCH_LEVEL downgrading the assembly architecture 
> to `r4000' i.e. MIPS III for MIPS64r2 configurations, while there is a 
> block of code containing a DINS MIPS64r2 instruction conditionalized on 
> MIPS_ISA_REV >= 2 within the scope of the downgrade.
> 
> The assembly architecture override code pattern has been put there for 
> LL/SC instructions, so that code compiles for configurations that select 
> a processor to build for that does not support these instructions while 
> still providing run-time support for processors that do, dynamically 
> switched by non-constant `cpu_has_llsc'.  It went in with linux-mips.org 
> commit aac8aa7717a2 ("Enable a suitable ISA for the assembler around 
> ll/sc so that code builds even for processors that don't support the 
> instructions. Plus minor formatting fixes.") back in 2005.
> 
> Fix the problem by wrapping these instructions along with the adjacent 
> SYNC instructions only, following the practice established with commit 
> cfd54de3b0e4 ("MIPS: Avoid move psuedo-instruction whilst using 
> MIPS_ISA_LEVEL") and commit 378ed6f0e3c5 ("MIPS: Avoid using .set mips0 
> to restore ISA").  Strictly speaking the SYNC instructions do not have 
> to be wrapped as they are only used as a Loongson3 erratum workaround, 
> so they will be enabled in the assembler by default, but do this so as 
> to keep code consistent with other places.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
> Fixes: c7e2d71dda7a ("MIPS: Fix set_pte() for Netlogic XLR using cmpxchg64()")
> Cc: stable@vger.kernel.org # v5.1+
> ---
> Hi,
> 
>  This is a version of commit a923a2676e60 for 5.4-stable and before (where 
> the SYNC instructions mentioned in the description have not been added yet 
> and hence the merge conflict).  No functional change, just a mechanical 
> update.  Verified to build.  Please apply.

Now queued up, thanks.

greg k-h
