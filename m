Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12971023DC
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 13:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfKSMGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 07:06:13 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40889 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbfKSMGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 07:06:13 -0500
Received: by mail-wm1-f67.google.com with SMTP id f3so3250833wmc.5
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 04:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LWlFeNmhDfOYZkGDpo72xFb6+mj3sYfXIgnBmjwKK0o=;
        b=fzQnlh4t/kxI7snkIpChwCdCCnpmQOkO75pJIoUc6mUUdBo+BA6PgdwfTH6m7sP/kf
         zvTq8iL9Ah1WKJAZbtoFLM2ySONqHJnfQ3yJFWxILZXprPyC2nDrm7Sl/cmX3Bxe2dI2
         9glf4/WPrOt2zx8/RlabomEbL5nwfEvvExiVYNMo3aGdVhCI2gopOih0qOpz2Pm94tXn
         BG0ipNhhl17az/wMM0uNpmGZSE/iQaH05l40tRQM+gZJFOauXfhLu4nIZA9aioP21Z6l
         McRmS0KC/p3PdkMqg9yycxuN12DWKtGb/4aiwxotX1CMLQMFi1BhEikuP4vz/bJtlI0/
         6c4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LWlFeNmhDfOYZkGDpo72xFb6+mj3sYfXIgnBmjwKK0o=;
        b=ggmSytFe0sH7GeywZO+B2CjPvP/dQu4IFES57CPYT1HMo+pGosnpH0EieMnU/msOf2
         9zUbedaigk7HZPWTuyioQY7kg8dvjLDFVOqvxuh1x+YoQ9tJ7PKFV167ZGCRZrBvQesH
         gzt+utS1miMcXImqh/YRjPCrisgFNQtjZTno0LTgLrD0FqlXbL0C8qVSuY/Ye2n171kq
         nV1FqcHUC/3Xs12MKvY+WPg21FYYaIUY/6SEmFprf2tGcuhSS+0faC7eaI385IdUhUyz
         Tsckyh6hjHSLITvE3qVV80Frivwr4IjXZOjj4kdhkFuvGzaRBacHEAM5lAtxlqGvPldJ
         wBuA==
X-Gm-Message-State: APjAAAWJkE3uOhIrzyotL3m7c4b/RpLrBmDhEvHBAUNXzAxcN7Kcr3hB
        suFfYnhEaDPdlzFT+vE0AlU4GxwqwkMEcQ==
X-Google-Smtp-Source: APXvYqxLX7J4UnR73Cio+9+/VEUzb0G1fZf4HomWxUSy43N9wit9db1NAuRELBkFLgKgEKXJ7jH7uw==
X-Received: by 2002:a7b:ce11:: with SMTP id m17mr4695060wmc.123.1574165171166;
        Tue, 19 Nov 2019 04:06:11 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r2sm27267759wrp.64.2019.11.19.04.06.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 04:06:10 -0800 (PST)
Message-ID: <5dd3dab2.1c69fb81.418aa.1a57@mx.google.com>
Date:   Tue, 19 Nov 2019 04:06:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.201-120-g7bbe76363f8f
Subject: stable-rc/linux-4.4.y boot: 30 boots: 2 failed,
 23 passed with 5 offline (v4.4.201-120-g7bbe76363f8f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 30 boots: 2 failed, 23 passed with 5 offline (v=
4.4.201-120-g7bbe76363f8f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.201-120-g7bbe76363f8f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.201-120-g7bbe76363f8f/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.201-120-g7bbe76363f8f
Git Commit: 7bbe76363f8f81351d9fa08d697b2f6dc200bbf9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 28 unique boards, 10 SoC families, 12 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.4.201-21-gb0=
074e36d782)

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre-seattle: new failure (last pass: v4.4.201-21-gb0=
074e36d782)
          bcm4708-smartrg-sr400ac:
              lab-baylibre-seattle: new failure (last pass: v4.4.201-21-gb0=
074e36d782)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.4.198-47-g1e0d280e1f=
8d)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.4.198-47-g1e0d280e1f=
8d)

Boot Failures Detected:

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

Offline Platforms:

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab

---
For more info write to <info@kernelci.org>
