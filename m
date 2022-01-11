Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56ED248BABD
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 23:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346357AbiAKW0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 17:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244747AbiAKW0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 17:26:16 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94B7C061748
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 14:26:15 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id i7so186522plr.4
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 14:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/+Tp4jsbXFEXj6BEcykwbuv5eUVsq8eGGoNNYntWYBg=;
        b=ketxuk53CpXEZ7JsfN8f8CPNGW4JK7cy38X4t9D/+X77lBWREHjx/YF6sQ5yqjWxOt
         P3GZOUSIa8/htbCwI/3RJS/2e5+UnkqYiBW2ZcdoyODdOjn47MBBKwNfQFVlYOVIkMNM
         O2zHNktREzjr4zQWlj0KrKyta83Lxl1XmPU5vXaToeQ9Hcozvv0LSBLYWXhybIKTIc5L
         YanZKjSQpCgufk3Q2nqsyhiWO00SjikdrhhWjZKSiCPUPE5G1iirwbPTDtdJXEC9w9s6
         wLDpYp9R3kLAYafeyc00RI8xyDn7wouy8bQ21KUft7eaMRqHp0czFf7Q2hF7RmwkB4j/
         QrAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/+Tp4jsbXFEXj6BEcykwbuv5eUVsq8eGGoNNYntWYBg=;
        b=ePhPDrvPl7HBd6z9WJhTWR3rOI1C2nmeLtW6MNamE6qSrSydjBbi2k5kR0pfUfKMas
         d6Q2iliqiYCvGRHedYLgUbw+6YszhG4bGH6+UHheUoEHp8TpBu//zVSWirzIQW2Mee0o
         dRHrBZrOmcJ8ZLfc2QTE6ONVtYPToEPUdFOZhpSNjNSJPbA+YADuofmHWwxX/JDtlUTM
         m99q2p3+NV4apzqdl56eUXHAKGBbCcXzuSoZs6LHLAsJkhVJOqYf7WQXhK7IJSrGA14e
         qElzIpUmY0SAwuAHgy/w0vX7qPndv7fzN22/GM3rn5BxHimS80vFvZ69kLn50Af3/FRu
         RirQ==
X-Gm-Message-State: AOAM530vAQtIMUzCAz1YR3QbMtX5XWSUC2adKlbPYacH1hOhiYne4Ity
        Guwez+Ey5e0STrbsmHqCSulNZ6EENvHxZHYL
X-Google-Smtp-Source: ABdhPJwI7FfQPsvvtguVTNzljQENlb6b5tp2vfbBnTBzn7IPbEyaFdAKROkBqBBM+tZ1ZQm6YdwX7w==
X-Received: by 2002:a17:90a:d3c8:: with SMTP id d8mr5428182pjw.189.1641939975342;
        Tue, 11 Jan 2022 14:26:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mq12sm3840431pjb.48.2022.01.11.14.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 14:26:14 -0800 (PST)
Message-ID: <61de0406.1c69fb81.5cdfb.9ad1@mx.google.com>
Date:   Tue, 11 Jan 2022 14:26:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.297
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 116 runs, 1 regressions (v4.9.297)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 116 runs, 1 regressions (v4.9.297)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.297/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.297
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8d58193689d0deecd834a254892b4df49a723d54 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ddd0d5324522ea42ef674a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.297/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.297/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ddd0d5324522e=
a42ef674f
        failing since 28 days (last pass: v4.9.292, first fail: v4.9.293)
        2 lines

    2022-01-11T18:47:30.149963  [   20.485992] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-11T18:47:30.200190  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/124
    2022-01-11T18:47:30.209730  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
