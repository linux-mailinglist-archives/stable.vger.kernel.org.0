Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938454CD7B4
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 16:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiCDPZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 10:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiCDPZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 10:25:34 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6778D1C4B1E
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 07:24:46 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id y11so7874816pfa.6
        for <stable@vger.kernel.org>; Fri, 04 Mar 2022 07:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WzV+IBeetx1vpXFsltRIOswvMKkwIyR8k7Yc0aYeYZU=;
        b=p0l5ZeosSEe+n/bYUAX6x+nufSa3aYf+LWA6sM9M3h4bK69P0R/v/3BWn+3+gU1C/w
         onJFP+JGVkldVCIGeZI6NvxWh2iT+qFgWy/GpTqMJcS1WIDu+j6/OjUR/ObqxxpXaxJk
         ZLbq/3UKn9KxJoWiI0KGR9WIJ/fBVlXa1W5Zg9C9wriO2OsZftsYYa40L2mbF5gwYSxe
         ne+/1UZRpByxWaHwHFT9VDYRDPMH1RjzI2n6/39MJKDFIETptYIrSw9Tvq0Er4sXOPz5
         vEao0JC8C4DIxMi+g9wa0WRyDhDjxrBLJNI5/PXiKar8Lv92AirY0gjNEknVMQwRFmTK
         BLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WzV+IBeetx1vpXFsltRIOswvMKkwIyR8k7Yc0aYeYZU=;
        b=wYb0X0IJTAznR9ADXRcxZjvgNO+5FVbdZsu6KcB2XC48OliiM2svpcAIYmrZ5h9nrb
         xdM2ODIXGKzI8GvHtSGsldhdMrsSeUQr8y7ROEtVgR0b80eOwyqWoEqPAOqGlQ4Xi2Ox
         6jSQjNK7EJAFpkFu1U5Fap57jOSK78pFo0GajKcN+xduQ7vZNuRs8Y8+rVWNsaLpUcd5
         1xGbf05BEUBxBj02DlGo8oB4dffXy5zdpQsNuFlDMAiOJkqri19ubc70eLLf7ccmszbc
         o3rx3RT9PpjKfx5s4kKAAFCBDsO+uTkGrrzNjhVRpqSomTI4t2Vwyfo1N8NPoNPvan7+
         Tvrg==
X-Gm-Message-State: AOAM533OLK587S/PRBaN08IqEalhRLeLKjaiVZfCYKzU0hUY/wcUfZb/
        lPbftai37DaUkjGngAv83lbNft6PxMjkWYSbHB0=
X-Google-Smtp-Source: ABdhPJytN/8qhte6Y1aANhtiEONYPjmBUInoveHtuQ/vtLp+A08A0QM6UcVgOSU+cQv3pEYn7HhgJw==
X-Received: by 2002:a63:4c50:0:b0:373:2a90:dc04 with SMTP id m16-20020a634c50000000b003732a90dc04mr34653280pgl.350.1646407485664;
        Fri, 04 Mar 2022 07:24:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k62-20020a17090a4cc400b001bf0d92e1c7sm5027867pjh.41.2022.03.04.07.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 07:24:45 -0800 (PST)
Message-ID: <62222f3d.1c69fb81.62263.d353@mx.google.com>
Date:   Fri, 04 Mar 2022 07:24:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.26
Subject: stable-rc/linux-5.15.y baseline: 99 runs, 2 regressions (v5.15.26)
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

stable-rc/linux-5.15.y baseline: 99 runs, 2 regressions (v5.15.26)

Regressions Summary
-------------------

platform              | arch  | lab         | compiler | defconfig | regres=
sions
----------------------+-------+-------------+----------+-----------+-------=
-----
kontron-kbox-a-230-ls | arm64 | lab-kontron | gcc-10   | defconfig | 2     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.26/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.26
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8993e6067f263765fd26edabf3e3012e3ec4d81e =



Test Regressions
---------------- =



platform              | arch  | lab         | compiler | defconfig | regres=
sions
----------------------+-------+-------------+----------+-----------+-------=
-----
kontron-kbox-a-230-ls | arm64 | lab-kontron | gcc-10   | defconfig | 2     =
     =


  Details:     https://kernelci.org/test/plan/id/6221f8d067ceb54ca8c629c7

  Results:     91 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
6/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox-a-230-ls.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.2=
6/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-kbox-a-230-ls.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.leds-gpio-probed: https://kernelci.org/test/case/id/622=
1f8d067ceb54ca8c629d6
        new failure (last pass: v5.15.25)

    2022-03-04T11:32:07.092441  /lava-95347/1/../bin/lava-test-case
    2022-03-04T11:32:07.092759  <8>[   16.972101] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dleds-gpio-probed RESULT=3Dfail>
    2022-03-04T11:32:07.092952  /lava-95347/1/../bin/lava-test-case   =


  * baseline.bootrr.sl28cpld-gpio1-probed: https://kernelci.org/test/case/i=
d/6221f8d067ceb54ca8c62a1a
        new failure (last pass: v5.15.25)

    2022-03-04T11:32:09.197521  /lava-95347/1/../bin/lava-test-case
    2022-03-04T11:32:09.197928  <8>[   19.081553] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dsl28cpld-gpio1-probed RESULT=3Dfail>
    2022-03-04T11:32:09.198168  /lava-95347/1/../bin/lava-test-case
    2022-03-04T11:32:09.198392  <8>[   19.099134] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dsl28cpld-gpio2-probed RESULT=3Dpass>   =

 =20
