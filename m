Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A235850A52C
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 18:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiDUQ1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 12:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390620AbiDUQQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 12:16:11 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C2C2B241
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:13:21 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id e62-20020a17090a6fc400b001d2cd8e9b0aso5598427pjk.5
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3wk1xolRK2dzo8hQaOrHAzTQT13hnxP2hdDsaDMdOrI=;
        b=JKINUiZ5Em841qWdDjzeX7+r/fZLhP9fbvuT1ng+hzKVy6AmyWZpjAUTjPz/3oKM9a
         QvVhdOzYDfXRozYvQ8fjlrpi0QIDuXhOr9/XNIYITN87cl5J//y0/+HaIb226YH9KgNb
         USPR7yJ+jSNG2KTsvsQbmZ5Imf8Rdn7r7dcrfTqr98vgI9Z6TIOVp0sR35K2AjJEZDhd
         n69WCwYDJFspXq7pu0DZJajmHu0/ZQLtS15MNrj7Tbvu8qKUEWRtEuEPzrgWLBMmVCAq
         97fgxZI5nxN7Ko5gbbfPWlrvB3hid7KeY5nwTXqyUj5egSTCTDttrRIafCmjH72VTEmK
         cktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3wk1xolRK2dzo8hQaOrHAzTQT13hnxP2hdDsaDMdOrI=;
        b=Qg2tCA315h3QxCK/aQkx1ayMnAcFqQ3aiYkql7ppngABTS0WQr94aavBsf+csr7d9Y
         jZBXw6NWiVWIqy/CAREgp14J58XMFsorQ8LSfmvNHOrdgkLQwAmTw821ADb9gfZsYb1N
         oxi8Gb9mwJJB9+u+iFh6bOHjPfKouOsuGVuGnIO1hIllmaEOT4Gmya1SUCMKoIt2Fwpt
         T2ZSg9/D9mcZC3LFu25dBBwussOWRAiEjlWV1zOgwuKKqzwX1xDCHeuAxGNah23Z9Toj
         ETN7iOZvOqLn/DWNn/KLryOFZ0kcQ9Wg4IhdSKAq+Y2S5vrs7GiWwsiiwGdrJ5IYZTwO
         ERKA==
X-Gm-Message-State: AOAM532Oj3Yyg0sxbh/JAxtei5QVtpkJ+MpSHRscKvyMpceIYdMU6O+Y
        vnucNB9AHf5AHAU0aIQnuVrwFuhVShHhmQdQ4bs=
X-Google-Smtp-Source: ABdhPJx7mnophLNKObcNH48wyTjJvKfmgILzFMHUKjFx0B86ZQ82tSqwessYamtJmU6gVuZVPZx09Q==
X-Received: by 2002:a17:90a:9109:b0:1cb:a814:8947 with SMTP id k9-20020a17090a910900b001cba8148947mr11081699pjo.52.1650557601367;
        Thu, 21 Apr 2022 09:13:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k187-20020a636fc4000000b003983a01b896sm22993620pgc.90.2022.04.21.09.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 09:13:21 -0700 (PDT)
Message-ID: <626182a1.1c69fb81.ac6be.6cf2@mx.google.com>
Date:   Thu, 21 Apr 2022 09:13:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.239-5-g74ad04bae4c1e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 21 runs,
 1 regressions (v4.19.239-5-g74ad04bae4c1e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 21 runs, 1 regressions (v4.19.239-5-g74ad04b=
ae4c1e)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.239-5-g74ad04bae4c1e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.239-5-g74ad04bae4c1e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      74ad04bae4c1e7f86aae8991c118944df866fb35 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62614d0846a44f7d60ff945a

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-5-g74ad04bae4c1e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.239=
-5-g74ad04bae4c1e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62614d0846a44f7d60ff9480
        failing since 46 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-21T12:24:27.243329  /lava-6140788/1/../bin/lava-test-case   =

 =20
