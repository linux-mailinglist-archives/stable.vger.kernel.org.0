Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 665C91901D7
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 00:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCWX1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 19:27:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40151 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCWX1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 19:27:24 -0400
Received: by mail-pf1-f193.google.com with SMTP id l184so8305320pfl.7
        for <stable@vger.kernel.org>; Mon, 23 Mar 2020 16:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IUbn5vVNjrK4OliLL+JANBM3q1l9NnT/Hqhv6uA8TCI=;
        b=Nu2FShrsrmwtIF3LEVStpPtaqdZ1P7iXHzAp3Rrvyt88OMXqzLtdofPgpkpF4cWYNB
         FlRae0pgdhxdAhTbnvrZQzR1yjSbatu169g9iXBhC5QIM0k4yCaScb9SaLSPkpc249dx
         OhtWneZ+i27o8tcnIRnTVz8jwlRI3hJ6M3lYWRO3KOkf3o7Jc0PFb/NJ0t4IQFED+dpw
         uo155wZsGZJIHuSKYan/70RJKtCFFPO+jZwqqeDP4fLbV4GiGbnl92g5ltvTWRdVF+cO
         m/unpxsKLFq4qHKNXAttrdZkpEh8kP3wKeJggPuCf/H7MPXsEwsotskpogoVqZca19sn
         HBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IUbn5vVNjrK4OliLL+JANBM3q1l9NnT/Hqhv6uA8TCI=;
        b=tHULAbSMEu8ty1QEUT3prtCefpzbhkz1fur6V7kihTD75ckx+FEL4hGYdicOfvPalj
         Z6Z2m6jeGQZ12kDWPEOt36qHk78U8b33KqdJxr3auixW6aFptfBfiRzoIZPoTiT3ZLYm
         XPiBV4jHmMtQ/Rn5JcigeOWSN4BTxCDV3dQP10leSUwPTLIb/fQ4lHA0mipvp+C9Fy2/
         uJK8hKzaK4yiKsk0MVnz4D0XHcxOPuchO577A3l1KiUV/52aX/N+SdYdSP+sID/465sb
         3u39DDslx+8clRADEX5tYGcdOnRDZlJDPsrCWQSUT6e/MRradZe2TRP1OmaK0jhSwhR2
         AajQ==
X-Gm-Message-State: ANhLgQ27Gpqfq1VnHRN/S6XZZMXZi6Z8hNQ371i6ikEhCApn34jDQySa
        fO1pK6rNkQ0s0EyI7BOUEt+nj1Seis4=
X-Google-Smtp-Source: ADFU+vt0QPd3BgkTqCWzceU69BEn7uG7dh0cPXNsjyt+SeZL2qDpEHlO3MuVqQjrSvHCz23gL0ycCA==
X-Received: by 2002:aa7:91c1:: with SMTP id z1mr21174598pfa.100.1585006042320;
        Mon, 23 Mar 2020 16:27:22 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z7sm596253pju.37.2020.03.23.16.27.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 16:27:21 -0700 (PDT)
Message-ID: <5e7945d9.1c69fb81.a293f.2ebc@mx.google.com>
Date:   Mon, 23 Mar 2020 16:27:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.173-140-g00befb200af4
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 130 boots: 2 failed,
 116 passed with 4 offline, 7 untried/unknown,
 1 conflict (v4.14.173-140-g00befb200af4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 130 boots: 2 failed, 116 passed with 4 offline=
, 7 untried/unknown, 1 conflict (v4.14.173-140-g00befb200af4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.173-140-g00befb200af4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.173-140-g00befb200af4/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.173-140-g00befb200af4
Git Commit: 00befb200af4e65e41fb00da8490d51a9673ff4d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: new failure (last pass: v4.14.173-100-g5510299b=
1b08)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.173-100-g=
5510299b1b08)

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.14.173-100-g5510299b=
1b08)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 44 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 32 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.173-100-g=
5510299b1b08)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.173-100-g5510299=
b1b08)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
