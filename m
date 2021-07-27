Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB0E3D790D
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 16:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhG0Ovd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 10:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbhG0Ov1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 10:51:27 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2E1C0613D5
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 07:51:26 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j1so18113939pjv.3
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 07:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mhzDaBrKTzQaAhh+O2NDzTtvIeBKq3KbYvveZZZZhhE=;
        b=hi31aNlC6Hb9MTjUyetas1g8+L5+icwXIByqq79XIbLHnp50csCZMt2x7EMnYo6mGG
         GKB4R2u+zPfC1gqhukJrwojqmqtCC7KP5RPGnxyDBjPf1a51i3hRNx6IO9PLNfOkA0s8
         9AzRFHxUj+1RAfYcydCPrNZY3o+RFFGt1LndrNaXFP7vefsgIkwiQk+faVsOMC0f5Bv/
         EvFFs6n2IEsLiPiG4Q0h7FO0LRzQDhkKszkplDp7YAf4dUWPuTT0R6VZbxr2viQdHLXD
         l2fid2hA9yqrwSvaHnUvk8Z2omvecNs1wk8SY/gLCTKbpZTodPxUAP5T3Cc9ymkGmESU
         MjjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mhzDaBrKTzQaAhh+O2NDzTtvIeBKq3KbYvveZZZZhhE=;
        b=JQN9bHvm0zvFgFjkw3MXmKjLwAmJzYE9mQWXcGdUvN0O+aNgum2eQBfXQ9WkfeMYBa
         aA+9eq7xukx8qp9pVVWgIcjT/hdCEdnN89z7GgC5nxF3Hb8XH8xtMRu6LB6u5n+mkbw9
         cw6LnSAvpY+HyNVOjtHEbnaTt+lyyY0H3c+sV/KVxCqrB3OGBPVbWXLvRYLtPd3zJxyE
         Jm7ziy1HIIpk+2W8odVH607i4fHCrBr7HCmR9s6zkihKYo+6RUhSrwxv5q2FZiYD4Zv2
         obXdre/jk0GNAhKpdnebHea3nCyj5cumpgpQfbNbmp8oUyseJA1jXrlhWy+rUdhRkfBA
         UgbA==
X-Gm-Message-State: AOAM53014TcJygiNCQ6xNqG3NsezR+BT7EMPIXXleYfhkiubVLXFl+/n
        1OLT+egSwsCCFGbF0OFBL83vpGZy9inzTMdj
X-Google-Smtp-Source: ABdhPJygC10XSNrP5mEPsOGBWzxsGejih1i4rd8zz9z6lDAmi18dpxZpkO3ZU78s8mDKM/4qPrF5tA==
X-Received: by 2002:a17:902:7b83:b029:12c:2758:1d2d with SMTP id w3-20020a1709027b83b029012c27581d2dmr8447613pll.80.1627397485957;
        Tue, 27 Jul 2021 07:51:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gb10sm2971621pjb.43.2021.07.27.07.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 07:51:25 -0700 (PDT)
Message-ID: <61001d6d.1c69fb81.1e5b3.8ceb@mx.google.com>
Date:   Tue, 27 Jul 2021 07:51:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.53-167-g06e8f61b67ed
Subject: stable-rc/queue/5.10 baseline: 186 runs,
 4 regressions (v5.10.53-167-g06e8f61b67ed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 186 runs, 4 regressions (v5.10.53-167-g06e8f=
61b67ed)

Regressions Summary
-------------------

platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
fig             | 1          =

d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
...6-chromebook | 1          =

hip07-d05               | arm64  | lab-collabora | gcc-8    | defconfig    =
                | 1          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-8    | defconfig    =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.53-167-g06e8f61b67ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.53-167-g06e8f61b67ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      06e8f61b67edb544b7116dabcc5000fe1420ff77 =



Test Regressions
---------------- =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
fig             | 1          =


  Details:     https://kernelci.org/test/plan/id/60ffebc5f40e25a5e05018d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g06e8f61b67ed/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g06e8f61b67ed/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ffebc5f40e25a5e0501=
8d9
        failing since 15 days (last pass: v5.10.48-6-gea5b7eca594d, first f=
ail: v5.10.49-580-g094fb99ca365) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60ffed2dce5296bf1d5018ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g06e8f61b67ed/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g06e8f61b67ed/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ffed2dce5296bf1d501=
8cb
        failing since 15 days (last pass: v5.10.48-6-gea5b7eca594d, first f=
ail: v5.10.49-580-g094fb99ca365) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
hip07-d05               | arm64  | lab-collabora | gcc-8    | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/60fffebcfae8f9b87b5018f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g06e8f61b67ed/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g06e8f61b67ed/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fffebcfae8f9b87b501=
8f9
        failing since 26 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-8    | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/60ffe973534ed1a34d5018ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g06e8f61b67ed/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.53-=
167-g06e8f61b67ed/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ffe973534ed1a34d501=
8cb
        new failure (last pass: v5.10.53-168-g25be65e302a0) =

 =20
