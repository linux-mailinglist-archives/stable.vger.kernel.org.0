Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CD61DB5C5
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 15:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgETN4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 09:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgETN4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 09:56:44 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BCAC061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 06:56:44 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ci21so1326464pjb.3
        for <stable@vger.kernel.org>; Wed, 20 May 2020 06:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EhBM2xafS+RVHMhkzutC3bQk43sd1maEbpjxtfggMw8=;
        b=rYe8ftvcwtHNThYUIC7bO3rxHD9f0jFjYPfr781aNjtxBLv/i+QQpp6vGZHJ8BJLcZ
         8hp0Ae1yqQ4GS7AbemfXZdTw1zD3b1ebjwDabvPkOn9bZcIA5px4kJHSJrvYDxsmwDue
         twxMi/gc1KH+a+PWI95fXF+ESV3lWpz+AVVTE3Dakz79L4bTA7zdjFQ/s55AN5bvlX/4
         5i5vAUOM5HumL6DkB+Nt+RBiQx1S18kT39KmbVAwSmnlMU8HGD0hubGH31L3VEeD1fCf
         3D5pRsK9IMVjMjm1skhU8OeX00ZwVpOjLd/4SBgu/Xo2lx4LXgkXyzm3KVjs13YGBI+8
         88TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EhBM2xafS+RVHMhkzutC3bQk43sd1maEbpjxtfggMw8=;
        b=o+DEQi6eKGfxuZ+8v/I088c9dw91l46OrraJ5wdwdKa9OblcCaOUuKHXCet4OodoUl
         EHd9uDrspdQEldX1Xckcg+FW+v9jf9ZSl6RzHrpyUh5UIoRn9VOe6ymUkW6uZrqRiLrT
         ez1xBkrhHZRPOD9rINe0tIvUl94I4JWNg1RTvN7xTTtRwIbBFnZP7rmKNKgB4Ptm3aEi
         YrDIyawlzwwxmVV/zLD7ZY3O+AC4PNw4FmRVSYN5GcMLw6FYz9kj3S27dAz9gwMjlaix
         Fpiuo3Fnshe0ESw7DOQjFgXcS3qu8o823mgvr/rpfglSJQKIVlB2icmwzfcQ5gPT+yT0
         1DEA==
X-Gm-Message-State: AOAM532QWW0iFm4s+wVjQacIL1DVRowLNHgzl3tmN63XnTFstX0sBRZc
        X8p4BX95V8/tUJbzDsqb1gE1xmjWMN8=
X-Google-Smtp-Source: ABdhPJxHyijuTdheT7N3NbKGiGDpWRFjo/FiSTSzOmsXRSxaaRwH5RgQMqTgKKVsh1KNw/YcWtsKqg==
X-Received: by 2002:a17:90a:102:: with SMTP id b2mr5787850pjb.153.1589983003414;
        Wed, 20 May 2020 06:56:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a15sm2220063pju.3.2020.05.20.06.56.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 06:56:42 -0700 (PDT)
Message-ID: <5ec5371a.1c69fb81.dcf4d.8e13@mx.google.com>
Date:   Wed, 20 May 2020 06:56:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.181
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 47 boots: 2 failed, 45 passed (v4.14.181)
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
https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel/v4.14.181/p=
lan/baseline/

---------------------------------------------------------------------------=
----

stable/linux-4.14.y boot: 47 boots: 2 failed, 45 passed (v4.14.181)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.181/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.181/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.181
Git Commit: a41ba30d9df20fe141c92aacbb56b6b077f19716
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 12 SoC families, 8 builds out of 201

Boot Regressions Detected:

arm:

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 117 days (last pass: v4.14.166 - =
first fail: v4.14.167)

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
