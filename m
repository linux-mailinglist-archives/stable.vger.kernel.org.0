Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AC04AA095
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 21:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbiBDUAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 15:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235857AbiBDUAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 15:00:37 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A897C061401
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 12:00:36 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id f8so5875377pgf.8
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 12:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tF6c7tPniitHRf+hEb0g8JMAzHRqoxoEupVhy7VKdzg=;
        b=knVSNdM6G64ikXk4br91GKX1DpwJhPwKNg44IHze0TVFInBMw9xs/4CyEUMKAmKdFG
         JT3h8Fo9jxK+NwyxFLMN2IJWi5vXQcGUUaQvS+LtznMj9ceNzxbQbQz/8E30WIyI0Z15
         CYMfzcTmrYhfMTLIst5knXGk32iy/0PcUYopTcqrV9wuq4RxL1QGP/mnbLTZvKQwzaXD
         LoA2AXjEZXPdywDD58zdls1oXLK7U8TDJxlX0oQHtwj329q7SUAO5/a8+dfLbKE8E9dU
         ToueeMzN8sucneswD2wVv/YAzau6xPb1I6gmgsrUs4dqOpzxqU6i1ExQmUvWHtRjs+st
         oo6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tF6c7tPniitHRf+hEb0g8JMAzHRqoxoEupVhy7VKdzg=;
        b=US5pCJUDXbqm/WwN3Eqaj1vj3MjLEjc7j3CWv8CIWdUSFCMqLbthlTD8YQE60XppsN
         8b48iwPOTgA0GO6rnUmlAqwOcPgwaeLCARJxCRgk9UdNMiW2hnHdfFRX3DeIALAHU7n6
         Ny2axbrjCcJOqP7zb+sZMMnLqNSgoJHOAe3RuDP2EKh3/z+l0Ku3mLClj55817EkEUXL
         Av5iGS9brjcMD7RAI2fHCaAbX4zwxGBW03MPjKoURQb6t4FnX9QufOm1HwhtV5HllCk9
         /8Ndnra4SJ9zAR7dhBholAbwmccKslxZerREPiMGJbHPFaVoQgC/tSODqlHLp5ElAxdi
         X/wA==
X-Gm-Message-State: AOAM530oybHvWXQsWzXSeVa2q+w62liu/QnpfkOrO09cQPmRRy5RBPc9
        yhTezLeoTOatCQb5kDRhEVmuJ8GrNIXU998q
X-Google-Smtp-Source: ABdhPJzw407DkbDPx7M+9/NhbtChce1iRw4ehCVnrOy6m9OLoVbsd8ZbtlY5nQfJ5kju/7ZiVo5uiA==
X-Received: by 2002:a63:4852:: with SMTP id x18mr517171pgk.286.1644004835607;
        Fri, 04 Feb 2022 12:00:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id na7sm15612595pjb.23.2022.02.04.12.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 12:00:35 -0800 (PST)
Message-ID: <61fd85e3.1c69fb81.9a609.7c7a@mx.google.com>
Date:   Fri, 04 Feb 2022 12:00:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.19-34-g61f904d1d627
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 136 runs,
 4 regressions (v5.15.19-34-g61f904d1d627)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 136 runs, 4 regressions (v5.15.19-34-g61f9=
04d1d627)

Regressions Summary
-------------------

platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
beagle-xm               | arm    | lab-baylibre  | gcc-10   | omap2plus_def=
config          | 1          =

hp-x360-14-G1-sona      | x86_64 | lab-collabora | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =

r8a77950-salvator-x     | arm64  | lab-baylibre  | gcc-10   | defconfig    =
                | 1          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-10   | defconfig    =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.19-34-g61f904d1d627/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.19-34-g61f904d1d627
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      61f904d1d62716d179a70419e910118621910751 =



Test Regressions
---------------- =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
beagle-xm               | arm    | lab-baylibre  | gcc-10   | omap2plus_def=
config          | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd4ddde5e333c00b5d6f58

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
9-34-g61f904d1d627/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
9-34-g61f904d1d627/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd4ddde5e333c00b5d6=
f59
        failing since 14 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
hp-x360-14-G1-sona      | x86_64 | lab-collabora | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd4e5b2c921f0f305d6ef5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
9-34-g61f904d1d627/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
9-34-g61f904d1d627/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd4e5b2c921f0f305d6=
ef6
        new failure (last pass: v5.15.19) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
r8a77950-salvator-x     | arm64  | lab-baylibre  | gcc-10   | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd4a9d49a369bbef5d6f21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
9-34-g61f904d1d627/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
9-34-g61f904d1d627/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd4a9d49a369bbef5d6=
f22
        new failure (last pass: v5.15.19) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-10   | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd4a5f314a6412a75d6f34

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
9-34-g61f904d1d627/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
9-34-g61f904d1d627/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd4a5f314a6412a75d6=
f35
        new failure (last pass: v5.15.19) =

 =20
