Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F71C355F18
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 00:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344293AbhDFWvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 18:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344418AbhDFWv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 18:51:27 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0740C061762
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 15:51:18 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id l76so11516410pga.6
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 15:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DyRvV0lIlVIbA4m1ZYei8geHpYP0Fc/UF27vdE6xSDQ=;
        b=zwWCjBOgUPATZa5lEL5EidaQo27cp1NOBfNoKjcEeDo0ZRHL0JhdyRicmlS3Y4MklS
         S/q0bf/2zDDMNl5BGwGVWErRqTiqq0eq+2UAAM+ZysBXgnqzz+B4ckDB8Kg5OOsPXy8X
         lc4fUtiaAB8YzsNI4T6LTgkPtiKdpGm7P5tAJZx9WO0vkuwYHQUAPJ9hJiH2SIB09FGZ
         zKfyE8kfUIonP60zv9af52s+co6L6U8AAFOtZwNOOvgocLjpMSXZ1XrIoE3m2cYrP5W0
         DhjaFwGzXAyjpl6brUfROS1AmpH1U70WYrAfdhWHaepG6Jeihm7xFjWFJDO0+U45Y7Hj
         L29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DyRvV0lIlVIbA4m1ZYei8geHpYP0Fc/UF27vdE6xSDQ=;
        b=t1jlDwzRjdGKqRMh2FxwO3R89XPkKkpSosyiJfulcpgOPngiSgV3JWBqF/KWET4jJD
         dIR4U1rjlVveEz7/HAYcQR7eLOAVn4eFhvU8lCBZzm++NwxE22VE59S9GW3xPfeQM4A1
         S+zF5nOCmdM1QiIh76lFDfFVzr35pYC4/ADgPLNrO82U1s/B8ZHJPkf6whzMAi80yFK+
         3JjVPRYV+8fi8fCkP/DpA4Se6FKJRFp3I3PVOFJGAT6VgVqGszKa/quOxsJb6hayEk5H
         sosC7qv35xetaEzhRQ0wWjwfyjl49VmUAilKqEJt/wFFWIomJZsmPJa9aLOtMeG4UOjI
         6wVg==
X-Gm-Message-State: AOAM531suaOCm7elnQYiUak9vJk9uolqEf2ImRb75mEIOahuVadvM/Qi
        3DjAfFgzAZE+mLbajhuM7tXskDb92NWNDQ==
X-Google-Smtp-Source: ABdhPJx4uBSKqTstPBp9h1cX1Gj+hW4M5GIFlJ1OWB8U29x8qfeZslLswXlwvCUg7dvTqk7fe14RCw==
X-Received: by 2002:a05:6a00:15c4:b029:204:33ea:ced0 with SMTP id o4-20020a056a0015c4b029020433eaced0mr346642pfu.20.1617749478374;
        Tue, 06 Apr 2021 15:51:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f135sm19408074pfa.102.2021.04.06.15.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 15:51:18 -0700 (PDT)
Message-ID: <606ce5e6.1c69fb81.15357.18a5@mx.google.com>
Date:   Tue, 06 Apr 2021 15:51:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.27-126-gae5ffd885a4f6
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 122 runs,
 1 regressions (v5.10.27-126-gae5ffd885a4f6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 122 runs, 1 regressions (v5.10.27-126-gae5ff=
d885a4f6)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.27-126-gae5ffd885a4f6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.27-126-gae5ffd885a4f6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae5ffd885a4f63d5aecbc14080dfffcb63cc4131 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606cb0aa1103a23030dac6ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
126-gae5ffd885a4f6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
126-gae5ffd885a4f6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606cb0aa1103a23030dac=
6cf
        failing since 4 days (last pass: v5.10.27-36-g06b1e2d598020, first =
fail: v5.10.27-53-gcd7f2c515425) =

 =20
