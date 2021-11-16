Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC7F4527F2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356112AbhKPCuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:50:52 -0500
Received: from condef-06.nifty.com ([202.248.20.71]:29260 "EHLO
        condef-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357224AbhKPCsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 21:48:51 -0500
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Nov 2021 21:48:50 EST
Received: from conssluserg-06.nifty.com ([10.126.8.85])by condef-06.nifty.com with ESMTP id 1AG2a0cN030162
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 11:36:00 +0900
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 1AG2ZVw4001708
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 11:35:32 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 1AG2ZVw4001708
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1637030132;
        bh=w9ucYvmbJK2UcVWkC87lt9IyQEuDcwA3LqTtmfKqN3Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bWNbNyJfJM/L7B+XvXSDdHBvfhIKFaG5iFdmulhLjy/tP5QuAlgBC8MTA+QiD6jum
         4qxq6lbq0lSwZxouJ0FWB4R/9nVhPnVAiWmSVYH4SCLPMksQcWYmptvc91pqz971Xd
         2quY/xCFN3KKyWxILvTXzN39ac5aSPKv55SEIMPpqXWY4+6fWHEIrsA7jQ93UfEBX3
         qzTjxkUis/Fhs0OvyPvhIUjeHQ9zqpOfsbpDrdSg8vr8FHO5E6BYzZklUpVd7JQkhm
         TSfD5sy85cGZciQLYPFogkGzoMc4wmiV39RXE4XziG8YFD5+TVXWCNGOVAW8q6ri4S
         oMbPJN17LdPGQ==
X-Nifty-SrcIP: [209.85.210.177]
Received: by mail-pf1-f177.google.com with SMTP id g18so16704069pfk.5
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 18:35:32 -0800 (PST)
X-Gm-Message-State: AOAM530AAApM07Pvp+unsb3YvFJSM84oSMpVSgJ9XnSqJLIA815rIHVa
        Bl52d4i//Vz74bBXOHXAmBBY2M14eoL80SgUb5Y=
X-Google-Smtp-Source: ABdhPJx5o1jMUsFsuyYZeLm4uxP75CoLFptJwOvPzkyGmWz8BGY8IqE6l6bCatY2qp+ZzdYYZeEqV4maZGLNZ7kv4yY=
X-Received: by 2002:a65:530d:: with SMTP id m13mr2629803pgq.128.1637030131310;
 Mon, 15 Nov 2021 18:35:31 -0800 (PST)
MIME-Version: 1.0
References: <163697999651153@kroah.com>
In-Reply-To: <163697999651153@kroah.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 16 Nov 2021 11:34:54 +0900
X-Gmail-Original-Message-ID: <CAK7LNARBgWYht7bCcp3iYWdt=B-1zfnP0f0D4Utfmt3SgyipYQ@mail.gmail.com>
Message-ID: <CAK7LNARBgWYht7bCcp3iYWdt=B-1zfnP0f0D4Utfmt3SgyipYQ@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] MIPS: fix *-pkg builds for loongson2ef
 platform" failed to apply to 5.14-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jason Self <jason@bluehome.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Nov 15, 2021 at 9:40 PM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.


I fixed the conflict, and just submitted it as:

   [PATCH stable 5.14.y] MIPS: fix *-pkg builds for loongson2ef platform

Thanks.




> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 0706f74f719e6e72c3a862ab2990796578fa73cc Mon Sep 17 00:00:00 2001
> From: Masahiro Yamada <masahiroy@kernel.org>
> Date: Wed, 10 Nov 2021 00:01:45 +0900
> Subject: [PATCH] MIPS: fix *-pkg builds for loongson2ef platform
>
> Since commit 805b2e1d427a ("kbuild: include Makefile.compiler only when
> compiler is needed"), package builds for the loongson2f platform fail.
>
>   $ make ARCH=mips CROSS_COMPILE=mips64-linux- lemote2f_defconfig bindeb-pkg
>     [ snip ]
>   sh ./scripts/package/builddeb
>   arch/mips/loongson2ef//Platform:36: *** only binutils >= 2.20.2 have needed option -mfix-loongson2f-nop.  Stop.
>   cp: cannot stat '': No such file or directory
>   make[5]: *** [scripts/Makefile.package:87: intdeb-pkg] Error 1
>   make[4]: *** [Makefile:1558: intdeb-pkg] Error 2
>   make[3]: *** [debian/rules:13: binary-arch] Error 2
>   dpkg-buildpackage: error: debian/rules binary subprocess returned exit status 2
>   make[2]: *** [scripts/Makefile.package:83: bindeb-pkg] Error 2
>   make[1]: *** [Makefile:1558: bindeb-pkg] Error 2
>   make: *** [Makefile:350: __build_one_by_one] Error 2
>
> The reason is because "make image_name" fails.
>
>   $ make ARCH=mips CROSS_COMPILE=mips64-linux- image_name
>   arch/mips/loongson2ef//Platform:36: *** only binutils >= 2.20.2 have needed option -mfix-loongson2f-nop.  Stop.
>
> In general, adding $(error ...) in the parse stage is troublesome,
> and it is pointless to check toolchains even if we are not building
> anything. Do not include Kbuild.platform in such cases.
>
> Fixes: 805b2e1d427a ("kbuild: include Makefile.compiler only when compiler is needed")
> Reported-by: Jason Self <jason@bluehome.net>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>
> diff --git a/arch/mips/Makefile b/arch/mips/Makefile
> index ea3cd080a1c7..f7b58da2f388 100644
> --- a/arch/mips/Makefile
> +++ b/arch/mips/Makefile
> @@ -254,7 +254,9 @@ endif
>  #
>  # Board-dependent options and extra files
>  #
> +ifdef need-compiler
>  include $(srctree)/arch/mips/Kbuild.platforms
> +endif
>
>  ifdef CONFIG_PHYSICAL_START
>  load-y                                 = $(CONFIG_PHYSICAL_START)
>


-- 
Best Regards
Masahiro Yamada
