Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A34618C124
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 21:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgCSUPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 16:15:37 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:56069 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgCSUPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 16:15:37 -0400
Received: by mail-pj1-f67.google.com with SMTP id mj6so1488580pjb.5
        for <stable@vger.kernel.org>; Thu, 19 Mar 2020 13:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KLt3d0kc/6IScW0PgBUDNCmk8NRnutHBnZEGlBjh5WE=;
        b=ZNuVmfqoNGEwgFNhpEzLI1n0UWzu0axZDtbJ3jINYjCsd5SAjmCZnwcSStAWG7PTnE
         ARW5MRC7A+JNBTeCBfiTOUnt7fDI4r3LSC0pMjCfmtNIqANNBK/U5UkvXpWNy3etAypW
         UbI/KI02+XqJIZqZkppLEaUj3xOumdmjLPrgkaFB8d9o/Vg7r66oV+ZXGyuq25p8mg+S
         GRw+CQloWRak0oOhTMfnRSozaIy1gQgeKnDtw6GXAsrsC2S19qZxNz2xDLTwNazuOzOT
         nY4ZirjpJaBIIQd4u1UULitKbziDYZ0dM/vaX789+D0UKEoZ8nfSPCaVgm202ZgjURdw
         dVYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KLt3d0kc/6IScW0PgBUDNCmk8NRnutHBnZEGlBjh5WE=;
        b=Xca3bYB+F4pWnOtiuxRY5csKgHTQ5cEA1ge92K3xW7HLdRMHiiOreUL70rTEqKUycZ
         j/v71zsbP7CtoPtOBxDS2GsGEJaL402yKI3NbDsp+oQ9ygN6S51oVWeDHLVHwJ7TwLfn
         uO5CcEydfg3ljBLn1Y3pnmmY2mp6Dg+2JWa6wUb9olDK8htv1WAYSIPcCR01mRbflC84
         NzE4OJ5fs+BMnb0o8Qs9CgevjcQtVDE7Cqa1LgDIVNgLHYGcbqhf5wt5gWsSGRrIOh+K
         C7zuKKOT1JvM/3s0gG4OlO7pEZ/YOX3bQiCke9bDSW4aGHCqYuMuls/N9fgBnn+xga/3
         R0Sg==
X-Gm-Message-State: ANhLgQ2UScVv+eLjfflOkQqCoS4It9AY3lhUNNSgKAEUSietO8AxS1T9
        HWVFuRI9Oja83eOWpFEI2Nr8hVEG4lU=
X-Google-Smtp-Source: ADFU+vvtCtiL0qjL5/Va6Hf8EXCAEKq+UISz0oSBndfj0VykH55sbhvf1IH7ISz3ePbqCwiRft0Ipw==
X-Received: by 2002:a17:90a:1784:: with SMTP id q4mr5563748pja.111.1584648935360;
        Thu, 19 Mar 2020 13:15:35 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c128sm3157884pfa.11.2020.03.19.13.15.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 13:15:34 -0700 (PDT)
Message-ID: <5e73d2e6.1c69fb81.6f9a5.b5f3@mx.google.com>
Date:   Thu, 19 Mar 2020 13:15:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.216-91-g8130ba7a9b6d
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 111 boots: 1 failed,
 101 passed with 4 offline, 5 untried/unknown (v4.9.216-91-g8130ba7a9b6d)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 111 boots: 1 failed, 101 passed with 4 offline,=
 5 untried/unknown (v4.9.216-91-g8130ba7a9b6d)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.216-91-g8130ba7a9b6d/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.216-91-g8130ba7a9b6d/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.216-91-g8130ba7a9b6d
Git Commit: 8130ba7a9b6d7bce0ecd428b5d085ea493ff3bd0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 20 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.216-75-g6e=
e407f35904)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 40 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.216-75-g6e=
e407f35904)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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

---
For more info write to <info@kernelci.org>
