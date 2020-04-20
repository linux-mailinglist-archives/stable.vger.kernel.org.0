Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E5E1B18BF
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 23:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgDTVsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 17:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbgDTVsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 17:48:23 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F5AC061A0C
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 14:48:23 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id r14so5613586pfg.2
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 14:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9PSeaCNEoRkhPddRhybZ7T70UkYpYW1yuGG6pA7+X3g=;
        b=tIbR6e1H6tAPrfC87aVdEk2lUZBAcFArRHn5xIintgL3KNGwwKxn7KLYlt/mnZ9wte
         MiYv71KH/o9oAKc9oNsjHnvq0MT48557FCBJImYjqa8wCXm8EW7lOMnvnB87TzUZX2Eh
         GdGLi5pg+aUmfBx8V2o84t0U3hQJL9TrvR2xB27vlmHABtTolLbfP2H15hwDBKfpYH3U
         VUNnPbSX5JVNZnjMOSU9BdzaI6nHSYYvTublAiS6PeE2Q5md1/8xphc7qKBVjPhd+sPn
         livm5+k1Fj4G9yUlo5p6JSYa2VY1zYrr+558XwSRD1ZD52ODlaK4uIkRZh46VJJKVfMA
         sXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9PSeaCNEoRkhPddRhybZ7T70UkYpYW1yuGG6pA7+X3g=;
        b=Ha8mugzsT1GnTuh7Ec7jI8b6/FCY0aICPg9RRzd2w1aLt/kXCVrpIMq1bXtWmVuRzs
         /6E1JJMRz/eyo2wk66jT/RkjzB1KA090d5KQ1a/5/+5NwGhvG44ZVfg2BynZi4QOOn7s
         GXgj9s/LYHKnRzQQok1ZUHfYwHv3zywqynIMzRTj8UDW9ou9BrJnzn9c8ES8yC3fUlLq
         XYm64+WBIAPW+3m1DDPQkG+USysC3cx2OrW2oRA1T+1N1KLickig8lCe9K6NFTtGghgo
         TkzrvKDF/xgYElgzT8l3qJvWPumUuYvmuDe6JtyK5n+MVfV3LXToJZiYvmAwtNTXjluH
         Xy2Q==
X-Gm-Message-State: AGi0PuYnS52fJNjHFnbrn5hWeCDLa4iJgc0KXVEExKOl95bKy6UxOp/Z
        fNYx21XqaWS3m5r5dk1U708IP28ZbFQ=
X-Google-Smtp-Source: APiQypI1EEWUlLIEvnVyYthUBxJcf+VrWXKaCRK8srtFRFarJbnPXoYohbfy96ytpH48TvMsTjr7oQ==
X-Received: by 2002:aa7:97a6:: with SMTP id d6mr18495280pfq.92.1587419302063;
        Mon, 20 Apr 2020 14:48:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g25sm440449pfo.150.2020.04.20.14.48.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 14:48:20 -0700 (PDT)
Message-ID: <5e9e18a4.1c69fb81.1ffe1.1b0d@mx.google.com>
Date:   Mon, 20 Apr 2020 14:48:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.219-84-gd7b7a33b0609
Subject: stable-rc/linux-4.9.y boot: 103 boots: 1 failed,
 92 passed with 5 offline, 5 untried/unknown (v4.9.219-84-gd7b7a33b0609)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 103 boots: 1 failed, 92 passed with 5 offline, =
5 untried/unknown (v4.9.219-84-gd7b7a33b0609)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.219-84-gd7b7a33b0609/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.219-84-gd7b7a33b0609/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.219-84-gd7b7a33b0609
Git Commit: d7b7a33b0609424e2b4fe31199b4ee6e570f504c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 18 SoC families, 18 builds out of 197

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.9.219-79-ge4=
f3ca7a34da)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.219-79-ge4=
f3ca7a34da)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 72 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.219-79-ge4f3ca7a3=
4da)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
