Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF845742E6
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 03:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfGYBjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 21:39:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39426 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfGYBjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 21:39:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so48838493wrt.6
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 18:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jbiaNFwTVHmObvQCaIGeKKoloe6kotseGVWW2gZ5WX4=;
        b=iHDykFM3pkVZ/qqRGyd31Y6+CPRXWZJwO1ZY0xhjgoHsHITkSBYAMmVgK6ilYDmj/z
         M6d8PAL+1o1guGkplIPg2FoArPpIfxsHXQFk0nKkILd7TJQRPdfK+UdBoxaAJSDfcThF
         6MPPH77ZSiK2/KDW1G3igSYyXHFyN+zRXJuYvm8Sm/qDF8ssBP51ra47JuWJxzaEBPj3
         iMo+4k3n04qscOz4hQ7a7BNh+pL3kk3PVmFEl1/hM7quQr5Cyli8kxxa75H/XUGitUQ2
         BoyyYH51G8hNHS74ol+0RCgqrNaE+3EzztgwIE2Xy6/9FN4LZ8LzpIKgZRYuB2szanms
         cAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jbiaNFwTVHmObvQCaIGeKKoloe6kotseGVWW2gZ5WX4=;
        b=rxgqyL3abfwFhPHHp9TDvnKckpXnOicWqHVki757nLHQajBZGwxWtnQAmLQOoYEqvu
         zPiekaHrIHAyuTcqqEhOgy3CZaM8z4dxibraNE4v+TmKM6lRft/KoRb4KYP1EkeDX+W+
         0Qqc0qZDR/OYYwUUq+Cm8cT1c5NKn8zFnyZh3t6eXTM8ctvm6UL3qP/jN0mdpRK8HzM6
         1ZFxCNZ23xO0+X4fEAPwgxAtqz6STodxDsELzvQ+xcfJBZVGWpg3X0QshfAeXdl75x3y
         NPvZREE0XWzKxMwXfLIeCOMb/Erm73zMctvabxqdIjx45M0HCTaVHEXCepm6uC+c66+c
         uAmQ==
X-Gm-Message-State: APjAAAVvjDRAQVdYKhF5cbKgFPuHEj9kI6ykKcIePDLLXq0m9CFdpE6c
        9AJ3qvtb0O0DST9TJ55xSGpYkxqKDd8=
X-Google-Smtp-Source: APXvYqyxyWuQjL+W2wmM6EGQMphJLu2aLpnLg1kW0Z79CpBtFqe4JaxB5NQpWRiQrujHv2+kRN0jvQ==
X-Received: by 2002:adf:de08:: with SMTP id b8mr65385517wrm.282.1564018752047;
        Wed, 24 Jul 2019 18:39:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r123sm43935326wme.7.2019.07.24.18.39.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 18:39:11 -0700 (PDT)
Message-ID: <5d39083f.1c69fb81.32e4f.4811@mx.google.com>
Date:   Wed, 24 Jul 2019 18:39:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.186-87-g08853233f3dc
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 96 boots: 2 failed,
 93 passed with 1 conflict (v4.4.186-87-g08853233f3dc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 2 failed, 93 passed with 1 conflict (=
v4.4.186-87-g08853233f3dc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.186-87-g08853233f3dc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.186-87-g08853233f3dc/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.186-87-g08853233f3dc
Git Commit: 08853233f3dc1af30edd80205c1985e0db76bf47
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 20 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
