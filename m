Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83EE57DD04
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 10:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiGVI7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 04:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiGVI7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 04:59:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7953A9FE39
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 01:59:42 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n10-20020a17090a670a00b001f22ebae50aso3648749pjj.3
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 01:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wzX8hW4QsumbdLlX33l7i9HwHQE3xlyRyoAixRF7C/M=;
        b=RHtg7+jyJ2GjYFAreP7ihAlW6pR7wYYPBRqwzDlvjAJtLqMQxuSdGHDkZpdm6802Nm
         tHMVJ5t2v/jnBDv1kECVLGHG90ZorqFAJL6uO1MoXizSgCmjyavNxwB2HSm4sNHqLhtv
         /CZeyEoRsxzpPuMFYAmjW6te54O7194apIFvlm6xcltRDE0vHx5xTgjw+F7c0IklMG8a
         hUXtn95JQ08/qiv1JgefqQJlACCO17BExXooTuiISw0IgUjOdRW/aTV9oFGEg+NwiCvR
         w2niEyTQ2XZEkwhX/pCmqQpPysCZHtau5V+S49yQgtUHpJ8+chMd0m9x4RTbor9Jo2Fj
         hqVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wzX8hW4QsumbdLlX33l7i9HwHQE3xlyRyoAixRF7C/M=;
        b=M/mlYrb7KkLEXs64RZzfCdcXj8AhXMPPBQDCg+wQGmOEVXQWHeUaPHxkNRDH51bx6Y
         LcUB/L2BQNERqO0L4GOXvauhD6SGZX0xW+DYKVwlTrtuRGTd9G8I/mUq1D87Prwwjw8z
         wiW+FI+U8dym1JvgmacyDzPSR9IQtpuyCCCGpKnZhZkSmfpTKatVjFwl9ejO2zXzhBgQ
         bQQQuM7EHfJM9wrFL4j1QvtSt+o+qaysX2caxs78+A/4LQzdWL5RHV98pmHygt8kXelY
         9jUvxKxPQ/2dJbKgAgUGvHWRqg/3wT0EQamNOtG9PNG/nydrY9MGjOJ1ig0y6mElG7Vy
         vLXQ==
X-Gm-Message-State: AJIora+G0Tc2oUPcEaIHhOl1SL/NsN+NW47A0miUeL0oBn96GQKD6yVo
        OCt5Zempu8hbZvrpryGl+3Uzys5EKT+lURGi
X-Google-Smtp-Source: AGRyM1vpsv2k4O9BIJV4nX7zg20VGJVGyUV2bMwgIi6BYwUAgmAooyMTUtnJrKa0N907VgH3wdbMvg==
X-Received: by 2002:a17:902:e841:b0:16c:3053:c7e6 with SMTP id t1-20020a170902e84100b0016c3053c7e6mr2372237plg.163.1658480381732;
        Fri, 22 Jul 2022 01:59:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y14-20020a17090a644e00b001f217ec21efsm4989512pjm.13.2022.07.22.01.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 01:59:41 -0700 (PDT)
Message-ID: <62da66fd.1c69fb81.ccc34.83b2@mx.google.com>
Date:   Fri, 22 Jul 2022 01:59:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.12-227-ga1ea64ad5b42
Subject: stable-rc/queue/5.18 baseline: 156 runs,
 1 regressions (v5.18.12-227-ga1ea64ad5b42)
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

stable-rc/queue/5.18 baseline: 156 runs, 1 regressions (v5.18.12-227-ga1ea6=
4ad5b42)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.12-227-ga1ea64ad5b42/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.12-227-ga1ea64ad5b42
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a1ea64ad5b4282c6565feb7444ffda06aa5a9f44 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62da370120f66558e6daf0a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.12-=
227-ga1ea64ad5b42/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.12-=
227-ga1ea64ad5b42/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62da370120f66558e6daf=
0aa
        failing since 16 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
