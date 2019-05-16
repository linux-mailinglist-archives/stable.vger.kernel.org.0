Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31125210D7
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 01:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfEPXAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 19:00:11 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:54668 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfEPXAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 19:00:11 -0400
Received: by mail-wm1-f42.google.com with SMTP id i3so5135987wml.4
        for <stable@vger.kernel.org>; Thu, 16 May 2019 16:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1K8nbQ4he/FiT5vkCh64U2cUUMHcN07QyaTksaZ0zE8=;
        b=LoVYCiUS3Lzfef/Kc6JdDjcFTpwTqsWgyxC26+kbSfGOEE3UnLSw4RMDiSaAm891AW
         Zfv136yFLMq2hdMnh3tbNZaBzn9ym8C/lzKifZA9MG9UCnwdveuRZtMtqOJ+evOcCnvC
         vS5yFuq7ujz6SdXVrKDXr2vVu4M6TA/JKARb7i6sNz2S1y1MwRW7CLaBLLpuekg0HHPl
         iSnlZ6chyJ4EuO6mW090KScapc/9Z4ZXaBFhNMxYCEV24+ew0Xxlcq+xt8rsep+0+PTk
         4caGh3Q6BV6tMq9CZGtopBOkXsHRPDnGYT7y+G0ItudtfRHyCnfqlEguBiO3NztBoNeO
         T1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1K8nbQ4he/FiT5vkCh64U2cUUMHcN07QyaTksaZ0zE8=;
        b=FCRfY34OBwU6E6gLAOyxd9xqYuAjxR+C7KeDMCttHQ2vUBIMZjnoQLZ8JbZ1iuqHh6
         9MhbuaqVo5MOaVwWv3+9WP9hVYTW6/fQlPfLNx0KmrE1Bq3Fhm9M+n6hiSlAkdAULNYH
         O2LIqVZJv0yBGc0Z9KTlNjV8CMvWKIfEdH8X4ptBd8TyoRnUG/GRa68Un5cf4SG6jpWB
         NSg0neFZT4+t/165MSz99QHRokXA+oawmbV5VAnTheQC+0yof2zD+TiPKcjtGy1hnrSa
         gxyCxh7yBoEyJBEtFy4shX/FOKp6aKZIyrimPaQEfMTZl3zI7HHv3fKTSq/B4HOYp2UQ
         s68A==
X-Gm-Message-State: APjAAAVfhx8z698Wlr5tujPwZc7adgSP7GU8b0U2THFhdqzVW22Dfg4E
        64iOU3UVaYyFF7ksS9GgPEJsKOTGZlMYlg==
X-Google-Smtp-Source: APXvYqxK22ncbpSD0U1mzGita26PJM/iy1tluU+DSRulg2PyEmuXJJnDq22kRv7/pmkJlv/CiC5ruQ==
X-Received: by 2002:a1c:9c03:: with SMTP id f3mr30125563wme.67.1558047609916;
        Thu, 16 May 2019 16:00:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t19sm2988383wmi.42.2019.05.16.16.00.09
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 16:00:09 -0700 (PDT)
Message-ID: <5cddeb79.1c69fb81.a028a.0f7d@mx.google.com>
Date:   Thu, 16 May 2019 16:00:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.120
Subject: stable/linux-4.14.y boot: 55 boots: 2 failed, 53 passed (v4.14.120)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 55 boots: 2 failed, 53 passed (v4.14.120)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.120/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.120/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.120
Git Commit: e6fedb8802c7543852cc6b06d8c009f89b3af3d8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 27 unique boards, 14 SoC families, 11 builds out of 201

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.14.119)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.14.118)

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab

---
For more info write to <info@kernelci.org>
