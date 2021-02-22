Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1981C320EDA
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 02:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhBVBBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 20:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhBVBBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Feb 2021 20:01:08 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01B5C061786
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 17:00:28 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d13so6719747plg.0
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 17:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sU66KNZfnJQezu8SBw00ngBxeiOtvQIi5Q9fWpdAYRI=;
        b=b8ZcjjyHW4qAntRpMd1F3KxVdN2oKKcqz4ZGncPcBLSmukG/6kB8/IzSqm+02IRjmg
         8lNUAt4e27MOKa2PfjkTM+/FQvOIzqc/YY4mjMPp+cDfY4Opxe7XSbzGODtppdHE4Vav
         dXbztrYjEf7Dzfyex3MHm9Z0jMWbn4BglX8vHelwnXqJsxf1mdCVD43eq7+d0r7+yXVE
         NyJehEq84yE+U1mHOOdZBqoTeMpoZoYE6M2kqXpWxuFd6vlzpfcelgoyrQkqSEMzoGs9
         9QjVl4oOtmMa/GDkOjD24/oWmghRzf4ABpdmh+HtyKfF/CQpbeZF+bchye7R9bEayQ0Q
         Tewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sU66KNZfnJQezu8SBw00ngBxeiOtvQIi5Q9fWpdAYRI=;
        b=pXDSCJHki0GZMn+3YsLWiH+CB9Rh8z5hMFsvIs2j8fd5jIKmDBmCstgcI9yJ9whIj1
         ulb0VEQf/IwIhr88lrqXQ7J06uoz4xbOER+xOvDgaJqmN+Cbg1vtS0ge+dvL8Fj0rtPC
         w+Cn2SMyHgKBAHUFqOolYC0KmlQ3MLZf+LRA6rt2xidfPFiAcHFux1Kmt9ICjNcFVJEv
         Ckg7llRZuPLNGUbh7io1bdTL445szzvNHGYZIuZQuI/GTrRdFYT4Sf0O/58jv8TcF6PG
         83uzxbSTJE+UT533dyImwBpjWhs4/rueVBiw9GkuocTva1R8I7dqNrxS83UPeHZv7xeX
         nnvw==
X-Gm-Message-State: AOAM531dWsYv8wDagJlbyEZeAimz3OrbRJuLvw1ezHo7qKLIO+DPncwp
        RXmcV1Cb0RbD7oNYaGgcri5j2b8K3H4rKQ==
X-Google-Smtp-Source: ABdhPJxR9DoJCIxy839aOreRCRrxWL3nNh/E/Rhn/906VVLLuOWULMVqNf3LOruP0FiQHcBNlUmz+w==
X-Received: by 2002:a17:902:b68a:b029:e3:29cf:3f22 with SMTP id c10-20020a170902b68ab02900e329cf3f22mr19604405pls.78.1613955627996;
        Sun, 21 Feb 2021 17:00:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm15432143pgz.22.2021.02.21.17.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 17:00:27 -0800 (PST)
Message-ID: <6033022b.1c69fb81.102a5.225e@mx.google.com>
Date:   Sun, 21 Feb 2021 17:00:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.17-6-gdabb1ab93ab7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 111 runs,
 2 regressions (v5.10.17-6-gdabb1ab93ab7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 111 runs, 2 regressions (v5.10.17-6-gdabb1ab=
93ab7)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =

imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.17-6-gdabb1ab93ab7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.17-6-gdabb1ab93ab7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dabb1ab93ab7a996cd7a3807d9278cce01c1cb21 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6032cd9cdb26a10f1caddcb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
6-gdabb1ab93ab7/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
6-gdabb1ab93ab7/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6032cd9cdb26a10f1cadd=
cb7
        new failure (last pass: v5.10.17-6-g4794fa0c53317) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6032cd659490a9cbb8addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
6-gdabb1ab93ab7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
6-gdabb1ab93ab7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6032cd659490a9cbb8add=
cb2
        failing since 2 days (last pass: v5.10.17-5-gdb4f9910056b7, first f=
ail: v5.10.17-6-g4794fa0c53317) =

 =20
