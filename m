Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30A760F4C9
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbiJ0KUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235405AbiJ0KU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:20:29 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9A71AF0A
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 03:20:21 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 23250320091D;
        Thu, 27 Oct 2022 06:20:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Oct 2022 06:20:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1666866020; x=1666952420; bh=nHOJfC5GUP
        r59MRGBvfUssiV7QcnEKTYqs1gUTySGuE=; b=pjHdI+QmfScx8CF3A3i00HNb4i
        GztQdCCoMdqoNWG6LwnXZAh3gkG3BJXC1QAdIgJF8fNEWg+vDB0VORg6/pq+9yGe
        wwKOy1D8cr48ZPxB4wpBLluDfm5fKoX26pp7iz15oEi09zChxCke92mXP4g/nibp
        oicImA0ceLcYpI2pmZA/nS0eBfJcgUqWsjByK8NAtJgiDmOy0YUrnsYjUORyChpN
        TwSobMd2mJUonuZgLSW1F+kL0OXC7GIVqx1FYm8KL+utCdAzeu++GCKimJ4Dn46C
        zfC1ItsImsXe5y4ldn/q1ZSgnK/c3xZ/DDdYiV/5DyAVll5yPz1DeyWj/EFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666866020; x=1666952420; bh=nHOJfC5GUPr59MRGBvfUssiV7Qcn
        EKTYqs1gUTySGuE=; b=Z01xPyMcHMEP8kz5PDGe4YeRo9p9H7ocEs75DWSYfmBO
        frYQCyRYPn+03kLW29dbZNkwBVxOYlOFR2vfiadldkDwGG5DEyd6tpjl8Y7fLnLU
        hylead4PljJfClnAqbCR5N7bvdf7zLAWw7OFPXp+aWOtzVJhW5B/2AQKuU8+qF8N
        /nJko1xiXEYl2IArYVvn+aAJKMFm+YNsvy2cxBWvY8meSaLmcNK8YVe0XXSor7z4
        RptsF0lRLBfqunFir+i2LfHCgRDuKlOBwWLNlQlTED7SuVFWOe30blIHPQpyz3hY
        OK86Nl5Or1QIyrcCuTngiKP2FxEYxFF9cJGN3tL5sw==
X-ME-Sender: <xms:ZFtaY_TCO5Zb384bUkIYIw5HgMmCqpPOhBRuf7izHgH45FW_VmXYzw>
    <xme:ZFtaYwxWf0Eyern9DbefaVS99IxasHYAIDjfr7BPKPMbtvf6lJKoXpkmAfJTc-W69
    Y3d5QVFrv233A>
X-ME-Received: <xmr:ZFtaY03D9vzMqW0XqCQipxNtFyo51b3dGq7sDQ7dQADB5Stv3Lip_GZL22CCqcdtbrHDLv-h2cuSD--BNJX-0OMpznK3XblC>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ZFtaY_DBZ35aIvHm4nuAWMaxL6AW6idL-AMd43v2xLX5m-GvySt-1Q>
    <xmx:ZFtaY4j37i9XRu5sHz00TEI5mC3lEl_xJGN8QhxdSNim3f36nM_scg>
    <xmx:ZFtaYzoxar0IQGJJ5XuIibSZOwE--Zuqw_-UrM5qcHweIsAT1dF50g>
    <xmx:ZFtaYwdhxFJLQCmJ1tHbSdLs0MgOjEvGAkU6rr1c7HadUxt-j2nBnQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 06:20:19 -0400 (EDT)
Date:   Thu, 27 Oct 2022 12:20:18 +0200
From:   Greg KH <greg@kroah.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5.10] perf/x86/intel/pt: Relax address filter validation
Message-ID: <Y1pbYl0639yV8EHO@kroah.com>
References: <20221026121510.4252-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026121510.4252-1-adrian.hunter@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 03:15:10PM +0300, Adrian Hunter wrote:
> commit c243cecb58e3905baeace8827201c14df8481e2a upstream
> 
> The requirement for 64-bit address filters is that they are canonical
> addresses. In other respects any address range is allowed which would
> include user space addresses.
> 
> That can be useful for tracing virtual machine guests because address
> filtering can be used to advantage in place of current privilege level
> (CPL) filtering.
> 
> Now for stable because a side effect is that this also fixes
> address filter validation for addresses in kernel modules.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://lore.kernel.org/r/20220131072453.2839535-2-adrian.hunter@intel.com
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  arch/x86/events/intel/pt.c | 63 ++++++++++++++++++++++++++++++--------
>  1 file changed, 50 insertions(+), 13 deletions(-)

Now queued up, thanks.

greg k-h
