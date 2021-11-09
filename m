Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD0A44B4A1
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 22:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241787AbhKIV3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 16:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236380AbhKIV3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 16:29:22 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCE0C061764;
        Tue,  9 Nov 2021 13:26:35 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d24so397386wra.0;
        Tue, 09 Nov 2021 13:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vlKo5w9x+D85wXEXPjLoehYGmsBDEHyr3st4ToBwqBk=;
        b=NoDrXkxiu8IKcztUVYYtgG/X+OBDZQdXp8rNn5ejkzmsj9Axplw8vozy2aZbhv/wKU
         bvY/cemEXOimMbqy52rowjEQIT3ZfavCJH1aFjVneACIYcoIqTOOtAeUBiN5Arui4Msr
         3jfIgJm8t29PDrChFG2gR2+fvo63YcqCgn3IlWkuVcBGPCP8mz3tc1gje4w0Qlr5cbQK
         iKkISLIvypRGLHXDgJuAGvnBH3pGViiIBhj1KDWQ2p35AgMql9qjAVSBazvwEKmQW8rf
         5lElMrg6mUq2vsV3zxG0dIPju7Fw4f20uL8fQ5NknN8zswDmYqA2d9nySRJlXmcSGMsQ
         koiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vlKo5w9x+D85wXEXPjLoehYGmsBDEHyr3st4ToBwqBk=;
        b=dgdlBQRp7a1w04lEfbpP9AIMhqhssAgVeYcz6OhetBptHpoIYXpuxDP6CJkklMuIrU
         hFE+6CMwY7VtwwXKsq60PXjIcynst0SSPQFEfPWT37+zD0NpAHJ+reGg30DhGbaF50qU
         yuoFgECZB+PE817rP6b84QQkozZRAD8VMPRIy2DtHN7IoDTnwC+oSHZnRNs2eMoAd3Pe
         GwoM4dC13HLfJ69pAeu/HJErqzsWUI2ZO01Pr0axuup0tDdzr6Ago3kzt0cJ4GNi87ol
         3uaRj2kT5SV3CYrsgYmyC8MsHlN0RlGQmiZLQm0mWih5rhKLQp+DU4rbDHANH7KcP2fR
         sGbg==
X-Gm-Message-State: AOAM532KZHW6JZssFhViYdKMS0ZLUsp4ztLop6RWlCnlu8vkCUeUIPzg
        Kbm74dhMC7pZn53pBRT3XsAmirYyi+okOQ==
X-Google-Smtp-Source: ABdhPJwsDjSn9L8UsuKLVNiFX+mwEF7ymM+fXG46RhaJ29fqpBE3bV+etLLmVnj1uspjaJAv2UP9nA==
X-Received: by 2002:adf:fe8e:: with SMTP id l14mr13155392wrr.177.1636493194552;
        Tue, 09 Nov 2021 13:26:34 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id c79sm3872154wme.43.2021.11.09.13.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 13:26:34 -0800 (PST)
From:   Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
X-Google-Original-From: Salvatore Bonaccorso <salvi@eldamar.lan>
Date:   Tue, 9 Nov 2021 22:26:33 +0100
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Antonio Terceiro <antonio.terceiro@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Matthias Klose <doko@debian.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: drop cc-option fallbacks for architecture selection
Message-ID: <YYrniRV/HjMTgWR/@eldamar.lan>
References: <20211018140735.3714254-1-arnd@kernel.org>
 <20211106165944.vstqt3stm2tvudjq@earth.universe>
 <CAK8P3a2k_PXEaJtM55D-uLALi6n-Lzsy9qeKfofhUSq3Oh1Ghw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2k_PXEaJtM55D-uLALi6n-Lzsy9qeKfofhUSq3Oh1Ghw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sat, Nov 06, 2021 at 08:04:35PM +0100, Arnd Bergmann wrote:
> On Sat, Nov 6, 2021 at 5:59 PM Sebastian Reichel
> <sebastian.reichel@collabora.com> wrote:
> >
> > Thanks, I ran into this issue after affected gcc release migrated to
> > Debian testing. The patch makes the kernel compile again:
> >
> > Tested-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> >
> > Would be great if this could become part of 5.16-rc1, which is
> > usually used as base by subsystem maintainers.
> 
> I've added it to Russell's patch tracker now as
> 
> https://www.armlinux.org.uk/developer/patches/viewpatch.php?id=9156/1

Thanks.

FWIW, we uploaded in Debian 5.15.1 to experimental with the patch
applied, and the builds pass now: https://buildd.debian.org/status/logs.php?pkg=linux&arch=armhf

Regards,
Salvatore
