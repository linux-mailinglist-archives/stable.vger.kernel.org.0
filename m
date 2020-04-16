Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3401AD1D7
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 23:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgDPV2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 17:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726049AbgDPV2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 17:28:09 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D853C061A0C
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 14:28:09 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k15so2267305pfh.6
        for <stable@vger.kernel.org>; Thu, 16 Apr 2020 14:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RB2Ban2k6Eg7ufeS4tTjRJQXCncdYcm/i2sHIGa5W6U=;
        b=xaEICLDT86w10C8xmR8pXopmIAH9pZooV4TpUsRirlbWOOOpx7t03Ipb1BYBIg0WwA
         96N77P1JP90vjnZwPgQ74d/LcVcZwafso8jkl9MrUtolnDwzf04D9G6xwdF0OBLduiMq
         mvGlFd84+2d8mIMQQGTr4Pff+KYKpFpvezHSqdDw/J1L4Be3MF3TULWxBllGy1D5ytER
         XU43KCHZiH9laBesC1RENPmOZj6BVAiFd31OpZCmpPJoC0+XHPvYhmQFQc+jgVnI/OWc
         wz2FhHuaxQmNSsEiYoUX+obN8IC5RjfcA0+BPOAvoXrmgo/Y9PWFthoDuxJhxbRGMYm1
         1V5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RB2Ban2k6Eg7ufeS4tTjRJQXCncdYcm/i2sHIGa5W6U=;
        b=B7BTA5iw7OfLklCqSZ7aE3J5uBSegwG/da1VuGLS4fgurEpc1/FJO8hcUnZt9eB85y
         uAwYILAs5f3UHHxNRk8tM+tG0X6MbeOzXwFb9RBhvIgbB7RKZyZZx5zmYhW3daRoJWMx
         C6sM3+fEE7ffVsIDPO+Dqp+o2iVfAKc7wnAAesWrqsuEdxVE0rkkVG85peXaGjDZf30H
         A0E4vvPDBriK9yvW3LhiyNmxiKe0HdDaSvndF/3BxIX3/9JuWJAk5/IKZ6zXPmwz9Mj5
         US51aVWt5hAX+r6h3B9huM2dj8cmsL4t2pgX96nm8DmVECZvH1fqYvf8yoXWqqhWreJi
         MqbA==
X-Gm-Message-State: AGi0PuYojQV2KcKGqVU9lXxZQcy5aRfd4sZHQYAGop7gxqTuDMEBbLQA
        2YgE44uX7NS5juctXq0RUg7Bwuj4d4A=
X-Google-Smtp-Source: APiQypLIEnvs5ftsHk8XNEipvWDDwd+5SwwDZ/hJk7Xb3bViaFj9xNF5r9PP5icc2mHdUdRkH9b89Q==
X-Received: by 2002:a63:c101:: with SMTP id w1mr19586972pgf.126.1587072488819;
        Thu, 16 Apr 2020 14:28:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u13sm549468pgf.10.2020.04.16.14.28.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 14:28:08 -0700 (PDT)
Message-ID: <5e98cde8.1c69fb81.2ad7d.22b8@mx.google.com>
Date:   Thu, 16 Apr 2020 14:28:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.218-85-g72558784a83f
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 74 boots: 3 failed,
 67 passed with 2 offline, 2 untried/unknown (v4.4.218-85-g72558784a83f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 74 boots: 3 failed, 67 passed with 2 offline, 2=
 untried/unknown (v4.4.218-85-g72558784a83f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.218-85-g72558784a83f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.218-85-g72558784a83f/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.218-85-g72558784a83f
Git Commit: 72558784a83fe11cae04f0da3de31c9d62628601
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 16 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 68 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 21 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

Boot Failures Detected:

arm:
    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

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
