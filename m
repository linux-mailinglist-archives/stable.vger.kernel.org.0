Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C951C4C34
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 04:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgEECdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 22:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726482AbgEECdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 22:33:17 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C40C061A0F
        for <stable@vger.kernel.org>; Mon,  4 May 2020 19:33:17 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l25so359946pgc.5
        for <stable@vger.kernel.org>; Mon, 04 May 2020 19:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bTrJQuCBqKQd5ukqbPtpGInZPMyTQZBG+ca2+eYSkho=;
        b=TyaSko37cGsTgV1lZ6SDT4tXQUINPJh1ng/TbEUk9BWd2rnnVBfHZuV4vhYSWCEJkx
         X31vDwdhXvCSEgfFjCMrgPatsAvv/ZdxBpMJR3cgyi5i5gRWSQctPtX9g9frmYzxPUTl
         ABnc5QbghQh4F/7tMIf8UhJIeqS+BWxzKUcam0GkczPv/P9FYSeu/qe5KUghJnKA/OWn
         ROhQwCB8pkUjXnq4SpMQ3NoRF9ZqcfZJ65C2OOkBpD7OjdFLSOGfIkvhxV4nP05KS11Y
         u1tJRqEIye0eHwKkPgIUNQQuVUPAau2lVZoZb6JTAB2tjATOu2Ag8brIJevoV04gXOYy
         uVbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bTrJQuCBqKQd5ukqbPtpGInZPMyTQZBG+ca2+eYSkho=;
        b=HB4Vy7ScPiXJdMCigHoqO31IJAHxc9TwQGVjBcUeD/3se1BziJRdiijYyZaaWo5EFv
         Qi+6JKMMFmwxj7giOjtMNC9abSu5INEgPNkgvwrxfSWLCNojzQ3EIyh8cPTnq+aAzrGK
         UUrVagEk0GqvqvDemkjrsFQCiqCiiioux6ACNUaPGP0U4e0BqVaEFy5dmuQjqoYr6tx8
         XEdAvazbSNW5CEF4KV/L/Oq7xG290134h8ZpNXr9AqoWM8Jo32Yn9PwJK808jXif7wLD
         xyi3Umu8zCIDzkv6il9eeFmFF6IfQSXEHK8p3YBBS06LoJ8gZ8wgyexzRm2UGwiSKhQi
         slvw==
X-Gm-Message-State: AGi0PuY9fq8d2PBC2rczWEGwgkR7lowIW9N0Z4rBHBN5m/5N/0LuGkzE
        EyGWVRQ/RvD3Vcab9c4ABxqmrNqFtUs=
X-Google-Smtp-Source: APiQypLgCO+BFUDEJ8lybf2csnjuTGa6rUO6LG6COEhEE6YiZeEyrCOPWSwKI0ytTKm+9X0ClH4GAg==
X-Received: by 2002:a63:8843:: with SMTP id l64mr1058567pgd.443.1588645996512;
        Mon, 04 May 2020 19:33:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i13sm289718pja.40.2020.05.04.19.33.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 19:33:15 -0700 (PDT)
Message-ID: <5eb0d06b.1c69fb81.8fa3f.15a8@mx.google.com>
Date:   Mon, 04 May 2020 19:33:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.38-58-g29ca49e0243b
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 158 boots: 0 failed,
 146 passed with 5 offline, 6 untried/unknown,
 1 conflict (v5.4.38-58-g29ca49e0243b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 158 boots: 0 failed, 146 passed with 5 offline,=
 6 untried/unknown, 1 conflict (v5.4.38-58-g29ca49e0243b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.38-58-g29ca49e0243b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.38-58-g29ca49e0243b/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.38-58-g29ca49e0243b
Git Commit: 29ca49e0243b0d2bb55a2ee418f3cdc1fae69627
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 98 unique boards, 26 SoC families, 21 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 86 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.38)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.4.38)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: new failure (last pass: v5.4.38)

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
