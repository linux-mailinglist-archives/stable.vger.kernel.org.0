Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11944544D2E
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 15:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244888AbiFINLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 09:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243948AbiFINLK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 09:11:10 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8100512FEC3
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 06:11:08 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id y188so12205314ybe.11
        for <stable@vger.kernel.org>; Thu, 09 Jun 2022 06:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xKLbTJr21DzL7tkc+KO9jQOPkfT6YdlPcpFis+IwWcQ=;
        b=ayd9nITyszwt50aBkf4t1qcsp4OfsO6Hk9CUV7fjw+VGoyMz8ZGWp4nkQxe8bAtQ7a
         /hOwGLb24rLue/LZuQ6+/5wShwExiOLNvySXQbpeUo0BcZvCFnQ57XCH8VsP8NseYt/4
         Al1UuZ33hNvfubvxxba3LnjT8kM+RFNIKsyMjlWZaln0oF6xGmgrRBPX04WQwp5bd1vy
         WKYf1GsFpIYn1bemof+BCO+WqIlkTMkrCZKinf/G9OK3g3P+PSj9rRRz0Fll13WqbHZS
         Yotu4xnzf/SkeV4ChX251iglYrM+TzDRE8VxWuYeNd1L53cd6VeFnomssUq+Ul9gDGIu
         gk3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xKLbTJr21DzL7tkc+KO9jQOPkfT6YdlPcpFis+IwWcQ=;
        b=hXqa8Jtt4HO9NHJ1Qg3nwyy/hjAu7rTKs3VrN5oD22YKH0apHI+IJRqiARbpY2PE5r
         k4jvSqKiFYIObJYN0NRii7d4bQPjAaWwMWNiBqOjyQ6TdWmC0bg/AGn+KC+QJAK9FsWe
         QfSkKxltEVJGNMVF1Ll5Hxsbd/I6TZ5e4qbeUhSdYecg4rPqErFZZbXn7hhymhMMsSGN
         /X4APSM8REWI/hkjLfwsPOaC6PskM4EIfjHqng058PQg3TBsqF7WwUDQ2oGG6ZClpmOx
         CvWarYODKSqjF4ygHtH6Hu5jWA2w6oj+xtNeky0nTeatC/wyI2UjjB5V2vR8oTPzikjQ
         g6iQ==
X-Gm-Message-State: AOAM532BPo0u38rYAaw8BsuAeDm6rY/HoRd3BWTwSF258o+lk+ZLPmb4
        UqKZnE7sj0Uv38GzgcKZxusqHV3VOVRhoz1lWxmoAA==
X-Google-Smtp-Source: ABdhPJyc8NZMM6O++VMnO40dYUYzxFBr5vLS6GICftrvSsLdF8KFE7TkG8pm54mwnl2OuBE885B+X3f8Ww4f0aZLmTE=
X-Received: by 2002:a25:4282:0:b0:663:dd7e:2374 with SMTP id
 p124-20020a254282000000b00663dd7e2374mr13458436yba.592.1654780267549; Thu, 09
 Jun 2022 06:11:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220607164948.980838585@linuxfoundation.org> <20220608235422.GC3924366@roeck-us.net>
In-Reply-To: <20220608235422.GC3924366@roeck-us.net>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 9 Jun 2022 18:40:56 +0530
Message-ID: <CA+G9fYs-xM3WZOOBuYOw+XyBHuCCS0P06tJk+8JK6r_MBrmOjA@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Guenter,

On Thu, 9 Jun 2022 at 05:24, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Tue, Jun 07, 2022 at 06:53:12PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.17.14 release.
> > There are 772 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> > Anything received after that time might be too late.
> >
>
> Build results:
>         total: 158 pass: 158 fail: 0
> Qemu test results:
>         total: 489 pass: 489 fail: 0
>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
>
> I see a new boot warning in some arm qemu tests, but that is related
> to enabling CONFIG_KFENCE and not a new problem. v5.17.y and v5.18.y
> are affected.

In LKFT we have been noticing this warning on the mainline, Linux-next,
5.18 and 5.17 on qemu-arm, and on x15 devices intermittently.

> [    8.157727] ------------[ cut here ]------------
> [    8.157843] WARNING: CPU: 0 PID: 0 at kernel/smp.c:894 smp_call_function_many_cond+0x38c/0x3a4
> [    8.158289] Modules linked in:
> [    8.158489] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.14-rc1-00773-gd0f9b2818e1e #1
> [    8.158564] Hardware name: ARM-Versatile Express
> [    8.158730]  unwind_backtrace from show_stack+0x10/0x14
> [    8.158802]  show_stack from dump_stack_lvl+0x50/0x6c
> [    8.158835]  dump_stack_lvl from __warn+0xd0/0x19c
> [    8.158863]  __warn from warn_slowpath_fmt+0x5c/0xb4
> [    8.158890]  warn_slowpath_fmt from smp_call_function_many_cond+0x38c/0x3a4
> [    8.158919]  smp_call_function_many_cond from smp_call_function+0x3c/0x50
> [    8.158947]  smp_call_function from set_memory_valid+0x74/0x94
> [    8.158975]  set_memory_valid from kfence_guarded_free+0x280/0x4b4
> [    8.159005]  kfence_guarded_free from kmem_cache_free+0x2f4/0x394
> [    8.159032]  kmem_cache_free from rcu_core+0x358/0xc34
> [    8.159062]  rcu_core from __do_softirq+0xf0/0x41c
> [    8.159101]  __do_softirq from irq_exit+0xa4/0xd4
> [    8.159127]  irq_exit from __irq_svc+0x50/0x68
>
> Guenter

[    0.000000] Linux version 5.19.0-rc1 (tuxmake@tuxmake)
(arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld
(GNU Binutils for Debian) 2.35.2) #1 SMP @1654710061
[    0.000000] CPU: ARMv7 Processor [412fc0f2] revision 2 (ARMv7), cr=10c5387d
[    0.000000] CPU: div instructions available: patching division code
<trim>
[    0.000000] kfence: initialized - using 2097152 bytes for 255
objects at 0x(ptrval)-0x(ptrval)
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at lib/refcount.c:25 kobject_get+0x9c/0xa0
[    0.000000] refcount_t: addition on 0; use-after-free.
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.19.0-rc1 #1
[    0.000000] Hardware name: Generic DRA74X (Flattened Device Tree)
[    0.000000]  unwind_backtrace from show_stack+0x18/0x1c
[    0.000000]  show_stack from dump_stack_lvl+0x58/0x70
[    0.000000]  dump_stack_lvl from __warn+0xd4/0x14c
[    0.000000]  __warn from warn_slowpath_fmt+0x98/0xbc
[    0.000000]  warn_slowpath_fmt from kobject_get+0x9c/0xa0
[    0.000000]  kobject_get from of_node_get+0x1c/0x24
[    0.000000]  of_node_get from of_fwnode_get+0x3c/0x48
[    0.000000]  of_fwnode_get from fwnode_full_name_string+0x34/0xa0
[    0.000000]  fwnode_full_name_string from device_node_string+0x5fc/0x6c8
[    0.000000]  device_node_string from pointer+0x38c/0x5b0
[    0.000000]  pointer from vsnprintf+0x22c/0x3cc
[    0.000000]  vsnprintf from vprintk_store+0x114/0x43c
[    0.000000]  vprintk_store from vprintk_emit+0x78/0x2ac
[    0.000000]  vprintk_emit from vprintk_default+0x28/0x30
[    0.000000]  vprintk_default from _printk+0x30/0x54
[    0.000000]  _printk from of_node_release+0x124/0x12c
[    0.000000]  of_node_release from kobject_put+0xc4/0x294
[    0.000000]  kobject_put from ti_dt_clocks_register+0x284/0x32c
[    0.000000]  ti_dt_clocks_register from dra7xx_dt_clk_init+0x18/0x11c
[    0.000000]  dra7xx_dt_clk_init from omap5_realtime_timer_init+0x10/0x21c
[    0.000000]  omap5_realtime_timer_init from start_kernel+0x558/0x718
[    0.000000]  start_kernel from 0x0
[    0.000000] ---[ end trace 0000000000000000 ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at lib/refcount.c:28
fwnode_full_name_string+0x8c/0xa0
[    0.000000] refcount_t: underflow; use-after-free.
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W
  5.19.0-rc1 #1
[    0.000000] Hardware name: Generic DRA74X (Flattened Device Tree)
<trim>
[    0.000000] OF: ERROR: Bad of_node_put() on
/ocp/interconnect@4a000000/segment@0/target-module@8000/cm_core@0/clock@c00/clock@0
[    0.000000] ------------[ cut here ]------------
<trim>
[    7.246032] ------------[ cut here ]------------
[    7.246063] WARNING: CPU: 1 PID: 0 at kernel/smp.c:913
smp_call_function_many_cond+0x3a0/0x3b0
[    7.259399] Modules linked in:
[    7.262481] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W
  5.19.0-rc1 #1
[    7.270202] Hardware name: Generic DRA74X (Flattened Device Tree)
[    7.276336]  unwind_backtrace from show_stack+0x18/0x1c
[    7.281585]  show_stack from dump_stack_lvl+0x58/0x70
[    7.286682]  dump_stack_lvl from __warn+0xd4/0x14c
[    7.291503]  __warn from warn_slowpath_fmt+0x64/0xbc
[    7.296508]  warn_slowpath_fmt from smp_call_function_many_cond+0x3a0/0x3b0
[    7.303527]  smp_call_function_many_cond from smp_call_function+0x34/0x3c
[    7.310363]  smp_call_function from set_memory_valid+0x7c/0x9c
[    7.316223]  set_memory_valid from kfence_guarded_free+0x284/0x4b0
[    7.322448]  kfence_guarded_free from kmem_cache_free+0x3a0/0x484
[    7.328582]  kmem_cache_free from rcu_core+0x2c0/0x964
[    7.333770]  rcu_core from __do_softirq+0x168/0x400
[    7.338684]  __do_softirq from irq_exit+0xc0/0xf0
[    7.343414]  irq_exit from call_with_stack+0x18/0x20
[    7.348419]  call_with_stack from __irq_svc+0x9c/0xb8
[    7.353515] Exception stack(0xf0045f40 to 0xf0045f88)
[    7.358581] 5f40: 00001770 00000000 fe600000 00000000 c2165260
c29e1500 c1f09f50 c1f09fb0
[    7.366821] 5f60: c1e95b28 c2163ad4 00000000 00000000 00000000
f0045f90 c0335434 c030983c
[    7.375030] 5f80: 600e0013 ffffffff
[    7.378540]  __irq_svc from arch_cpu_idle+0x28/0x44
[    7.383453]  arch_cpu_idle from default_idle_call+0x50/0xd0
[    7.389068]  default_idle_call from do_idle+0x224/0x2cc
[    7.394348]  do_idle from cpu_startup_entry+0x20/0x24
[    7.399414]  cpu_startup_entry from secondary_start_kernel+0x13c/0x15c
[    7.405975]  secondary_start_kernel from 0x80302180
[    7.410919] ---[ end trace 0000000000000000 ]---


you may refer to this warning log on the mainline.

https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v5.19-rc1-23-g34f4335c16a5/testrun/10066624/suite/log-parser-boot/tests/


- Naresh
