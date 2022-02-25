Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CCA4C402D
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 09:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235730AbiBYIej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 03:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235206AbiBYIej (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 03:34:39 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B8F247769;
        Fri, 25 Feb 2022 00:34:07 -0800 (PST)
Received: from mail-wm1-f50.google.com ([209.85.128.50]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MvryJ-1oGATC2KAR-00swa3; Fri, 25 Feb 2022 09:34:05 +0100
Received: by mail-wm1-f50.google.com with SMTP id p4so1213534wmg.1;
        Fri, 25 Feb 2022 00:34:05 -0800 (PST)
X-Gm-Message-State: AOAM531E/j6S13Yb+YVordzdIyMNOwY64v2CLQ+9k04WKi0/xa6c+JuP
        +4SyB2M8ymkZJNufNUcXUk395TidptYOiLwOOe0=
X-Google-Smtp-Source: ABdhPJxlT0ZeeZN0sp/wnlDP9vqKjX5249QxVFT0x3B4UnYiAZsJdwfn3z3PfGHyveoi2R5x9P4PLXraCF/IwsdQHuA=
X-Received: by 2002:a05:600c:4ecb:b0:37c:9125:ac03 with SMTP id
 g11-20020a05600c4ecb00b0037c9125ac03mr1654188wmq.98.1645778045094; Fri, 25
 Feb 2022 00:34:05 -0800 (PST)
MIME-Version: 1.0
References: <20220223135820.2252470-1-anders.roxell@linaro.org>
 <20220223135820.2252470-2-anders.roxell@linaro.org> <1645670923.t0z533n7uu.astroid@bobo.none>
 <1645678884.dsm10mudmp.astroid@bobo.none> <20220224171207.GM614@gate.crashing.org>
 <1645748601.idp48wexp9.astroid@bobo.none>
In-Reply-To: <1645748601.idp48wexp9.astroid@bobo.none>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 25 Feb 2022 09:33:49 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0feJOsKMNP0zCdPho5XdD+NXFceUTTe1X6dA9OdWQntQ@mail.gmail.com>
Message-ID: <CAK8P3a0feJOsKMNP0zCdPho5XdD+NXFceUTTe1X6dA9OdWQntQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] powerpc: fix build errors
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Segher Boessenkool <segher@kernel.crashing.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:V3M9SmkRnE9os/eykVVe88xc1Z4Z0/NijhamjVkFNGxnP9lcJNX
 XwYkh8mmSmoGRtLddGmzAMa4RkKZo3x9fRVOKsFKI2h6KQIfypCWZH/OoFIwW6CIYlwkdX+
 xhG6K/vKjSoprdke6bsrF2DrT0iuyxq2p7jYFczcuMKOFfk9sEGDOy9EH2BC3c3LEE1z8JS
 /Yh0OLOPlE+5PPsTWmg3g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qjY77EtsRBI=:8S4FHM4uubYJ99LtsrLa8B
 95RSBjhwuvOXrzuhBAYalx1kZMOnKHsnwNjzoI7ULwD/mJLuBZSFkrNYK4BKgFcpIM3BnIcmV
 oZ/pkhsMYr5qLRo7Uz922ynpd+jWlJxWTPxRlFF7Ef1z/2o3+LNxSl0SmsOGnelKZdoTw1Vpz
 Fs9drUBQpHI3n4SzV6ixubCWsPZ1hGSR+0iMxP8cik8cjvh9VQcuMqTMhM0divMhaftWA9woV
 waV6Iecdx4SaZvmfX55nzbAtyzeHd0wNGtYgjNH629Uqxn8i8QsyE8LnpQw7FFih9ZKfJuwxe
 HPBQBSNnrxf4wZwMryGIuwdNFjZ8Phpn6Dn1pviC9ZyccsfPbqqOK5xGRn/QM9uLPniVq5LEv
 skvcZ3Sg9ZjcaSkbq2OCztQAd7UbU+couHNroosYbS0GBap6vjKdpAihUJiPuG8wGyTiHwNYg
 +Qe2r5ZyTmXIbqux14fifBZa7uqPilmBVAtVXkhzZx9mndYFCXylEhJ/0oUjn9FeaJQWBCLub
 ELRYmFQOEW3lmWqzyCK75Q5CjbELnghinJ56oYZgGkQjJwqLBVkpSpZNrm0SihGkh3geUTkCd
 ToVxtm5yzGy1yZHq9xW+SPGLAx0e/7//EGhlKr9/MGXhGbBd2qt3+ioNkzchlcxy9UcHyjV3X
 K78RwYVU4XmuGvS4fQnpSMp+0fprcefS+lWQiaGbQMT4KyiT2fr4bZzgABL+3S5JkVWk612a4
 GtKcPsyud7xbf0oGPPlqYL0/z3sigKsNb8XFnZdbfQyq8Cbm9X0LyxrjFnp9Bmlsg3ZxRJgeO
 /r+5wk8g5okbMLeYlZ4BNWAJRqPQdybc+/ZdoZ8E7TrvZF1GG8=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 25, 2022 at 1:32 AM Nicholas Piggin <npiggin@gmail.com> wrote:
> Excerpts from Segher Boessenkool's message of February 25, 2022 3:12 am:
> >> +#ifdef CONFIG_CC_IS_GCC
> >> +#if (GCC_VERSION >= 100000)
> >> +#if (CONFIG_AS_VERSION == 23800)
> >> +asm(".machine any");
> >> +#endif
> >> +#endif
> >> +#endif
> >> +#endif /* __ASSEMBLY__ */
> >
> > Abusing toplevel asm like this is broken and you *will* end up with
> > unhappiness all around.
>
> It actually unbreaks things and reduces my unhappiness. It's only done
> for broken compiler versions and only where as does not have the
> workaround for the breakage.

It doesn't work with clang, which always passes explicit .machine
statements around each inline asm, and it's also fundamentally
incompatible with LTO builds. Generally speaking, you can't expect
a top-level asm statement to have any effect inside of another
function.

        Arnd
