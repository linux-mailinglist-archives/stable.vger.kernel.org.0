Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633403E0CA5
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 05:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhHEDCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 23:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhHEDCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 23:02:48 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FECC061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 20:02:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l19so6021621pjz.0
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 20:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DHk9cbsuWRxRSNVmVk+O4T8V8BDKby+nmuABmeLLbU0=;
        b=kZ8cAUDcNdbvC35gbFCjdlhxUn49pEIQZq4+fhTbj/jeYBEqlSvSwT4dGde/U8BJJv
         EzQLBqJniReal4p3u76YjnPCW42pDHZJk+m0d2Y5z9VnTWw5AWii6ecwj3rAuqmr8Obv
         ywAA2ALlfvoSZ0PE9y4c9KkEAJ2skHSLmvnfvtPj4svqtgFmu4Hw+j6xna6XJs9Osl0T
         umIZeMqfYwfpcFj11sWOpw5KhviQxBtQHPA6cRqoVn5lkGje4g24O35rk+K3Kh8qL8Ig
         9VLe/Q04u7oM3O1UTx+FvRLjZJMHdbEuloTfj8l9Bjyk/mkg/Q/YwWWDp/vwKnqyiMX7
         T0/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DHk9cbsuWRxRSNVmVk+O4T8V8BDKby+nmuABmeLLbU0=;
        b=UP4H9XWERhS8JQNXVBCoJrMvMWZXSpcBX5Q++K/FHx4CWmh//Dh62yd9j6O4w8ia46
         ayDI5NDybRvPulPYGwWMAIWpu4Qp+8T1YE+j82OQELN1WQLX3xlGt7BqiW/qG20OihtI
         YTPq8ub7zVv6Ofch75pMl9sw85kAbRL4HEomaCVJYbBhk78y+GCN1tMEu3v7za5W5ib8
         Fn15EE227MfGgBff6J1ZFk7XMTsX8W3RYqS+3cAJ57d4yy2G02BR/MEWVOwXyokFLk6B
         jTetlaHiA/IuH9F7KhQEygzPWkvoeMmX1qXY5empQfQa0K1J5iv4mrGWnObdY8LExovU
         uKGQ==
X-Gm-Message-State: AOAM532CfBQNYDLXYne/Gy5eHAcrwED98JHkysIdM4A2eQImiT+E3p4a
        vFJgRNKlnn4fMcGCamcH0J18A17bLaEUbdXA
X-Google-Smtp-Source: ABdhPJwxK8uYgf9DDnxHzcmWNLPzESAMxtSL2sgQ1ktPbKYtgycT9zb4gDLiCXk6RGAZ1qWBSvedig==
X-Received: by 2002:a17:902:a705:b029:12b:71be:d24e with SMTP id w5-20020a170902a705b029012b71bed24emr1982578plq.29.1628132554062;
        Wed, 04 Aug 2021 20:02:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j25sm4280266pfe.198.2021.08.04.20.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 20:02:33 -0700 (PDT)
Message-ID: <610b54c9.1c69fb81.54b18.deaa@mx.google.com>
Date:   Wed, 04 Aug 2021 20:02:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.278
X-Kernelci-Report-Type: test
Subject: stable/linux-4.4.y baseline: 51 runs, 4 regressions (v4.4.278)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 51 runs, 4 regressions (v4.4.278)

Regressions Summary
-------------------

platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.278/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.278
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      372cffad865ffc79132d858ab0526dd51f97b0c8 =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610b24fa19ca70fbe9b13675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.278/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.278/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b24fa19ca70fbe9b13=
676
        failing since 255 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610b1e97dd5a86e506b13669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.278/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.278/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b1e97dd5a86e506b13=
66a
        failing since 255 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610b24fbc521058aa4b13678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.278/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.278/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b24fbc521058aa4b13=
679
        failing since 255 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610b1e8a88e447ac95b1366d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.278/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.278/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b1e8a88e447ac95b13=
66e
        failing since 255 days (last pass: v4.4.243, first fail: v4.4.245) =

 =20
