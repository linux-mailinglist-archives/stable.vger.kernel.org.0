Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8EF5E394
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfGCMOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:14:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49927 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbfGCMOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 08:14:20 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 478E22179E;
        Wed,  3 Jul 2019 08:14:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 03 Jul 2019 08:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=vwK6Q8IOXwBUxbpA5K+aNBubtye
        1Pz28M8e0HirqAyk=; b=H+7zuVGkf4MUkzUZujR95wAVCdZHQRH8ixLmehKGFFB
        7a5r/emF6u99EGs/vZ9xFWp9KjbFI+8SmA3zOJSI+n3AJqnfoRfT2ZbOyh/X3pdO
        KnRVgUlqW2F+GVPA0bwVocXiKXsfBZG6KjKSF065frWN42rJ8l7SqfEaMd17wpMq
        hbxC7fkbwxpFLt2By69p3lPL6zgjmUkWNK6x5t9zepdOJX5lHm7KE/Yn+ErG7yzy
        G6seHjzX7iHvmoLl/uhD/rsfXZINitv1dUypNPIXsETzgXBPAp3j/kwV+jcXC65E
        xpgWYGBCGsqxnQe8OYVhc5hrRtqS91otEuGGXD5HYiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vwK6Q8
        IOXwBUxbpA5K+aNBubtye1Pz28M8e0HirqAyk=; b=wqFLmTmAy5nLmiu5hlTzM0
        7EmfO5eFZOSc84azwpZwl8uD1qOhmm6NSHlJzkeIH6xE3256hSIKVL2jQYxvwqhi
        QQp5tPb08bxnt+SaL9K+ib0RH7JpAvnaYva+R34Df0MDx7DrC5laB+CFzM63Njta
        ZOV+/f1WVr4eLImVeq+vS58S7MKfC/xVrEu/FpMW1r0W/w3rBOxmi8qTEYcyOvou
        Bi4qyJjAhwWxiExa6EHszzqWTlwD5stt8BoRh5m7YSViO0o3xso1ImOrSbXWPnMD
        D4Fe3n6kL8lYdpFYk7S6iFxLD3kk1ZCOdCgwLvM8UCLby37bQt4FKmDo2jkGAPwQ
        ==
X-ME-Sender: <xms:GpwcXVPvp8889cUai2FFPISWj3wR_3Pw58GfC_weFFlK8ft96wDKQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfedtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepfhhrvggvuggvsh
    hkthhophdrohhrghdpkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledruddt
    jeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuve
    hluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:GpwcXd_vC78MOV-wOPpBegh5NxsvxU3bqUZxNSHm_xT3z-vQsMHIJw>
    <xmx:GpwcXfHk6yjr-CJ5EnFFpvIkLNPYjX_vhElcB3Yodia5jGU0yZMlIQ>
    <xmx:GpwcXUgRvyo0DtZbhfqkW5sBFE77EVAwWhJGYUuaVs52yQ-ahEegyg>
    <xmx:G5wcXb98uoqXZ1UPvia4n53Uesej5Q25vBnsufQe-9XZZY1oi8vHwQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A1448005A;
        Wed,  3 Jul 2019 08:14:18 -0400 (EDT)
Date:   Wed, 3 Jul 2019 14:14:16 +0200
From:   Greg KH <greg@kroah.com>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH stable-4.9+] drm/i915/dmc: protect against reading random
 memory
Message-ID: <20190703121416.GD7784@kroah.com>
References: <20190702192304.31955-1-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702192304.31955-1-lucas.demarchi@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 12:23:04PM -0700, Lucas De Marchi wrote:
> commit bc7b488b1d1c71dc4c5182206911127bc6c410d6 upstream.
> 
> While loading the DMC firmware we were double checking the headers made
> sense, but in no place we checked that we were actually reading memory
> we were supposed to. This could be wrong in case the firmware file is
> truncated or malformed.
> 
> Before this patch:
> 	# ls -l /lib/firmware/i915/icl_dmc_ver1_07.bin
> 	-rw-r--r-- 1 root root  25716 Feb  1 12:26 icl_dmc_ver1_07.bin
> 	# truncate -s 25700 /lib/firmware/i915/icl_dmc_ver1_07.bin
> 	# modprobe i915
> 	# dmesg| grep -i dmc
> 	[drm:intel_csr_ucode_init [i915]] Loading i915/icl_dmc_ver1_07.bin
> 	[drm] Finished loading DMC firmware i915/icl_dmc_ver1_07.bin (v1.7)
> 
> i.e. it loads random data. Now it fails like below:
> 	[drm:intel_csr_ucode_init [i915]] Loading i915/icl_dmc_ver1_07.bin
> 	[drm:csr_load_work_fn [i915]] *ERROR* Truncated DMC firmware, rejecting.
> 	i915 0000:00:02.0: Failed to load DMC firmware i915/icl_dmc_ver1_07.bin. Disabling runtime power management.
> 	i915 0000:00:02.0: DMC firmware homepage: https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/i915
> 
> Before reading any part of the firmware file, validate the input first.
> 
> Fixes: eb805623d8b1 ("drm/i915/skl: Add support to load SKL CSR firmware.")
> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
> Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190605235535.17791-1-lucas.demarchi@intel.com
> (cherry picked from commit bc7b488b1d1c71dc4c5182206911127bc6c410d6)
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> [ Lucas: backported to 4.9+ adjusting the context ]
> Cc: stable@vger.kernel.org # v4.9+

What about a 4.14.y and 4.19.y backport as well?   I can't take this
without those as we do not want people to upgrade and have a regression.

thanks,

greg k-h
