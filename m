Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080DF3571F5
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 18:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344852AbhDGQOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 12:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354276AbhDGQOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 12:14:11 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02491C061756
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 09:14:02 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id d10so8583899pgf.12
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 09:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iDlD38WlT3v1IUIhEHd4LN9/9gms2Mh3RBnn+nRncEw=;
        b=LwoniVM6pGtdaNtas9GOBvKqjiTZiUfabG4wg5vdaG2mZZkcBcaIp8AsGusQt+b/Yp
         QI7Y3LZuGOTI5e1eUIVSYD8ThonEfeKq5cxRxfJM9JFSdahARzlKXDDEa7dR3kZgnQlJ
         /Hc4ARyLJ4QPBNfERHxG6aHG1WXxXxJi01RtiMTo+7a+lGfPeTzWGWXeOjTdxa27I2XH
         CtC/ToPEQ+RdpIpzMSrS0RRMklenzmcZETt33v0NAZUvJ0E9oJA5NO4uZBK9gtxbefQU
         69UpMU416H6xXKAOZU+jipxdXs0HpJJq6o6FoPJ7VJFP+7Coh1VwG1BSkUw1qQNukhIx
         cwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iDlD38WlT3v1IUIhEHd4LN9/9gms2Mh3RBnn+nRncEw=;
        b=pw5/3wrtN/iGLVXoJMEn2H2kUyusnIZAlIsZmMcLZdYdYRkaAFJ7Pv/cXWpk+toJKw
         wNAksfMr3nY/PDriM09KOwRfdD3aavuFhcN+8/jo28vSZtM9xmL2ZZkbEgIcLc2tquis
         DaJfNqHk7khJ8LaqUV+N4KIXS0SX1nz80uSnzzSsiIRLkBD3PSx5+04MYyYLvLehnNwC
         AHzxTENk3tc2mpQ9nVRvcEa+Z1m1vGwGKwJQH/VvgeQXbqbq5EhgK2xoWqXwkxX8y1Ro
         G4dAd+2ze6UXpQFVGXxfaI1exzwOkHn5vo1ddYlEc3jkGrFwYYG19EyU8nEIQCRPcaRw
         evoA==
X-Gm-Message-State: AOAM531WjmgXCLspKc8bhtbut1IL3vjwWgWoQceR6b7XS5VHJ8+kcdDe
        d6hJiXSCscbYgxZqOwHzfu7GEkZ1Wx7KNc41
X-Google-Smtp-Source: ABdhPJyoCaejVBS2wERgC495BIBqTGkfAiOnn57UwZHMjcGKeGFGHmtvziEBPbHHwdSs5QXXC+a0Rg==
X-Received: by 2002:a63:1202:: with SMTP id h2mr4104027pgl.35.1617812041285;
        Wed, 07 Apr 2021 09:14:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r16sm22367125pfq.211.2021.04.07.09.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 09:14:00 -0700 (PDT)
Message-ID: <606dda48.1c69fb81.aac6e.71b6@mx.google.com>
Date:   Wed, 07 Apr 2021 09:14:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.27-109-gba0af7445cc12
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 154 runs,
 1 regressions (v5.10.27-109-gba0af7445cc12)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 154 runs, 1 regressions (v5.10.27-109-gba0af=
7445cc12)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.27-109-gba0af7445cc12/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.27-109-gba0af7445cc12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ba0af7445cc1204ebe974411bad96bc6423e4d77 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/606da8cd96840104cfdac723

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
109-gba0af7445cc12/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.27-=
109-gba0af7445cc12/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606da8cd96840104cfdac=
724
        failing since 5 days (last pass: v5.10.27-36-g06b1e2d598020, first =
fail: v5.10.27-53-gcd7f2c515425) =

 =20
