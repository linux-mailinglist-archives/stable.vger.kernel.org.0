Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0911B1DB243
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 13:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgETLu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 07:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETLu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 07:50:29 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F19C061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 04:50:29 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id c75so1322514pga.3
        for <stable@vger.kernel.org>; Wed, 20 May 2020 04:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6kyCzZs/zoIG+DL/0ATxq86d6zPj91LW5Gmi03vF/IU=;
        b=jWL/iaMPTc/hu6pg6mCAvwSQ0rFwP/A0tDF8eNlKZqHWkEurnmPMvs2EyKa3TcTESn
         rp6TdPgixKWLU2pM9oOcFOL2gsw4IcuAeANuf0VggBUDpWa5Xv2dogP5KIyvio1V3RSG
         KTaUkl+nOU4p1sQqgOqxX8pOkZhWgpw+W3YBC1NcYIMq0c3HqxLuRH9ZPTFoGFIKvfVq
         7W4hYdWMVGCM0OrPq65ITU2adN4u1xA3Cnt7xtUCnC1c/mS+7L8MRyQL5cwnE1fGOuj1
         kR5uW/47s9ysbObVx5/TpwW0mic53/uf379zBIsDs9F5EXh0pYMWl3WeCbQ5Bd8DBbLG
         Ztag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6kyCzZs/zoIG+DL/0ATxq86d6zPj91LW5Gmi03vF/IU=;
        b=YuHVIIfpJYf62bnJbOFQyjgSBcMCcJlVM/iwzU9JLJ2MuByDrLwUr2c+HsFpPRJa5E
         zRPPhTR5FXjGc9OZmX7Zis0UdbFX1tlaLRiEwAKZx4jCeeJsWCW1ohYCtVlYK5SYngIC
         LCHP8CZSCxriOsb3FoiBhVuzZa/4PLkT0tCpOq3DM50s1gtLIwUvCVw3+BxtgzlQrxD9
         mj3Y8ncKSYHJDsj9UjUR3qP4HKEf0asFqkZuzq6X26IZmVFBLAEbOY2NGhg88moH61hQ
         CQ5V0L957xQe4AzG4O1a6/cHXDu74Zs9cjZ7c4IofRwEWXNGOwujAt2kVSnOgE6ycf5W
         EZLQ==
X-Gm-Message-State: AOAM530yTBXhz94SVLtOA8sjwHzcVCZ45f+M7KOVmgCRi6wHVQY4nAXu
        QUvpWERryVsKkuQVc+z9ll2TcYozBqg=
X-Google-Smtp-Source: ABdhPJyQUH6WS5n6K0CYbC7txhrrsi/rZzVNxpA+wpIjEQVnYQdBU6Pd7fBlda/IbfQ+lpNjLSWscQ==
X-Received: by 2002:a63:b0f:: with SMTP id 15mr3643674pgl.6.1589975428250;
        Wed, 20 May 2020 04:50:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t14sm1434678pju.42.2020.05.20.04.50.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 04:50:27 -0700 (PDT)
Message-ID: <5ec51983.1c69fb81.5eff2.44b5@mx.google.com>
Date:   Wed, 20 May 2020 04:50:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.224
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y boot: 39 boots: 1 failed,
 37 passed with 1 untried/unknown (v4.9.224)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/v4.9.224/pla=
n/baseline/

---------------------------------------------------------------------------=
----

stable/linux-4.9.y boot: 39 boots: 1 failed, 37 passed with 1 untried/unkno=
wn (v4.9.224)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
9.y/kernel/v4.9.224/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.224/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.224
Git Commit: e4ebe4fae299b559e683eb31a2dc950507842bf7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 22 unique boards, 10 SoC families, 10 builds out of 197

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.9.223)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
