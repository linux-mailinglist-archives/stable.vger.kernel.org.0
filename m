Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE95587455
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 01:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbiHAXUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 19:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbiHAXUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 19:20:36 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF6339B9A
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 16:20:35 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 206so7432108pgb.0
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 16:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KGtozq2yEkR30feK05YhEAGFkQ0aYok/RHpuJm6RqgM=;
        b=e9iQta/g2+WnuiMlpxg535gN8M+GBVrtaMXRSkfyEuvTLZk3KZ5062S8cXwSPh9SMM
         ZltqDbcjI6wV9x9uQQGTUwU/pLppwHRxHycHUmkl7ITmv8sayDyVfxNWKXGkk0Ka0YeS
         xLnnBqOCy5W91EgxHQ6LlzewdOE9LcIBYz8Zjq1WvkTfps0exdcLeYhwm14Zp5hZ7D8k
         xk/CHi+RkEyD0L38wFHWIKRH/q23vOvG0r7RNvth4lG6Plq0mR994qk5q7JLCekogUwj
         lwLIO5sNM1TB2bEk/vKqzdQrrLlTZP+3AwWjNDGmHwYj692y2FaHsqFO4pc2skH+ThNI
         IUOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KGtozq2yEkR30feK05YhEAGFkQ0aYok/RHpuJm6RqgM=;
        b=MkUr6oOXSse8Ga1QZxPYgt/jZ1pAbh0GUpWYHzdHKJbxC90GBVHZxIqe32P209xgYS
         vpZQ73+E5tzq6rJB8ufcphvgch1iH1W9Bmmi8tlHT6Lz/2C5z5Ef+Rq6WlRiGHBFXxqm
         cgVkRyuSzgcdx2m2fU6HNDG/UykHqdlbmpYdAR0DpGMbYSWtJWFZBLV9x8ikoSzgC5t5
         udGbQHDntBmDiPyNYW1R+f0zgrHDmLuD/BDSwOz/QJ3853K7+j83n/6bcTYrpY3Wp5vn
         taGZ0uhVsSpy5lX/B9yv9gQpRlhx7wuwi0zvTvbzeb91ruL0k/3XfBlMuVQSKgiVw8l1
         hHuw==
X-Gm-Message-State: AJIora+jpoa8P7KNIlqSjpt2OqaQRzHZ1aauJC377pkU4XHiBM9J4/ac
        EOMG1qslGjx0gmHc2LYiyaiCQWr8kHtLF7mM6RA=
X-Google-Smtp-Source: AA6agR6U3L181qlrBMmVbSmUNcJalSf6zyA/LCAfGmQ7yH6eSX8cDBk1axpxJOXyPynEgmE31KkC1A==
X-Received: by 2002:a05:6a00:892:b0:52b:c986:c781 with SMTP id q18-20020a056a00089200b0052bc986c781mr18533033pfj.64.1659396034863;
        Mon, 01 Aug 2022 16:20:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9-20020a170902ec8900b0016c3affe60esm10422055plg.46.2022.08.01.16.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 16:20:33 -0700 (PDT)
Message-ID: <62e85fc1.170a0220.c85e2.012b@mx.google.com>
Date:   Mon, 01 Aug 2022 16:20:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.57-272-ge258d1bce28ad
Subject: stable-rc/queue/5.15 baseline: 114 runs,
 1 regressions (v5.15.57-272-ge258d1bce28ad)
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

stable-rc/queue/5.15 baseline: 114 runs, 1 regressions (v5.15.57-272-ge258d=
1bce28ad)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.57-272-ge258d1bce28ad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.57-272-ge258d1bce28ad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e258d1bce28ad1e8fb68ecf643ed68befb967c35 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/62e82e2494fbaddf27daf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
272-ge258d1bce28ad/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.57-=
272-ge258d1bce28ad/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e82e2494fbaddf27daf=
06a
        new failure (last pass: v5.15.57-236-ge17300de5f59) =

 =20
