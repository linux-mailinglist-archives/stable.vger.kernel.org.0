Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20755F52E4
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 12:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJEKur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 06:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJEKuq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 06:50:46 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B8846D91;
        Wed,  5 Oct 2022 03:50:45 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id g28so466214pfk.8;
        Wed, 05 Oct 2022 03:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=781LGdP1ASK+T8d/G2nBidUhml4Ns7GkYFIAXMHDR3A=;
        b=T7ARhLonYods1P/5YLpLePuvQsX0HgufkoQtBq6enKYRP6UH8SsyFl8VXPwzueN5H2
         FlM14gaLcMhC0l3HPt3+0p39wan6ebGrVXOcyb67fYxVdEfNUz28h6DU625fSku0D8VV
         xF+zC98aAQ2y70NS7tkOg0WaTq1IOYOCMDqcBTpaHdrJ4870Yx3J4o8MOUf2E4rxIvir
         kPjik4b4Os/17B28kmL0EIb2I2nHr0O0EjawIBSJSZByLwkVbyaOaV0A83KHE1MwxgFE
         tyLU7xn/CJOapXv2ISZcVdW8omODRIP8iBnpJggJDFN7l/1nDaYKrvFnn5G/kt4JZkcF
         I6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=781LGdP1ASK+T8d/G2nBidUhml4Ns7GkYFIAXMHDR3A=;
        b=FYMlblaxN7ViV2kAdUfGw5ZtK3JaA2CIAwqIDH7p3EHtnZH0Q5hWTsKBiQeyRHkg0T
         V/UntmtNHJQqcob9cN+Jrj13W+5FYJL84K0+2rH/HeZByhKqBUe/v+l61en/4YfWRfzg
         /BXzXVmc1Vv8N9e+Gp5RSVasUkvE8v+WVcG9NnuO3wOCtFa24Tpl+s1QEJ4842l3Wuem
         /66b/tGmME6FIlJs4l9QeIPyU9T8Wk2GtoMmTKHciobwNv80MJCoJl0oQJ5jSwRvseYh
         DMUlm7diut1V0kx/j+u5NWBbLUoS+KjsOMc2uOBtXjoIwT3VngHJoov2AI6SPgJG+kT0
         MLEg==
X-Gm-Message-State: ACrzQf3eYIhzflmGhDQGnS/tz85d3Fl5g54ixRpuMFkBXWatGMUIdyvo
        mpMYxZIK+QjvoGDkU6T6+kw=
X-Google-Smtp-Source: AMsMyM677nlUNb92wUMcJgsIKA+7U+eughPTJvzq6lFxE3hevEklEM4u0qfmns9FQ0lWaGLsEubd4A==
X-Received: by 2002:a63:c06:0:b0:439:9b18:8574 with SMTP id b6-20020a630c06000000b004399b188574mr26979655pgl.608.1664967044477;
        Wed, 05 Oct 2022 03:50:44 -0700 (PDT)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id j22-20020a63e756000000b004405c6eb962sm9829448pgk.4.2022.10.05.03.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 03:50:43 -0700 (PDT)
Date:   Wed, 5 Oct 2022 19:50:36 +0900
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, Feng Tang <feng.tang@intel.com>,
        Waiman Long <longman@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Marco Elver <elver@google.com>
Subject: Re: [PATCH 5.19 000/101] 5.19.13-rc1 review
Message-ID: <Yz1hfEdYAXhqV7tN@hyeyoo>
References: <20221003070724.490989164@linuxfoundation.org>
 <CA+G9fYvxTQ52SDLnF2-7Kynuy0NcojXuikC8L5BaTZWBsCMv2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CA+G9fYvxTQ52SDLnF2-7Kynuy0NcojXuikC8L5BaTZWBsCMv2g@mail.gmail.com>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 04, 2022 at 12:18:05PM +0530, Naresh Kamboju wrote:
> On Mon, 3 Oct 2022 at 12:43, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.19.13 release.
> > There are 101 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.19.13-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h

[...]

> 2) Boot warning on qemu-arm64 with KASAN and Kunit test
>    Suspecting one of the recently commits causing this warning and
>    need to bisect to confirm the commit id.
>     mm/slab_common: fix possible double free of kmem_cache
> [ Upstream commit d71608a877362becdc94191f190902fac1e64d35 ]

[...]

> 2) Following kernel boot warning noticed on qemu-arm64 with KASAN and
> KUNIT enabled [1]
>=20
>      [  177.651182] ------------[ cut here ]------------
>      [  177.652217] kmem_cache_destroy test: Slab cache still has
> objects when called from test_exit+0x28/0x40
>      [  177.654849] WARNING: CPU: 0 PID: 1 at mm/slab_common.c:520
> kmem_cache_destroy+0x1e8/0x20c
>      [  177.666237] Modules linked in:
>      [  177.667325] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G    B
>        5.19.13-rc1 #1
>      [  177.668666] Hardware name: linux,dummy-virt (DT)
>      [  177.669783] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT
> -SSBS BTYPE=3D--)
>      [  177.671120] pc : kmem_cache_destroy+0x1e8/0x20c
>      [  177.672217] lr : kmem_cache_destroy+0x1e8/0x20c
>      [  177.673302] sp : ffff8000080876f0
>      [  177.674013] x29: ffff8000080876f0 x28: ffffb5ed1da56f38 x27:
> ffffb5ed1a87b480
>      [  177.676478] x26: ffff800008087aa0 x25: ffff800008087ac8 x24:
> ffff00000c73b480
>      [  177.678215] x23: 000000004c800000 x22: ffffb5ed1eca3000 x21:
> ffffb5ed1da381f0
>      [  177.679873] x20: fdecb5ed18ea3a78 x19: ffff00000759be00 x18:
> 00000000ffffffff
>      [  177.681540] x17: 0000000000000000 x16: 0000000000000000 x15:
> 0000000000000000
>      [  177.683139] x14: 0000000000000000 x13: 206d6f7266206465 x12:
> ffff700001010e63
>      [  177.684776] x11: 1ffff00001010e62 x10: ffff700001010e62 x9 :
> ffffb5ed18b89514
>      [  177.686554] x8 : ffff800008087317 x7 : 0000000000000001 x6 :
> 0000000000000001
>      [  177.688238] x5 : ffffb5ed1d893000 x4 : dfff800000000000 x3 :
> ffffb5ed18b89520
>      [  177.689912] x2 : 0000000000000000 x1 : 0000000000000000 x0 :
> ffff000007150000
>      [  177.691598] Call trace:
>      [  177.692165]  kmem_cache_destroy+0x1e8/0x20c
>      [  177.693196]  test_exit+0x28/0x40
>      [  177.694158]  kunit_catch_run_case+0x5c/0x120
>      [  177.695177]  kunit_try_catch_run+0x144/0x26c
>      [  177.696211]  kunit_run_case_catch_errors+0x158/0x1e0
>      [  177.697353]  kunit_run_tests+0x374/0x750
>      [  177.698333]  __kunit_test_suites_init+0x74/0xa0
>      [  177.699386]  kunit_run_all_tests+0x160/0x380
>      [  177.700428]  kernel_init_freeable+0x32c/0x388
>      [  177.701497]  kernel_init+0x2c/0x150
>      [  177.702347]  ret_from_fork+0x10/0x20
>      [  177.703308] ---[ end trace 0000000000000000 ]---
>=20
> [1] https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2FcC=
yacq1SusUcnAfamULqzkdUA

[+Cc Marco Elver]

I can't reproduce it with the image and still not sure what caused this,

but the dmesg output [3] raises some questions: 1) What made kfence_test fa=
il,
and 2) can a failure from KFENCE test cause this SLUB warning?

2022-10-03T07:48:54.922482 <6>[  146.564765]     ok 3 - test_out_of_bounds_=
write
2022-10-03T07:48:54.922578 <6>[  146.577134]     # test_out_of_bounds_write=
-memcache: setup_test_cache: size=3D32, ctor=3D0x0
2022-10-03T07:48:54.922666 <6>[  146.592675]     # test_out_of_bounds_write=
-memcache: test_alloc: size=3D32, gfp=3Dcc0, policy=3Dleft, cache=3D1
2022-10-03T07:48:54.922756 <3>[  156.602992]     # test_out_of_bounds_write=
-memcache: ASSERTION FAILED at mm/kfence/kfence_test.c:312
2022-10-03T07:48:54.922844 <3>[  156.602992]     Expected false to be true,=
 but is false
2022-10-03T07:48:54.922934 <3>[  156.602992]=20
2022-10-03T07:48:54.923018 <3>[  156.602992] failed to allocate from KFENCE
2022-10-03T07:48:54.925842 <6>[  156.864670]     not ok 4 - test_out_of_bou=
nds_write-memcache
2022-10-03T07:48:54.926038 <6>[  156.883110]     # test_use_after_free_read=
: test_alloc: size=3D32, gfp=3Dcc0, policy=3Dany, cache=3D0
2022-10-03T07:48:54.926178 <3>[  156.920306] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

[...]

2022-10-03T07:50:11.011619 <6>[  163.904684]     # test_free_bulk-memcache:=
 setup_test_cache: size=3D223, ctor=3D0x0
2022-10-03T07:50:11.011811 <6>[  163.927257]     # test_free_bulk-memcache:=
 test_alloc: size=3D223, gfp=3Dcc0, policy=3Dright, cache=3D1
2022-10-03T07:50:11.012007 <6>[  163.992279]     # test_free_bulk-memcache:=
 test_alloc: size=3D223, gfp=3Dcc0, policy=3Dnone, cache=3D1
2022-10-03T07:50:11.012200 <6>[  164.007799]     # test_free_bulk-memcache:=
 test_alloc: size=3D223, gfp=3Dcc0, policy=3Dleft, cache=3D1
2022-10-03T07:50:11.012392 <3>[  176.777879]     # test_free_bulk-memcache:=
 ASSERTION FAILED at mm/kfence/kfence_test.c:312
2022-10-03T07:50:11.012592 <3>[  176.777879]     Expected false to be true,=
 but is false
2022-10-03T07:50:21.406181 <3>[  176.777879]
2022-10-03T07:50:21.406483 <3>[  176.777879] failed to allocate from KFENCE
2022-10-03T07:50:21.406616 <3>[  177.604811] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
2022-10-03T07:50:21.406728 <3>[  177.608387] BUG test (Tainted: G    B     =
       ): Objects remaining in test on __kmem_cache_shutdown()
2022-10-03T07:50:21.406827 <3>[  177.609927] ------------------------------=
-----------------------------------------------
2022-10-03T07:50:21.406918 <3>[  177.609927]
2022-10-03T07:50:21.407005 <3>[  177.611424] Slab 0x000000009535baed object=
s=3D14 used=3D1 fp=3D0x00000000e8649a76 flags=3D0x3fffc0000000200(slab|node=
=3D0|zone=3D0|lastcpupid=3D0xffff)
2022-10-03T07:50:21.407112 <4>[  177.613882] CPU: 0 PID: 1 Comm: swapper/0 =
Tainted: G    B             5.19.13-rc1 #1
2022-10-03T07:50:21.407219 <4>[  177.615231] Hardware name: linux,dummy-vir=
t (DT)
2022-10-03T07:50:21.407310 <4>[  177.616197] Call trace:
2022-10-03T07:50:21.407400 <4>[  177.616788]  dump_backtrace+0xb8/0x130
2022-10-03T07:50:21.407490 <4>[  177.617792]  show_stack+0x20/0x60
2022-10-03T07:50:21.407581 <4>[  177.618630]  dump_stack_lvl+0x8c/0xb8
2022-10-03T07:50:21.407671 <4>[  177.619548]  dump_stack+0x1c/0x38
2022-10-03T07:50:21.407761 <4>[  177.620396]  slab_err+0xa0/0xf0
2022-10-03T07:50:21.407851 <4>[  177.621180]  __kmem_cache_shutdown+0x140/0=
x3c0
2022-10-03T07:50:21.407935 <4>[  177.622230]  kmem_cache_destroy+0x9c/0x20c
2022-10-03T07:50:21.408017 <4>[  177.623242]  test_exit+0x28/0x40
2022-10-03T07:50:21.408100 <4>[  177.624172]  kunit_catch_run_case+0x5c/0x1=
20
2022-10-03T07:50:21.408183 <4>[  177.625189]  kunit_try_catch_run+0x144/0x2=
6c
2022-10-03T07:50:21.408269 <4>[  177.626251]  kunit_run_case_catch_errors+0=
x158/0x1e0
2022-10-03T07:50:21.408355 <4>[  177.627359]  kunit_run_tests+0x374/0x750
2022-10-03T07:50:21.408439 <4>[  177.628316]  __kunit_test_suites_init+0x74=
/0xa0
2022-10-03T07:50:21.408523 <4>[  177.629376]  kunit_run_all_tests+0x160/0x3=
80
2022-10-03T07:50:21.408606 <4>[  177.630440]  kernel_init_freeable+0x32c/0x=
388
2022-10-03T07:50:21.408687 <4>[  177.631517]  kernel_init+0x2c/0x150
2022-10-03T07:50:21.408770 <4>[  177.632351]  ret_from_fork+0x10/0x20
2022-10-03T07:50:21.408856 <4>[  177.633506] Disabling lock debugging due t=
o kernel taint
2022-10-03T07:50:21.408942 <3>[  177.634724] Object 0x00000000a1747116 @off=
set=3D2880
2022-10-03T07:50:21.409029 <4>[  177.651182] ------------[ cut here ]------=
------
2022-10-03T07:50:21.409116 <4>[  177.652217] kmem_cache_destroy test: Slab =
cache still has objects when called from test_exit+0x28/0x40
2022-10-03T07:50:21.409205 <4>[  177.654849] WARNING: CPU: 0 PID: 1 at mm/s=
lab_common.c:520 kmem_cache_destroy+0x1e8/0x20c
2022-10-03T07:50:21.409297 <4>[  177.666237] Modules linked in:
2022-10-03T07:50:32.517549 <4>[  177.667325] CPU: 0 PID: 1 Comm: swapper/0 =
Tainted: G    B             5.19.13-rc1 #1
2022-10-03T07:50:32.518598 <4>[  177.668666] Hardware name: linux,dummy-vir=
t (DT)
2022-10-03T07:50:32.519060 <4>[  177.669783] pstate: 60400005 (nZCv daif +P=
AN -UAO -TCO -DIT -SSBS BTYPE=3D--)
2022-10-03T07:50:32.519440 <4>[  177.671120] pc : kmem_cache_destroy+0x1e8/=
0x20c
2022-10-03T07:50:32.519798 <4>[  177.672217] lr : kmem_cache_destroy+0x1e8/=
0x20c
2022-10-03T07:50:32.520150 <4>[  177.673302] sp : ffff8000080876f0
2022-10-03T07:50:32.520502 <4>[  177.674013] x29: ffff8000080876f0 x28: fff=
fb5ed1da56f38 x27: ffffb5ed1a87b480
2022-10-03T07:50:32.520852 <4>[  177.676478] x26: ffff800008087aa0 x25: fff=
f800008087ac8 x24: ffff00000c73b480
2022-10-03T07:50:32.521203 <4>[  177.678215] x23: 000000004c800000 x22: fff=
fb5ed1eca3000 x21: ffffb5ed1da381f0
2022-10-03T07:50:32.521565 <4>[  177.679873] x20: fdecb5ed18ea3a78 x19: fff=
f00000759be00 x18: 00000000ffffffff
2022-10-03T07:50:32.521903 <4>[  177.681540] x17: 0000000000000000 x16: 000=
0000000000000 x15: 0000000000000000
2022-10-03T07:50:32.522248 <4>[  177.683139] x14: 0000000000000000 x13: 206=
d6f7266206465 x12: ffff700001010e63
2022-10-03T07:50:32.522624 <4>[  177.684776] x11: 1ffff00001010e62 x10: fff=
f700001010e62 x9 : ffffb5ed18b89514
2022-10-03T07:50:32.522978 <4>[  177.686554] x8 : ffff800008087317 x7 : 000=
0000000000001 x6 : 0000000000000001
2022-10-03T07:50:32.523346 <4>[  177.688238] x5 : ffffb5ed1d893000 x4 : dff=
f800000000000 x3 : ffffb5ed18b89520
2022-10-03T07:50:32.523706 <4>[  177.689912] x2 : 0000000000000000 x1 : 000=
0000000000000 x0 : ffff000007150000
2022-10-03T07:50:32.524060 <4>[  177.691598] Call trace:
2022-10-03T07:50:32.524419 <4>[  177.692165]  kmem_cache_destroy+0x1e8/0x20c
2022-10-03T07:50:32.524781 <4>[  177.693196]  test_exit+0x28/0x40
2022-10-03T07:50:32.525138 <4>[  177.694158]  kunit_catch_run_case+0x5c/0x1=
20
2022-10-03T07:50:32.525491 <4>[  177.695177]  kunit_try_catch_run+0x144/0x2=
6c
2022-10-03T07:50:32.525842 <4>[  177.696211]  kunit_run_case_catch_errors+0=
x158/0x1e0
2022-10-03T07:50:32.526203 <4>[  177.697353]  kunit_run_tests+0x374/0x750
2022-10-03T07:50:32.526583 <4>[  177.698333]  __kunit_test_suites_init+0x74=
/0xa0
2022-10-03T07:50:32.526944 <4>[  177.699386]  kunit_run_all_tests+0x160/0x3=
80
2022-10-03T07:50:32.527319 <4>[  177.700428]  kernel_init_freeable+0x32c/0x=
388
2022-10-03T07:50:32.527677 <4>[  177.701497]  kernel_init+0x2c/0x150
2022-10-03T07:50:32.528045 <4>[  177.702347]  ret_from_fork+0x10/0x20
2022-10-03T07:50:32.528415 <4>[  177.703308] ---[ end trace 000000000000000=
0 ]---
2022-10-03T07:50:32.528777 <6>[  180.045230]     not ok 14 - test_free_bulk=
-memcache

[3] https://tuxapi-prod-storage-public-linaro.s3.amazonaws.com/lkft/tests/2=
FcCyacq1SusUcnAfamULqzkdUA/logs.html?AWSAccessKeyId=3DASIA4PEBGJPLJ3MHQBGO&=
Signature=3D%2FlJHsH06tzBXzSyMCaDjWaTG%2F9o%3D&x-amz-security-token=3DIQoJb=
3JpZ2luX2VjEBoaCXVzLWVhc3QtMSJHMEUCIQD4TKWLb%2B8aAYVTlrta0n5XyR9BsgwaUXE46E=
gOgqjuIQIgXIMnwwIUUqYAkt86EjRR0kCmWx8E9iuRgYvoqC2yEyYqjQMI0%2F%2F%2F%2F%2F%=
2F%2F%2F%2F%2F%2FARACGgw4NTcxMTY5MjA3OTAiDLYObfq5JIo0d4obbSrhAmrI7gL9QgdUI5=
D%2BN1Rh7sCX9meh0FAVldxj06oK5BHlily6x7rI0m7oJNlD3P31xSxDHUhBgPE3qiQj0XVBORv=
URqUuf5jHKEWuSO%2BqWGWYKPZLECeRUlMl4JXq5fI5FjWMU9VRsHrZDqZhV25z2i8jtjsOWsHW=
iNvyhhN1am2eYQUMmVnLhoEgLDhgSj4k72%2BJnczrPYpgcbJ1L%2BUlwNUT9nMdRV6oYAbJVeQ=
eUp66n%2FJ4AvPZzlm3BhaCjvoJhI4dmB99papGw4IhdTdfbqkKvOyIR6gRDYxKiXPmU1EKgNEc=
WUQU9e9ILLOJh%2BgEH9Sad8ObcQtR4L91o%2B%2B6eZasaga%2F9GvBj1pr7YYpRCVmkOGs1Ed=
w22NKSDAtmf1qiI2ShVoqW3VkvXSIClq5VNTZBjMKi9P5x005XdCqXxZ8Iug07v%2FolQ1ee4na=
CCXbbYEa10YjLkkBYk0gXujugT2wMKOp9ZkGOp4BfdXurWMFtd5rU4pfcZewiMwwM4h%2FXlUqG=
OIGkaps7RLxPQ4e1vmMPoKiU16a3kWxR6ZC0IuDEwMyU2Cr13UxEAY%2B5nBjYv2iFzGinJwM9O=
EhLcOkizY%2F6y0o6hLg%2Fqd5jflTqMjPRkbhtVoH2W%2BnBZkPUvRgjDU6%2FRC7Tb0iiIpGw=
7pqRHJpnzxtzQzsUU%2Bd5FL4OAGxKQDR9Dbjzt0%3D&Expires=3D1664967348

> ---
> mm/slab_common: fix possible double free of kmem_cache
> [ Upstream commit d71608a877362becdc94191f190902fac1e64d35 ]
>=20
> When doing slub_debug test, kfence's 'test_memcache_typesafe_by_rcu'
> kunit test case cause a use-after-free error:
>=20
>   BUG: KASAN: use-after-free in kobject_del+0x14/0x30
>   Read of size 8 at addr ffff888007679090 by task kunit_try_catch/261
>=20
>   CPU: 1 PID: 261 Comm: kunit_try_catch Tainted: G    B            N
> 6.0.0-rc5-next-20220916 #17
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
> 04/01/2014
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x34/0x48
>    print_address_description.constprop.0+0x87/0x2a5
>    print_report+0x103/0x1ed
>    kasan_report+0xb7/0x140
>    kobject_del+0x14/0x30
>    kmem_cache_destroy+0x130/0x170
>    test_exit+0x1a/0x30
>    kunit_try_run_case+0xad/0xc0
>    kunit_generic_run_threadfn_adapter+0x26/0x50
>    kthread+0x17b/0x1b0
>    </TASK>
>=20
> The cause is inside kmem_cache_destroy():
>=20
> kmem_cache_destroy
>     acquire lock/mutex
>     shutdown_cache
> schedule_work(kmem_cache_release) (if RCU flag set)
>     release lock/mutex
>     kmem_cache_release (if RCU flag not set)
>=20
> In some certain timing, the scheduled work could be run before
> the next RCU flag checking, which can then get a wrong value
> and lead to double kmem_cache_release().
>=20
> Fix it by caching the RCU flag inside protected area, just like 'refcnt'
>=20
> Fixes: 0495e337b703 ("mm/slab_common: Deleting kobject in
> kmem_cache_destroy() without holding slab_mutex/cpu_hotplug_lock")
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Reviewed-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
>=20
>=20
> ## Build
> * kernel: 5.19.13-rc1
> * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> * git branch: linux-5.19.y
> * git commit: 0d49bf6408c47f815c7e056a006617d5431b1bed
> * git describe: v5.19.12-102-g0d49bf6408c4
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.=
19.12-102-g0d49bf6408c4

[...]

> --
> Linaro LKFT
> https://lkft.linaro.org

--=20
Thanks,
Hyeonggon
