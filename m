Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CDA1C1E4C
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 22:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgEAUSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 16:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAUSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 16:18:35 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C441DC061A0C
        for <stable@vger.kernel.org>; Fri,  1 May 2020 13:18:35 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mq3so338579pjb.1
        for <stable@vger.kernel.org>; Fri, 01 May 2020 13:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8ZA7/KESIBgxgX3oZXkTkEjfP6Vh9zizF7Zc6fHALRM=;
        b=YvXQ1AUI5XVNdEFAfWd8XPwqq4FCC7ODjxffRTwIgRRS78Qds8480s+ok5mACDCvVL
         lRzqcrDWCmbo/lCZwm8draoEAYjJNrXj4Gm4CnRQa6aMy8jZNnnkiNlUbODwKK4qBece
         0BX422nfOqUC9YB4LLALsFsBZ2snVy0OdYExRg9G4oGwsbu346BWoSK+NSwzIrRr5JPK
         j72JgTZuuoETHgjmh9RJcfhF9QE0wvNJWkWuO7UsBvEUmVPrwaYv2bDkoFvdOQVTPeul
         3I27hc+WT6z0iqvqtYrUjcpMNXz6VDtMesmu62ngwhdn6XbllU+dqGe6bRaeWA3HbG7J
         FE8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8ZA7/KESIBgxgX3oZXkTkEjfP6Vh9zizF7Zc6fHALRM=;
        b=rQl3FfGT0hTSjS7/HZbwtaZgzqFLGiI+cDxIDsVIuRKN4aKxecHVGX3vkEnpmOa9Jo
         chyztKaxqRzbkb11iq/yw6AQ7dvrbMz/HqZwIQyzDCtSGoFntX6rBlVmfGmJ8BwOEN8V
         dZaBCPXlLp4iL8mG+RGAidsV7ctko4XdUHn/wsWJGwEg0A3Uo/MarjIE3bap2nzU0yoW
         dXSNvADO5eRDzrgfFZNWkmRx+nnjxgtlwXYIMDUEGVzgcXqh36fBi+aMskhWr5wqXsnT
         c7TMWEZcRUT2RakZNGKpMpp4JTESbEG/fVtstFh5Gc+FAbzsedTKbCxGY8og7ZRjxWfm
         T12A==
X-Gm-Message-State: AGi0PuZQ0x1l9YvxCnIYbR7Zp0U1PK3JHP2gQiOnEULuVNVkQwpTBFBX
        uDqZoK2+6t2mUOu+2dtUaEsjrRje9Dg=
X-Google-Smtp-Source: APiQypLpdROffmN3APgjQj4LJaTtb77nvTrAL6MEvj1xBKAIpxvTKOptSDiGfe0kdH4NLJJWRMT2Wg==
X-Received: by 2002:a17:90a:b293:: with SMTP id c19mr1425301pjr.22.1588364314976;
        Fri, 01 May 2020 13:18:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u188sm2906315pfu.33.2020.05.01.13.18.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 13:18:34 -0700 (PDT)
Message-ID: <5eac841a.1c69fb81.dc8fb.a6aa@mx.google.com>
Date:   Fri, 01 May 2020 13:18:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.177-118-gb24d32661fe1
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 130 boots: 3 failed,
 117 passed with 5 offline, 5 untried/unknown (v4.14.177-118-gb24d32661fe1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 130 boots: 3 failed, 117 passed with 5 offline=
, 5 untried/unknown (v4.14.177-118-gb24d32661fe1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.177-118-gb24d32661fe1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.177-118-gb24d32661fe1/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.177-118-gb24d32661fe1
Git Commit: b24d32661fe15b71ca1f5f6913749d2c8be9e0ae
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 20 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 83 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 71 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.177-98-gc52cc936=
0302)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
