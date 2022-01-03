Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AED482DAB
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 04:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiACDuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Jan 2022 22:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiACDuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Jan 2022 22:50:55 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3850DC061761
        for <stable@vger.kernel.org>; Sun,  2 Jan 2022 19:50:55 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id mj19so27849432pjb.3
        for <stable@vger.kernel.org>; Sun, 02 Jan 2022 19:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hlAdTTU4ILYUzqiGs0DzTfdEfNYc2kqLabM1bZFRnBM=;
        b=xveF+weZf0jx72aCUkqm/FXGqkjDRqRn5nMdH+qG7nDjPfO6eDV+GAKILawioPnLvZ
         lKh2KvceAf+IQGcZEwpb1JfN/h+gDoFwxdxWkG3YfC79t6XNQAk+GJrsIA/2Ako3QddG
         QyeKPJTHLTsgXEVho8dpBkfNzozKBNW0xbuPglvEm4DvRBsSb+j5IeCP1bHuFVkq4uBw
         IGJfoPB4xFsP+fVaBr7Dl1T3n6t+KG+9m4YCG1ys4QRjAB1Jy1fHSWRqcNnkYaRro5f6
         f0OkM/xc9fwN+x21Hk4RgyWIKDglDFgGKRVKgHAl48rPPvq30h1G3YXagTmblqHAKV5i
         Y0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hlAdTTU4ILYUzqiGs0DzTfdEfNYc2kqLabM1bZFRnBM=;
        b=qxbCUwdmWkZ2beVTeC4AEgxouBZkD/WPRZ131AnJSQQK6jsWr1oC7b05N2HIxS5g1X
         NCZvnD755SMJOhdZuZstXYKuUbkGLz76il/jRjfICX26upT65Iby7CT24m+yBCDHgKaD
         K8BXl8fnBBFJJGrO7NM6KD/bT5+Tdg3S9W8zL/GTsLS7VCgyka4QhBt0sn8bNQAD7k/Z
         D3XuXzK/NiQEz7kkPZLwgBMDIB8jcFNUNVNgyuCuNP189qOGPyjiaf0U7j4wnxF2WeF4
         +c4R+O9x/+E9dwJkQq9HRqRJJXZqBIZDAlvwJyQ1ebZpuVk7+i2iWPRU7FqqJT/Sn5Yj
         sCBg==
X-Gm-Message-State: AOAM530ha8bna+Hl9eDwPkNDo7yNynW34EJ69SpIUpUNWAmQecVE5PYn
        DfK+amUmw+jHYbg5qf7gX0mwRMoQXlJI78L+
X-Google-Smtp-Source: ABdhPJzIqPgI+fKj/qk/0EmXFGb6a7whPffxe9zWqqpxUrO0XX6Da1TuwcUqO3KviMA2rcryxCBcPg==
X-Received: by 2002:a17:903:3091:b0:148:ab3d:7d45 with SMTP id u17-20020a170903309100b00148ab3d7d45mr44174606plc.119.1641181854426;
        Sun, 02 Jan 2022 19:50:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c24sm20512932pgj.57.2022.01.02.19.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 19:50:54 -0800 (PST)
Message-ID: <61d2729e.1c69fb81.20b84.7e5c@mx.google.com>
Date:   Sun, 02 Jan 2022 19:50:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.260-9-gb7bb5018400c
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 144 runs,
 1 regressions (v4.14.260-9-gb7bb5018400c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 144 runs, 1 regressions (v4.14.260-9-gb7bb50=
18400c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.260-9-gb7bb5018400c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.260-9-gb7bb5018400c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b7bb5018400cd71cfb1bfe80aba967d47a961977 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d240a98d889f4436ef674f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.260=
-9-gb7bb5018400c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.260=
-9-gb7bb5018400c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d240a98d889f4=
436ef6752
        new failure (last pass: v4.14.260-5-g5ba2b1f2b4df)
        2 lines

    2022-01-03T00:17:30.958641  [   20.248718] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-03T00:17:31.000353  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2022-01-03T00:17:31.009833  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
