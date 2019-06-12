Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F6B41E3B
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 09:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406162AbfFLHu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 03:50:56 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:37803 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405233AbfFLHu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 03:50:56 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E4B234DF;
        Wed, 12 Jun 2019 03:50:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 12 Jun 2019 03:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ibnfl+8xKs40HASLH7el8ogm6D7
        fXLbZYdTL2iD4vcQ=; b=NM/fZdYl0Cq1bfgm5IT3B33aeNuPMS9hmSYPmeq0S9j
        w3BAbcmccRBUibbsCfiA5Tdp4C6nu95MLTuBhOfTWSY9Lxw4Pr01G/PXJ9BmHPTu
        CZhHqKdfwZ48eA+TCne2DudbVUGFe98IBcb3ygWQDcNqNQkc1QPmftGP+1V41O9a
        GEBR5r9w+2OOtrAiI3vIffymQfS1bbeTqY867is3nUUjYvAI3U3MryBcGgniMnDa
        pg/15qArkkrq92CjbfLgaH57VpWgznJOqCb0hZyucjeh41Ag2TbuDDKpsGmwi2Y+
        FMxDSQV0cTLc9EikIjFSIsUQqj5ayUUkFF33Mjiaf1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ibnfl+
        8xKs40HASLH7el8ogm6D7fXLbZYdTL2iD4vcQ=; b=IrsdjC7SrNhyzj+rtqjnqJ
        pLm9ZNCrnbrm/xQrHkaXwGnkq87242dkM7dDNm0KjtOjvHyYyDHAi8OMvF3uY0Tk
        AVgshoX3D7J1rZ5IV+6ADil6dU/RLEAEVDrdTWZfLd+FTJRsFHgC7jFKJWIWv+y6
        mAYDmzL922KJaEdsHSAqrwR8Mq4LIjg/UfjoECWsNoBVFatWG2sQ2JwOqcpAHf0m
        5lFyFF+AjgeBbYhajo83Z+hN/ZO6P8nPvflwOHkvuXz8fmENAgz9GLQHHEogkD9u
        4EJUV+1n3xpJJCBTyRWYKHEZU4kWHfanfY1jLtjZBFK4jMSAXAznZjb6V+pxNWvw
        ==
X-ME-Sender: <xms:264AXXpbBEkp4MhaDU5UYOrIc7VBrG89WjfZtogX9pD5pE-ezWIrJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehiedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:264AXcS-AqMVU-L3-qlnj37Yp41RRi-n5xkH4r_kvBsvf-y07KbSvg>
    <xmx:264AXaMH4cXEa5APKJdr9xykdvrkr1u5RxiuTvvoUzy6_ROHiyqz-A>
    <xmx:264AXaiu95q0rZ3GtK1OJjjvbubARo8dGhgeTBAHAqj0RNiZX_7IsA>
    <xmx:264AXeBiKpIGaHkHLtj6qWbSf7hfvetUlu-XPhG9l3QX9E4b4YMSwg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C27878005C;
        Wed, 12 Jun 2019 03:50:50 -0400 (EDT)
Date:   Wed, 12 Jun 2019 09:50:49 +0200
From:   Greg KH <greg@kroah.com>
To:     Rolf Eike Beer <eb@emlix.com>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        stable@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 4.9.180 build fails =?utf-8?Q?wi?=
 =?utf-8?Q?th_gcc_9_and_'cleanup=5Fmodule'_specifies_less_restrictive_attr?=
 =?utf-8?Q?ibute_than_its_target_=E2=80=A6?=
Message-ID: <20190612075049.GB17662@kroah.com>
References: <259986242.BvXPX32bHu@devpool35>
 <CANiq72nfFqYkiYgKJ1UZV3Mx2C3wzu_7TRtXFn=iafNt+Oc_2g@mail.gmail.com>
 <20190606185900.GA19937@kroah.com>
 <3659495.RxnUGBN4mp@devpool35>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3659495.RxnUGBN4mp@devpool35>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 09:19:15AM +0200, Rolf Eike Beer wrote:
> Am Donnerstag, 6. Juni 2019, 20:59:00 CEST schrieb Greg KH:
> > On Thu, Jun 06, 2019 at 08:25:28PM +0200, Miguel Ojeda wrote:
> > > On Thu, Jun 6, 2019 at 5:29 PM Greg KH <greg@kroah.com> wrote:
> > > > And if you want this, you should look at how the backports to 4.14.y
> > > > worked, they did not include a3f8a30f3f00 ("Compiler Attributes: use
> > > > feature checks instead of version checks"), as that gets really messy...
> > > 
> > > I am confused -- I interpreted Rolf's message as reporting that he
> > > already successfully built 4.9 by applying a6e60d84989f
> > > ("include/linux/module.h: copy __init/__exit attrs to
> > > init/cleanup_module") and manually fixing it up. But maybe I am
> > > completely wrong... :-)
> > 
> > "manually fixing it up" means "hacked it to pieces" to me, I have no
> > idea what the end result really was :)
> > 
> > If someone wants to send me some patches I can actually apply, that
> > would be best...
> 
> Hi all,
> 
> the patch I actually used was this:
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 8fa38d3e7538..f5bc4c046461 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -129,13 +129,13 @@ extern void cleanup_module(void);
>  #define module_init(initfn)					\
>  	static inline initcall_t __maybe_unused __inittest(void)		\
>  	{ return initfn; }					\
> -	int init_module(void) __attribute__((alias(#initfn)));
> +	int init_module(void) __attribute__((__copy__(initfn))) __attribute__((alias(#initfn)));
>  
>  /* This is only required if you want to be unloadable. */
>  #define module_exit(exitfn)					\
>  	static inline exitcall_t __maybe_unused __exittest(void)		\
>  	{ return exitfn; }					\
> -	void cleanup_module(void) __attribute__((alias(#exitfn)));
> +	void cleanup_module(void) __attribute__((__copy__(exitfn))) __attribute__((alias(#exitfn)));
>  
>  #endif
>  
> 
> So the final question is: do we want 4.9.x to be buildable with gcc 9.x? If
> yes then we can probably get this patches into shape.

Eventually, yes, we (or at least I) will want to build 4.9.x with gcc
9.x.  We went through this same process for gcc 8.x as all of my builder
test machines switched their default version of gcc...

thanks,

greg k-h
