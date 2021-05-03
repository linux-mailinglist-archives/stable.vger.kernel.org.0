Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F5037203E
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 21:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhECTSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 15:18:23 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:60277 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhECTSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 May 2021 15:18:23 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N95qT-1lSUUJ0vw7-016BEv for <stable@vger.kernel.org>; Mon, 03 May 2021
 21:17:28 +0200
Received: by mail-wr1-f42.google.com with SMTP id z6so6752631wrm.4
        for <stable@vger.kernel.org>; Mon, 03 May 2021 12:17:28 -0700 (PDT)
X-Gm-Message-State: AOAM530Tt9MUyZI9jzJyX0qxsnWp2eVnsNnNNUWoIqbMFpVCm/sIgzNa
        rnhtDjqYxSxlMMScA9jKFBOAVrPacs7ZG1cS8cI=
X-Google-Smtp-Source: ABdhPJxeaqynZXoeue3wCqk5dBIDSGPfaE+Td6YHgoCDhLjegY+5XAYM20GsGHL9RWdcvPLDt8OFuABmzWT6FQFKFIg=
X-Received: by 2002:a5d:4452:: with SMTP id x18mr27443363wrr.286.1620069447928;
 Mon, 03 May 2021 12:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <202105030311.xWwkyV9z-lkp@intel.com> <CAK8P3a0ZdZY94KVwF-C_t+7rx=iHC60ty52AQAmc1VDZwsn9Rw@mail.gmail.com>
 <CAKwvOdmCmvHNpyjNtNU1OeSzK_E_9n9T4CPiFGD7K_JuJDOj-w@mail.gmail.com>
In-Reply-To: <CAKwvOdmCmvHNpyjNtNU1OeSzK_E_9n9T4CPiFGD7K_JuJDOj-w@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 3 May 2021 21:16:42 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3KLasm-CdcM3HCP6EZO1Vr0ay17jw7zSy0btqPr32WRg@mail.gmail.com>
Message-ID: <CAK8P3a3KLasm-CdcM3HCP6EZO1Vr0ay17jw7zSy0btqPr32WRg@mail.gmail.com>
Subject: Re: [stable:linux-5.4.y 5541/6083] ERROR: "__memcat_p"
 [drivers/hwtracing/stm/stm_core.ko] undefined!
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Sasha Levin <sashal@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:LetEelgOooX/rHr2DOT/78bMtKxcCmdnh/75dIybhTBZNZl6v6J
 oLy8fVhdyMdWRWlny+gUg5UdP1mtzzBa4MsbpfTp+RDfm1PBeko8Z6SVv+iQ7xyUpM4JjYk
 whxG8tCvkzJJb7gq0wMmR1L8pG7uhMhe/Q2i6ssUMwKdpf0O8Ruf7dMnxTHEwd06//P1u/I
 zkpk/SNtfYUkz2HUATH1g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HDEONmb/fb0=:fvGiR+bIYVss9PuNt6X1SN
 krKe45GgTBl7HsL3tzHFbk21C7lZC8r9fb+xIB+tS2TUcbI3I99F6iRQdlPvc+0BVel1mZzr6
 iTI5Sypn2Bs0Fo4NDrZm0IDmcCwAz683YXdRLan4rZCbn0IcO4RcFFrl04Xld1m4ZlFVlC4Rt
 0jNEecBC1+PwA6wNglBBnB3wkMJnBEZk81QEQeaMAimU46v1Ku6EPDBfL+xwJN1MU/VmHEXEI
 Zqo7/NB7JZstj++/kJtTfn7mBUdEr6hKkKXzzpF0dcMsffiE/9mA3Vq/Kx1z+hqy+KohKgXST
 ESEETOpiPXMCx+KcaVKw9bIDNpN39JXuhu/UtJU+GI3mK0etc260U5/Bk9S1tEmmQQX4tpSOK
 6W8Cpn/fxZIM89xcVdCIO7/bj+VcCut65uLBa22nwcKD7uLPtnUSdvmCCjNGef/ncLlf1QmSO
 2kofhEA71923JctceAivfrEumH1zk0hRoiqRfLGX5vGgKMRckERGzlFlMhspBFbgJZtjamoZg
 A0gmq7Qr68L3knB6RALsNt7qwPm2CTxLKOgfV2+HqU006RwsLM7XkE9hbN583araFAtFyfOFp
 v8W3IKz2J+cepianD7n4jDM8zgt64tg0v5hH9Uisac7bwiz7RBpcN43o8PpPhzTNViv4Hm+2p
 Bt2o=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 3, 2021 at 7:00 PM 'Nick Desaulniers' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
> > > >> ERROR: "__memcat_p" [drivers/hwtracing/stm/stm_core.ko] undefined!
> >
> > I'm fairly sure this is unrelated to my patch, but I don't see what
> > happened here.
>
> It's unrelated to your patch. It was fixed in 5.7 by
> 7273ad2b08f8ac9563579d16a3cf528857b26f49 and a few other dependencies
> according to https://github.com/ClangBuiltLinux/linux/issues/515.
>

Ah right, the big hammer.

Greg, not sure what we want to do here. Backporting

7273ad2b08f8 ("kbuild: link lib-y objects to vmlinux forcibly when
CONFIG_MODULES=y")

to v5.4 and earlier would be an easy workaround, but it has the potential
of adding extra bloat to the kernel image since it links in all other
library objects as well.

        Arnd
