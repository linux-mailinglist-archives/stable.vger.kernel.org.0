Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9D98DFB8
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 23:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbfHNVWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 17:22:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44854 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbfHNVWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Aug 2019 17:22:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so409322wrf.11
        for <stable@vger.kernel.org>; Wed, 14 Aug 2019 14:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gOSGHAnv1dzyIe8EDgubNAZDWKQjn+KiJwRJWkvxmCs=;
        b=EC/+D2BDOb825HWcottF+dUdirOBrVKrcpqOaFymuR+l0Mw6OapubiT05zonOv3AUu
         UbPgpewZbIjSaE2sdIqJpXbrpPqYg/ZnSzCHMahcbjiFBTVs4iAbN0hbu9BmyHt4g4Nd
         nCBQLVWHDxAKSl59pGXPQoXeIq6zyy2BJokP0fseauQPcln4T34YMlQ7LWk3z38nru9b
         CwKGnVVMlEQLfa4PzZ2fEwYXGtkmKoqCranMuddyi+lHxRggnn8YxIidXe3rFUmNBYoq
         qMAZsOjDVjUskB+9hyEaM+F14pFxV8qeQuki+ZHRvVv/RP0nXCxSX8sDDLptcWlT36nd
         dibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gOSGHAnv1dzyIe8EDgubNAZDWKQjn+KiJwRJWkvxmCs=;
        b=Erb1P9C02djhxtDUqKb6IrmLpuGvqUiEjZ2YueyjKslvS5Ym/iYK8h6TMaI9qojZN3
         6Gx00hjPZjKRJ3B/C5AsP6cVM5S3fvkJONlqvgGZhjAaIIE+HMaU76jzdCCBJI+Rli72
         8cBw58Jz/SnAV0bmDbQgAa2UIvdKVR55O456uVSHVUpzMPVsHB5qfSat2RH2JQyTncee
         VN/BZCDBpTKxxeHZWufduOEWb538b9YorVefr0z6NL7CB620njxo6xuHBR2LqSEtaUE4
         pAlC5L+1h5Kmo96UCaKTmQ1ZoYZN8o0JToyzPkdLEIqb4kZYrmOxo9yL6rljde5suS9t
         Vkkw==
X-Gm-Message-State: APjAAAXfuPf4uhitnP2piQ4lofAGcZg9hsAbQn07bvKzoqAbx6aXn1EV
        y7/VpsdTrbrYzNO+KLE0f0IS+NeZVee1pQ==
X-Google-Smtp-Source: APXvYqypPxzcF8ji242Ed8XjSBt6r0p1yCUrb0jtNP2gL+LmDSD0NGfKq+HUrv3RR6Q7rVtCkl7bDw==
X-Received: by 2002:adf:eac5:: with SMTP id o5mr1764655wrn.140.1565817758352;
        Wed, 14 Aug 2019 14:22:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e4sm975200wrh.39.2019.08.14.14.22.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 14:22:37 -0700 (PDT)
Message-ID: <5d547b9d.1c69fb81.bea40.5094@mx.google.com>
Date:   Wed, 14 Aug 2019 14:22:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.66-92-gf777613d3df0
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 136 boots: 0 failed,
 124 passed with 12 offline (v4.19.66-92-gf777613d3df0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 136 boots: 0 failed, 124 passed with 12 offlin=
e (v4.19.66-92-gf777613d3df0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.66-92-gf777613d3df0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.66-92-gf777613d3df0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.66-92-gf777613d3df0
Git Commit: f777613d3df0e7226d30d0e0ba97e9419e3064f2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 26 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.19.66)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v4.19.66)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab

---
For more info write to <info@kernelci.org>
