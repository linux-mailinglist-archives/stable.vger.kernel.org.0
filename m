Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3143390172
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 14:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhEYNAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 09:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbhEYNAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 09:00:41 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484D3C061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 05:59:11 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ne24-20020a17090b3758b029015f2dafecb0so11937905pjb.4
        for <stable@vger.kernel.org>; Tue, 25 May 2021 05:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eBzXM4Fi/jNQ0lXaupD4RW3+HtMwcPAQhvqaBYRvqsI=;
        b=kdovR8OsR11Y2Tq+kEo/RwSi9dA8Xa31Qu4vb3nv5HE8eKIVqL5ooXgn+JEpjiCVxW
         KhtSafEug478Y2MwBli9YliO+tQYmZ4Q7GwC4ididnqiyQzfN7B09OuU1/azbUgSq7pv
         vInBKFnCyMqyJ0M5IH5SA8GWLeUhNDDOtW1VDn9hd+AQUgX3nAoy4tf9vRcq/MM3l0ms
         aWmDx7AFKNTMhUNnOs+LUSl3ywp06dLoQQDXHLYMBHc+EqO8AXCbLxrB3sgN1+G+U80z
         ZgTuem9h+N2Hb1GodZDTpXmRcf7UQhqffcKroFaduk3ojVjurwS1Xouv45umhk9qAE6F
         2Cwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eBzXM4Fi/jNQ0lXaupD4RW3+HtMwcPAQhvqaBYRvqsI=;
        b=rIYd6wdLnjNUtUWXMNDnt8udvAoPzDVTYamXUWNdbKgEQfEiis9DSzUP4LFlQKp5eZ
         lWUssMIc1kUO5MkbHgxgILO9pnKc0wRutQb0HTOwPWKj9n6TOI8Ovqq8MDb4HC8xvYII
         AvPT+upoZGB2pmHBWKpQqnLwhRXXEGf1+1koy9MEjKxEYxegiUMX8lMlNFgB2sFQqmQE
         jBDM0o4vdZllmLo9ZLgknI4p+ea1w6yvdeDaoNqB4FmMsB4yIruvLH6wU2MKPXVdA42k
         B5c8jR+ZLagUzPx3oEGtk+0E93Mt3aaAkDAR/c/0AajGiG0ZBE0DhBHmfbrcPiu1qxzB
         aOJQ==
X-Gm-Message-State: AOAM532qvgxZhwNkIzTAllng79evhAdc/LeVqCgfBUu8THqTuwm2iC7C
        MMygoEH4wVQt24/nQLfjUQNLlVhWicWOf0SM
X-Google-Smtp-Source: ABdhPJyJksdn4ojQ6CLhehlKvLnUfIm5YkPQn/PQc4vjyh9Lol98+byFWDmY1UP7KllK7UdlQUIpIQ==
X-Received: by 2002:a17:90a:8048:: with SMTP id e8mr11197849pjw.206.1621947550560;
        Tue, 25 May 2021 05:59:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y14sm2023536pjr.51.2021.05.25.05.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 05:59:10 -0700 (PDT)
Message-ID: <60acf49e.1c69fb81.e8b3a.6937@mx.google.com>
Date:   Tue, 25 May 2021 05:59:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.121-71-ge76b1b8031ad
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 122 runs,
 3 regressions (v5.4.121-71-ge76b1b8031ad)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 122 runs, 3 regressions (v5.4.121-71-ge76b1b8=
031ad)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig | 2          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.121-71-ge76b1b8031ad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.121-71-ge76b1b8031ad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e76b1b8031adb4aaa2595dbc4d440293e0eeaa6e =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/60acbb7fc9453eecbcb3afa1

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
1-ge76b1b8031ad/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
1-ge76b1b8031ad/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60acbb80c9453ee=
cbcb3afa7
        new failure (last pass: v5.4.121-71-g15ff63eb4fc9)
        4 lines

    2021-05-25 08:55:12.967000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address c1d669c0
    2021-05-25 08:55:12.968000+00:00  kern  :ale<8>[   42.827512] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60acbb80c9453ee=
cbcb3afa8
        new failure (last pass: v5.4.121-71-g15ff63eb4fc9)
        36 lines

    2021-05-25 08:55:12.972000+00:00  kern  :alert : [c1d669c0] *pgd=3D01c0=
041e(bad)
    2021-05-25 08:55:13.018000+00:00  kern  :emerg : Internal error: Oops: =
8000000d [#1] ARM
    2021-05-25 08:55:13.019000+00:00  kern  :emerg : Process udevd (pid: 95=
, stack limit =3D 0x4ab63c87)<8>[   42.870467] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D36>
    2021-05-25 08:55:13.020000+00:00  =

    2021-05-25 08:55:13.021000+00:00  kern  :emerg : Stack: <8>[   42.88146=
8] <LAVA_SIGNAL_ENDRUN 0_dmesg 373837_1.5.2.4.1>   =

 =



platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60acbe8ba79a688003b3afbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
1-ge76b1b8031ad/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
1-ge76b1b8031ad/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60acbe8ba79a688003b3a=
fbe
        new failure (last pass: v5.4.121-71-g15ff63eb4fc9) =

 =20
