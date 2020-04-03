Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3735219D60B
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 13:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgDCLuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 07:50:11 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38854 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgDCLuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 07:50:11 -0400
Received: by mail-pl1-f194.google.com with SMTP id w3so2609465plz.5
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 04:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6O+kHg3cRFt+RyYveFCx2maWId1PlMXCV3/TRXyPcxk=;
        b=xsO75BFEErh/tNFKGKOjpZEg1qPaWKCGc5blACwk4EeTiEM0f92BX//h+3fOzcZsVy
         JZ5lydZ+0N0u54sM2uQ3gydaz51HrgsJxf3PCgGRvnEKYjmuJJooyrBGA29AW8YvxTvF
         bFObRCOeuAMtNzbdD2jgosDOx6Ye5az3Um8NmhYX4qLVLAALLCnIAGbF6ulNI7/32wbR
         STMVM4R6zVm4IsZ7ywiit207grYBfqg3Z53gF4dyHHX9+trM8sxfDdWIdUfNHHNRldbO
         W8whJuwm4k4hcP++TErfMpj5pS7HqVURlck2UvhMGaDG9kIPSwcvsq6mrekF+6HaO8w5
         wnNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6O+kHg3cRFt+RyYveFCx2maWId1PlMXCV3/TRXyPcxk=;
        b=YkPQj/mfsjILEUZZD3LJblGy/PG+N8S1+VzGN3nGlfTGIk6ONHdB0kuFTfaBYVHwYO
         5nv2gw46a9aO75rTWVEC2FNAnrtlihG7D+gyDfNVVZY32a8B3C7PAYOulIAm44m6g0QA
         VLUozAu20OtakSIJ7twv6GkMyIl/als0rPcdSVhv/9zLfzOLl5I5llwBVqLvzZ1Np/l4
         tHf+zBFZuhE8fFAG2mgBQley0U1ZrYlpTNQaG7tgYUxJzlbQUrKc3h1Ts/It7wGyy1Vp
         wTF9hxUIbmAoH+pQuo4Ep1Sb++1J298wxjTqUPpRlhAaXZgX6veiVbThSLDHu1rSPhWo
         HPAA==
X-Gm-Message-State: AGi0PuY2PU62T9E9sIUvXBd/4CrzkLRwokTuPsfR4SDLT07JNygQWuoo
        zpTg5uRCuOJZmIkLqKLDbwNxarde5DA=
X-Google-Smtp-Source: APiQypLuVWlmI/L4Zdko5ECWHjjwInotwDlFWBYX4Nz+3ww7PC5nSSHuFhzupRu6UhA/Ddv3lDBLkg==
X-Received: by 2002:a17:902:ec01:: with SMTP id l1mr7495637pld.151.1585914609969;
        Fri, 03 Apr 2020 04:50:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m28sm5155573pgn.7.2020.04.03.04.50.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 04:50:09 -0700 (PDT)
Message-ID: <5e8722f1.1c69fb81.889cc.81ee@mx.google.com>
Date:   Fri, 03 Apr 2020 04:50:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.175
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 133 boots: 4 failed,
 121 passed with 2 offline, 6 untried/unknown (v4.14.175)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 133 boots: 4 failed, 121 passed with 2 offline=
, 6 untried/unknown (v4.14.175)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.175/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.175/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.175
Git Commit: 4520f06b03ae667e442da1ab9351fd28cd7ac598
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 54 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 43 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.174-149-gbc03924=
ca6ea)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.14.174-149-gbc03924c=
a6ea)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxl-s905d-p230: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
