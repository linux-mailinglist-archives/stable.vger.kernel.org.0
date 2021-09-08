Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C948403FDE
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 21:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350811AbhIHThM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 15:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350585AbhIHThL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 15:37:11 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E25FC061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 12:36:03 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q68so3692151pga.9
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 12:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nMNyJVbPdSGIcfFFM/tu99YPgg5CNt+ZlpGuC2kOPv8=;
        b=kq4YQ4yXoiQ4ngyYx3qoz41rYlhxIRX2M0eb7BL9W08/clEeQ6+GeQOECgmjb3lL7a
         WEsEdQmP0dybLl+PV2KXZjXUee3C36AR5q+gmYFqkkP17X76m+l1LyHHzBZEmn6mOMFS
         RX5PnUNi39nZYpIVhqCQP+SYiWNKM9YQte8rQfQrIeJIUGnHrS6H4k+qBPuhyyXav266
         B66Uh4Q3eVtre7Hsl72mqxE2oNddM8GFqANxTomFQRHqvNUsw6K+M0MUqV+ZxD8gQa37
         WrGQ89BOynNf3Fmpt3ENupv9mnBj7Y/7hCU9zFzrKtiXTGG9sXpPkmNlLiavanWh3vEo
         7k8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nMNyJVbPdSGIcfFFM/tu99YPgg5CNt+ZlpGuC2kOPv8=;
        b=AVMGMYkd00ckgKn9Kg/3b5g44dnS4jhB/18bX7Qh+1EqFylCBhwDuNJrNzrkRBcZ6j
         ye3CFMaBng6+4bRnnsv6jHhCXSl3lS8bMLrtMuE8prNScKYchYwNNOKBwvyaZUNXK3JK
         sMqwSJVbzIRgIr6ZIYTLp8ck/ABpt51Z0xGvi5WXGmqgHc+4DVgznfIn60nrUrCkNTLN
         FO2rZ+0BhQMpJS53kwi0o/gsrqaEdzad72A73n03WzIOY1VIt68CAGZCt9dE9gQVEklI
         u1T7b4/uavfSNDlPBtidkdkHH4rtVyjXHlU6y+qwTg8B/CJ0t5FQe3JDllN0B/P4cGmf
         B/2Q==
X-Gm-Message-State: AOAM531MxzDSjCC8G9PPQ7y2eaYNJpBj8mQGJCnWFaPO0JJa5AoxCojJ
        qgzApa5r1h8WvC7Vtgo5dLk5FQXz6f8jvTJb
X-Google-Smtp-Source: ABdhPJzUItxpQxLUdiSQWSg1lsswEUrIO4vF9Qwhu7npGg7jW4/VZUxmEIZ/KrZSZFK0mUl55EFr7A==
X-Received: by 2002:aa7:8d46:0:b029:3cd:c2fd:fea5 with SMTP id s6-20020aa78d460000b02903cdc2fdfea5mr5431087pfe.31.1631129762221;
        Wed, 08 Sep 2021 12:36:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 77sm21403pfz.118.2021.09.08.12.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 12:36:01 -0700 (PDT)
Message-ID: <613910a1.1c69fb81.f3737.01f6@mx.google.com>
Date:   Wed, 08 Sep 2021 12:36:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.15-4-g89710d87b229
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 202 runs,
 2 regressions (v5.13.15-4-g89710d87b229)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 202 runs, 2 regressions (v5.13.15-4-g89710d8=
7b229)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig          | regress=
ions
-----------+-------+--------------+----------+--------------------+--------=
----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1      =
    =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig          | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.15-4-g89710d87b229/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.15-4-g89710d87b229
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      89710d87b2295087737d4aa8b890ec9f847db993 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig          | regress=
ions
-----------+-------+--------------+----------+--------------------+--------=
----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6138defee9f11ebfadd5968e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
4-g89710d87b229/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
4-g89710d87b229/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138defee9f11ebfadd59=
68f
        failing since 0 day (last pass: v5.13.14-26-g85969f8cfd76, first fa=
il: v5.13.15-3-g247080319c1b) =

 =



platform   | arch  | lab          | compiler | defconfig          | regress=
ions
-----------+-------+--------------+----------+--------------------+--------=
----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig          | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6138e0abab21056a25d59672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
4-g89710d87b229/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
4-g89710d87b229/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138e0abab21056a25d59=
673
        failing since 0 day (last pass: v5.13.14-24-gff358fe92fee, first fa=
il: v5.13.14-26-g85969f8cfd76) =

 =20
