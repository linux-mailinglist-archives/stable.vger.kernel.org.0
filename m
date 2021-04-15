Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2804361320
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 21:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbhDOTw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 15:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbhDOTw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 15:52:28 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FA8C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 12:52:04 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id g35so17598086pgg.9
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 12:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3XBRVEyRB+3uxwFnXBd8rwgyNc8WgQAzJgNKEqrTdm8=;
        b=kcbMBhdgYIp4ecTddrow4HGldZXWgoSt9QpKP8Fl6MiGzZ2ZEDGEIQJMDKTsVinSjg
         kg+DzVctd0qsjfYAw7JGqTTj8Cat10HuQFn+6ofIawV2en3NIiySh+MMJgWVkmNPTU9P
         ZAN44/iea9TDB233Nv4W91gJOFRjHrG0hbz4sJ6FwZag/JtV2ipGm8sMiK0cFHFvZD5n
         UBnayYQE1nFYvxh3L+17nxqZ9kCz20oVvPEScLtFrTATpgIQowtNQsx+XNl3bfNehlHZ
         FPL6otDu2ms/nuzti+FfLJzQes91lsraV9hYqLNmBOrFmUhNUUVS1ctN7TIe1VZxAJCM
         BauQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3XBRVEyRB+3uxwFnXBd8rwgyNc8WgQAzJgNKEqrTdm8=;
        b=uG/wWKsrpDf4uYv0tV3e1vDUTZKdvjtzpG1J45cdk5ZIeuVE0p4+aiUPTmz0csLis6
         7Da5YkHfUlltevqO8gjSDX9agfQS6yt5gs3hn8F/WF4c/lMzsquN9PWbgwiXYiadE4oB
         //clmQCIx6uo9DOD3i99ILu5YMKrQDba5MOOk7WL6WFo6Ujdqmb9EtKtAb2BBF+FkYuL
         izfYvw0rg0zWwm6zcFsEIWfFLSJ22ai/TJ2lYkUoPYEiWK8nIyiTU1OpqLo9u9dSfBWm
         IEoTTK0txRzko9PI+Ze0R+0YDDGOPw8qrk5CFzyO6z1hbSXvFs8FvMVvLrxcG2FTq0qt
         42qQ==
X-Gm-Message-State: AOAM530n1xkHHAKD1rTdXND5/zKfqDi8ZlGENMCtVo7M1QchCJGynis7
        +Z1COpvGVhKek/Gknk8i74tQZZ9e2Vo/N0wR
X-Google-Smtp-Source: ABdhPJyCsirvZ/YJS4idiZ21ZoRD80WTNgQ2Rp+d7Gc5iTA9O2IkNXdN8i8Ycp7sHW0zuqHi41Zr2A==
X-Received: by 2002:a63:e64b:: with SMTP id p11mr4887577pgj.10.1618516323557;
        Thu, 15 Apr 2021 12:52:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o23sm3159848pgm.74.2021.04.15.12.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 12:52:03 -0700 (PDT)
Message-ID: <60789963.1c69fb81.ae953.9555@mx.google.com>
Date:   Thu, 15 Apr 2021 12:52:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.30-25-g6d12651b9a74d
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 154 runs,
 1 regressions (v5.10.30-25-g6d12651b9a74d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 154 runs, 1 regressions (v5.10.30-25-g6d1265=
1b9a74d)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.30-25-g6d12651b9a74d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.30-25-g6d12651b9a74d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6d12651b9a74d8a93fd38a9f6aeae85e2c75536c =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6078616faec40787fcdac6db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.30-=
25-g6d12651b9a74d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.30-=
25-g6d12651b9a74d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6078616faec40787fcdac=
6dc
        failing since 3 days (last pass: v5.10.29-90-g9311ebab1b30e, first =
fail: v5.10.29-93-g05a9d4973d3b9) =

 =20
