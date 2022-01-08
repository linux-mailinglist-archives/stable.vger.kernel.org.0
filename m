Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AEC48868F
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 23:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbiAHWBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 17:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiAHWBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 17:01:44 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4186BC06173F
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 14:01:44 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id s15so8746775plg.12
        for <stable@vger.kernel.org>; Sat, 08 Jan 2022 14:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VDLzLJnzSiq8YfMRjC2NIdRRvE0hJhUPLQTIwF0QShA=;
        b=XD06+ASClXqkLuMYd4E1ljGleUNagse8aoHpsBF9O1Rd/5fcbNn1e8CutAJGCCKPxV
         /0/8c62ag6B3ji6RlNpJjAFcaJCC2IQsUlwDXrANJtiC30In4//esk/GdaQbGhpZmkt1
         vqyvx4QZueggIOQSzKywuXjQbXXwtMTBg2DXYfpOznTdD38saD9lkCvxlcPc7sDMlhm5
         C2cTYW5GvL4I5CL0eZgAwhc4K56pwejrj/TRMiI22nBmh2Bl21Thj3gvUlAOqiL00UdD
         +He/lGoMZsY60MUx5OndF/dKLw21LdmV+nVvfw94PHsVhGuw9MndrwAjEupO2wjJRtMF
         B7Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VDLzLJnzSiq8YfMRjC2NIdRRvE0hJhUPLQTIwF0QShA=;
        b=kGxuVNcrtdllxbBMAFBZlb+UddpgoLFEFwLbPZ3rQnL8oC/NFmjDFc44Keii35rhv4
         NpPVeai2GzqA1bcAjV1DeoGKcxA7ryIHL8DCzd97wX1okPB3UfAATe+iqFC0yBWlGMNp
         yOn1+KcKzU78ObhZcSVqSuJUhmyLJd4m6nZt98oXCdNVmmjjd7TxFH7vSDdrNg63ejNY
         +Gv+6lJvrYCEER+3ZFB55iFZwhQzlimXMPY15D5hWZwiCjAq9yX2z9WvvcsnwB7F50C/
         Az8oGp17FNiVnDzONWSjF4cltE/sPoNNG+3DcsQOXIYQUHAgf3gf5cVh6PnF2DeYBnTh
         YbJw==
X-Gm-Message-State: AOAM530/RMuxg/XKunwq2hZfwBY7alTFimc4uZeZVg8PG8fygUu5Wacy
        +5ST0Hm0f8Ra5bGbB6jxma0LNu2CG6sOOXPw
X-Google-Smtp-Source: ABdhPJypE6fyBREb3wJNO/zJo/DdZfL19+uwSW71u3JBMMfKiux6cPO/IX7g6O1PCyQnmS0JwFRTxw==
X-Received: by 2002:a05:6a00:174b:b0:4ba:c9f4:d4ee with SMTP id j11-20020a056a00174b00b004bac9f4d4eemr70255384pfc.3.1641679303530;
        Sat, 08 Jan 2022 14:01:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o11sm2897190pfu.150.2022.01.08.14.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 14:01:43 -0800 (PST)
Message-ID: <61da09c7.1c69fb81.fa286.6eb0@mx.google.com>
Date:   Sat, 08 Jan 2022 14:01:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.224-10-g09145260dc76
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 114 runs,
 1 regressions (v4.19.224-10-g09145260dc76)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 114 runs, 1 regressions (v4.19.224-10-g09145=
260dc76)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.224-10-g09145260dc76/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.224-10-g09145260dc76
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      09145260dc767c558401c897759e7f2b51f3e84d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d9d49f4be3f19e49ef678c

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-10-g09145260dc76/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-10-g09145260dc76/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d9d49f4be3f19=
e49ef678f
        failing since 4 days (last pass: v4.19.223-16-ge86e6ad8a5c1, first =
fail: v4.19.223-27-g939eabea13d4)
        2 lines

    2022-01-08T18:14:40.570635  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2022-01-08T18:14:40.583169  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
