Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1483850910D
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 22:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381977AbiDTUHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 16:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382069AbiDTUHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 16:07:40 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DA6D8F;
        Wed, 20 Apr 2022 13:04:50 -0700 (PDT)
Received: from mail-wr1-f48.google.com ([209.85.221.48]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MD5fd-1nYhqS0iA5-009C9f; Wed, 20 Apr 2022 22:04:49 +0200
Received: by mail-wr1-f48.google.com with SMTP id p18so3744800wru.5;
        Wed, 20 Apr 2022 13:04:49 -0700 (PDT)
X-Gm-Message-State: AOAM533PUNnGDotKxEOSsahHZaTf50NTyXHt3zRdKCFVv4vHZ8o+7QGQ
        FYgXsfwQUJQs3eUKKJCdbUdCt6+GSx/eRDIndi8=
X-Google-Smtp-Source: ABdhPJzQqXetCmaGkZ0VLDQKkxSmuQBexNxn4+LtaoO2pmxTQhac0Nj1iF3iDiepN/wJPA+ZQPYKZ600Fq7P1vAaoZE=
X-Received: by 2002:adf:e106:0:b0:20a:b31b:213d with SMTP id
 t6-20020adfe106000000b0020ab31b213dmr2425684wrz.219.1650485088720; Wed, 20
 Apr 2022 13:04:48 -0700 (PDT)
MIME-Version: 1.0
References: <87levzzts4.fsf_-_@email.froward.int.ebiederm.org>
 <mhng-32cab6aa-87a3-4a5c-bf83-836c25432fdd@palmer-ri-x1c9>
 <20220420165935.GA12207@brightrain.aerifal.cx> <202204201044.ACFEB0C@keescook>
In-Reply-To: <202204201044.ACFEB0C@keescook>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 20 Apr 2022 22:04:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2KvK78bbW_5DWKsrxLvKxYDqoCkii-kxi-mB7W9DCvNA@mail.gmail.com>
Message-ID: <CAK8P3a2KvK78bbW_5DWKsrxLvKxYDqoCkii-kxi-mB7W9DCvNA@mail.gmail.com>
Subject: Re: [PATCH] binfmt_flat: Remove shared library support
To:     Kees Cook <keescook@chromium.org>
Cc:     Rich Felker <dalias@libc.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas.Cassel@wdc.com, Al Viro <viro@zeniv.linux.org.uk>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Mike Frysinger <vapier@gentoo.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:gQ5lfzAIVy37ifJumMEGNd7d+cNLiqaZmRMa9ueMfNJ5xnstoFb
 1LXvZ4iv4Jz6LH9bqtciDqVccsCUMZExFOxSVmOb4bb+jTKEtg9rNUSSuKL0mQ0xfHgHSz4
 Yer2462solt1ixzcojB1Yi6+zHG9VnR0IleEaOxH0DKXidOxVE/AFRBtrh5faTPL7geL+BP
 bs/5vz7VJrJva9UKV3djA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:KDu2y8Cc/7c=:pa8fGFPiX/gUUwbekJEvUn
 UdD3IcE6tGtlWbFlnGWQIr1SupnmqlaeN1Ynw2rQsGRMOPplxfI+ooeGmt5nnUBxI2Y6+YZnM
 PdJ6jq0e25C+/vIkByuEI/M3E04qBLST6JJZNor6UDQ4e9I8XSuMJ7sjDHVncA+7b49eapCrR
 OeNa7DVIn9eJJXnH9RnXmdF0YjGPf+ALuuStLlEeLT0sKDXHFsxsix6JtV/7sm7xIJt94MmCd
 lvtod81gxusuZMKv8/WRX43LQMopmD4sDD2AYw6cYM1nmw4U9Owk/eAmjWuJY43Gfh16ED7vN
 W4sziGJfHL1clvysEkvMCWjulYGUCx5xV0W4pJ9QTO8w+pc8CoFRRwY5KzxUfYTeanN3unBrl
 +cUeRI7AZrUVGyWVy1isFIamzWiA1slrC95OFawv4y7tmcj1Q1zIW315PS1zZjCGJ1EHlA9mw
 eYZy08p37e6dDOTtJTeK+lT/sk/xOvomU7tJnnhO17VHcpDRy48kad06EpRVDMsrxbiY7YDxy
 1spGtYhlXruJR0lJ+9rVNpRFmvBe0xHy+Zw0ljahxTVEJ5NVXUCBm3rgfRbgQ94RpzcaY5J3a
 HWCqvwDBPOFYt5eqJyxNHhMR3yWiZ2ZTuGda8wPeD0LpTnu+rdt+hvI+/l2LxSjhyAcGqDw5i
 uYoTy0BkMXEm9j2/15Rwp1s1SQ+CyDxEhRr2Y5kityB2PR43L8mKKlhh250/da4bAV1pFT5MU
 86fJdsGlA3hzaa7nRsQkZL0UWaGFdKE2iwtM0GtGVpsPHIHuBrKtbb7k2+CsLUnhQRZW4vZuX
 HK7yaj8HqfferE22/0xHeYgGmBbzOVD1dU/B9+nMi4Zf2OOXyw=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 7:47 PM Kees Cook <keescook@chromium.org> wrote:
>
> Yeah, I was trying to understand why systems were using binfmt_flat and
> not binfmt_elf, given the mention of elf2flat -- is there really such a
> large kernel memory footprint savings to be had from removing
> binfmt_elf?

I think the main reason for using flat binaries is nommu support on
m68k, xtensa and risc-v. The regular binfmt_elf support requires
an MMU, and the elf-fdpic variant is only available for arm and sh
at this point (the other nommu architectures got removed over time).

        Arnd
