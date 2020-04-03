Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC2D19D6FF
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgDCM5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:57:50 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:37948 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgDCM5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:57:49 -0400
Received: by mail-pj1-f68.google.com with SMTP id m15so2905246pje.3
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X85tjlgk4tZ4x4VpiCP78DOUndN/FbleZpqwWqFlZDY=;
        b=jhPWyN5Z6sesmke2RK/Owk8k1nDg+LLbPE87kVBKFp67+UFGmORKSio42JxVjPguPo
         yQS1ClgfX2Se+1WYPr++PwUoX3vOjVSrzT0cwYJCMqsDBr/Dz4admTsQIOTF608yoYzu
         VJp3PXZqh+d1cdlW9FgQe6GpS8FOq9S06N3UTMd0baT5Ycx0cbR8m0+2YLxd2H9/si/X
         7o1S5QgLP8QLMGPFv0Vdav0BGtIBZti1lo0qzp02qmX+msAeSC/PkiCLOvytBnxrqGNT
         kyz1hvg72ExBJB+R1OyekRAPKJ6F/l+JxfFydSUSigF8kA7VCYCqmjwZMwBzKvbsiu/H
         4+DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X85tjlgk4tZ4x4VpiCP78DOUndN/FbleZpqwWqFlZDY=;
        b=IVOvBSfdiCMJdKmej5fAnzKz9L0UraMOxqhqe2RwXJLlnbX87lBxuqJeJLHmY1PB19
         qtRizMoWMBEsuiDnYYiAWeYVQ3m4z2MPvU0ohEtnkNwovKoXbBy1shHvsmFRWsJu7xIL
         GRlO6FnlQNDlEmOnz9Haq8JSEI8FFWVESes35EtDbNcD/FGuc4c+dz3lPR1Y4nHPeIlV
         4LJexHSpgiEoIYv+nWQBZUC3pZMpiiLeuxnMku4MO5FTdKlBf1KYiACDjCiNrfBn2Tg/
         7M7A6Z6JkSTxWOKLSyj3chp5uoQjTtHWHeZDk5k8xolYo0boWiMajcuaRABYBBL47+1q
         0rgw==
X-Gm-Message-State: AGi0PuYgvREGx35a9I//cim21myk9IT6UBQi4gHV+W80LC3/kP5hptQ0
        HhiRLkZNF4ZqkQqCXQonQMYD76Mszqg=
X-Google-Smtp-Source: APiQypKADVRy8o+8oGy5UCrcnwamw5xFVlUZdtLHEAJf9qC2PsYEIDJPG6TbSyHvVZ9AYOAHNN7RoQ==
X-Received: by 2002:a17:90a:a602:: with SMTP id c2mr9519129pjq.135.1585918668117;
        Fri, 03 Apr 2020 05:57:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i2sm5794606pfr.203.2020.04.03.05.57.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:57:47 -0700 (PDT)
Message-ID: <5e8732cb.1c69fb81.9d657.ac63@mx.google.com>
Date:   Fri, 03 Apr 2020 05:57:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.30
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 136 boots: 1 failed,
 130 passed with 3 offline, 2 untried/unknown (v5.4.30)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 136 boots: 1 failed, 130 passed with 3 offline,=
 2 untried/unknown (v5.4.30)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.30/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.30/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.30
Git Commit: ad13e142e024aa194016a32de8b9ba058fe9a6af
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 92 unique boards, 23 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 54 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 18 days (last pass: v5.4.25 - fir=
st fail: v5.4.25-58-gc72f49ecd87b)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.29-28-gc1d=
6c1dff8f2)

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

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
