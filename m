Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921D145E008
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 18:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347801AbhKYR4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 12:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354431AbhKYRyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 12:54:41 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F94C0619E9
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 09:40:41 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 28so5859621pgq.8
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 09:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dBGECCbLsTi3roxUAZ9rN3qmke+SOvlUesKJYuScNiQ=;
        b=sm8BmQ0SEg4yjjb1SI9GDn9Ot+8vx5by6ODYM4XgGC6jmP0hEAEWlzs6zeklwXshB5
         VPa7lGmVvZpBGOft/moF/gK2T5KnHU1WGGp1/vQt83kUUyYWcuyfUib6bVxhZVj/H0+X
         2IekHd88LSc9VFxXqyXVvKFNHkz5qYZu9cnfVcprEy0vq/El/g0bRfrH+o4s/g0U1RBl
         dodXBjM0HExyQyn6gd/cWA8dwPAVmSV70TyqLGRix+4IFXVC04XzXLLXTFWk7f9MK8if
         c8/mK+ztIc4z4eR76kQRdTJmFjNBYgD+xK0RHNLgcM2kuefEY3VXaN/YxFI7V/6mxeUb
         HI+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dBGECCbLsTi3roxUAZ9rN3qmke+SOvlUesKJYuScNiQ=;
        b=yHJJFBPdpt1uLxKxlmPUMAQernWmVgXuLgVGobpIBekAn88gid4z2KX/9zLAgHkYe2
         Cb0Mu2upBrpbNzzaK8wp5GdDX9kUxGyt3zeJCDutp+YaSN/iy3RnExqx26NC5kWIZ344
         W29Lv7m1O9yMG0IuWmiCi7PzYyHgoldWLIB/rVsRdTFZuCCX3tzJeSbBuJ5Vwna3w+fv
         G4EqzS7muVuE2VpLYU5yvo1iLqaaBZRiRKhbe0/H2aMD3m9j94FvMQj+TpGa4ObK0d5Y
         hyk0l7CIRLZj2fo4VDgLK58uHLV5Na6bj48AKOxMIHGg3r5qmX6kPlNIJhf10DvkscAO
         r1NA==
X-Gm-Message-State: AOAM531MNdcuSTkpMCkyEAJ/YeZeLfCHeOnr+5DxX51H/cjopeZ7Ja6T
        Kwf3JfzlLaBbZmcqAGeG43Hp44ixQsx61MVSkx0=
X-Google-Smtp-Source: ABdhPJxwmnovet0H6qk44TQU3D/H/+GRujbvuof520eqtjZ++lN0lf19PgULA25OVod5w85dSo+68w==
X-Received: by 2002:a05:6a00:1396:b0:4a4:ca76:bc0f with SMTP id t22-20020a056a00139600b004a4ca76bc0fmr15204019pfg.5.1637862040698;
        Thu, 25 Nov 2021 09:40:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t4sm4304709pfq.163.2021.11.25.09.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 09:40:40 -0800 (PST)
Message-ID: <619fca98.1c69fb81.8f60.b2d2@mx.google.com>
Date:   Thu, 25 Nov 2021 09:40:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290-206-ga3cd15a38615
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 92 runs,
 2 regressions (v4.9.290-206-ga3cd15a38615)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 92 runs, 2 regressions (v4.9.290-206-ga3cd15a=
38615)

Regressions Summary
-------------------

platform | arch   | lab           | compiler | defconfig           | regres=
sions
---------+--------+---------------+----------+---------------------+-------=
-----
d2500cc  | x86_64 | lab-clabbe    | gcc-10   | x86_64_defconfig    | 1     =
     =

panda    | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-206-ga3cd15a38615/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-206-ga3cd15a38615
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a3cd15a3861534cb854e73e391607c81b4e7c0e0 =



Test Regressions
---------------- =



platform | arch   | lab           | compiler | defconfig           | regres=
sions
---------+--------+---------------+----------+---------------------+-------=
-----
d2500cc  | x86_64 | lab-clabbe    | gcc-10   | x86_64_defconfig    | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/619f90bd4b1206790af2ef9f

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
06-ga3cd15a38615/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
06-ga3cd15a38615/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619f90bd4b12067=
90af2efa4
        new failure (last pass: v4.9.290-204-g18a1d655aad4b)
        1 lines

    2021-11-25T13:33:40.280327  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-11-25T13:33:40.291777  [   13.322978] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2021-11-25T13:33:40.292178  + set +x   =

 =



platform | arch   | lab           | compiler | defconfig           | regres=
sions
---------+--------+---------------+----------+---------------------+-------=
-----
panda    | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/619f928df32e634efff2f00a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
06-ga3cd15a38615/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
06-ga3cd15a38615/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619f928df32e634=
efff2f00d
        new failure (last pass: v4.9.290-204-g18a1d655aad4b)
        2 lines

    2021-11-25T13:41:12.640107  [   19.986541] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T13:41:12.685294  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/129
    2021-11-25T13:41:12.694454  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
