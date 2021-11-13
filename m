Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B7644F42B
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 17:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbhKMQiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 11:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhKMQiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 11:38:15 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408F9C061766
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 08:35:23 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so176217pjb.2
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 08:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hJwidXHX+QSvGU7LgA4BhKfYQSxvUozz3OXW6N31O6M=;
        b=inEo2qtGOQvapmBc77jLJ3olJr3+pTQmpWW6YB+EV0r4CjxxlnKlP45d8nTNAVqn3b
         F6qjYyhWS7Xr85la/f4nB4ARxha+GLtEOuJzIKm1Ei+Jm3LEERj/0bG7eFsL56ncKVs3
         dIm8CjY2lI996+shx5bRqWydDE3I63NFOMDjpfCCa7JdgMNFWy2JxLfFlL0m2/RQGPy3
         XdU7GTga21lJwpvLuA04Rn4PALKFCRSdw9/v8gR1ueTYaf3AVl/QLI5kLvM+iT2owR/d
         P7tN4mf943OkglJwAJejXVRzlf7l/9wpSX22FGZB7FcBftFw4pfKNxFm7pgZ1oEwXK+c
         Tm0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hJwidXHX+QSvGU7LgA4BhKfYQSxvUozz3OXW6N31O6M=;
        b=gZWBGLheOR54HI7zyvnMlfgWlP6AKDj3P087LQ6DmhDWMHxt0qGg+NyAUdVIwhZpwW
         TI4sd0dMqIiKVfU7erw/W6qbaMgNA0CWurDW3+MCoRcJlaC7/T63z0nKAizjej9HY8Tb
         lG5AHOG0/b0J0mtJTR129NdJZhfEA8hKBb+rtLsOsUIn222RbSG5NPMHgvQbtLUvM9yO
         ImZai5HuxGiIGRbQw9jbOTJ3nq+DiizwRClQVYRijzAHnuJtd2ZobyE/hP3eVskzG/EV
         guiIwqnZrz3Zk/LfmmsDwKVVDeq8sBLIt0ogB+zAhXHdRjwKjVzfmzzX6c1X9UqVaoov
         dERQ==
X-Gm-Message-State: AOAM533w+uWpvDvr97ZkybGCc1kIPuY2TDjrqhRFrA+EP3YRWTheass4
        HZzg4ZJuGArLuJde7+5PRxxbMFyfEPQQUhYH
X-Google-Smtp-Source: ABdhPJzIB6bPj2O6qePAb0iiigfhXNT+K9HjAGmU1nkFVzBsRE5MzjUxyTOHddpG0DF8My+M+v39Ng==
X-Received: by 2002:a17:902:b941:b0:143:ae25:ba1a with SMTP id h1-20020a170902b94100b00143ae25ba1amr11461944pls.66.1636821322696;
        Sat, 13 Nov 2021 08:35:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ls14sm14427066pjb.49.2021.11.13.08.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 08:35:22 -0800 (PST)
Message-ID: <618fe94a.1c69fb81.f00f6.950e@mx.google.com>
Date:   Sat, 13 Nov 2021 08:35:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.217
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 181 runs, 1 regressions (v4.19.217)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 181 runs, 1 regressions (v4.19.217)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.217/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.217
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd8250304dd51bc2c8674af65c102dd8463ee88b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618fb259091576e1613358ec

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
17/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618fb259091576e=
1613358ef
        new failure (last pass: v4.19.216-17-gf1ca790424bd)
        2 lines

    2021-11-13T12:40:38.615437  <8>[   22.011383] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-13T12:40:38.664089  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, syslogd/82
    2021-11-13T12:40:38.670139  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
