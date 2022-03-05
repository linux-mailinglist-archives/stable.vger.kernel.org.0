Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD624CE610
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 17:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiCEQxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 11:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbiCEQxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 11:53:37 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BE455B1
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 08:52:45 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id z15so10202020pfe.7
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 08:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2u+HLsMEI3Yv8jKg7cMoZTTWCzcryLBHBAKk0V/0Yis=;
        b=pJg4LCmKFUXNKCM/AYJUrAwqkdOOCjJTeL4ywU7DzE8YI/ZBtxcKfpHZB2+zyRqKmq
         o+GzMVjCNyhvuxMhAD10XggmoZIg0ld45bc2KWW3SIf0Sm7vLnsKot7zsexejQ2QEY6b
         BogOZakirWWOQvU95U84IXQOKcax1YqOXOfp+g5r/hp40QQoKdJ4PLx7yRkltRM6S9yI
         m/jnBvFKaopF37jcq5V2xqRdu2WbgpH+514djor/PQkrh+mFK6sOGSeHD0gEsUk0eRNj
         vTQ2tVkK1Xwi3p3LrULgVl2bW8DEdH/xYQffrignwXu6IwQ+nsAyFZ8IxFP3Aq+Cl3bT
         XIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2u+HLsMEI3Yv8jKg7cMoZTTWCzcryLBHBAKk0V/0Yis=;
        b=yADsz8Ywu3k+9Fs5+7ypPkjZlV+ZQQjWlWiOdWm1brDJnwJi99apPGq0385Bi3a4+F
         MvMFaarOq6tTYIuF1UISCnxzW3A2wfPUazC4LkACnAYvzY0UMoEhKxMnwHL6UtfAcqd2
         bcktA9TnCxxPWYOdpaNLxj2BerCDgjSPqCx9HN/oknfe/p05NKsurRW9g0mkKY/e2Zx9
         K9AUMhaVeKSqwMQJ1zm3jzxOm/ITScTUdRaUxAHPcOCwezSeQddz+4QhiXRG5mU8oXFv
         1NIUWWN2i35ODfz2s+nfxxhSeEt7ISEh+jIboJaclczUTwNG4JhBOmxFM1DYlDwCPpsr
         38dA==
X-Gm-Message-State: AOAM530u14BSFufuRbM3K5bFTyxPKvk94JFjM6b9O2ZsDKyoWQZYBxb8
        Vjz7w/+gBIIJpOWRZ/7GGgvvyL8gHOZktkahKXU=
X-Google-Smtp-Source: ABdhPJxUmkaS2MtXgzxF+ZMd7Nx+gZkEUW5ePm1/FJwSoRcuHCRTnFeu1twHABfEVBrhQON/vfT3DQ==
X-Received: by 2002:a63:e817:0:b0:373:8abb:2c51 with SMTP id s23-20020a63e817000000b003738abb2c51mr3345957pgh.185.1646499164643;
        Sat, 05 Mar 2022 08:52:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x6-20020a17090aa38600b001bce781ce03sm7995065pjp.18.2022.03.05.08.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 08:52:44 -0800 (PST)
Message-ID: <6223955c.1c69fb81.b15af.49ed@mx.google.com>
Date:   Sat, 05 Mar 2022 08:52:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.103-45-ga9cd4525baaa
Subject: stable-rc/queue/5.10 baseline: 126 runs,
 1 regressions (v5.10.103-45-ga9cd4525baaa)
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

stable-rc/queue/5.10 baseline: 126 runs, 1 regressions (v5.10.103-45-ga9cd4=
525baaa)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.103-45-ga9cd4525baaa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.103-45-ga9cd4525baaa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a9cd4525baaa3d4080906e767371bccdd3a750ac =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/62235e4a95c79225b6c62993

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-45-ga9cd4525baaa/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.103=
-45-ga9cd4525baaa/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62235e4a95c79225b6c62=
994
        new failure (last pass: v5.10.103-24-ga3cf12bb4a6c) =

 =20
