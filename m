Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3824342BAA8
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 10:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhJMImN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 04:42:13 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:58657 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhJMImN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 04:42:13 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MlfCm-1n0Jtz0Nso-00inTn; Wed, 13 Oct 2021 10:40:09 +0200
Received: by mail-wr1-f43.google.com with SMTP id o20so5683495wro.3;
        Wed, 13 Oct 2021 01:40:08 -0700 (PDT)
X-Gm-Message-State: AOAM531XZ+akxFDnC9pNLL8QnAfsTzc+/qTNCcHliS7C1weqMeOM0oJB
        jBaIhr/zeJ55KEGm5LWuQbKsHk1CRYN4fsbVNqc=
X-Google-Smtp-Source: ABdhPJylEmhtr82il6e0GF5LoTKEaSZZhYHzvRZQ/fSCmQWwST+wPLckjIEh7n69i2viC66dywxL9rWDe+r1YR2RU7w=
X-Received: by 2002:a05:600c:208:: with SMTP id 8mr11068365wmi.173.1634114408630;
 Wed, 13 Oct 2021 01:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211013005603.700363-1-sashal@kernel.org>
In-Reply-To: <20211013005603.700363-1-sashal@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 13 Oct 2021 10:39:52 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0DogjF=AeTD8hv++ns9j8zh_5u1W0Vcusqxe4srnrp8w@mail.gmail.com>
Message-ID: <CAK8P3a0DogjF=AeTD8hv++ns9j8zh_5u1W0Vcusqxe4srnrp8w@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 1/6] ARM: config: mutli v7: Reenable FB dependency
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>, Joel Stanley <joel@jms.id.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alexandre TORGUE <alexandre.torgue@foss.st.com>,
        Thierry Reding <treding@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Olivier Moysan <olivier.moysan@st.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:vwlE9709mGLvJbfWkWawOMIZpg+f3UuBbyoU6r85lZNo7V5xe5l
 jyP129R2Rs5G0Q1HFSfLZhLiJRigXNkmNjsrZu5H783RxBISlb2PSzmq7B4CXn6j3DZMtA8
 bL22LD8s79uOWzjmZ/R7wX3xBxDW3Qwiy08auy4nCetX29K+NM53ZzqIOz4WBTZBOpearC3
 CZcxiXodOq6cJHnKidF+A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0saA689E8fI=:xq2t3z5W/aM/lkzk2UktRM
 aooD0yek1cWWU+QliSC3GrqPfrSw1MfYiJp2e08t9FBB/3l41UBgfqYWxoyAuGbEiDk9Gvvig
 4LKi7fge/eOp4pHot2mB4wnu7UJvpYdLVFu9rhRyAboVKT2m1O0ppKHwdFuSmgxA81C6cJgVq
 bs7eXxthsCN49hu4xbiWp0Np36ONV2cP0eSmfP2A/P5VSRvEDeUluO/dresuv5MusVfcxcS+n
 on3z8QZ+tXK25uc18F0w+D4daT1rnvRXQdHshBEX4hVKigzE1XpeQf7x6bkAlh9l76Jtpey2g
 cc75o89HHe1GByFHBJASLbcM4Vr5o3dJN3Yj3g+32V8g9DFANziA+HlOQZ4E83vzTCVHMn4S0
 24eulTfJqBV3OJs+jD24FGQJwRP36O26CA/+Kmju1KlKVVy2AIcw9zffhqDLf4e8tW3AwCfkL
 hUJ3WKkFjbXyrSd+9y64IUgg8OiwwM8uec1Po+YLwTrdwxnZoD1tm4RNfzz9FP5u90HurjtXb
 rp7UfzA+Jv6qUDcOrZj9vc7EJ6kQBlYbO1lh9BUKKhG14EThv0kzxPvIi0uraql4QhTDFJezB
 AkpNwb5SNkEjn6sZrL8KcZ40mF9oW+GA3b4tgTYP/ZmjZwpPl4g0i1pLZTwcZGhB/JxvK6GRU
 /gazfU+ck/9bUc+4spdHWwzfKBt67VcqvGWIMDIpK2MRjC3xSGl+mqI7Obh3ro6dRrFpb70qq
 02FczX+Qf2MVGeEE83L6jsiD9UWZ/rCtar5epLs9yfdrfhQ1VE9wP1X71p61qz5KzpW2vhSo8
 mVBhS5JOXQvtE/NiuBAA9ZaXwy+1km9a/xn4uMmzFnurvJfUEnCWRwSYq8aogFp8IPLINGp/x
 FhnaFsmSAVTvAUsuvAZA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 2:55 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Joel Stanley <joel@jms.id.au>
>
> [ Upstream commit 8c1768967e2733d55abf449d8abd6f1915ba3539 ]
>
> DRM_FBDEV_EMULATION previously selected FB and was default y as long as DRM
> was enabled. In commit f611b1e7624c ("drm: Avoid circular dependencies for
> CONFIG_FB") the select was replaced with a depends on FB, disabling the
> drivers that depended on it.
>
> Renable FB so we get back FB_EFI, FB_WM8505, FB_SH_MOBILE_LCDC, FB_SIMPLE and
> VIDEO_VIVID.
>
> It must be set to y and not a module as the test driver VIDEO_VIVID
> requires it to be built in.
>
> Link: https://lore.kernel.org/r/CAK8P3a18EdBKQdGDOZc9cPKsf=hY8==v2cO0DBE_tyd82Uq-Ng@mail.gmail.com
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This is only needed to fix regressions from f611b1e7624c, which made it into
v5.14. I don't think that patch should be backported, so neither
should this one.

       Arnd
