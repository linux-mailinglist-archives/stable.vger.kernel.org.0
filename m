Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74135F9A5B
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbiJJHrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiJJHrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:47:17 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D8D1C921;
        Mon, 10 Oct 2022 00:44:13 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id n18-20020a17090ade9200b0020b0012097cso8010533pjv.0;
        Mon, 10 Oct 2022 00:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=byYv+p4uc+egG0+zuLE4MMW1fuarHCm8QYsjJ5KX+/g=;
        b=JEJ9mBjH45J+pWURJLiPEp4ZCHXwV75nr955I1u3f7eUUneGg/usBui1mNS8ePqtIV
         VSqexjBb9RMIf3FvNi1Qmn73rJQObFN9cv4S+yi29om5TDsYaj7tr42edstRWKO71wV7
         qZtUs4dB/t90W10sCMNEkMBJYqZe0wZva38qFR8FQpIbKDs88D6sR/3ql2tNNrhEn6Gh
         gEd/AUjtyp/6vJdhSoam1ckZ8jHKeWE0YroIu7eAfpMpAypDHqZ/HqybfWzP6+ONzxQB
         MfUNbGDQcAB9A3dTZhElz+NEbUVPLtFuIzF+iepAGCLC7Drscxnn1b0sZG07l8VZIufr
         Fq5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=byYv+p4uc+egG0+zuLE4MMW1fuarHCm8QYsjJ5KX+/g=;
        b=dw9OwjW4hXp89aUkEYG/Z19/BcTOpuIpWnqliAeeGz73XgUGVOjNPhnKJilV7WfYJA
         nn5ZUeAf8LZQqqqoCeVuvkJQlOKCgHBaOv+PRc0Q6FfXxVguEMWCBRkrA0cEzDtKNiuD
         agbF7+iru4AvmUihadctOvVn58OhtNNkqY+MEUbr0AbZcbld1fFZYONTSB4yrOTRoWrx
         0FuZCnsUM/IKAIRpiea8m0jjs1Zt4ms3njakCflgYMLeStIYiBjDtvuSC8cPkA4iXT21
         144xfyaBrxDZbq1I0nPqmkGrMjiXgvAvuNNdAWVQjcoy+J2kyZyl8YGV9BQt45VyMeJB
         bLEQ==
X-Gm-Message-State: ACrzQf1x4Ac1MyRRCgWxrbFeQKBMEtbRmcGNq4XTAh+w+VfUJqz1/QF0
        s60zu3YYGEs5ntW1OXHDHGJrS1205nDH0r6EnVU=
X-Google-Smtp-Source: AMsMyM7KRGGyZHJ2tp41WQTQeyJuRXK5xKHwabpO1RzA3t42hFOcYnAtPxG5XCB34B5qhzzDPh8QLbFyG0lXZSwjLxI=
X-Received: by 2002:a17:902:c94e:b0:181:4ab4:179b with SMTP id
 i14-20020a170902c94e00b001814ab4179bmr9753809pla.126.1665387839925; Mon, 10
 Oct 2022 00:43:59 -0700 (PDT)
MIME-Version: 1.0
References: <20221010070330.159911806@linuxfoundation.org>
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
From:   Luna Jernberg <droidbittin@gmail.com>
Date:   Mon, 10 Oct 2022 09:43:47 +0200
Message-ID: <CADo9pHgdB7Czsuw=gxv9jAyrUJLjFNCVLW0CGXfszKrj1EfK1A@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luna Jernberg <droidbittin@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Works on Arch Linux

Tested-by: Luna Jernberg <droidbittin@gmail.com>


On Mon, Oct 10, 2022 at 9:07 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.1 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.0.1-rc1
>
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>     Bluetooth: use hdev->workqueue when queuing hdev->{cmd,ncmd}_timer works
>
> Jules Irenge <jbi.octave@gmail.com>
>     bpf: Fix resetting logic for unreferenced kptrs
>
> Daniel Golle <daniel@makrotopia.org>
>     net: ethernet: mtk_eth_soc: fix state in __mtk_foe_entry_clear
>
> Kumar Kartikeya Dwivedi <memxor@gmail.com>
>     bpf: Gate dynptr API behind CAP_BPF
>
> Palmer Dabbelt <palmer@rivosinc.com>
>     RISC-V: Print SSTC in canonical order
>
> Mario Limonciello <mario.limonciello@amd.com>
>     gpiolib: acpi: Add a quirk for Asus UM325UAZ
>
> Mario Limonciello <mario.limonciello@amd.com>
>     gpiolib: acpi: Add support to ignore programming an interrupt
>
> Johan Hovold <johan@kernel.org>
>     USB: serial: ftdi_sio: fix 300 bps rate for SIO
>
> Tadeusz Struk <tadeusz.struk@linaro.org>
>     usb: mon: make mmapped memory read only
>
> Aleksa Savic <savicaleksa83@gmail.com>
>     hwmon: (aquacomputer_d5next) Fix Quadro fan speed offsets
>
> Shuah Khan <skhan@linuxfoundation.org>
>     docs: update mediator information in CoC docs
>
> Kees Cook <keescook@chromium.org>
>     hardening: Remove Clang's enable flag for -ftrivial-auto-var-init=zero
>
> Sami Tolvanen <samitolvanen@google.com>
>     Makefile.extrawarn: Move -Wcast-function-type-strict to W=1
>
> Bart Van Assche <bvanassche@acm.org>
>     sparc: Unbreak the build
>
> Al Viro <viro@zeniv.linux.org.uk>
>     fix coredump breakage
>
> Dongliang Mu <mudongliangabcd@gmail.com>
>     fs: fix UAF/GPF bug in nilfs_mdt_destroy
>
> Jalal Mostafa <jalal.a.mostapha@gmail.com>
>     xsk: Inherit need_wakeup flag for shared sockets
>
>
> -------------
>
> Diffstat:
>
>  .../process/code-of-conduct-interpretation.rst     |  2 +-
>  Makefile                                           |  8 ++---
>  arch/riscv/kernel/cpu.c                            |  2 +-
>  arch/sparc/include/asm/smp_32.h                    | 15 ++++-----
>  arch/sparc/kernel/leon_smp.c                       | 12 ++++---
>  arch/sparc/kernel/sun4d_smp.c                      | 12 ++++---
>  arch/sparc/kernel/sun4m_smp.c                      | 10 +++---
>  arch/sparc/mm/srmmu.c                              | 29 ++++++++---------
>  drivers/gpio/gpiolib-acpi.c                        | 38 +++++++++++++++++++---
>  drivers/hwmon/aquacomputer_d5next.c                |  2 +-
>  drivers/net/ethernet/mediatek/mtk_ppe.c            |  2 +-
>  drivers/usb/mon/mon_bin.c                          |  5 +++
>  drivers/usb/serial/ftdi_sio.c                      |  3 +-
>  fs/coredump.c                                      |  3 +-
>  fs/inode.c                                         |  7 ++--
>  include/net/xsk_buff_pool.h                        |  2 +-
>  kernel/bpf/helpers.c                               | 28 ++++++++--------
>  kernel/bpf/syscall.c                               |  2 +-
>  net/bluetooth/hci_core.c                           | 15 +++++++--
>  net/bluetooth/hci_event.c                          |  6 ++--
>  net/xdp/xsk.c                                      |  4 +--
>  net/xdp/xsk_buff_pool.c                            |  5 +--
>  scripts/Makefile.extrawarn                         |  1 +
>  security/Kconfig.hardening                         | 14 +++++---
>  24 files changed, 141 insertions(+), 86 deletions(-)
>
>
