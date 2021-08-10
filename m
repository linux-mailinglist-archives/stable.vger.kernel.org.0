Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7B43E7E33
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhHJR3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhHJR3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 13:29:03 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1637C0613C1
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 10:28:41 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q2so22131819plr.11
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 10:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XmZ7mW9TP6UDfVcEbUafHYfRZp06ZSrPuK2z97SpQZU=;
        b=ujPWyY9I4D3S2nkghM64aF3dhGf08DrP53GbS6I0Lc68fRFwa/w2tZTJ1KvdEZ0a9A
         tn7WUUQvrhN6PRD3ekyPGvqmUHWoGMNAgfZJ5FhArZTZnrU7FRyvcPwAW66PsyNGt1rD
         mrOUBDvubmMr4wgfq3+rOWLoTjYKIRNaXhZ2o5W0V/MUlmcfJ0YrRS/mt+wemBDp7CaK
         oqPP51MAtTApDszbEYxey9X0ZP5dpv66j9N26RntpqW+maN5VhBx6aryeQrJDFV4k+T7
         EeHSKsVGex3VAaH/B+jeJVP4oZ6FD1na+feHgrYhMo9kaecA9XmOL3fNUNWC1cnJmORY
         1BvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XmZ7mW9TP6UDfVcEbUafHYfRZp06ZSrPuK2z97SpQZU=;
        b=JoHAS6K383pP0/IKpWMOVzlyGlo73CQy0k6hf1g8MEkHn7JwJGTLIswLaesM6rxxKe
         jj0fHEgjEtyebJQtjp3J9OhEsn30hJDjf1mwjoE1yENQ8Kw9HFMGpFCdNLwD6Q4zvP6n
         ot8qQFuZ2oJ3yixSINVjA8W4ZV4ilKNQxrTZWuXQAyI9WdyhmI6AT7YFdQTzsOTWhBYO
         1SZxG4uCwDgX6m+7t+vwhpUioANOBC1U1R0SYzUIu7hhgTkA4xSpf4vi9FD8mMLEKaQG
         55QayhoUEOf42G1+TqDK9SffrqWgInJAJrYi0B5CSOi2V/pW5NzrOH5Y/eR1/HnkVGDA
         DgDQ==
X-Gm-Message-State: AOAM531pY+CWnNKvDLC/uCa4HO2JML3M0sIm5bqGKMjJcWIND/82Ksw8
        3Bp5ExIIPX5qBN9CKBLls0lZWLF5fVvpjDLk
X-Google-Smtp-Source: ABdhPJwUXg+RtCx5JSQoTvtBQOo/KveLrDGXjIU1eyhEbXZqaw+kB1LdkJmEjwWFIUUVDF+FueV5YQ==
X-Received: by 2002:a17:902:ecca:b029:12d:1a3b:571f with SMTP id a10-20020a170902eccab029012d1a3b571fmr12440954plh.37.1628616520943;
        Tue, 10 Aug 2021 10:28:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t19sm26452724pfg.216.2021.08.10.10.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 10:28:40 -0700 (PDT)
Message-ID: <6112b748.1c69fb81.a9c19.a786@mx.google.com>
Date:   Tue, 10 Aug 2021 10:28:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.139-84-ge627b0376182
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 169 runs,
 3 regressions (v5.4.139-84-ge627b0376182)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 169 runs, 3 regressions (v5.4.139-84-ge627b03=
76182)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.139-84-ge627b0376182/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.139-84-ge627b0376182
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e627b037618224c1fb20a26a2c93a7c43b1918cd =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/611280e0e2d7668b20b1368a

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-8=
4-ge627b0376182/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-8=
4-ge627b0376182/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611280e0e2d7668b20b136a2
        failing since 56 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-10T13:36:14.447834  /lava-4341996/1/../bin/lava-test-case
    2021-08-10T13:36:14.465470  <8>[   15.176771] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-10T13:36:14.466058  /lava-4341996/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611280e0e2d7668b20b136ba
        failing since 56 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-10T13:36:13.025385  /lava-4341996/1/../bin/lava-test-case<8>[  =
 13.752638] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-10T13:36:13.026004     =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611280e0e2d7668b20b136bb
        failing since 56 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-10T13:36:12.004084  /lava-4341996/1/../bin/lava-test-case
    2021-08-10T13:36:12.009769  <8>[   12.732961] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
