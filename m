Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C685167A6
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 22:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354299AbiEAUNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 16:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354261AbiEAUNm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 16:13:42 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE4C1030
        for <stable@vger.kernel.org>; Sun,  1 May 2022 13:10:14 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id bo5so10902891pfb.4
        for <stable@vger.kernel.org>; Sun, 01 May 2022 13:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CVI8BamNoyaTb2vFrnfiirzmpA0okAwTYi+2+VZ3w8o=;
        b=J8KLSinI3WhWrl6nYhzvBKdFBPP+vjf2gs3/+xQGnglMTISnI9SgZaTkL58vCmWYvW
         TsS/mxcL98asDln/q/j4iLIHJU4uTK/qHNk7YUg20jLeB8F0ye+HGad2syUL+yt9Lp+2
         NJ1JyJkV/LKmselICwINRnKZeWMOGEMBvEw0gz6Q0P5QJVyaWP/eUKTj1Ud7yrODAVW4
         Xyb9tWf38UKGzTwbb18EIO/TKCoso86PBc67Ph2Z+ryeaJkgBKQV3rY6C38cOXMpDRoi
         FlgOPIJYoahcCU7VxCTbzq/2biHtUunmTDOHc+kwSOW0bmzOT4b0svf/Y52AGSXXQ0f/
         Xh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CVI8BamNoyaTb2vFrnfiirzmpA0okAwTYi+2+VZ3w8o=;
        b=HLx9mBanVXqRi+A5zBjmpylAUbM0D34in9GjfBZR5EijzEOLI4gAf5DOIUh2O/YvzY
         VDXM6fph/+5C3bX14/8mGtvtafV8FfvgZngOZmvsPwtHVuRlXgNkhtRzRzUozk9NpXdu
         Nob0EqtuUZzwP/Bgq9hYn3jsKpnk3/HJkQoCEoQqIuFjnweTJmmMLFBLtsguzwpx7iDj
         +hsR5942pp/cuMrjOuUb1Rv6VNiSvkFslO/X1lwWpsElPHLO7MCIX6ZuvPhFK6Zmv7EL
         epvZPXpfuAkeZuNIwLJf6y82SLoCear3Yev2CbfmWrdVZAZpU7UL6dx3TLV6qJKHKlW2
         QX6A==
X-Gm-Message-State: AOAM5320s2rNEoCqvkX5jE4U7S7UpxjMT8gMlGs9CqOWiliS0vEV8GTD
        p4JYGoRMoeiK8ykSwI5OmYf6rubaDsLmliKwt7o=
X-Google-Smtp-Source: ABdhPJxqe5/R59vv7hZJ37SkyvvWPTiuR20FX+SJSRcG7cqQ79vRgXNo5F9XmzE3M/hhkwaTE24HSg==
X-Received: by 2002:a05:6a00:2181:b0:4f6:f1b1:1ba7 with SMTP id h1-20020a056a00218100b004f6f1b11ba7mr8192927pfi.73.1651435813632;
        Sun, 01 May 2022 13:10:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y18-20020a1709027c9200b0015e8d4eb20dsm3225201pll.87.2022.05.01.13.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:10:13 -0700 (PDT)
Message-ID: <626ee925.1c69fb81.64102.7b32@mx.google.com>
Date:   Sun, 01 May 2022 13:10:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.15.37
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 131 runs, 1 regressions (v5.15.37)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 131 runs, 1 regressions (v5.15.37)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.37/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.37
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4bf7f350c1638def0caa1835ad92948c15853916 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/626ebceb7f141f41f3bf5fe2

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.37/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.37/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/626ebceb7f141f41f3bf6004
        failing since 53 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-05-01T17:01:08.139093  /lava-6229814/1/../bin/lava-test-case
    2022-05-01T17:01:08.150395  <8>[   60.899845] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
