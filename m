Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3E983A699
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 17:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbfFIPMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 11:12:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35359 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728703AbfFIPMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 11:12:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id m3so6674345wrv.2
        for <stable@vger.kernel.org>; Sun, 09 Jun 2019 08:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1dc8DxUZ+4obD4ZFb6zA1CjGwP/WJL9ZOpbiGr0coi4=;
        b=WyDtoShIR3VUKKPnV5V33eB6N2NhMjobNwLWiVK4hKJMHNUzyqxiUvVYhpNb5N24V9
         PU0+svCV75GwMC1j5OJ9TcWlYR2IKKlQIpTC5UOeFhSBbCnINv86H/VB9hDySpm0KCTM
         4pvHQcGnOUMymmB7gdL0EyRxVLHcZN2iFxVu4Tofe9QL6VS55jX67yb+3gpDMgp9zsHL
         9Rx1K0MfnJpl7Tz/7GmWcIVd556u15xMPS1UBZt5dA1w0flMuQRDM+m2cQjNN3o1IBdl
         bSSV+TG1TLXe+WdEqTMZRij/vauCvMZpJgtIMFq45Z6ssKi6RuBTud+Mt70Ktktx1rQZ
         wySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1dc8DxUZ+4obD4ZFb6zA1CjGwP/WJL9ZOpbiGr0coi4=;
        b=ibOJHgkHjXNPuFuNqR1Fd/S0LCpOM4S0KxNLIe1uOpPqf/7DzMGD8a1talk1B8TBqL
         zGh9iXAyYlFEEo/xjAIhv+2DgSzz9NLWc2z63qk4OZT5v2820Rkoo4EYoRvC3g04CBkl
         qBEH1wZz/c1UQAywnauCSYOgDN2apzxTcISYfyh9AXBTwM0Yf0jOkzVoiGITXfW4XoE8
         nN6+cJSRd5wyD2bM0NrKwki0sv0tiSkX1cFxsr64tMU7BU5j5bWoQB3sBlCz3pMAZKuF
         P79ZhRwIABg7x3KHpEz+vQTmfgcAHZxRZCX8jcY6QSXOhapxEv0iYPGMKn9aMXuhIQ5s
         ZnTA==
X-Gm-Message-State: APjAAAXTTSQ+V9BY8vrqAUI9aLn1rMAvs6gvG/xUcBwEyduV1G1FTusg
        +L4ArBbSrjJxIvbT9f1dtSpJyX3hw38=
X-Google-Smtp-Source: APXvYqyrfTiSwM8TdIt0CaOX5S7kZqxJV0gdDhORhwGKAK5v/5sIxNOwf/L8rtrV6enibnuwZh/Naw==
X-Received: by 2002:adf:eb42:: with SMTP id u2mr39635254wrn.80.1560093149188;
        Sun, 09 Jun 2019 08:12:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r5sm15996003wrg.10.2019.06.09.08.12.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 08:12:28 -0700 (PDT)
Message-ID: <5cfd21dc.1c69fb81.d2b1c.ebfe@mx.google.com>
Date:   Sun, 09 Jun 2019 08:12:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.8
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.1.y boot: 68 boots: 1 failed,
 66 passed with 1 conflict (v5.1.8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.1.y boot: 68 boots: 1 failed, 66 passed with 1 conflict (v5.=
1.8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
1.y/kernel/v5.1.8/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.1.y/ke=
rnel/v5.1.8/

Tree: stable
Branch: linux-5.1.y
Git Describe: v5.1.8
Git Commit: 937cc0cc22a27757746f64769d3b1ba3e424e9e4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 36 unique boards, 15 SoC families, 11 builds out of 209

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v5.1.7)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v5.1.6)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    exynos_defconfig:
        exynos5422-odroidxu3:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
