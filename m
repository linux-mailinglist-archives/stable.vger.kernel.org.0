Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5115E638068
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 22:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiKXVHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 16:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKXVHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 16:07:03 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE788FB13
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 13:07:02 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id EF5613200A6B;
        Thu, 24 Nov 2022 16:06:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 24 Nov 2022 16:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1669324018; x=1669410418; bh=8CEj2REjt/
        Cpu9PVrcS0Ej8RlkM0BRcAByk9q/BqXCU=; b=saKmVkfpZdHEX5KQDqmUxhnhIP
        F4zPAv7kBxLWx654QigXeb/aWQkonkpQB/pwniedEPvG8pxx3M/PurZ24xkA4TZj
        FQIw9t+eNUI/Ya7YTTcLeYEFu3U8R9chwFmA6ay65Ne+DSM3I8ldTp3wNPP79ony
        5ZkTJEkJwAttKgy3stgRjnOmLzy92wN5R2shi3HlIPVIWXrwo1qWHAmtxQ2s59Yc
        FpgCXHupmVtw/uexzpbsNs5ubkHuiqQTOeRU8I0E+ojCLHjsk7LwV77jp5KdwEk3
        76oy6CnmOuddIS+aXP/VCQqnOWX8Mg6N8YoPYpAuysSBYNi/Fbe4dQncx95w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669324018; x=1669410418; bh=8CEj2REjt/Cpu9PVrcS0Ej8RlkM0
        BRcAByk9q/BqXCU=; b=RyI2/btNOsKbFyTyHllXwmdgsgr0SQJJlNsUpq69LXbp
        VVcju08yMZlRZz5g1F0bYJ66vfmMp0K/vsl6/n9fNuAuWNYzzSrnobZl3xaCtbFP
        rm6xfk2zkjiQJgMYkScogUKGADUre3FaRMVgXnqDuqctCAr42eXl+mo9+bY+P2oC
        eOQshYWkT4kpsE2w6gzqaqq/rK1MX0Q93HF6+IdYfzsrI9joiruueGYMOYmPH/xv
        AZBCqG9IqpiqP5WDoI0mtwnI3DA70DZW72kj+F5oh9grBIwHCdkqIUa+e2GQUinj
        3CzGCebcDAEqNmWDxpWyc428/7RxrcSUKTDHeK+Siw==
X-ME-Sender: <xms:8tx_Y008CyJxDq6suS6TQP6_AI6pAAYODdLbjc413_nyPhCAkWXWgw>
    <xme:8tx_Y_H25zusX9iZphZJ1BgtLRpIBW32ye6T_m78nWmBTGW_ySTfUC3odnhZkygeV
    m1ameFRdFOOOg>
X-ME-Received: <xmr:8tx_Y84CLYWK464bAh0CwhLUMCddtP_ozrXuZSmluzrMs668weHa7q4I96Gvlmfly_m_Dh8GCSWngsIqmcvPRLJOrHHuHZUx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrieefgddugeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:8tx_Y92xeqODs91Ot-CHQfBlFmgDH1WjNji57QJhbePcuq7B5vrIjw>
    <xmx:8tx_Y3ENCrF0RI26tTUG_KsOObWLC3uUG-LPSeTMBcqLIgYs_juHCw>
    <xmx:8tx_Y2_bbUwylathgJkWWJhl--JUsqwdU2G26zzkfQyJonY8ZiK-OQ>
    <xmx:8tx_Y__dQg-VST0nsJSzyiwqBW4MS7DqAwrFPl4FfokqTnLbhI3LiQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Nov 2022 16:06:57 -0500 (EST)
Date:   Thu, 24 Nov 2022 22:06:55 +0100
From:   Greg KH <greg@kroah.com>
To:     John Aron <john@aronetics.com>
Cc:     stable@vger.kernel.org, 'Mark Salter' <mark.salter@canonical.com>,
        Mark Lewis <mark.lewis@canonical.com>,
        regressions@lists.linux.dev, kernelnewbies@kernelnewbies.org
Subject: Re: OBJTOOL Build error
Message-ID: <Y3/c73nZVdHCBdZo@kroah.com>
References: <041601d90035$4f738de0$ee5aa9a0$@aronetics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <041601d90035$4f738de0$ee5aa9a0$@aronetics.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 24, 2022 at 01:48:08PM -0500, John Aron wrote:
> Hello -
> 
>  
> 
> I have an idea of where to begin: our kernel code compiles and works on Red
> Hat, CentOS, and Fedora. In Ubuntu 20.04, I have an error.
> 
>  
> 
> root@form:/home/john/thor-linux/Kernel/ubuntu20.04# make
> 
> rmmod: ERROR: Module thor is not currently loaded
> 
> make: [Makefile:7: all] Error 1 (ignored)
> 
> make[1]: Entering directory '/usr/src/linux-headers-5.4.0-131-generic'
> 
>   CC [M]  /home/john/thor-linux/Kernel/ubuntu22.04/thor.o
> 
> /home/john/thor-linux/Kernel/ubuntu22.04/thor.o: warning: objtool:
> _Controller_process_response_map()+0x1b3:    unreachable instruction
> 
>   Building modules, stage 2.
> 
>   MODPOST 1 modules
> 
>   CC [M]  /home/john/thor-linux/Kernel/ubuntu22.04/thor.mod.o
> 
>   LD [M]  /home/john/thor-linux/Kernel/ubuntu22.04/thor.ko
> 
> make[1]: Leaving directory '/usr/src/linux-headers-5.4.0-131-generic'
> 
> make[1]: Entering directory '/usr/src/linux-headers-5.4.0-131-generic'
> 
>   CLEAN   /home/john/thor-linux/Kernel/ubuntu22.04/Module.symvers
> 
> make[1]: Leaving directory '/usr/src/linux-headers-5.4.0-131-generic'
> 
> #@sudo dmesg -C
> 
> #@sudo insmod /usr/local/etc/thor.ko
> 
> filename:       /usr/local/etc/thor.ko
> 
> version:        0.1
> 
> description:    THOR KMOD
> 
> author:         Aronetics
> 
> license:        GPL
> 
> srcversion:     BC856FA85DB2FEFD38A1B2A
> 
> depends:
> 
> retpoline:      Y
> 
> name:           thor
> 
> vermagic:       5.4.0-131-generic SMP mod_unload modversions
> 
> #@sudo dmesg
> 
> root@form:/home/john/thor-linux/Kernel/ubuntu20.04#
> <mailto:root@form:/home/john/thor-linux/Kernel/ubuntu20.04#> 
> 
>  
> 
> Every 2.0s: tail -n30 /var/lib/dkms/thor/1.0.1/build/make.log
> 
>  
> 
> DKMS make.log for thor-1.0.1 for kernel 5.4.0-131-generic (x86_64)
> 
> Thu 24 Nov 2022 01:10:33 PM EST
> 
> make: Entering directory '/usr/src/linux-headers-5.4.0-131-generic'
> 
>   CC [M]  /var/lib/dkms/thor/1.0.1/build/thor.o
> 
> /var/lib/dkms/thor/1.0.1/build/thor.o: warning: objtool:
> _Controller_process_response_map()+0x1b3: unreachable instruction
> 
>   Building modules, stage 2.
> 
>   MODPOST 1 modules
> 
>   CC [M]  /var/lib/dkms/thor/1.0.1/build/thor.mod.o
> 
>   LD [M]  /var/lib/dkms/thor/1.0.1/build/thor.ko
> 
> make: Leaving directory '/usr/src/linux-headers-5.4.0-131-generic'
> 
>  
> 
> Is this an error in objtool on Ubuntu within
> /usr/src/linux-headers-5.4.0-${26-130}/tools/objtool ?

Do you have a pointer to your code anywhere?  Do you have .S files in
it, or is it all C files?

And did you ask the Canonical developers about this?  You should have a
support contract you are paying for with them, so why not use that?

thanks,

greg k-h
