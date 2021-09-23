Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFB34166C5
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 22:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243065AbhIWUfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 16:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242529AbhIWUfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 16:35:30 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77129C061574
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 13:33:58 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso5723002pjb.3
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 13:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WMbZVag0mu7eTMrDEuhOnNX2mX3H8Gj+zvB2p+IY5ao=;
        b=ooheeVRRU9I0/NfDGc3liXkrzqJwA1vThZmzT7aQiUSzjwDgqufjgrLfoVDnrH4lsY
         CX7Oyxt48DxS4Zpb086IeLIbtTzTC8YhCPW3risruY0+WNqeXT/tUDBo3X+/yO4aowYK
         xh0/xnQ3c9VrTC5DReskUqyjvdXmUS0/2OADoMb6cnCjKBdlQvUd/VH+QQ16brI5sGfX
         qm9e8Ur14iYSV2q6qdsCMBV5fnJh1fikrrPniuZ+gNS48lrAMnJZuBsUUNZBMmJczTI4
         eQoJ6UXO7qSZHu7quma83wptCE5a3MKvDvvv7ZA7IpNcfWAGpvQZAboj3WQJ3nlDWiCQ
         J3GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WMbZVag0mu7eTMrDEuhOnNX2mX3H8Gj+zvB2p+IY5ao=;
        b=mNUNrmuulFEMUSwcb5xsDunKSg28sl9gvm/frYSeM+GtiVQnT07MqEphA6+V5kYYdq
         /M6abt4sTL3E4b8oxFrGIFEk+KGK7uI6IvNkqODoADIuRR3fUwE8WiZXUwWf7FBgi+Ps
         eT467XdVJlGGoIDWj2JqsRSS9IYEp9wROJwLwQMafmICzuq0y3yqWH6AACEWYsdE7olb
         jAyVoZD7qoCw6QHH2KVq+mfQHy32cIpxeP6/n7evaT77w4Liql1mpWWnfeCqLncWFe2C
         zko+paViLM9Nu1WwDmVbB2TA6JjD4p7Wm9u1AalY4OyTJ62sx2yXIbR+pUEkR8mXiGmw
         9QWg==
X-Gm-Message-State: AOAM533qEOfeDbPp9v2rGWlU87/Bphp6+ZHnHFQd63OrqF9X8vbv4iqE
        L9p6ezpSqlyQv3YTGe/+2wtvrE41sACpaueI
X-Google-Smtp-Source: ABdhPJzMuhpBgd6A4cRvMIC5cOuFsLbBEnv5fn+v/AAzCKJiYOOV0lB8UNX+JUovoxFquc+7mAAS1g==
X-Received: by 2002:a17:90b:2015:: with SMTP id hs21mr7607914pjb.200.1632429237884;
        Thu, 23 Sep 2021 13:33:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x8sm6512223pfq.131.2021.09.23.13.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 13:33:57 -0700 (PDT)
Message-ID: <614ce4b5.1c69fb81.da36d.3f76@mx.google.com>
Date:   Thu, 23 Sep 2021 13:33:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.283-8-g5d0e7eac2915
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 70 runs,
 3 regressions (v4.9.283-8-g5d0e7eac2915)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 70 runs, 3 regressions (v4.9.283-8-g5d0e7eac2=
915)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.283-8-g5d0e7eac2915/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.283-8-g5d0e7eac2915
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5d0e7eac2915c35a66b52de769a3a2bc2b663b3a =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614cae8373fd2620c999a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-8=
-g5d0e7eac2915/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-8=
-g5d0e7eac2915/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614cae8373fd2620c999a=
2e1
        failing since 313 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614ce124cdadec9c1499a32e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-8=
-g5d0e7eac2915/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-8=
-g5d0e7eac2915/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614ce124cdadec9c1499a=
32f
        failing since 313 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614cac92a3927119ef99a30a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-8=
-g5d0e7eac2915/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-8=
-g5d0e7eac2915/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614cac92a3927119ef99a=
30b
        failing since 313 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
