Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4CAF742EE
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 03:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388007AbfGYBkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 21:40:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44833 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfGYBks (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 21:40:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so48851583wrf.11
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 18:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IZEpiyc4LCHeDdooMNLEP5kBmkg1zeLKiHvK8QRA4Q0=;
        b=A1ZxDlyxhgK3oA1vAsjYsOBgwZyIMp9gkupye/BHiehyTOPY8SO0NmPPGM4ZUC42fF
         i0Klrs/NmhxlK6VFu6vVlgObNmsg0h/VBNcAS8Ck6ce3pEIgSD2zsNPoIXDbikSTePlm
         N2DyPTHovg2t0S2lDHsyemGfey6I+3LxJnEzdeOVVEqjR3prwbswAs7jq5CKdfF6isgn
         DDEinrk5e9n5YIdlK6KNIqpCXBzAemrK4JMGziojBHGYuRiPYHZgbdFj9DihZWBku/ju
         FgTcJ49/n9wmqG8oa8cyaJ+Ib+uu8j7QC9WOEHM+y0ZK1o04F6FtFLJtyDLZ08jqdbwI
         yvDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IZEpiyc4LCHeDdooMNLEP5kBmkg1zeLKiHvK8QRA4Q0=;
        b=dcR87ujQZWV9y63O/Zl9rgJo2uM7pX8NIQo4877FP+6UpO2/X5IfWeo4RffuCAC/sh
         Wt+hJtgJa4gGSOOoQB44rThuyVv59t5Ip7oq8usGfa4N/3xm+6yLswlnBwPQYgopurLc
         CPI1stAs/3M0z2ySDxs01Tqu6EOXf4FgmF+63wOTEBWxFKp1RzlqCZz7Tuxi1mZoaCYq
         NgJdks2vvsLD4Dded5LLPftGMA1+ZQmXHUKrBqXOi0s5M7mH079NietgnD9z+QQfvgtP
         1rew37JcA1VM7fxHjFVvYGvJIbwfccY0fMGEzIRv80VoRTMmGNJWEDCg96LcYoCOmHQm
         uf3g==
X-Gm-Message-State: APjAAAUqP9JOF0elQWfELBiKdD0VuhIZH0y3FnNN/olPy1LsSAIwHGC0
        zX6gxt52GomLu6yKitlK9wfErKSik38=
X-Google-Smtp-Source: APXvYqz2EMqGlESY+jL5pjv+4qXozKDr0QsZZE5bFaqW9uU5iOQDjU73CSEbilTQhHEBvKx0z8vv2g==
X-Received: by 2002:a5d:4085:: with SMTP id o5mr89289394wrp.101.1564018846544;
        Wed, 24 Jul 2019 18:40:46 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n5sm37677180wmi.21.2019.07.24.18.40.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 18:40:46 -0700 (PDT)
Message-ID: <5d39089e.1c69fb81.af756.eead@mx.google.com>
Date:   Wed, 24 Jul 2019 18:40:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.1.19-372-g21e90543f836
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
Subject: stable-rc/linux-5.1.y boot: 137 boots: 2 failed,
 133 passed with 1 offline, 1 conflict (v5.1.19-372-g21e90543f836)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 137 boots: 2 failed, 133 passed with 1 offline,=
 1 conflict (v5.1.19-372-g21e90543f836)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.19-372-g21e90543f836/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.19-372-g21e90543f836/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.19-372-g21e90543f836
Git Commit: 21e90543f836d29dae6ec06215a6e52419913d7b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 27 SoC families, 17 builds out of 209

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905x-nexbox-a95x: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        exynos5422-odroidxu3:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
