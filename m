Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3421318DC4C
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 01:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCUABk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 20:01:40 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35600 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgCUABk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 20:01:40 -0400
Received: by mail-pf1-f193.google.com with SMTP id u68so4124883pfb.2
        for <stable@vger.kernel.org>; Fri, 20 Mar 2020 17:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kB4CbVlfwtPQyy+jpUqdVgzxyxtpeKkOKn8fpK4zlK0=;
        b=UvtFR7eWFVg75rowiAkN2jXhzwXb82LWgbv1K2TwPWpL21ycS5pOt45SS5CitH/i15
         Uv0L8L3a8dxUEi+FPUFTbcTT/ks3tUvvsqeo5uWJlrUZuvhIUEwzFXaNWBFBbbYJQNT7
         SZMqaScltHmLGyLMr4up4Ac40h5J4L+U4itu/LJSwfgmbrr0q4Dhg0iwnK8A1npi4U8m
         KKRJMaU7CYx3R38ceKHwEtXsbUZrSJVfhy6t6caFu5timMqsrYvuyRgJugWMyPqCuXST
         iStsx4yifFXVYix4k2OS+G02lF/+UwFXWtvDgZpQtyi+jE2MbuHRFhLIE9EE94xvNbTe
         E/Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kB4CbVlfwtPQyy+jpUqdVgzxyxtpeKkOKn8fpK4zlK0=;
        b=WbFSWOdXv2tuo6hlG/+Sm1+SbCQ8MJ84XZrWwx1zyACpYipniNUU0TR/YL+uVXrOqk
         JIBYk8x3KQt43lVaYM35sONj79yLUHnx9b3OSswQdsvOAh4TiDO2khNo6AEK55Be13Ld
         pvvgVIm0yHXTXWk6b2tX2BwyzaPgDRkA3kl8NSD0ClhwSQIxPg3VrEfARuBC3m/7B013
         cZhg6vPIVTI1sAOKI++G44/P+AoGlicoZR5Qs5SfoKescZ60JxjiyxpY9Wl/YDqOzYoj
         aay4uPhT1gbJeYJ9UkSCvihZ9ogGK3gS1FiD/+jypZvpi6ZxX0RYuXh/fxZp+92yKaI5
         Y3JQ==
X-Gm-Message-State: ANhLgQ2rmS5vQt+KcBTTskXb5pOvLVuqzcgFHKJ81tADqoKODAlPKs/a
        PLFjc7Y6lJYfAIeBvHnA5gLEeC2E2CA=
X-Google-Smtp-Source: ADFU+vsa0tkbx0Mxhqm01W9c3oI9gy01fjXyPe/ZhV102pPb53MQBUGf+Ofno2lriiVsH8Y7rILHCg==
X-Received: by 2002:a62:a515:: with SMTP id v21mr12219157pfm.128.1584748898620;
        Fri, 20 Mar 2020 17:01:38 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 26sm5993209pgs.85.2020.03.20.17.01.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 17:01:38 -0700 (PDT)
Message-ID: <5e755962.1c69fb81.6383d.5527@mx.google.com>
Date:   Fri, 20 Mar 2020 17:01:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.174
X-Kernelci-Report-Type: boot
Subject: stable/linux-4.14.y boot: 80 boots: 2 failed,
 73 passed with 5 untried/unknown (v4.14.174)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 80 boots: 2 failed, 73 passed with 5 untried/unkn=
own (v4.14.174)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.174/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.174/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.174
Git Commit: 01364dad1d4577e27a57729d41053f661bb8a5b9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 46 unique boards, 16 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 57 days (last pass: v4.14.166 - f=
irst fail: v4.14.167)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca15-tc1:
              lab-collabora: new failure (last pass: v4.14.173)
              lab-baylibre: new failure (last pass: v4.14.173)
          vexpress-v2p-ca9:
              lab-collabora: new failure (last pass: v4.14.173)
              lab-baylibre: new failure (last pass: v4.14.173)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

---
For more info write to <info@kernelci.org>
