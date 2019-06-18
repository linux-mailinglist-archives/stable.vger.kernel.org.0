Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18EC249671
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 02:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfFRAus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 20:50:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51057 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRAus (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 20:50:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id c66so1302417wmf.0
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 17:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VCXDcNl+K32BYbF78ee7gYIpu018su0TlbymGib3qxc=;
        b=cXQfCoqjEyMsJLEAvkR5JwOs4HAa7REHHIqieSstZyG0J6QlWGvstxVH78pPW8xwsn
         5OwfHNKrJ7y9ZjUlNzvxHqiWGaZQgodmSAOJ9PpUpGHx35aDKNZqlSkHedTJaNj+CW2c
         dcy3e0ZYYU21hpw3cOM+25MHsD78I0S6l0sA3u7PCYHJFdI4wMO1YhqFqO47KU6+2/8a
         oY5RQvOYaldCSxkOSFQR1eGQv8jkbH4qukintArOwfkBeZL7RCv1fyjfNBDykOA45KhJ
         KiUNcJBlpRdfOYICSc1Zs6jU7pas+5EqTvGDNnZKOneWptO/3JmeeTy+spL+7GBBlsiz
         Q88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VCXDcNl+K32BYbF78ee7gYIpu018su0TlbymGib3qxc=;
        b=tyU9t+HM4rCZRL7TwSZOmdPg47CzG4IZdQtZhvQylWi5LJrtbreeb5YzVS3OAxEydE
         I4vZ/LXb5bUJjxfZnPd046p5CyR5uUt/TT8JjgBPhQqupu1EIkGbEnmQfHPOp9unI/Bv
         cpP3u+X+lX44mkb8v/W59l3lW20vpc27YOpA4y6kH6vgnfyuZumXcAF2Md/9u4QCGjc2
         pklsAdXpo+NBfMJ204TNqABhthlO1C0CKI6V+jtW2X333MRUQNN7VXrYoGlW5JoYlMLj
         1mbP9oOdy9EQBu8eXsaY2psaswiw86SI2RAa+tWX8C8xbQwGggt8s5vC37Q4TNM1OZEJ
         zPLw==
X-Gm-Message-State: APjAAAUwl6VtqWURtZbKGTsk7RobN08efYWBBuZjFWPVpZSsuGNKK9PV
        MgBZiKVIiG/yF1c43UvFyUs/ZOTUWf337A==
X-Google-Smtp-Source: APXvYqyPPPzrqkRpjXbSJ6+Ks728VURs0yWjqsJUiWoN3k2U33UF+cQYxn3EmMhCAs/CmmVgOlfWFw==
X-Received: by 2002:a1c:ddd6:: with SMTP id u205mr808127wmg.54.1560819045889;
        Mon, 17 Jun 2019 17:50:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o185sm536432wmo.45.2019.06.17.17.50.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 17:50:45 -0700 (PDT)
Message-ID: <5d083565.1c69fb81.40dae.3224@mx.google.com>
Date:   Mon, 17 Jun 2019 17:50:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.182-63-g4d1195c2c43c
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 79 boots: 1 failed,
 77 passed with 1 conflict (v4.4.182-63-g4d1195c2c43c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 79 boots: 1 failed, 77 passed with 1 conflict (=
v4.4.182-63-g4d1195c2c43c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.182-63-g4d1195c2c43c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.182-63-g4d1195c2c43c/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.182-63-g4d1195c2c43c
Git Commit: 4d1195c2c43c331095e91d0f198adf6c03ea8a08
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: new failure (last pass: v4.4.181-51-g3cb069b526=
84)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
