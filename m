Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC85721F803
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 19:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgGNRS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 13:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728312AbgGNRS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 13:18:29 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88BFC061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 10:18:28 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id d17so23982778ljl.3
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 10:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=lwlUV3a+QKc9bh6BlS9RBaiRNTGMyisXHjbIgMFrRQ4=;
        b=zGkuS3pYmyX4lmXAAFK55PFZ5X9hdOfwxEfjGUY1WuPGnMU0JYRfnrepzX/r4s/4tQ
         NhS8j9s4NLucZHEItc1f7DIZSaV4S5VsFV3x94/sEafDmt7DpjLkyMmfEKr06aSTl41/
         GS3qb1VBU2A6mpLnN+LDu8PoxnFKjjkYVYeIgw9aEXGDZplB4un/jhd4iX97p1bBckjp
         0R0IcN1FHjHsrsBXgsadKAmdMln+qAm2xsazhrKqCI7T0P5lDWBonRFfB3tmAbK76D7v
         IdML9mq0UHY76czuIIKPonFbC6mGs3khJd3FQ5HuEZs7M4kZgDl9eBwtmx790RIpoIVd
         vu4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=lwlUV3a+QKc9bh6BlS9RBaiRNTGMyisXHjbIgMFrRQ4=;
        b=fn0rHGEnqs+tmZgYiggYJMfOk3FCUM0391T90oMct2RhTuONK7ub8V7s7R4foIzdPR
         ofB+7SNPuAluHer1zAlkSkIq8Dd2RTdv6sje403WhWU0McDuxZ5tiExJMEiWI9mC9tnF
         rrpptwlMT2TpZdzNddR9zQcVYGe6o+14XIehAH988+vz507lUtycwLvRfxSj4bvpdtbq
         JsBZapDmwaaI5IrB2gNT8RnTMORAgguixiaCNksYaU5XeVVo/EEXQ+FVaWtuBMyfQdZc
         6wggfAa5M9qx3Z5v5M7Xu4nZNc2k5+rWqi316aUJOT31kgExbsmXt4f3zeBcBgHbBJ4D
         o99A==
X-Gm-Message-State: AOAM533n9dz74bVQ6WVRc5js15p/SXRRpmR/f/kVKUPiS5NzOPd1TVk6
        S+QeiwLxz655Zo991/YJACkPJT7le1HhRu6rvkY4mfvGh61K0A==
X-Google-Smtp-Source: ABdhPJxOM73aZXK8ZybuK9U/imgdTEfa2aBJ8kEu00YO6gHS2efKNwuFB3QR5OgVAXZkjlqANLT7tmLRIQu5QukQ9fo=
X-Received: by 2002:a2e:b054:: with SMTP id d20mr2629367ljl.55.1594747106341;
 Tue, 14 Jul 2020 10:18:26 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Jul 2020 22:48:14 +0530
Message-ID: <CA+G9fYsLBOVVjxO2DAUgjXskxEXyMpBxYG1PRKwe7BTHJfzfZw@mail.gmail.com>
Subject: =?UTF-8?Q?stable=2Drc_5=2E4=3A_arm64_build_failed_=2D_error=3A_=E2=80=98const_?=
        =?UTF-8?Q?struct_arch=5Ftimer=5Ferratum=5Fworkaround=E2=80=99_has_no_member_named_?=
        =?UTF-8?Q?=E2=80=98disable=5Fcompat=5Fvdso=E2=80=99?=
To:     linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

arm64 build failed on 5.4

make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j16 ARCH=3Darm64
CROSS_COMPILE=3Daarch64-linux-gnu- HOSTCC=3Dgcc CC=3D"sccache
aarch64-linux-gnu-gcc" O=3Dbuild Image
#
../drivers/clocksource/arm_arch_timer.c:484:4: error: =E2=80=98const struct
arch_timer_erratum_workaround=E2=80=99 has no member named
=E2=80=98disable_compat_vdso=E2=80=99
  484 |   .disable_compat_vdso =3D true,
      |    ^~~~~~~~~~~~~~~~~~~
../drivers/clocksource/arm_arch_timer.c:484:26: warning:
initialization of =E2=80=98u32 (*)(void)=E2=80=99 {aka =E2=80=98unsigned in=
t (*)(void)=E2=80=99} from
=E2=80=98int=E2=80=99 makes pointer from integer without a cast [-Wint-conv=
ersion]
  484 |   .disable_compat_vdso =3D true,
      |                          ^~~~
../drivers/clocksource/arm_arch_timer.c:484:26: note: (near
initialization for =E2=80=98ool_workarounds[5].read_cntp_tval_el0=E2=80=99)

Could be this patch,
arm64: arch_timer: Disable the compat vdso for cores affected by
ARM64_WORKAROUND_1418040
commit 4b661d6133c5d3a7c9aca0b4ee5a78c7766eff3f upstream.

ARM64_WORKAROUND_1418040 requires that AArch32 EL0 accesses to
the virtual counter register are trapped and emulated by the kernel.
This makes the vdso pretty pointless, and in some cases livelock
prone.

Provide a workaround entry that limits the vdso to 64bit tasks.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200706163802.1836732-4-maz@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


ref:
https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/638094006

--=20
Linaro LKFT
https://lkft.linaro.org
