Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558901AF78F
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 08:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgDSGcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 02:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgDSGcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Apr 2020 02:32:43 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1564CC061A0C
        for <stable@vger.kernel.org>; Sat, 18 Apr 2020 23:32:43 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o15so2853698pgi.1
        for <stable@vger.kernel.org>; Sat, 18 Apr 2020 23:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YZeUbwu49UlxuAtyTITu/IQtfMJK4XDjvZxPOxyea3w=;
        b=KfneottdaBFwJPC3cnuoaJBKjKKObBZbyxb+1qDge9ariUQPF3O/HOnCxiTx9Fp/FP
         J+bVi0H8zmnzNZgCGAdUTInGxxS08AKhfBdpWuG5jlZ2x/F2v+ttsFU/ydJE9NrYdXMF
         O17r1/wAuIAqg1ufr3ggzrVBIQuOB8pcgjJ3pGgaRJaldQ/sQB/+Xvwm/HdGhqABbmZi
         BZabpnc36CKUp5wba3k3oG7VoSdDkImwN8Qy93P0ubcxVE5pHMUloGqlJ1MT1P7m864g
         mPxy21L65Xtco2UKzI+u+YWhTQPxmWK6w0vyAjFCMrA2A6kUwk1lgnqLEM82TR1nbNfL
         ofRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YZeUbwu49UlxuAtyTITu/IQtfMJK4XDjvZxPOxyea3w=;
        b=kzb4dCdlwvMNVtQxpX/0X8AHR2jWQTUZKRoCYkGXsjQpCR1ndtvTZiYnDa2F2oGV3s
         Lr4VX8RO0QLEQRKRA1/Lnz3GjuJe+QRrIVQXDOEZx478muFWGniXMhmBgdVuNODq9lRr
         CA9sfl26XuKCPkOIAyu6SBEFrfINeXSyQV7481p5/Y3gOaK/CDMT2Uv0C+7T/ruDQDy4
         vPMsc5DQXCWtdyj6B6MvAciMl/h4pXoWcLraHUxXfZ3Dbu6fcnXeQ1mGxWZFYedYM9Yu
         Aj9p9xbINOQekg++MXALruBT+Zie4nuH2Fsa6yVWNwvG007l21vobVy2/Wukcw8Jkfu0
         4X1Q==
X-Gm-Message-State: AGi0PuYqY55kQ0uWrfmv7z6E7LvMVg2lSww9URE3gNQI3y9CWryXiSGp
        Kfdm0Qtgacb7IyCOhwfimNOtQzGISWs=
X-Google-Smtp-Source: APiQypLZFAHQTkWzxHJeDDQk1qfiPAmiJtyF+9CpLZvVYy1yLjIZDvt8paNOW25Luj6iQ5TUO+Y4Fw==
X-Received: by 2002:aa7:9811:: with SMTP id e17mr10774074pfl.70.1587277962163;
        Sat, 18 Apr 2020 23:32:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f3sm10071226pjo.24.2020.04.18.23.32.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 23:32:41 -0700 (PDT)
Message-ID: <5e9bf089.1c69fb81.8032a.4687@mx.google.com>
Date:   Sat, 18 Apr 2020 23:32:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.219-79-ge4f3ca7a34da
Subject: stable-rc/linux-4.9.y boot: 112 boots: 1 failed,
 104 passed with 2 offline, 5 untried/unknown (v4.9.219-79-ge4f3ca7a34da)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 112 boots: 1 failed, 104 passed with 2 offline,=
 5 untried/unknown (v4.9.219-79-ge4f3ca7a34da)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.219-79-ge4f3ca7a34da/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.219-79-ge4f3ca7a34da/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.219-79-ge4f3ca7a34da
Git Commit: e4f3ca7a34da1bf21cc4030655e8540cf6333d74
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 19 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 70 days (last pass: v4.9.=
213 - first fail: v4.9.213-37-g860ec95da9ad)

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

---
For more info write to <info@kernelci.org>
