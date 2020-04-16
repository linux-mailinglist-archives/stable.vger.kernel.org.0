Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9021ACFB5
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 20:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgDPSdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 14:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbgDPSdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 14:33:09 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE3AC061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 11:33:09 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n16so2027196pgb.7
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 11:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xIeaTrISHv/2qN73zZFj7p9GWBSwuaAuoS7mHi8Z29c=;
        b=OYVrbHWiNutEEPKGqijcTzkeC79TDOqJHQzj2AsZlALkpRY7pP+TgkHKBJ1FWL9gPF
         4w0iDDUJCbfmf56OoFHklOs2RLpDEmAB3lTqXciqpKeOb6Zyr78PMV78oQNezyFPk2yT
         XrBF19w4v3j/Hnz4DRNVqsYZedsaZr8CDmnCSkhUEScPvF6HikvdggKn+yY6b16pIl/R
         h7fziZ8m1NB/dEFLob7HF3oPNeg5l+4yXRQS13Fn4vQrmCr897R/rWGEGTl+HjOEIG0c
         BrIxLAHK8dHy4mOuZBK9sYwMc8Dv83fADn4RUGfEkVlBa9cel8CtvKf4icOMJ+Orzzo/
         Ag6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xIeaTrISHv/2qN73zZFj7p9GWBSwuaAuoS7mHi8Z29c=;
        b=VYOiddBEOJXcFvKMuHVz0dn2HErbQUFtGWeFsIW4QiXD2LHjpe7REjoijlaLXzaRgy
         cUmC+Zkjqtk3wGgJ8lVDaNfNGSo51h5H3JTY87G51Y5vHe1IobIX0FtAxpehP1UNRXGY
         EKJtW0bXYsw2/gf/Plv6J65VeyJGj78xcEoSEvgeyeUV86sCoXyqBFIzHsiMwlYTCHKg
         MYbUgMg+ehy4IL32nDuPGTdTaRmJ0N5vt10nUhFK+t/ZNBeNSo9T4OsQgFzQtk1S4pc2
         tbnuJxTQ67GAbkmWXnq23U+UBco9QFuv/rN4NOOJzNKHV4LEGr68AQTi2C2sHzHQtLFE
         7q6A==
X-Gm-Message-State: AGi0PuZbtFPHFamTiGCW9BWz39QybkTekSaJuZU84zEVUvK6Q9XHedTq
        ZxmiTvm4ijDS7kLD0LTlweZ9ftJv6Sg=
X-Google-Smtp-Source: APiQypIjkSBPVKvN/NBgmXMboeGVQUjpmsl13Yn5nLAHjSEUcllxeeZXk7rJOZeDmuCJbNLMPoA1vQ==
X-Received: by 2002:a63:1562:: with SMTP id 34mr8016248pgv.150.1587061988439;
        Thu, 16 Apr 2020 11:33:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11sm5268133pgs.25.2020.04.16.11.33.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 11:33:07 -0700 (PDT)
Message-ID: <5e98a4e3.1c69fb81.5ae1d.20ee@mx.google.com>
Date:   Thu, 16 Apr 2020 11:33:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.218-99-gbd51c04713a4
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 113 boots: 1 failed,
 104 passed with 2 offline, 5 untried/unknown,
 1 conflict (v4.9.218-99-gbd51c04713a4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 113 boots: 1 failed, 104 passed with 2 offline,=
 5 untried/unknown, 1 conflict (v4.9.218-99-gbd51c04713a4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.218-99-gbd51c04713a4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.218-99-gbd51c04713a4/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.218-99-gbd51c04713a4
Git Commit: bd51c04713a4f34dd89ff3897c11e9bef252825b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 68 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.9.218-93-g827144487=
8fc)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.9.218-93-g8271444878=
fc)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
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
