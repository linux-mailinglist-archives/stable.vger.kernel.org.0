Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932741E2235
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 14:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388824AbgEZMpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 08:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388814AbgEZMpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 08:45:49 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF65C03E96D
        for <stable@vger.kernel.org>; Tue, 26 May 2020 05:45:49 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y11so361521plt.12
        for <stable@vger.kernel.org>; Tue, 26 May 2020 05:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f+E5l1c49uqWPfg3i/g729115p28q++wB0X2PdXG8oA=;
        b=qOvtFvJYAt+xHU60t3Ogj+JV5U0hYGEH/X/5PIY77KvUrsTLyH6S7D1e3WyrPSrarP
         Gu+EuTeQWFUXfvzhsdASvVY8/xpjybeDhq+67Ul9mFxg1XuKzBajsTUrNz9sIfd4Yj2W
         32s8ilGSxC2cUe48qJSQ0NDyV1Pqg3G3Yr8Btm/+x7kskz3w+65Vh3NhyPvm+cmnAD3H
         rWNi2Mtoxdh5IceqyJCsa++qpVKyMKc09zOE+uWTqCCz+vWIys79FOeNz6bHBGi2Q5o3
         S2oAEKp3ImcnSq79wCQ4dVd4KS3Soqsf+HqfLiKqlDCq2Fe/rU6bnat3GrISw5Xbw4MN
         pZjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f+E5l1c49uqWPfg3i/g729115p28q++wB0X2PdXG8oA=;
        b=hDmoLrG1cMRq3IyFb8CXlHhMR9LVTdHFdreX4GDCdvTLtnzmyYQ2yVkr+P9CsDnYXs
         TuvlBF0i246lqHYNramqPJ9gtkofEvkX96/B9hapwrf1feUqmjmxt6YgB9AkkRLvU3df
         iI/oLAS4Z67+ivq8bNIxPRkQPmHnkG4J7yR1QqgsNj3pSLHMvTGMH7XrI4CoxK2jIo9D
         7H1/EfSIJfSHdE/1fOfnkvH6AqHkMA8r4Shy8Ms6sj52p3U/tSOlECKJ1z1i+EDzgOuU
         z6mi/qMywmjoUbmDqW76OjRe84vaZ5VxmI/a95a7oybbHnIG+88C8atEwzto6qjnZWaM
         zocA==
X-Gm-Message-State: AOAM533rfrCkS8tPa7gd+ArdVRsLxO6DmDHXsrXlNcXTMgaMKgFhbmdh
        DHSTLlHaiw+tEJmzCE7bPVlip2YNeZw=
X-Google-Smtp-Source: ABdhPJyhNyZdIyDm+EYRbSzeHJLutd3f7qQn1FwVfScDiBKaQqhLOfxd9XGCAR6QjVG7lT+K+Ysg8w==
X-Received: by 2002:a17:90a:21cf:: with SMTP id q73mr26322624pjc.230.1590497148483;
        Tue, 26 May 2020 05:45:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k29sm14147771pgf.77.2020.05.26.05.45.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 05:45:47 -0700 (PDT)
Message-ID: <5ecd0f7b.1c69fb81.e2ae4.5b62@mx.google.com>
Date:   Tue, 26 May 2020 05:45:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.14-121-g8f40203f4915
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
Subject: stable-rc/linux-5.6.y boot: 131 boots: 1 failed,
 122 passed with 6 offline, 2 untried/unknown (v5.6.14-121-g8f40203f4915)
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
https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kernel/v5.6.14-1=
21-g8f40203f4915/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.6.y boot: 131 boots: 1 failed, 122 passed with 6 offline,=
 2 untried/unknown (v5.6.14-121-g8f40203f4915)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.14-121-g8f40203f4915/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.14-121-g8f40203f4915/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.14-121-g8f40203f4915
Git Commit: 8f40203f49158f3292f524ed280268758f8c9f30
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 88 unique boards, 23 SoC families, 20 builds out of 200

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
