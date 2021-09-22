Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7F24153BB
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 01:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238389AbhIVXIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 19:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238293AbhIVXIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 19:08:30 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4DAC061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 16:06:59 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t20so3140054pju.5
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 16:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K67zf4gKykSOXiGg554aTjt/aW82mWxlz3UbFACdkpc=;
        b=kZjQefeLYryDYoaBMDZm2Ewu4ltunsMtbNMePbpIx/klW4QGunpidx8mlz6q3T0X7V
         4wzg4Sa1jshLzQZ6wIpSzt3psB2/blf3Rwsuwnf4KXXkfnUfiIsitoB4RSn97Kr7tyBS
         yP9tlePmt0xzW8sp2bBFBMSmQKqiiU06PBPQhY/T7YOL3y/DfI7UU2iVUm+HEbC5+jD6
         1gEzrfSe+D3QHqh6YCqykL+8JYxQkYpLXlE8PPsCAlIS5w9UiouaJ9653tUkhOtCVLUl
         m6wRkJyhcPpsw74oZKBP8M3V3ojr83lKWr/MsUzpr/raNvibk3Zni92LoJbuhpX0T+Oe
         1YOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K67zf4gKykSOXiGg554aTjt/aW82mWxlz3UbFACdkpc=;
        b=U33dyFm5GdXzogsJL/dMnZK/s+eU324oAbtW000+M1GCcud4dXoZinLmWj2ceYfhdT
         b4+J1loU7HvhcM+pPna9HVM5hgfSAPYkzBby9RF/qSOtwyQIpLD2kMjzy4GB2gJp3Ip1
         /V3UuTKn+uZ7AiTl6teEleAEz7pf3k0gg4SSL0MMFN24AlxMHaRcwbs3YF2b8u+hd3z6
         Mlig+6dgEFLtOgIJZn4ECAmtBoTUDNxFWTnl9tS4qKSy/N/lt/wN4ZtirVMT0Rwkg12R
         0asEBMbaxeifqJrSWhsGRHmQwc5Ss9roWTtNgb9hZ+eFM2plS8q109ed/gl1VAj7nIkX
         xuDg==
X-Gm-Message-State: AOAM532Bew678ZSnVCAFsEhjVzaXPgHrxNpBSX4Zun7NKUtTajNlPySl
        pCwlx/dbG1eSpe9AzObes4grcMQLXLzWQhH7
X-Google-Smtp-Source: ABdhPJwpuyqBuNUxhWb8uaOsTvACwnFcqktFsKetPOEAGzGcPsqysg8qIESJWGdJtMdVmJMXKVhgCw==
X-Received: by 2002:a17:90a:8009:: with SMTP id b9mr1627739pjn.15.1632352019119;
        Wed, 22 Sep 2021 16:06:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1sm3467140pfc.53.2021.09.22.16.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 16:06:58 -0700 (PDT)
Message-ID: <614bb712.1c69fb81.d69c0.abb0@mx.google.com>
Date:   Wed, 22 Sep 2021 16:06:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.67-128-gad904e1e9645
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 135 runs,
 2 regressions (v5.10.67-128-gad904e1e9645)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 135 runs, 2 regressions (v5.10.67-128-gad904=
e1e9645)

Regressions Summary
-------------------

platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
hip07-d05  | arm64 | lab-collabora | gcc-8    | defconfig | 1          =

imx8mp-evk | arm64 | lab-nxp       | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.67-128-gad904e1e9645/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.67-128-gad904e1e9645
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad904e1e9645854b557894dcae85f646cd0cfa06 =



Test Regressions
---------------- =



platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
hip07-d05  | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/614b889b048142ef0b99a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.67-=
128-gad904e1e9645/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.67-=
128-gad904e1e9645/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b889b048142ef0b99a=
2f8
        failing since 83 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform   | arch  | lab           | compiler | defconfig | regressions
-----------+-------+---------------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp       | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/614b87bfec805dc17d99a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.67-=
128-gad904e1e9645/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.67-=
128-gad904e1e9645/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b87bfec805dc17d99a=
2fb
        failing since 0 day (last pass: v5.10.67-124-gd409bad9aec2, first f=
ail: v5.10.67-125-gcad917b556de) =

 =20
