Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30961BB586
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 06:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgD1Ewl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 00:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgD1Ewl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 00:52:41 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49451C03C1A9
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 21:52:40 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r4so9726885pgg.4
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 21:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=haeEAasZqYJZhPRoPig2fY+ESa+Q/AkWBz/Y4HmdynQ=;
        b=AoC/JL1l5i8liIBHVYj4d0ayt+PYJ27KFO05rOSEgv4zD7nhZeIq5LLltlTHysx8Sh
         JMAmQzUn6aeV1idFuZkhqALUUAojj3eFJSkdPVr4CLoHUOXxyMIS9NuIOHWvixi7HJCA
         5pJ6L51UBR9zNZzhNJHjBWa/zD4kBx+Igghstr82Q58NDDmVJFvf7uoXDyNj51/KuMdR
         6ijgSN4btismJhgSX3e34jiJFmYJOMnDYuwLivxDd50eiPopx//o5OAp8nntKGkSilAQ
         ngloKbm8H+MMl+IbqBgX7my6Hy8IrHyydsnqzxAdwECJqInPW6A00UMrzLzl+ujKzNDT
         OJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=haeEAasZqYJZhPRoPig2fY+ESa+Q/AkWBz/Y4HmdynQ=;
        b=qGWRM/DKL+VxN0T6zWW3MPXBmi71YNxcsXjS9D9BryNEQmEajkiPvAILiYvTRhhhN3
         6u0I1pNpGNkHNhwqEKkcJXD8CVNalJLgi8ih5nnY226PaZMP9Z9r83YfDYjejqWS1aim
         vQA1HV3U0kJ19vNES88uaxUlof0bkOxnh/+oQsvhTeS18zVIatdpTdyLFRanyr5TAsv/
         a2AGElNiM513c+cNqspmoF7BLSQzwBH7r1GibFo4io5enjc5LGdPYfGnCr+plx2liKlv
         16/dV+zol1s3VUEmlG38tzIfRlhUc8SnNPlu82z9p64jQhKMLuxYkogsXk/Z7n4OBPiy
         eZzg==
X-Gm-Message-State: AGi0PubpU0uzP9RsDHkEgU8cxjSk4MMRnlJnJMXkyYHLkLUOccTFS1Pk
        Hd7GnmQwv/J2nz9F1IxnxtOexYpYkMw=
X-Google-Smtp-Source: APiQypID+qaClG3sSguNaWWtmE98uNEAyRTJgpEpKSDUFxCcBtf6aOTTZv+9U+MPyVLfiaMZyMZ3+A==
X-Received: by 2002:a63:b649:: with SMTP id v9mr23598691pgt.402.1588049559354;
        Mon, 27 Apr 2020 21:52:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f26sm788401pfn.183.2020.04.27.21.52.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 21:52:38 -0700 (PDT)
Message-ID: <5ea7b696.1c69fb81.ce6d9.3f13@mx.google.com>
Date:   Mon, 27 Apr 2020 21:52:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.177-83-gbbdd9c481dc2
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 109 boots: 3 failed,
 91 passed with 8 offline, 5 untried/unknown,
 2 conflicts (v4.14.177-83-gbbdd9c481dc2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 109 boots: 3 failed, 91 passed with 8 offline,=
 5 untried/unknown, 2 conflicts (v4.14.177-83-gbbdd9c481dc2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.177-83-gbbdd9c481dc2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.177-83-gbbdd9c481dc2/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.177-83-gbbdd9c481dc2
Git Commit: bbdd9c481dc22b1742774d061c9e7077593e52f4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 21 SoC families, 14 builds out of 183

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.14.=
176-199-ga7097ef0ff82 - first fail: v4.14.177)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.14.=
176-199-ga7097ef0ff82 - first fail: v4.14.177)

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.177)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 79 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 67 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.177)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.177)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s905d-p230:
              lab-baylibre: new failure (last pass: v4.14.177)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.14.177)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: new failure (last pass: v4.14.177)

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

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
