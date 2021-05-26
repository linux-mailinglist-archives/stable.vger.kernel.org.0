Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636963918C2
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 15:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhEZN0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 09:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbhEZN0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 09:26:20 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71017C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 06:24:48 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id m190so953907pga.2
        for <stable@vger.kernel.org>; Wed, 26 May 2021 06:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iou9oejrRk4KnpBKs7gAkwyU6zjHYFwca2SVuPaYrNQ=;
        b=CBcKLD4qDIr9MFiopvLhr1T4/L4TntMfynsNZ/mMYOA7z/1m7u8ukejvhbFRYF2PlZ
         KIH+7iz1EflbHU+se5QDaFQk7f3nEO2cdn+p8MYxq2+0Hl1aVHkRAEf597+ULX4z+59W
         kxy1LemtJZY8OFRR/t467jgqxhiOte6gJuxHyCGHf+vayE0DZFx1d9314ilUvAncqOMi
         B6a8FCWKXP3vJwL9o/DDBWLGrRaflt5iEGcu9RWO8cWNxgXkrjC5nh49/sqiOni/5Egu
         sLXGvLpd/jyw3fEsY4P77dZ6ydib25bbrGgUfNhoILnJj2jEg3G+iQkEsJlpCxIYTwlR
         uaNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iou9oejrRk4KnpBKs7gAkwyU6zjHYFwca2SVuPaYrNQ=;
        b=PMthMlSx4rfVVqyFwO9mbS2frAJj9b4ndzbPHvH8NJ79ngHXnbU/Ug1dwtybRYjKAY
         vwAhI3tPDEJetRT2GLDS4QOwBUmgRLw3HUi3btzF/Jz03cHzAPlPXGLVgn3GAgeKhlu9
         0fbsramvOOysBUkaYq6lr6SE8Bcz4ltoLjSHDKRtW9oMGaM0GiMvt3J869xAE7gEhtor
         uJNf7KXcJyV13H4/eOoNflA6mlCgXrgz1RWqIdeej5Uvpai5bfsfKm/2M+edBoUA0fJJ
         Vy2ScXsVjxlQgPoOejW1etMzrkTEX9eFCYoKP518e5Rob7NC8RRmSM2FL+uhZd2ciVys
         55Pw==
X-Gm-Message-State: AOAM532uIDd2QfV5C7gCsa7d0uju0e6M6HarMQTPPiB2Sr2UWq/wVbW7
        VTTFV9lQlz35xQmxgWTcJoAGtH82zmvx8Xko
X-Google-Smtp-Source: ABdhPJxLlLEuPkMygripX+YwqtsF4iSBGChDbu9rojTHBo3QEHEGRBx7Ixc3+JKy5O/j302MFM6lbg==
X-Received: by 2002:a63:ed58:: with SMTP id m24mr16873744pgk.436.1622035487796;
        Wed, 26 May 2021 06:24:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z5sm15786370pfa.172.2021.05.26.06.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 06:24:47 -0700 (PDT)
Message-ID: <60ae4c1f.1c69fb81.25a61.3889@mx.google.com>
Date:   Wed, 26 May 2021 06:24:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.121-72-gb7d94ef5137e
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 101 runs,
 1 regressions (v5.4.121-72-gb7d94ef5137e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 101 runs, 1 regressions (v5.4.121-72-gb7d94ef=
5137e)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.121-72-gb7d94ef5137e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.121-72-gb7d94ef5137e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b7d94ef5137e66f6ac47e72e37ac6106d8d8e0cc =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60ae17cc3ea91bac43b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
2-gb7d94ef5137e/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
2-gb7d94ef5137e/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae17cc3ea91bac43b3a=
f98
        new failure (last pass: v5.4.121-70-gb3c1ba3ecdd9) =

 =20
