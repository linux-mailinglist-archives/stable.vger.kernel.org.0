Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4370C4A3116
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 18:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244653AbiA2RuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 12:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235418AbiA2RuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 12:50:08 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3A8C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 09:50:08 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o16-20020a17090aac1000b001b62f629953so6552205pjq.3
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 09:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WnK/6Qk/aUpcR6zudORsmHv79vlEgvJPfG1wXP8qQSk=;
        b=4ljM9LuVE2QGrkYalaYX18I9w+Cxg+TaWEMEHKHZbtONDK6HCZ/K4yRs9EY+Fhnm6U
         dkIj9naRv2u2iPMjxtzfMBkbl8yqJCoFsHznVHvSL565hw+Ni2tU1ljU8eJyQfqJ7hTV
         t1GsQdaqCcV4UX439M0hRn570TFofS22kts+lKyc6zdtOePW5OWRb+d3F4rZFnJgVysk
         n1Eif6YUro1ksEE/3Q7DU4ICGTElg2XfLteEHQxGTSA74RAz2DobO1N3L4vXJnHjw4PS
         klodd7WBJ013xzaFtTTKstpex/wfbwi5bbNHTgSlXVC6LzlSCil7gvyDHL/8ecpSWLY6
         lfqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WnK/6Qk/aUpcR6zudORsmHv79vlEgvJPfG1wXP8qQSk=;
        b=BplCXnOfWl404ksBsqFskiL1ZlSaaDWjjml7LN/FQ/UcS6lGAqUHRgBD0irEdNXaIw
         6fqPhmg6kDJkbD3PB8reiiW7Gbm4A89A9TBLXQJ1/sWR2505WF4E9MdsH1BilYbBXWaw
         MFxYlc2KRz4P3YF6y/VGAgX+Juw79GYTj5BWqQNqC3PEfqpMndb7UEVNe6siE10o5oDY
         OGdNcWYnxLEsVcqL9IEFOWfjH953ZEQwx1uRk9a5pwN2PRNRlxEcAGfHJ0605oyCW+Ln
         H3XrWMI2gqZ3CK+CXSO57n4dwQ4Qxb9AOq+VenOwXhFupTKaqzcjh4iICH8U1o5jxTkq
         us5w==
X-Gm-Message-State: AOAM533duKcUqfEMRSDGLQCMcamDBWMbYnyjr4Wp/LlVnc7lhlPriLes
        RHSb7ApXzvtsP2HFwFRyfZMEAvSloUj3Mfsw
X-Google-Smtp-Source: ABdhPJwvXSh8v8HMti4QIgYDI9sxUbpuPCzleH9Ha8TiflCdgX7xmWX60bbn9cem89+03cEBxycfWw==
X-Received: by 2002:a17:902:cec4:: with SMTP id d4mr13707709plg.56.1643478607659;
        Sat, 29 Jan 2022 09:50:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lr8sm6390218pjb.11.2022.01.29.09.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 09:50:07 -0800 (PST)
Message-ID: <61f57e4f.1c69fb81.1cfa4.0844@mx.google.com>
Date:   Sat, 29 Jan 2022 09:50:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.264
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 98 runs, 1 regressions (v4.14.264)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 98 runs, 1 regressions (v4.14.264)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.264/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.264
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b86ee2b7ae42b6b37a918b66236608e2cc325f59 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f546512d40e78244abbd2e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
64/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
64/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f546512d40e78=
244abbd34
        failing since 15 days (last pass: v4.14.262, first fail: v4.14.262-=
9-gcd595a3cc321)
        2 lines

    2022-01-29T13:50:55.978903  [   20.062499] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-29T13:50:56.025476  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2022-01-29T13:50:56.034831  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
