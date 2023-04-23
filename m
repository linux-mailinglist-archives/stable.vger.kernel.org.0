Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F3D6EC288
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 23:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjDWVqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 17:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDWVqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 17:46:47 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BDA19F
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 14:46:46 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id a1e0cc1a2514c-77239ff7aebso993562241.3
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 14:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682286405; x=1684878405;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ikXW5eAUAASPifxp6zcp5zEvPgGmqOKTCh0oBKs5DYg=;
        b=VlwuRWSSXgel3cEa3MmSipV86dWkNYOoYRcaD2te/rf2s2FX85dxuj7GUuspOEvDbZ
         DCu4NRyJCAxg15DrSsYTr3XBYlvDzjdNr35c2P0xG3ngIO3Fa5qIve8lfZTsjr154Un0
         WA82It3h5BVfncqPayxfiTrMGQmGBThhPFcYN8gOJnGqSs+CbEpTItJWgPOBpfltSsyB
         MLE3Loxxdb0MjgmQ/FxHhf9uDbdMiX2+CcA3d35o25/SUkBX+4xUyP/7TKdXzAgLkqJi
         UBwHhwnV/6m5qe6qPfy0iyIiNp5qmHOMSCbAQTd0zkPz7zooAYeZMHfNtPgQ2EhOXFMe
         YJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682286405; x=1684878405;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ikXW5eAUAASPifxp6zcp5zEvPgGmqOKTCh0oBKs5DYg=;
        b=bxi04ZsuMXcBxdvK2hmkUMflCWr3T/ugBUujVcJq8z/uvXIAiiPIsM/iRRZDUENDJX
         6xFOIJoxV92uWqiT1C67BjNtHP4Vc6wsvSpO6fK/7n55h57I6MAv5t7+IW6A6J+tUKdD
         Vt1caILDu2YnywpbRosyMn95a/9ri+WnKgd8/pcX7EWgzI9KBL+dDmKIJ3aCSqxqL7gL
         RhYwxG0CDjyePpH/JpfO8wD8emSTLkTVwzE2Obl8Wu0nrp/NQxa8nZsisALr3oQqVm2Q
         Ea7HZ2kFxXlmT9SoCKjHV3kMGhgYsI44AibphGFcJDDy73O5fzYjfi+jtaOHcdoXDBtH
         jjTg==
X-Gm-Message-State: AAQBX9dXTFXYYLD7Yf4N7KYPiRMRjyig9+v0RCgxGdPr6eCyEsekD7uH
        G60zfE6Rf6Q53tUM7ZeOOwfPI3oK4wnD+RWEzkzzngTWkHSv2Lgmy3iCjA==
X-Google-Smtp-Source: AKy350YWt2GA740Ew+ZdB04BoEEYBqNvoxuT+o7qgqqNhdMuQIEP5cwi/iXsZG6mHRdz2DSXUc48+hSCYZ+Cw9gLRk8=
X-Received: by 2002:a67:e407:0:b0:42f:e97c:b0eb with SMTP id
 d7-20020a67e407000000b0042fe97cb0ebmr5546968vsf.4.1682286405096; Sun, 23 Apr
 2023 14:46:45 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 24 Apr 2023 03:16:34 +0530
Message-ID: <CA+G9fYuZdBJx8jF2STHzRZ8dw86awZ68OQen6bzgB=H+Z-tPAQ@mail.gmail.com>
Subject: stable-rc: 5.4: drivers/pwm/pwm-meson.c:313:25: error: assignment of
 member 'polarity' in read-only object
To:     linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Munehisa Kamata <kamatam@amazon.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Thierry Reding <thierry.reding@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following build errors noticed on arm64 and arm while building stable-rc 5.4.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build error:
-----------
  drivers/pwm/pwm-meson.c: In function 'meson_pwm_apply':
  drivers/pwm/pwm-meson.c:313:25: error: assignment of member
'polarity' in read-only object
    313 |         state->polarity = PWM_POLARITY_NORMAL;
        |                         ^
  make[3]: *** [scripts/Makefile.build:262: drivers/pwm/pwm-meson.o] Error 1
  make[3]: Target '__build' not remade because of errors.
  make[2]: *** [scripts/Makefile.build:497: drivers/pwm] Error 2


Suspected commit:
------------
  pwm: meson: Explicitly set .polarity in .get_state()
  commit 8caa81eb950cb2e9d2d6959b37d853162d197f57 upstream.


Steps to reproduce:
---------------
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.
# tuxmake   \
 --runtime podman   \
 --target-arch arm64   \
 --toolchain gcc-11   \
 --kconfig defconfig   \
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/lkft.config
  \
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/lkft-crypto.config
  \
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/distro-overrides.config
  \
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/systemd.config
  \
 --kconfig-add https://raw.githubusercontent.com/Linaro/meta-lkft/kirkstone/meta/recipes-kernel/linux/files/virtio.config
  \
 --kconfig-add CONFIG_ARM64_MODULE_PLTS=y   \
 --kconfig-add CONFIG_SYN_COOKIES=y   \
 --kconfig-add CONFIG_SCHEDSTATS=y   \
 --kconfig-add CONFIG_GENERIC_COMPAT_VDSO=n   \
 --kconfig-add CONFIG_COMPAT_VDSO=n



--
Linaro LKFT
https://lkft.linaro.org
