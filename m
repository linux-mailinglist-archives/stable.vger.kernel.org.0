Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BE2628990
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 20:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbiKNTll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 14:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiKNTlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 14:41:40 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D141B1E5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:41:39 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso14827671pjc.0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5LgnjyN55RUfsSqkDlRobrNq04ErFPW9kmSc5YdZns0=;
        b=4TsSqzNTUCo6VUpAL66ys5EqcmbHkdBuhR0ezUUZwWgwMTIvLQXWbqVePMnEhWjl6V
         uMdFfuTB+7l/G/Bkh1gksh6cmS/K5mmAxjnL3eXMdrJXHmN6uDg1Q8W1PN4wzs6kYrM1
         FY69efQw+5QQNGm0hJ3Pz1YnOImGTbMHD0GPCMCK2vd1/+n6aEG02GTNxeQCflDpzQgU
         +NHVNxgbaYnOlv4nVyF0gNGyliWb6RzaSqe4HcskHXD3ONiYjw1oWRMWwRh+IZCd4ne6
         fbwq+GuTugC8j/MyI8545ZEmOFk5YRaVqGinvHh/KMb9fWv3HPh6J7HTJhm5AayFtA3/
         Ugww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5LgnjyN55RUfsSqkDlRobrNq04ErFPW9kmSc5YdZns0=;
        b=jY5Nx8PBA/DEtTw+g0BhMuJu8Xfyo/CQ/vpius0mOm63M34J9s1CZB6WTrAXvrYVkr
         oG7GWn7uVV1+yJhKUOboStlBDFRiegsM+CMeXTNX+m3BpM7YShXKN7XOW7Yjx2k/v2nQ
         UgqTndW8D04U7bPupOZnBhvuLpjW0YC8BC1jGOQZG4D3k1CPOKABYfDihJehP9W1qWj4
         mAmJje8g7YubVaaDtiSVt/xWMW7Z/10Iw9Yo9bffpKwOiC07onLMfJTwwAkIzUn19VoK
         +sw9pePUE+HVA+HVigvSjxf7bBR/hIKpjl+YEz1AwBT0MLeqwtaF7jgpird2c/earXuG
         l2Xw==
X-Gm-Message-State: ANoB5pkcVBRaArRVYRU0LL3DU6T0TLqMsWVTOQfQDBTpoyZqHCOg75VP
        kvH9Rc7DglQT9SQE35hUGYqrbnbdbN4LSXvGUac=
X-Google-Smtp-Source: AA0mqf7v+0UK4L8soriKtm3nEnrmlRGuigz8Qjv48FPcUsJikM/vI1Na699pSXNDZGPhB4RSW3z3WA==
X-Received: by 2002:a17:902:bf03:b0:186:cb66:9dca with SMTP id bi3-20020a170902bf0300b00186cb669dcamr694581plb.98.1668454899175;
        Mon, 14 Nov 2022 11:41:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e2-20020a170902d38200b00186e2b3e12fsm7855055pld.261.2022.11.14.11.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 11:41:38 -0800 (PST)
Message-ID: <637299f2.170a0220.cdb1e.ba4d@mx.google.com>
Date:   Mon, 14 Nov 2022 11:41:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.78-131-g8f06926bb1b0
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 150 runs,
 2 regressions (v5.15.78-131-g8f06926bb1b0)
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

stable-rc/queue/5.15 baseline: 150 runs, 2 regressions (v5.15.78-131-g8f069=
26bb1b0)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.78-131-g8f06926bb1b0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.78-131-g8f06926bb1b0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f06926bb1b0e2aff588997f5e4cb06c88498bb4 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/637266066bdee08b53e7dc40

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
131-g8f06926bb1b0/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
131-g8f06926bb1b0/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637266066bdee08b53e7d=
c41
        failing since 49 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6372648ab0e7c17858e7db4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
131-g8f06926bb1b0/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
131-g8f06926bb1b0/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6372648ab0e7c17858e7d=
b4f
        failing since 50 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
