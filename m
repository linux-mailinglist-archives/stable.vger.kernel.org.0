Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBDF48E154
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 00:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbiAMX7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 18:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbiAMX7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 18:59:13 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD7DC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 15:59:12 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id f13so1530056plg.0
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 15:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5v8YTYQmvWsxuKWSYu0N3sW++/xkugPtctVQAxNQMEE=;
        b=YgMKTAFfkS2QuYWL5XBQ9UZA+8hJySmtiYsfc2JsVpkuO2Pzfh9wHQ0ht+qGtWbIea
         +g1J/9ebyScHL38AC1tIBBQGYpF7MpTTPW8lGiMWq0+s016PRvHVZqwlBEwK/zqR8fcB
         mniPx8pZKXRZ1RSlmvnHk/aMzR+yaZuSFAy+lgcjmOiCSDTivieYMP8rIq+kEi2QjuGv
         s8ZRioCFomA5M4IZf4u/Aw+yX3oT7MPHOXEOXiaz4lyDJmbi8/sbVbljS6PWaKpPfVF9
         J0K+sRWlJBh6OXKAtPN2dTLxugjWuSvslE9ynGNVMOH7YjsCvWbbGs+fWG6fWRUZMti/
         XyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5v8YTYQmvWsxuKWSYu0N3sW++/xkugPtctVQAxNQMEE=;
        b=5zsmh+Bcxa2MFyeqxWinva+gMrN2f8+J3uwhSD09y5hHFISnaqhbqPHR+PkwgDQ4Tl
         4zkV5gQmn2yVWLL7n2W8DMfvgwyiyg/7UJ88nRjAadfLrWRUEGuSqxszxRFvjc4K0F3X
         hSGSsOzyuSG9TchTjM5TjXid2MjUHJVwPFL0lC7HVGYYydqhFLMstLNhg+f+khz09B8G
         NeaJ45kxRF4vlDKjW04DapImMEQkztd3FeeO8yqjQz2F5snVYOa7GoR/rkURpmi8syIW
         i30IRo1vdZ1Iq1/KfA627ML+bUYHRcIwpz1uQZn9kDQE+3Cuh6kdNVfN9EzV71M8s5Pl
         ODxQ==
X-Gm-Message-State: AOAM533Yq9YcooK6mjoCyHI8JjcEk4iBzFl2Ixlp+2YNe8yB3+3Tz9so
        YOi674yeofeVuMms3u2/8fkT/UpL1ihpxs9Eki4=
X-Google-Smtp-Source: ABdhPJxdRBdScj2RhwXSiU2oRX00i48ZLUWCzCxXtuwUt0ryz8EKCm88GVC8jQ2Fm9GashsmjFE/SA==
X-Received: by 2002:a17:90a:f193:: with SMTP id bv19mr16827476pjb.157.1642118352311;
        Thu, 13 Jan 2022 15:59:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p10sm3882366pfo.95.2022.01.13.15.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 15:59:12 -0800 (PST)
Message-ID: <61e0bcd0.1c69fb81.19441.b0c2@mx.google.com>
Date:   Thu, 13 Jan 2022 15:59:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.262-4-g79003afb4545
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 133 runs,
 1 regressions (v4.14.262-4-g79003afb4545)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 133 runs, 1 regressions (v4.14.262-4-g79003a=
fb4545)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-4-g79003afb4545/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-4-g79003afb4545
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      79003afb4545d26189efaeebd7192940c4db94fe =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e08a4c1712a0f7bdef6752

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-4-g79003afb4545/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-4-g79003afb4545/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e08a4c1712a0f=
7bdef6755
        failing since 10 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first =
fail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-13T20:23:24.321610  [   20.050384] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-13T20:23:24.363059  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2022-01-13T20:23:24.372110  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
