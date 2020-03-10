Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B40D1804EF
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 18:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCJRgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 13:36:45 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39205 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgCJRgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 13:36:45 -0400
Received: by mail-pf1-f194.google.com with SMTP id w65so6276118pfb.6
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 10:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LVVqIwhA4KWhDQBoypSI4s/sgookMvrI4Mo+jHYh74I=;
        b=gswgUUcAZZE73iESunCoKJRHjAWZDvjhutlc6f+iHKiaCUUhU+7Cgwy7+vXx3hHQwY
         NCiFDv4DzSKtimSBRcpAaRwdaues5W0BtAjvhriBGaD/3zroo0eQMqOhqQmrwf6b+sFD
         UJcf8Wdfa2n7HOF+7f0utjIhhcl2SOa2n/XMHZRnY4mKYvvOxRR7acS88RrX9+evKIV7
         KkV4NqNji74LFTr8TJDLkHCIjCkt+Wm4UqzMYpZbm4ZPQtUPXJbnt2It5bNmzxLuawQR
         9L0ix+wQ4IsmPVYQg/bvCPVd233TaKait4QuvWnWbdrmDuVCUnF8rf6V1GVYw53in+Zl
         Ie8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LVVqIwhA4KWhDQBoypSI4s/sgookMvrI4Mo+jHYh74I=;
        b=lQsq1Tq+CRnjQRn1LSaTUL3LVmFFhX1i8yFHvNzLdjA8tKp41YndeKgd4LZswjzLRt
         +WQBzUjLqgJuMYqJcf/rFD8wgCzfh8rwq0jdhBSUTAERqCTuQJiNxK7nU3GCuLu7fDcl
         rObSJz93HE3164AEKXhWx+yUryJpX7MgIauAXMVtjKuKcK6BRSOIjC8+ech4T2Q/+CSp
         1QvZ1lSWEv2yvIutB/sFSVkANmUiGYzQvw+0VRnB1NO8ufvHNYspzauZVRVfTzpaeTvp
         rSJSKcDBynPd8+3+F6Wu356jCG1gWxSMo35kZ2sOSSw/who/1DuvLJoSRlFNva/3bPYF
         m8sw==
X-Gm-Message-State: ANhLgQ0z4b8lTR6lm/kpCUQFLIe6GuUnqit8yQY+wHUHO2Dfet9MlIuX
        hxUi/CFuozaWWD9Pd4L7io0ezWjjSYQ=
X-Google-Smtp-Source: ADFU+vtX9JSdQxsWOH6KeaM5OT0f9NT/U9jdpNTIzHisK4qM8IvxmEBFAqIby3El78Hu7l3kVew6/Q==
X-Received: by 2002:a62:aa17:: with SMTP id e23mr22540105pff.45.1583861804207;
        Tue, 10 Mar 2020 10:36:44 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l62sm33885740pgd.82.2020.03.10.10.36.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 10:36:43 -0700 (PDT)
Message-ID: <5e67d02b.1c69fb81.fb890.c962@mx.google.com>
Date:   Tue, 10 Mar 2020 10:36:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.215-73-g836f82655232
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 64 boots: 3 failed,
 59 passed with 2 offline (v4.4.215-73-g836f82655232)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 64 boots: 3 failed, 59 passed with 2 offline (v=
4.4.215-73-g836f82655232)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.215-73-g836f82655232/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.215-73-g836f82655232/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.215-73-g836f82655232
Git Commit: 836f82655232ea02028bb5857f19bfd950b33c33
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 40 unique boards, 15 SoC families, 15 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 31 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.4.215-62-g1e=
f447a18aac)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
