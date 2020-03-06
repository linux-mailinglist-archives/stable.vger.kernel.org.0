Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09D617BC6B
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 13:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCFMM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 07:12:26 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43934 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgCFMMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 07:12:25 -0500
Received: by mail-pf1-f194.google.com with SMTP id c144so1017667pfb.10
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 04:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8u0c2e/kJp4ixtEDqOi395TMnoWKMGRZ8iZyrmkyfIw=;
        b=fvfoW2nMUQJB+N+MzDnxwTx8Qs8l9+A/KQu8yPwIAbi/G/boqPw2fBIWdjUDbO5XjX
         FpFppgYVu9D4d7eFmrEdZxQe4pYc12s4ve/OchxhVTNw0kTsf9hMSqypTELZzgSRD0EY
         xY/dzmYFMaQfUc/6Z848lr4XVaTlBgsSDx3el3//7mQG3smwDMVvy9kS1FdLAxUVOv/X
         os+LInHY/H4YrQnbzM5eicwGalup3w/8fvybWxcvSt+rHJVnp5pf30KyXNXTCTMtLJp/
         QTpttq2l7chBdnHYlqd89WG/y+uVbfJgsMf6oryuhXFgnAsUnnWhtC2s9PT+lOc7dKFJ
         ft3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8u0c2e/kJp4ixtEDqOi395TMnoWKMGRZ8iZyrmkyfIw=;
        b=W4QaxC9X/9t0D/ahDncLVNvKsh7oPxVM8p6BahOOyIvnhsjKSphRsFHQLrf2slrz00
         s2TsL5yytCSh3/bs+BK9SMi1jwAYeixa3pNIo5O9/AmeotFgFBxsxll8n0idZnOdwKdZ
         4ox06104LkHPMaA/F7fq51r0d28M23wZlNMvLDO+wStM4PkKbQswQZXmtFpc4vISJ4Gc
         4vLIeDW+FwPSP89CHDhHBsfX1zF0JihjtSgu0eAIbRDao7fN9cREcvKcjjkz0s704X6+
         03E/O3DbGvVFEv5l3Na6tY+7kPzPeuoOz0LfMmIXT7g3xPjAgK5dfhAT7AT6knrkgXkg
         scQQ==
X-Gm-Message-State: ANhLgQ3DNsB4td9eLxKM2GuhaDJ1YMnUV0uCmkc6Qs1iiB5SCVr4lGzZ
        lk1bgpbJ9F4iTjPYE2GUIDcH+SOUpVY=
X-Google-Smtp-Source: ADFU+vvmtbRneligXK2vWJG7NmI+t3e1SNyw2uWVzuMnChbObZ36S/taffdBs6R0syVnPfhzwHaVeA==
X-Received: by 2002:a62:507:: with SMTP id 7mr3650120pff.49.1583496744494;
        Fri, 06 Mar 2020 04:12:24 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a143sm11340083pfd.108.2020.03.06.04.12.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 04:12:23 -0800 (PST)
Message-ID: <5e623e27.1c69fb81.83ba1.c579@mx.google.com>
Date:   Fri, 06 Mar 2020 04:12:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.215
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 28 boots: 1 failed,
 26 passed with 1 conflict (v4.4.215)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 28 boots: 1 failed, 26 passed with 1 conflict (=
v4.4.215)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.215/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.215/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.215
Git Commit: 1721173ef18200e8e8265568f13942d6e19c2c83
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 19 unique boards, 7 SoC families, 9 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-collabora: new failure (last pass: v4.4.215)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
