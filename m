Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958D9CCCA9
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 22:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbfJEUVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 16:21:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41485 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbfJEUVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 16:21:07 -0400
Received: by mail-wr1-f66.google.com with SMTP id q9so10873044wrm.8
        for <stable@vger.kernel.org>; Sat, 05 Oct 2019 13:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1+CzJuKRAJ82UDjMAqJFvJXzSNf1DUQQCO4NJq6Tm4A=;
        b=KMNZ7Uq7iCe/PulJYq1ZFZ+mDsKUAeIzv+FoPGwtoSqai+e224eP8iisiJMEGkTyYq
         04wB1MX8vwKzGI50gmk/q9df8TvaSuBzk5t6xBlspbhJyMoXLRSuKoBJG8OdLQ8xlnOo
         LuLkqrzHOZzGKGMJVW3fh0XFQdKNCf4sXvu2QSvfg7i2pZwsRmaMsbIeCDbBmNFJFaT/
         nqZPqepTZGRV2S5msKP3nWvYj3zWAxZUWb8c0KOepDiVFD+SZi/g+5EuJteQ5rHUduBH
         K0GeeOXodQiTu0i30Q0t9u2IyIxk0ylJlUYDW2Aqm/YXvZ+hAyiuZ5bGQ8aYVTLVamaa
         ywDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1+CzJuKRAJ82UDjMAqJFvJXzSNf1DUQQCO4NJq6Tm4A=;
        b=QnW5iDYTmWkj98LBn6k8CfRjZ495i9dWrRWJrlV3Tex8fhz/42g3g/h6v1MT2SCmR4
         SCLCdZRm7U2sjCND3HoQFiPT2BHFfsX8AHt3QEUYQy6YYoLgoWNEOku6GYItYKhUeKAz
         xbzfgZRUYdATUw3Ig83TS12jZZ8xGocFycJshGRiJT2Bop4IOYMVQyI1AraUKI5Ir7pl
         00bxwaLv3ljhBCtwGhj0dgu3X3c+7NIC7PNLwaqALj+2opUGP+6D0ZFIWCUdv777ZOQO
         XHiMh77mcgB2k+gPwSUQ9GDdNUcsKi35l3ZPxrVY/Q0yd+pBoEAaEOu5NER8Hu7h8HNQ
         tmSg==
X-Gm-Message-State: APjAAAWbwW0e0NHUnqbIwxwT5KKdo8zIFHaNpPADUxJAhJuXIZwl5Xwo
        iDAyrGTnhTramKCEhKi/mxvDob6EAWU=
X-Google-Smtp-Source: APXvYqxDNqpAwFX5EvgP2QYadR5YdkNHk3Dgc01Qg9rQdok8PDbwWzZed5aw72jJ7k50yOojvEd9EQ==
X-Received: by 2002:adf:bd93:: with SMTP id l19mr449652wrh.160.1570306863343;
        Sat, 05 Oct 2019 13:21:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f20sm8521383wmb.6.2019.10.05.13.21.02
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 13:21:02 -0700 (PDT)
Message-ID: <5d98fb2e.1c69fb81.4f221.6680@mx.google.com>
Date:   Sat, 05 Oct 2019 13:21:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.4
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.3.y
Subject: stable/linux-5.3.y boot: 70 boots: 4 failed, 66 passed (v5.3.4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.3.y boot: 70 boots: 4 failed, 66 passed (v5.3.4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
3.y/kernel/v5.3.4/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.3.y/ke=
rnel/v5.3.4/

Tree: stable
Branch: linux-5.3.y
Git Describe: v5.3.4
Git Commit: ed56826f177921da1cc66a927de22ca1666eb78c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 51 unique boards, 18 SoC families, 13 builds out of 208

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-libretech-ac:
              lab-baylibre: new failure (last pass: v5.3.3)
          meson-gxm-khadas-vim2:
              lab-baylibre: new failure (last pass: v5.3.3)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: failing since 1 day (last pass: v5.3.2-1-g9c306=
94424ee - first fail: v5.3.3)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            apq8096-db820c: 1 failed lab
            meson-gxl-s805x-libretech-ac: 1 failed lab
            meson-gxm-khadas-vim2: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

---
For more info write to <info@kernelci.org>
