Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46C99165A
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 13:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfHRLXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 07:23:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43347 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfHRLXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 07:23:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id y8so5768873wrn.10
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 04:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=32DfOyOwY7BsX854kWf/n3qoxl6VAY4fK3Wg/tECAg4=;
        b=vQOhbMv5ZWwQgftE0IKyUNIg442Aey2rFcZnSGvHSiFonMckoQkQWkS+laOwbEKRFp
         urXmgTusK0eh1BCJzvD9DSZ7DBMY98fgrk/uL38iphSFoqCAFTDYS2VkwUcdr2g9OGtP
         kVua1+jzL0tztxpbUyiydBpTdoGERaLuMPSq/6nM/2SvC8EINsMfahy+N+V9ZBhVeZRi
         eBVFimDDPCnz/xvn4VP37S7QPWAs46tUghyKt7gYC9B7XnB+OLDR83L6ZbwtLLGbOgfK
         6y4afyeHCgltpj2enlQtNzAE3IKcjZmV4oDTPCiyoN3+4c1vgasWfb/vt7ljwDvr3eza
         2wAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=32DfOyOwY7BsX854kWf/n3qoxl6VAY4fK3Wg/tECAg4=;
        b=l7o7Gr0xJsT6m4T52+W/+96PciETWKX71DoQZ9Qi4T16fBUV3yDQbDyasXFaFC9M/I
         2W1UsuAokHrqENVsoGUfkFxoAaDpP+MPfp17IvpHnztC05by44R4OfB2XABfH3nj9FGW
         gduJqZpkMvfDKSHMvHIuJyaBa6CXb87QFQeAIoYeRDQTqCP7zJ/UoeJ/jTB2EvH3XS7u
         /H6xYGaC2FVVuZ8uxyg3m7LedNShBX8ZiEVkCV4EJ9UYkL/glQ6IH8zZhALc6CAMaP/E
         f5zxcwY+/vumyFujwR9w2Q4q+ThcV2CuOYfO0mwcD/Do2MqcYZoE7hUCudsR0GTvnN9z
         vAKg==
X-Gm-Message-State: APjAAAXwOyRaHvAZeoIq1UrhgQ5e3obrSd9iirN80CcjWScnSFUx6nTP
        sp5BBZ/1i+4pYrUiBHXv4zrAn0HLi0k=
X-Google-Smtp-Source: APXvYqy7dTlYPJL+Nf3UPoiYQ4S7fZg5zTd0PGijIfJCxzHm97dgONOuwtsCap10QLlulvloESY9ZQ==
X-Received: by 2002:adf:8364:: with SMTP id 91mr20738748wrd.13.1566127386526;
        Sun, 18 Aug 2019 04:23:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r16sm24348768wrc.81.2019.08.18.04.23.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 04:23:06 -0700 (PDT)
Message-ID: <5d59351a.1c69fb81.9b104.93a7@mx.google.com>
Date:   Sun, 18 Aug 2019 04:23:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.8-177-gfd570399d29b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 29 boots: 3 failed,
 25 passed with 1 conflict (v5.2.8-177-gfd570399d29b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 29 boots: 3 failed, 25 passed with 1 conflict (=
v5.2.8-177-gfd570399d29b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.8-177-gfd570399d29b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.8-177-gfd570399d29b/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.8-177-gfd570399d29b
Git Commit: fd570399d29b727fa483a0175fe0592d9d57f6ee
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 20 unique boards, 10 SoC families, 4 builds out of 207

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          rk3399-gru-kevin:
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)
          rk3399-puma-haikou:
              lab-theobroma-systems: new failure (last pass: v5.2.8-157-g9e=
53d01dff58)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-nanopi-k2: 1 failed lab
            rk3399-gru-kevin: 1 failed lab
            rk3399-puma-haikou: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm64:
    defconfig:
        r8a7796-m3ulcb:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
