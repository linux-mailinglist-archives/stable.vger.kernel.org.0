Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49495226295
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 16:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgGTOxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 10:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgGTOxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 10:53:00 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B46FC061794
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 07:53:00 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id q7so20599857ljm.1
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 07:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=23eFm33zVbMakY44pp2FHM+5kxZRsAv5/tu2Q+OCFVQ=;
        b=ACpO0EeJIItd+F55NFLQ1KRbvWWcPab7rZRdcJJavihcLSOK5tygI4kQ5zdVRpEoTF
         vBkQchMPo3pdZ9dg+OX181q3wfUW6g9fxsWWUximHbygueLExMEP03PMxdm/xbKnWkoj
         YOaAAE5dOKp49kKUAqEmsBjHhs23BkZSxEBIBth0CiPwpJrzUhDL4XZJRreKVQGuzwdo
         hlyhQr2NofcIfX1W4LQPWUyn2Fe9QFIUr/245Q6UdUCzkeRNvf6twk5nHPGdnpWF2hKr
         SxaKcPr51enfYhm08naCg8q57QpeReUTFJA0aF2mJlkyA6pmOoodLLrAjjkNj8/3L/2N
         bZ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=23eFm33zVbMakY44pp2FHM+5kxZRsAv5/tu2Q+OCFVQ=;
        b=fQCF9u21IgpWk8ix2PXJPy2uHxeVXKD1luYWNLyM56Avbu07ma60aSppDgBi9d/XDD
         cmvUla+czxXne/gH0ODDAkGbvEIu83zRnk2MQYkG5kPMm34hNaGk5hRZLmsTMFHLgenr
         dYTkAbLAKXj6tW9w+t+azxQv4gJ2tyr08IxvTWwth3AShmvFG7zVaZsodP2FOHwLUjwf
         LoXOBejGNga3b9UZq0TTDB42teqG7f8Pm6ncnRKFdp8Ou2fWnaAtLb6d617FcoyR9BW0
         eZouXayWsHsexBRJ4Z9jyxUTxfBky03CcrOgAo3mfExbMPLehYVfaDi+gpEJ0xv9gpJG
         7GIA==
X-Gm-Message-State: AOAM532YxWdXTS8WU9qujFbc+6MNV9XWCCpyQwu3vjxuMMcweBdjGETT
        n3i5Boap5cvg61EFu9uapS928V+tIolauftwzHXGVllhSOrpCA==
X-Google-Smtp-Source: ABdhPJxh9HuK/xDX58PelA70nPmnYIDYc49QQNgkSf6CV/9ELpEiICSDANiza62vMlIZdctBZG5BHe7jdNywazLLoFU=
X-Received: by 2002:a2e:9857:: with SMTP id e23mr11179243ljj.411.1595256777698;
 Mon, 20 Jul 2020 07:52:57 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYuPe=XkrTx+yDo556D5t4wrFRFXctPPb2+7w+v-hAHvyw@mail.gmail.com>
In-Reply-To: <CA+G9fYuPe=XkrTx+yDo556D5t4wrFRFXctPPb2+7w+v-hAHvyw@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 20 Jul 2020 20:22:46 +0530
Message-ID: <CA+G9fYs0gT__dkBE7XbRj-n5kZmfeHFj=GXhHZ+d-BSNBdtYyg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_stable=2Drc_5=2E4=3A_arm_build_failed=3A_arm=2Dinit=2Ec=3A327=3A?=
        =?UTF-8?Q?12=3A_error=3A_implicit_declaration_of_function_=E2=80=98get=5Fdev=5Ffrom=5F?=
        =?UTF-8?Q?fwnode=E2=80=99?=
To:     linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        saravanak@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Jul 2020 at 20:16, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> arm build failed on stable-rc 5.4 branch.
>
> make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j32 ARCH=3Darm
> CROSS_COMPILE=3Darm-linux-gnueabihf- HOSTCC=3Dgcc CC=3D"sccache
> arm-linux-gnueabihf-gcc" O=3Dbuild zImage
> #
> ../drivers/firmware/efi/arm-init.c: In function =E2=80=98efifb_add_links=
=E2=80=99:
> ../drivers/firmware/efi/arm-init.c:327:12: error: implicit declaration
> of function =E2=80=98get_dev_from_fwnode=E2=80=99
> [-Werror=3Dimplicit-function-declaration]
>   327 |  sup_dev =3D get_dev_from_fwnode(&sup_np->fwnode);
>       |            ^~~~~~~~~~~~~~~~~~~

same build problem occurred on
stable -rc 4.9, 4.14 and 4.19 and 5.4 for arm and arm64 architectures.

> efi/arm: Defer probe of PCIe backed efifb on DT systems
> [ Upstream commit 64c8a0cd0a535891d5905c3a1651150f0f141439 ]
>
> The new of_devlink support breaks PCIe probing on ARM platforms booting
> via UEFI if the firmware exposes a EFI framebuffer that is backed by a
> PCI device. The reason is that the probing order gets reversed,
> resulting in a resource conflict on the framebuffer memory window when
> the PCIe probes last, causing it to give up entirely.
>
> Given that we rely on PCI quirks to deal with EFI framebuffers that get
> moved around in memory, we cannot simply drop the memory reservation, so
> instead, let's use the device link infrastructure to register this
> dependency, and force the probing to occur in the expected order.
>
> Co-developed-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Link: https://lore.kernel.org/r/20200113172245.27925-9-ardb@kernel.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
