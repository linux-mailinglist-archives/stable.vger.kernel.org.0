Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 090D61878ED
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 06:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgCQFAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 01:00:48 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36765 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgCQFAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 01:00:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id z72so1185231pgz.3
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 22:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ENZKE+TEldeCGAmuNlDrpmRSQ44pEPe0NlgFJKafLCE=;
        b=bNRD1keZ3zDBeJQRWUsICjaLZnMg6fLILLmfDVD0RsDfJqjKgicNweKAXWngrHxwek
         qx8K0dqLG5C18++fJ1SBPKKTT3sUBHf8lhmN+XLHmdrmnu7Xuo2yYe9ad45JXkF3/nD0
         l1LkjCxql3ZjeKuAqyB7ynINyqDXuJT+4feCDFrF2BuDE+BQt8iF62jT3ou/VoAFuG47
         hp03PtSVqLb6q0DIkIMmNpM963Rpewv6IGy6/dYWXAf3Tcj4FxRAyl34xQI4jjl/pjZ4
         fYQZBYbn7qgFcprRMGv7LM4NJErcDza8vZps4zZrddEbLpAzNlrwOUTyyHOYQRaHKqCg
         QYEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ENZKE+TEldeCGAmuNlDrpmRSQ44pEPe0NlgFJKafLCE=;
        b=WgwDqptLO1Lwp9LZ9B3lsuszG74U99/qTPcdTgok4X/30+xIJ+I+bBx1YISFu8hzu/
         HPp6yJK3IrdrXc3jJkIpCLWg+85AoysWXsJcmuP7R4v5+gx+bJsD9mB0psmjLfshyHgs
         uu1KkKiRMjhorxWwOhME/xtxJMoSTPSSYLqK5PF8bcLwD0esLKCLQa34s+wADVpN9IKw
         1LkfCTPtXmPzPCJCLcYnEf5wNlkpd7STjP55HjlYW5VnDEMum2fjWVXDc+tdiNJtZ3kI
         CrK0HgnqOKFUnS/TVqqwaoVWK9244JgZg8r0YvV0tiYmESaJ7/nEswusWoHvwc0mcfCI
         K5hQ==
X-Gm-Message-State: ANhLgQ3krgdefkrPpnTmcWUyLqYaPBIOsYy1c5WQDjHsJ5WOJGpoJShV
        yMQR6OtykDppUTq0VzOYka3m0oNEK6A=
X-Google-Smtp-Source: ADFU+vtHZa0pgpC5uXkDpzyyL6Ozxc4+ubH/jsmUc7cMpkYXMaVJIidvS6mDkf2Ep2cTU5tiUffxNg==
X-Received: by 2002:aa7:8f22:: with SMTP id y2mr3356494pfr.300.1584421244820;
        Mon, 16 Mar 2020 22:00:44 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e187sm1407737pfe.143.2020.03.16.22.00.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 22:00:44 -0700 (PDT)
Message-ID: <5e70597c.1c69fb81.f1563.6fb2@mx.google.com>
Date:   Mon, 16 Mar 2020 22:00:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.109-91-ga807140ca617
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 115 boots: 1 failed,
 106 passed with 5 offline, 3 untried/unknown (v4.19.109-91-ga807140ca617)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 115 boots: 1 failed, 106 passed with 5 offline=
, 3 untried/unknown (v4.19.109-91-ga807140ca617)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.109-91-ga807140ca617/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.109-91-ga807140ca617/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.109-91-ga807140ca617
Git Commit: a807140ca617b44592aec2a4a33472692df1ca86
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 21 SoC families, 19 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 37 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 3 days (last pass: v4.19.108-87-g=
624c124960e8 - first fail: v4.19.109)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.109-2-g5b=
d9ed044815)
          meson-gxl-s805x-p241:
              lab-baylibre: failing since 1 day (last pass: v4.19.109-46-g8=
fb46e602a12 - first fail: v4.19.109-2-g5bd9ed044815)

Boot Failure Detected:

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

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
