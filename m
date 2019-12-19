Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14BCA127099
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 23:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfLSWXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 17:23:20 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54373 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfLSWXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 17:23:19 -0500
Received: by mail-wm1-f67.google.com with SMTP id b19so7015016wmj.4
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 14:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=I3n3ug6RjxYkkDZE3q42LauM8aL7Ag6xFBtTYoayuVI=;
        b=DciyxlAwRfkFi3Owoo6gjHjLAfxWegDoQHZnI4SA37iSGokvpFmfCOPeD/WRmHIBF3
         XNv2WfNU2K83MqsW6dsfTynJ8HJmLLomeq4L6EMlzBFhAtYuMrReO8zSFigrAc2hrU4X
         GVGc9Buek4blehN0TIBa4/HvHsfNIcJavtmmNVWJxmviwNkYGWK10eMgZZhhwUNL4ULT
         tWsMrjhMq7JoTy0WMXysHZLaiySwYs8jH/0QcKBQQeZTL995lTKc3D8FYmukCT6+VaYi
         oy0Sj+lDEGT8uGKGftQXU8CiD0ZSHycc6luPKg/eCBQypJl65CjSfhNf4lxgBS7J9pP2
         0ARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=I3n3ug6RjxYkkDZE3q42LauM8aL7Ag6xFBtTYoayuVI=;
        b=mm9sPlapS6E/euaJSCnqEjXwKwef7eEjwUZ7UK3d/pRAWTHXwXaupDSdBYXpPZIRKD
         9a8uVTBUvNKJV4savk4Cz2PdSLbUCI1RKGVSZuqESmUnnbZAVZuynLP2hM9FJOJCVHUT
         66j4wvVW1wKwiqv7TQs+fY2OjNr8jKaNp48HcVkEgsXuMmXpNl1hYmo+XUmPNzOX7wQJ
         gU0mQPOcDyt6PIkWGOqi9VxG+WOA/yMOZvimpvxB4Yz7TLe5M84S4Aqhsxqu36utHeoI
         CN+fXnFUXiriCLrTWsRnJNq78QQ8M0RMT/rK/hJHrwEm4WidPe56JmM/qRBYZ3yd52xs
         Iwuw==
X-Gm-Message-State: APjAAAVNJrSEX4r1ch+sqfp3fshoEuvGWaTfKg1usgrUjDqF1+6K8QoY
        DtZbyPbNlHOw4aVJOSaTfVrgqK8ZSObQhw==
X-Google-Smtp-Source: APXvYqwAwltwQLmCbgMCXuL5JA8T8lz/aTVvAhvi6WbN/dFfSptVn9owxhlv6jQq2JDLM28jwqMXBg==
X-Received: by 2002:a1c:cc06:: with SMTP id h6mr11856747wmb.118.1576794197821;
        Thu, 19 Dec 2019 14:23:17 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b67sm7970882wmc.38.2019.12.19.14.23.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 14:23:17 -0800 (PST)
Message-ID: <5dfbf855.1c69fb81.1900b.94f0@mx.google.com>
Date:   Thu, 19 Dec 2019 14:23:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.90-48-gb3300fab1bdd
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 77 boots: 3 failed,
 70 passed with 4 untried/unknown (v4.19.90-48-gb3300fab1bdd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 77 boots: 3 failed, 70 passed with 4 untried/u=
nknown (v4.19.90-48-gb3300fab1bdd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.90-48-gb3300fab1bdd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.90-48-gb3300fab1bdd/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.90-48-gb3300fab1bdd
Git Commit: b3300fab1bdd504639fecedabfea3c97c2221390
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 15 SoC families, 13 builds out of 206

Boot Regressions Detected:

arm:

    tegra_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.19.90)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.19.89-160-g5189dfa0a=
ee0)
          meson-gxl-s905x-libretech-cc:
              lab-baylibre: new failure (last pass: v4.19.90)
              lab-clabbe: new failure (last pass: v4.19.90)

Boot Failures Detected:

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab

---
For more info write to <info@kernelci.org>
