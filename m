Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C587F1DB104
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 13:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgETLHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 07:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgETLHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 07:07:22 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC22C061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 04:07:22 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z26so1368437pfk.12
        for <stable@vger.kernel.org>; Wed, 20 May 2020 04:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yCIsHigfjpcfcEv/881WtYfI5LcSU0JLXgDEKBXWeY4=;
        b=dq7nhrLwwt5hBk+upjVOoZ3RgQZM8kdo9G1JWcYhzAE/CRVWZ/RW0Nd/ogZamt2jbU
         8YZl7qUdHsrBdACUJHis73NxELGq+Hd9RQSY67RFFKfkhWjHZ80tDCZwqS8rT73wY112
         BuEyPhSf2suuy2b5XEGOSGATdzMydcM5PtiWBgDuyslwArzQCHhMhXhvdyFUUmXSVe9y
         pHCgkzJjzNIMAmINu2i0lEm8TN9PBPBac2DFhkYWW+Wi4h6EO3EICLgxeiviZnL/n5J1
         WpHhiXQsbmmos6vMiBGtAaN+P0WhKQ1jU2bHCkCiGmAKTPPKQjkWJtMrhVbpcUQfa5TH
         CcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yCIsHigfjpcfcEv/881WtYfI5LcSU0JLXgDEKBXWeY4=;
        b=Oi4LzWo/6CkAdjVgFOQjyb4obqndtT/CTvmaDlwoiMmuVra9JYzURGmWfM1Xtrb24t
         kizk2XYrVQeJb666CIgz91jtTZ2XAUuOM5KF4stpDUBHmou52T3MrmbovTD1sDfG9LhQ
         zWkvIt0bjuOLLeLrpK2F1/nhGDspfJN0WWWRkAt0ovCN965DbIwjlSH/Xy8SaUNRw2q0
         TtYCcKWsoJdDwrephbXv5silN/1qPu1FjYq9vNsYfjwvTXLOX+PaUdGIxMA8Ag1UOpkJ
         QbqDglWWCa03w4faDXvesP9bSevyaQfT2qz2FbRImjSSbVRC92NeVmmh2Qf6Vua+4E/3
         kNUA==
X-Gm-Message-State: AOAM530KaVxBsT5/nWLhLF9OwnzBWipRpUXbvg+IYfVI2xTLry1rB36Y
        RYyFfuQIu8dfYUxpjIqk16xt5lzJAHs=
X-Google-Smtp-Source: ABdhPJzUtJzK+iO5pjhp4elvxdJPK9BC0c920SdAenY7AV6pHZD6uJpWxrn+UvhoJ0S3nnTmNIHb3A==
X-Received: by 2002:a63:454c:: with SMTP id u12mr3619575pgk.153.1589972841294;
        Wed, 20 May 2020 04:07:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k10sm1939336pfa.163.2020.05.20.04.07.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 04:07:20 -0700 (PDT)
Message-ID: <5ec50f68.1c69fb81.c34e3.7535@mx.google.com>
Date:   Wed, 20 May 2020 04:07:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.224
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y boot: 30 boots: 3 failed, 27 passed (v4.4.224)
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
https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/v4.4.224/pla=
n/baseline/

---------------------------------------------------------------------------=
----

stable/linux-4.4.y boot: 30 boots: 3 failed, 27 passed (v4.4.224)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.224/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.224/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.224
Git Commit: d72237c1e00f85e5df1c040280d50561c8a28329
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 16 unique boards, 8 SoC families, 9 builds out of 190

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

---
For more info write to <info@kernelci.org>
