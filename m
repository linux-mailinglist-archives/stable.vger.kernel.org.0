Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0D24A913D
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 00:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244278AbiBCXi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 18:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiBCXi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 18:38:27 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF824C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 15:38:26 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y17so3596583plg.7
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 15:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=id07sJN0ydbT/yk7AemsOF2HRPY/xYI6uOutK18ycgc=;
        b=CxCsB2CTB3PutV9HAnxYELWGABcET3bCK1ui5v4YTDFoyp/38OBCkftHTP/0BFolv6
         +a+kx2nOqDKXMtIEq7XbRUfV6SLwSheYOm7x0QpHgKV0ircke71PSYUYGq1zdwbe5L6K
         0I3U2W6tLAdiqDUGRQcCcM1ks39mhS0T8ORdMtrC2jro0oBJE9RIuNsj5RzFMDqLJoRg
         FX4iBWxzRMBcQ9RvSGux+KCxRT3WPfTIjumM5gPE+VeCQz+rKmtgujDjOTCH1VF9+ffg
         ESBTT9BbNgnHGSJ1VLqldJvLjVX1lsfdqNfFcEULvx8GhCSU6+OMm8H0rPjdOA+Anyk9
         u8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=id07sJN0ydbT/yk7AemsOF2HRPY/xYI6uOutK18ycgc=;
        b=CTz8nJo8a6FFZT1XEwqM/hNqyXTdOXYP9fE8ww8N9SUQanozqNoR8S+Xm7z/z8eWkS
         zDbjXEr64lEZgcNlILJrM8v1LNAdacARrozMiYimAqts6untSwNdwVmPXrl2N30aF9Uq
         vsMDeaW8x9WBTgECzLyv4EKWzEASkjc589LY+HQbrb94VN4CepylitqUU/8gsw5uZQiL
         8AkFoPX1yNK6Hgu+KUJ6wui6yNLWtEZ0sZFthIGRzSQ0FuHOQusDr+9k8RuUF0JpisAE
         z3pUTT+szfudTJjBi+hCRiRxS2q+s1HfPsFbllh9b4l9WYqjLx79p1dZdcOIhJXARoPI
         S5DA==
X-Gm-Message-State: AOAM5334rxWwSky+qT7cp/iGFNAxz4hxkPap3sG1rq4lryF3uwQ0T1Oq
        412IiS762mKjvlCU6h+/43sN0RF1rkQj6+So
X-Google-Smtp-Source: ABdhPJyMaD2y7oIuYqzTIhj5tPp4vVw8S4lOQu/BpkHlkGYRAUIlhk2qqmDlojI7nxd1EJ9fGlen0A==
X-Received: by 2002:a17:903:2310:: with SMTP id d16mr329648plh.20.1643931506201;
        Thu, 03 Feb 2022 15:38:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k13sm112679pfc.176.2022.02.03.15.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 15:38:25 -0800 (PST)
Message-ID: <61fc6771.1c69fb81.27356.086f@mx.google.com>
Date:   Thu, 03 Feb 2022 15:38:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.227-48-g5372ecaaa6cf
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 113 runs,
 1 regressions (v4.19.227-48-g5372ecaaa6cf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 113 runs, 1 regressions (v4.19.227-48-g5372e=
caaa6cf)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.227-48-g5372ecaaa6cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.227-48-g5372ecaaa6cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5372ecaaa6cfa9c843ad0979d6e927cdfbae2ec4 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61fc3166a2a6f191e05d6f03

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-48-g5372ecaaa6cf/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-48-g5372ecaaa6cf/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fc3166a2a6f19=
1e05d6f09
        failing since 1 day (last pass: v4.19.227-45-g1749fce68f74, first f=
ail: v4.19.227-45-g388e07a2599d)
        2 lines

    2022-02-03T19:47:30.955184  <8>[   21.146789] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-03T19:47:30.999283  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/111
    2022-02-03T19:47:31.008544  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
