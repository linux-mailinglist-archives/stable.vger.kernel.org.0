Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878A7456C5F
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 10:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhKSJg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 04:36:57 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:59497 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhKSJg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 04:36:57 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MVuXT-1nCv1r2q6n-00Rmk1; Fri, 19 Nov 2021 10:33:54 +0100
Received: by mail-wm1-f47.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so6998921wmd.1;
        Fri, 19 Nov 2021 01:33:54 -0800 (PST)
X-Gm-Message-State: AOAM5318XE0ByAiTAooESxZs3/19Ww/qQe5jVT1jkd+RwruIP+NDk8s2
        hmfC5gnxrqlYP12NVc3tUU4qcz8s0R3C82+H+JY=
X-Google-Smtp-Source: ABdhPJw1mwMmaaalSUZfsyGJMMNGoqt3TH3nRf0QR2qofUjWuKGMPjn4bgvv2PCsNuyZRSDzHhKiiGQtZZ51tKuOedI=
X-Received: by 2002:a1c:1c1:: with SMTP id 184mr5024692wmb.1.1637314434318;
 Fri, 19 Nov 2021 01:33:54 -0800 (PST)
MIME-Version: 1.0
References: <20211115165428.722074685@linuxfoundation.org> <20211115165456.391822721@linuxfoundation.org>
 <9fdb2bf1-de52-1b9d-4783-c61ce39e8f51@kernel.org> <fd7132a4-a016-9bf2-bb08-616f5f9d6e85@kernel.org>
 <CAK8P3a3kE49BgyWozXH1rsxUr=ZDH1GM6r+nyeCRfe5r40QD_w@mail.gmail.com> <871r3cr08w.fsf@wylie.me.uk>
In-Reply-To: <871r3cr08w.fsf@wylie.me.uk>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 19 Nov 2021 10:33:38 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0W+U=82dGWZS7vSoGbnB+wmVVckSM2ppZyk_szhTYE+g@mail.gmail.com>
Message-ID: <CAK8P3a0W+U=82dGWZS7vSoGbnB+wmVVckSM2ppZyk_szhTYE+g@mail.gmail.com>
Subject: Re: [PATCH 5.15 808/917] drm: fb_helper: improve CONFIG_FB dependency
To:     "Alan J. Wylie" <alan@wylie.me.uk>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        "Acked-by: Jani Nikula" <jani.nikula@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:JYt/krPBUDafBvqRg8wdhj2Ce4MwgIGKFqvs6Ol/OQTtok0VAB5
 y/njoKZojueO0HWB1VUnt0cHP3jyTQEFL690ADf1WfbQbUPzgYWWF+9bJB95AVZ6uSv0NOI
 PPiCsKspTtZEJndgJUZMXFXQj1TGLgZh9gSoiBUPpDjeinYl5msPIn95CIZ09cIrdypf7gD
 cwHWQW7+KHS+FAbmnDk8w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QDLwKBmkI9o=:Hvs/+XwYCuh4t6/ROWCPIH
 unp80u224kmToOH8Qk9tB2OTTs3lcxaBND2ScPP20VkfXfPdVBG2fnOxmUT/rKQrwWz3lYp7P
 98CkxvFV/gHzKVtCz1P73BHubPGawwoyqzq0OEnsftUbAVgz4xDIGozU1LlB/d5yiVmP5nH+7
 kyZNc4204CZ6EDfpOyr3FbGBlNEBi/QnPYf3yiF8tRCNrF+Ac+JL/mcnS1qXdp2/OIXuny8Bk
 rqlRbLcsNGtwlXv6jApfy5KxikkpGz9UIkRz6+ffPWJ3mL2iqf36IeG9N+biCUvbidkkOfof4
 C05dBRUm/4gpepdST55mr5NT3FZSDL5lqGHdCBcfRq+g1Rcypg0Q+mLmj179zS5wQq5+pHHio
 TtlyXtEbvOuycu77TLhaMOo3WCgN1FnC4/JS0MirW9eYla6xQKOrjJlPKfq2Jdmv+MRIDZCJ/
 +Jxn/fumfHwhpGdBo01qIkv9dWbl0H7NBSpRG3hdnpfJIVl/7y3x1qOM3XXerZp/Z7VDCsM2A
 9KPg7RZrXeFJSB98F1SpD/EjoWs042+5QqkLSw9aPaM4ohKaOVSf7nLdNmzVpjWJIy22FTBSt
 eqtkLsPczMgdR/pFUxlvMBPpAR8bLxp3yxjRSr31ZgsLDHqcwA41BCGfH8T6opFvHTJwvBmmY
 nozR5cwEio/ZnEEDzQTDaCfeEthJCqEewrcmvITV/6kbT9/gV+W6o+77/R8k0JWpxo46iAk1l
 KCPlOB+jAQ8QM7UZwB/jXdNdkcI6U04sjHyhbb/lJLJ48vV5zWwLFmDd4myxAc2eiY+y07oBY
 8b2lPkVvqcmY9pvg76gTPdPvdqXdz/vhI97iIUJr9gdnM+CRKo=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 9:57 AM Alan J. Wylie <alan@wylie.me.uk> wrote:
>
>
> Arnd Bergmann <arnd@arndb.de> writes:
>
> > Ah right, I ran into a similar thing on my randconfig builds, this is
> > what I have
> > applied locally but wasn't completely sure about yet, it may need additional
> > 'select DRM_KMS_CMA_HELPER' to cover all instances:
>
> With 5.15.3, I had these errors on *one* of my boxes with Nvidia
> drivers when building the nvidia drivers
>
> Gentoo, nvidia-drivers-470.86
>
> ERROR: modpost: "drm_atomic_helper_update_plane" [/work/tmp/portage/x11-drivers/nvidia-drivers-470.86/work/kernel/nvidia-drm.ko] undefined!
> ERROR: modpost: "drm_atomic_helper_connector_reset" [/work/tmp/portage/x11-drivers/nvidia-drivers-470.86/work/kernel/nvidia-drm.ko] undefined!
> ERROR: modpost: "drm_atomic_helper_page_flip" [/work/tmp/portage/x11-drivers/nvidia-drivers-470.86/work/kernel/nvidia-drm.ko]

To be honest, I'm not overly stressed out about breaking external
modules. It is true that this driver only builds when CONFIG_DRM_KMS_HELPER
is set, so you end up having to enable some other driver that selects
it because the kernel doesn't know what symbols would be used.
If you enable CONFIG_TRIM_UNUSED_KSYMS, you'd likely get additional
problems here.

Before my patch, the kms helpers were selected by
CONFIG_DRM_FBDEV_EMULATION in your .config, but this made no
sense unless you also have a third-party module that uses it.

         Arnd
