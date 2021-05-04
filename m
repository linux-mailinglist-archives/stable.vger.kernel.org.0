Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65BC37292F
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 12:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhEDKrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 06:47:46 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:39527 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhEDKrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 06:47:45 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MirfI-1l1X5020NI-00eqyX for <stable@vger.kernel.org>; Tue, 04 May 2021
 12:46:46 +0200
Received: by mail-wm1-f49.google.com with SMTP id o26-20020a1c4d1a0000b0290146e1feccdaso963033wmh.0
        for <stable@vger.kernel.org>; Tue, 04 May 2021 03:46:46 -0700 (PDT)
X-Gm-Message-State: AOAM5334g0dk+7hFxCg3vfEgbb9HMEsXd3XgYWk5e2vJJwYSDijX621H
        33P0MOn6/LRVVsG3g42me9rnN5XxMOtkwkTGsNY=
X-Google-Smtp-Source: ABdhPJxxvpkCwRwFPdnc23Ys4QJ86ZELb0JsnYM/xw8nlHedObKlO3IGhvdzUM1POww/j16K71WLnDJx67/ZcANfApQ=
X-Received: by 2002:a7b:c344:: with SMTP id l4mr3204841wmj.120.1620125206188;
 Tue, 04 May 2021 03:46:46 -0700 (PDT)
MIME-Version: 1.0
References: <202105030311.xWwkyV9z-lkp@intel.com> <CAK8P3a0ZdZY94KVwF-C_t+7rx=iHC60ty52AQAmc1VDZwsn9Rw@mail.gmail.com>
 <CAKwvOdmCmvHNpyjNtNU1OeSzK_E_9n9T4CPiFGD7K_JuJDOj-w@mail.gmail.com>
 <CAK8P3a3KLasm-CdcM3HCP6EZO1Vr0ay17jw7zSy0btqPr32WRg@mail.gmail.com>
 <YJDQ0ePGHxmcB7dX@kroah.com> <CAK8P3a30xJ1+zrCC4fk+q9xzLspHuE4VM0UHSWiU3-iFeNN+6g@mail.gmail.com>
 <YJEFF1iHZ4o7LUgV@kroah.com>
In-Reply-To: <YJEFF1iHZ4o7LUgV@kroah.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 4 May 2021 12:46:05 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2-ttarw-31YTbq1YbwAxvG3HwouKC9u1YjfyQwMhwovw@mail.gmail.com>
Message-ID: <CAK8P3a2-ttarw-31YTbq1YbwAxvG3HwouKC9u1YjfyQwMhwovw@mail.gmail.com>
Subject: Re: [stable:linux-5.4.y 5541/6083] ERROR: "__memcat_p"
 [drivers/hwtracing/stm/stm_core.ko] undefined!
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Sasha Levin <sashal@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:KmSyDHJ53UaqsH7ef7Oiaer9tGYxbNcQZTMPoQwtiwiWCbo5Rh4
 hGF3yDwuVlvrlWa5CLRj7BZYxZfTWfhLyt5SVtQNY82mWmfrspGber9wnz6VDIoZvQbIBlr
 INMuTCI5qP5348+MT/BgQmMTXB02/OT/zRaHNcgdUITJqGZtdJznZPwphSoeDoq/Ys8T2p8
 0gzGZqjnehkmVq5aUtBFw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qzidNzaStyg=:blc6QEHqFvgnrzJtoutiP4
 XkTEj4D4zf53MApZereDXimF+lyKupIC6fZNmBiw549UatdoKkCzMlV+6foH2gNB2tNyJ4KCC
 Cq2yfS33HeuudSNulhxn3qq+tIWSWS1O63+BWqU2hifjWo73ZWQP9b9s58wkkMz+lXIkTzm5c
 2zywMmX3CtKREO9OXi5T7+Jw4ePtkO4KzAms5ZnvN1L3VLXY02bh0dulE89D5O7kxUH4cZTU3
 UJl4Bs9f+F/fwWsGiwSFc0QF2dcDraukAeyMfXMPoyRohAURIm5WUtfCfG6hqqlQVuqEEah7T
 fGUkaFCa8ZcgkJrRxEHzX1JmLsCpRVm+H7cZEIIyeZLTtRqdyR2co7RGTg77ls5djaoY8zyEe
 FhSYvNTwGDmrYjeUCkDlYX+MpkQX6gomuOiPmEb35zj7SSu16g2m3rntSm5kX5DiKAS7RUKxA
 hWUEVYgga6vtnTJPqsg0SNNDRiajudIBmNPOwFa1xsvT8l6XpnLgqJZcG8GaYw3QuAWgd1GD1
 haNyeGIUcWizn+q6X9wn1U=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 4, 2021 at 10:26 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:

> On Tue, May 04, 2021 at 09:41:14AM +0200, Arnd Bergmann wrote:
> > which is the same as what 7273ad2b08f8 does, but only for this one file
> > instead of all of lib/*.o.
>
> I think a "one off" change would be best here.  Can you submit it?

Sent https://lore.kernel.org/lkml/20210504104441.1317138-1-arnd@kernel.org/T/

      Arnd
