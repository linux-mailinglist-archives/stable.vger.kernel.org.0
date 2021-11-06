Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC1B446FFE
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 20:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhKFTHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 15:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230234AbhKFTHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Nov 2021 15:07:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3286A61076;
        Sat,  6 Nov 2021 19:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636225493;
        bh=ZYJPSyegRon6WTuZ0TotF+GSWcBGvAP9XlxDfwuru4E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=C/IrsbqdA6xDxOog3h27cokuwO6kGeoRIHUj+KGHja3fdu3o2J7oy0RbzVAGWYfkp
         7lJiLsaDC62JZwkFxuQV+2SV4K+bd5oQIQ5yyc5fSJFBFR584gHwcFhoVpTwHizP2j
         EU7g09W6E7TCR5PgT5zVXQlNEGJqmzQTcA3GXj49evPzZYMonI22iKiPNkcyj9qYvH
         XAtUyGOsNI1mQ1zv3Kgtbr/CNVEn1USzTL2QKU9zqrYiOFMn5cWj7EZRbVYlrl6GU0
         5Th5/8mzavHryzVG0Zs3mrb/xQ6p2XPPxdZX1RZaVol2M8bQKNfDuofv5hPKgvoFv7
         SWnIixOYiX4Og==
Received: by mail-wr1-f54.google.com with SMTP id d3so19156203wrh.8;
        Sat, 06 Nov 2021 12:04:53 -0700 (PDT)
X-Gm-Message-State: AOAM530J0kOJCVXGM9/XqAstpWRm26LDGrXFRzQHhiMO/gWA1ZfGL09p
        0JvGe9ACiN5SrXRytvHv1RRK1O6y6zG9lpJiKj0=
X-Google-Smtp-Source: ABdhPJw8yr5DAkeCvIDzLjJ7eNOfBXoe0A3N2p7wC4yo2LrNd0lPGHaZfmAsE+vGDfBrhcJrCVRAWHL466hHDdOF58Q=
X-Received: by 2002:a05:6000:18c7:: with SMTP id w7mr84588115wrq.411.1636225491711;
 Sat, 06 Nov 2021 12:04:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211018140735.3714254-1-arnd@kernel.org> <20211106165944.vstqt3stm2tvudjq@earth.universe>
In-Reply-To: <20211106165944.vstqt3stm2tvudjq@earth.universe>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sat, 6 Nov 2021 20:04:35 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2k_PXEaJtM55D-uLALi6n-Lzsy9qeKfofhUSq3Oh1Ghw@mail.gmail.com>
Message-ID: <CAK8P3a2k_PXEaJtM55D-uLALi6n-Lzsy9qeKfofhUSq3Oh1Ghw@mail.gmail.com>
Subject: Re: [PATCH] ARM: drop cc-option fallbacks for architecture selection
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     Russell King <linux@armlinux.org.uk>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 6, 2021 at 5:59 PM Sebastian Reichel
<sebastian.reichel@collabora.com> wrote:
>
> Thanks, I ran into this issue after affected gcc release migrated to
> Debian testing. The patch makes the kernel compile again:
>
> Tested-by: Sebastian Reichel <sebastian.reichel@collabora.com>
>
> Would be great if this could become part of 5.16-rc1, which is
> usually used as base by subsystem maintainers.

I've added it to Russell's patch tracker now as

https://www.armlinux.org.uk/developer/patches/viewpatch.php?id=9156/1

       Arnd
