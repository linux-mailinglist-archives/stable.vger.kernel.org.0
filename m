Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42000655CA2
	for <lists+stable@lfdr.de>; Sun, 25 Dec 2022 09:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiLYIiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Dec 2022 03:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLYIip (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Dec 2022 03:38:45 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB60D52
        for <stable@vger.kernel.org>; Sun, 25 Dec 2022 00:38:44 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id 17so8607851pll.0
        for <stable@vger.kernel.org>; Sun, 25 Dec 2022 00:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PNeLHHK6eAM946YBabheybYdxyqHapM0fq2KBV9UoFc=;
        b=H7WVtNuo0oVv5cqitPFh1P7yglQMQAgEOQW1Dut3hSIlXGyDoXq939KZmmBQn7/3Qi
         4XfyXqDmvUnZgyAQBZxqtxoprPUAtm6x/kPdEGBtdtm57Ptw12wKv25PNsooMolMMXvw
         wSKHC7HAwkpA9UC1Ga76rOZNhY/oCBXtrRN64YRUG9VyDimL8bjjh+dzc4QkL1FjpgAg
         nvPw+gJPwSEBlUYV0I9tPOq6eEyMDIrrN5ZU1ZkyhJ7B+uoSj5UdsntIEgSF+/Cp1KqX
         mwnMmtXG0kKgUnOnVErDsRMFHAicSYW+dQlnApy21M2j1/YMr3MDn41q3hZIF3e6FhYS
         nxfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PNeLHHK6eAM946YBabheybYdxyqHapM0fq2KBV9UoFc=;
        b=5A4DVhCbctwU1K+gXv5nvS48NEwC7bsf5J2m7AbPJgSm/zrkvTmOZQxeV21SEjq0KF
         xf0UenaOgaACAeL1p8gExOHw/yItrKRdNZFCeW1wCnfjvQ4jXRWHwUSxO+dw7DXskgE0
         MEov8gcRqi3OVBcRTpinQCXxIYjUuIRi+r9YThFQrdroPtNfkVO6NQkISVZitNcbW0Ss
         /JMUA4g4E2JoJ+CU/1G1ZnndwLu4Pe0k6C0AHKDbUp8uQmKVY7ve2yskh354s3ypx8mz
         RjvZp5tnCQAZkqImDeyeRZ9jMRksoP34RjxqCdzm4UMiVLDARVYgWzNMby1nrGtc4J6r
         9Kjw==
X-Gm-Message-State: AFqh2krkGWoHKgd8ccKyXlG6AGWgr7/CU56QC2wCz3Lfqgv9JtRKhveS
        yGdc1kh1hzbPXbyzkJQ/Uwoc+/zHiT8etFQbJRg=
X-Google-Smtp-Source: AMrXdXumSXg/m9+EH2iZEBM0sqYci4xY11zabxZdvu6WMmNCxRG5E9ufR9siHIE4c5xjx4nx/SqEWw==
X-Received: by 2002:a17:902:7044:b0:186:dcc3:5133 with SMTP id h4-20020a170902704400b00186dcc35133mr16410477plt.49.1671957523482;
        Sun, 25 Dec 2022 00:38:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u2-20020a1709026e0200b001708c4ebbaesm1727353plk.309.2022.12.25.00.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Dec 2022 00:38:42 -0800 (PST)
Message-ID: <63a80c12.170a0220.8ff24.2a7f@mx.google.com>
Date:   Sun, 25 Dec 2022 00:38:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.161-545-gccb97c7715c0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 146 runs,
 1 regressions (v5.10.161-545-gccb97c7715c0)
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

stable-rc/queue/5.10 baseline: 146 runs, 1 regressions (v5.10.161-545-gccb9=
7c7715c0)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.161-545-gccb97c7715c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.161-545-gccb97c7715c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ccb97c7715c08ef267a41249eda532bf36186525 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63a7da5b11fcbf61a64eee3b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.161=
-545-gccb97c7715c0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.161=
-545-gccb97c7715c0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63a7da5b11fcbf61a64ee=
e3c
        new failure (last pass: v5.10.160-18-g2007c64d18cd) =

 =20
