Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CE31AB419
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 01:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388104AbgDOXOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 19:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387914AbgDOXOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 19:14:39 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDEDC061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 16:14:39 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t16so613480plo.7
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 16:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jvXWyNoyl+lwZuQAzhPgwcQwIa6SburGS2IlSBaAuqw=;
        b=HkCTx+/DnHxy0kCvXDt+SUtVCnwavjl/Q6vsod0X7/FpWVGJAXgz6YxKTIpDX0PZdE
         LPQpnVSjkQ24/cktoUwUQBj4J1x21ivli/BLewmAmUZa/t4uMLmAGWcVHh0BzMKNeRTA
         CZIUeZlt6pwCjw94eJRX5q9nxlEqB0zfI/LpA0VgFQLW9ChZ7LYeKdpNXxXhES/xgc+K
         X09eSgHmCJXeKpiFzIGdUmpYMuuzWOv1mfE9jK27KxvBn9nLsS/04baKvN9duDEDWnu2
         jupvLVjCCHfuBOUo9ld3uQakUIQQ3K2rlNOx0EbR+C6osUuSDEYJ4ay214B8NOJZurjb
         HFhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jvXWyNoyl+lwZuQAzhPgwcQwIa6SburGS2IlSBaAuqw=;
        b=BIGQ0BBRW5TAoK0mB5g3aiZC8OpHasB1ta0GAOyaunFaez5FwDcLsU4kLJpQUp6fkN
         8upIyCd5tjf1cnxc6FxLk/7Awfc3toTdlCkzztKM38COi+Wns5d5UJBqNDYC4G4GPJll
         6kg02dcGncPRWE72uIoHh9ByFwU6CLT8h7wL4n54Cbq/VpawZTKjDIibTyCyBB5n/fWj
         7FFrW3oJ7iwWvxoelia29lFuof7IrZY9PwRsrH6Fg0AjEyP4aTMfUXfl6MwW9DEj/5X8
         qfOf/AAgOtT9jSGfF1EINec67HufEQKh/2CB9yVN8qE/n2PSsPdSLnT/Nv/YS2ushSnx
         EvhQ==
X-Gm-Message-State: AGi0PuYjP2sE3k1aR/xtMe0PfH4bNlHuJzaFcwm92FRFPwS6mGP1FqIG
        33Ljc0iAj2g5mVlb0x9uSCzYWPUzidE=
X-Google-Smtp-Source: APiQypIUCXLqXZh1pvGaIPrYW0KS+1q78CvvfUTCesTKTx01au0W/3lXyXqcduDMJNFw/7Ol8euobg==
X-Received: by 2002:a17:90a:94cb:: with SMTP id j11mr1811261pjw.160.1586992478444;
        Wed, 15 Apr 2020 16:14:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e30sm5212862pfj.114.2020.04.15.16.14.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 16:14:37 -0700 (PDT)
Message-ID: <5e97955d.1c69fb81.8a349.2f92@mx.google.com>
Date:   Wed, 15 Apr 2020 16:14:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.114-185-g53a9f76066d0
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 83 boots: 1 failed,
 75 passed with 2 offline, 5 untried/unknown (v4.19.114-185-g53a9f76066d0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 83 boots: 1 failed, 75 passed with 2 offline, =
5 untried/unknown (v4.19.114-185-g53a9f76066d0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.114-185-g53a9f76066d0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.114-185-g53a9f76066d0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.114-185-g53a9f76066d0
Git Commit: 53a9f76066d0832721801cd2fe2431facf1b8cab
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 19 SoC families, 18 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 67 days (last pass: v4.19=
.101 - first fail: v4.19.102-96-g0632821fe218)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 33 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.19.114-55-g3b903e5a=
ffcf)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v4.19.114-55-g3=
b903e5affcf)

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

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
