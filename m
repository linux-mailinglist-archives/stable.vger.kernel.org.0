Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2AE2351F5
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 14:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgHAMCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 08:02:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49443 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728609AbgHAMCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 08:02:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id E734B5C004B;
        Sat,  1 Aug 2020 08:02:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 01 Aug 2020 08:02:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ORzcYBFzwKhUt5cMMkHmLNVPkJ4
        6bxi1gj/+jznNyUw=; b=PNy9mGmNcZe0NhAN3ghnJB2OBjMeA3qetEsniKqS6T4
        5nNyVtpeY+2qSGKLx5S360OeMEnGvmLsvPk0v4HBLDr9fqUaW6fqBuwG1NYyEj/h
        2Wxbq6FQnDc4wHnHitELKfVpFJatyFxEJfnHkU7ktyOQAdIs9K3pGdNsmdHjkPkG
        AOZPNbmS+yGvCFq5RfTV74IlcPlYBnNIDKnJeSIwr6UYBlTnE5x27+fU0sFbZUNW
        OoFMyb2/sabmSONnp73mq4Bog5usYuXCbjAuWwhIyMNTEJmXSuUypqv/5RVuDcOH
        rLGNbZk4AjqSSDEae6mrqm1tZPKN4ooccfuUbt8r+pw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ORzcYB
        FzwKhUt5cMMkHmLNVPkJ46bxi1gj/+jznNyUw=; b=gCnUsktZCSMn39RI8Tjr4B
        yKYfkJOiAnUbouvDQBwV62YI224MaopWp+6RIa1k3crQfQV5IB9uKFpXB1p+PAq0
        Csj/6Y/1iZnejw2H0tp1FdChS8bf+D6GqZmgVXypn95Q0j2MBjSPkPw70yc1bNii
        hIUm4OGBO7piIOC8gOJveoNPh1Nskg5P6ixMaXoqE9596G6GdpYQ4yOt4hjr8blw
        B5+524NeoyGLNiWtY+Cdr5NfesGhSEokcB1Rtoz/dGX7RSU7KquZGdAGao1Oh986
        IxZ/jDTQ3uxap/bfrDqUXT2r2KOyvtRhrlb8/dqxgVWNkwiYN8QoLQV2hqqyA3IA
        ==
X-ME-Sender: <xms:1lklX68PKKNXzkacQwvse9CooFz7FTuwM3NoovcJJg7_aB2g6Y8SVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjedtgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:1lklX6sDcPXGhg7PjlRdjfMHR1R065K_nJyCk2bUM5UU1GiYRotiOw>
    <xmx:1lklXwCKAcd_ROv1sAWtcyAax5KX8UnsNWDoR3u9DGhooqWMED5bSg>
    <xmx:1lklXycuh5pm32Jp2rvgg8TigSFZu77BKnajn-Bts7l_HGBnrOmRfw>
    <xmx:1lklXxXnNbZ6MFHA0WwrZo7r736EdjJH7mHV05IkSLY-R9XIX1aDSg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4363330600A3;
        Sat,  1 Aug 2020 08:02:30 -0400 (EDT)
Date:   Sat, 1 Aug 2020 14:02:13 +0200
From:   Greg KH <greg@kroah.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     stable@vger.kernel.org, Pi-Hsun Shih <pihsun@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 4.19] wireless: Use offsetof instead of custom macro.
Message-ID: <20200801120213.GA382353@kroah.com>
References: <20200731210255.3821452-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731210255.3821452-1-ndesaulniers@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 31, 2020 at 02:02:55PM -0700, Nick Desaulniers wrote:
> From: Pi-Hsun Shih <pihsun@chromium.org>
> 
> commit 6989310f5d4327e8595664954edd40a7f99ddd0d upstream.
> 
> Use offsetof to calculate offset of a field to take advantage of
> compiler built-in version when possible, and avoid UBSAN warning when
> compiling with Clang:
> 
> ==================================================================
> UBSAN: Undefined behaviour in net/wireless/wext-core.c:525:14
> member access within null pointer of type 'struct iw_point'
> CPU: 3 PID: 165 Comm: kworker/u16:3 Tainted: G S      W         4.19.23 #43
> Workqueue: cfg80211 __cfg80211_scan_done [cfg80211]
> Call trace:
>  dump_backtrace+0x0/0x194
>  show_stack+0x20/0x2c
>  __dump_stack+0x20/0x28
>  dump_stack+0x70/0x94
>  ubsan_epilogue+0x14/0x44
>  ubsan_type_mismatch_common+0xf4/0xfc
>  __ubsan_handle_type_mismatch_v1+0x34/0x54
>  wireless_send_event+0x3cc/0x470
>  ___cfg80211_scan_done+0x13c/0x220 [cfg80211]
>  __cfg80211_scan_done+0x28/0x34 [cfg80211]
>  process_one_work+0x170/0x35c
>  worker_thread+0x254/0x380
>  kthread+0x13c/0x158
>  ret_from_fork+0x10/0x18
> ===================================================================
> 
> Signed-off-by: Pi-Hsun Shih <pihsun@chromium.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Link: https://lore.kernel.org/r/20191204081307.138765-1-pihsun@chromium.org
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
> Fix landed in v5.7-rc1. Thanks to James Hsu of MediaTek for the report.

What about 5.4.y?  Why ignore that tree?  You can not have people moving
from an older stable to a newer stable tree and have regressions :(

I'll queue it up there, but be more careful next time please.

greg k-h
