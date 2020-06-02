Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A851EB286
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 02:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgFBADj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 20:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgFBADj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 20:03:39 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240EDC05BD43
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 17:03:39 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j21so4221374pgb.7
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 17:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CUkMpnPwlsJWz4G8UN/FlsWAqGdSv45WJtbsKkR/k1Y=;
        b=AgvGKMI0Coc97byyRwxB0LXhU3qgqLSVp5dFRCt3AfvigmyRcYSLCJPNstq8Zec3w4
         D5xIbpjyEU3El3vEJKCVat9j2wsVVrZTHsB8VdSYg9+4nJY9UYb8fRgu1fwjlp6cDqQO
         gBtYihPD2Ce8kjwsb8zecWZSSxRZ0sNvut5UWYikbtjFoYYCQ1avm9xKMQO3BzElsjbs
         JIqT2V570WvIJGDnCRsBziAybLJlMsUNU7BBE/EDvR+mSZyhVm37mWatSkJaZuYss+po
         0Qp9vxTnKk/+qg4Tiym3MpWjlz5WiVvkdANhqGpZqUQ0M41ZSAHTNQ3dwj4QVHG1O9Ha
         u6Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CUkMpnPwlsJWz4G8UN/FlsWAqGdSv45WJtbsKkR/k1Y=;
        b=Wln+eDn8SQd0OLW94pdAEehiz8cyVPNoZu+3io3TaXrJBVFdDqIyXBCBcEK3chSP+v
         uCsoUvujV2of2RF4VJseTdt3CDzbOcwuPiDhhL1xfrWARG2o1+lELMJE2uYYR7cuKXef
         xKWdH9qmVgYTMSXUzcz+xQM6vDmvXMq4nTIDfaBJ6yAmvFZ/NOAgM9MEfMVA1N62LWnh
         jSLkUKUtzn+pxxaWMfOp0Hp7F2EyIOToR8ljq8vkzQgGiOe3D+tpQk2dJRSugAT7fR0d
         FoEJX2f8jPVUUJ7zKpmx0TnRnRtm8oHkK5F3eVbccbfwBWNtd8EFOQM4GnEunC07nYqO
         9Xbg==
X-Gm-Message-State: AOAM531TE1f4b6G9l0+r4i4pz/pzrKeHWktwwOXw9FThvkh0jMfUteP3
        EGkJBUWH2Lkadxet0qOlFVsuUHtSx5g=
X-Google-Smtp-Source: ABdhPJwhrQWotRleK7/ofCbALPNURYASEe6pYa4eAXeey6dm3OLoZp16vHParMdHo6kHkWYyoxjxbw==
X-Received: by 2002:a63:ad0b:: with SMTP id g11mr21718721pgf.275.1591056218248;
        Mon, 01 Jun 2020 17:03:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v13sm467787pff.27.2020.06.01.17.03.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 17:03:37 -0700 (PDT)
Message-ID: <5ed59759.1c69fb81.21c4d.1f2b@mx.google.com>
Date:   Mon, 01 Jun 2020 17:03:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.4.43-143-g1fd4226c4fe1
Subject: stable-rc/linux-5.4.y boot: 138 boots: 2 failed,
 127 passed with 4 offline, 5 untried/unknown (v5.4.43-143-g1fd4226c4fe1)
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
https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kernel/v5.4.43-1=
43-g1fd4226c4fe1/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.4.y boot: 138 boots: 2 failed, 127 passed with 4 offline,=
 5 untried/unknown (v5.4.43-143-g1fd4226c4fe1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.43-143-g1fd4226c4fe1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.43-143-g1fd4226c4fe1/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.43-143-g1fd4226c4fe1
Git Commit: 1fd4226c4fe1a358bb8277e25ebb03950180443a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 98 unique boards, 25 SoC families, 16 builds out of 155

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.4.43)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 114 days (last pass: v5.4=
.17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 54 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

arm64:

    defconfig:
        gcc-8:
          sun50i-h6-orangepi-3:
              lab-clabbe: new failure (last pass: v5.4.43)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            sun50i-h6-orangepi-3: 1 failed lab

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

---
For more info write to <info@kernelci.org>
