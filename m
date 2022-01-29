Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839CE4A307F
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 17:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352069AbiA2QTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 11:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242424AbiA2QTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 11:19:41 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42B5C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 08:19:41 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id q63so9450374pja.1
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 08:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NTsUACP6DclBIgKnkUVPdxAhQrd94S/2hxbGAbkINe0=;
        b=z7R9pxqepFwv19s6JVLrCu3cUC8t2U3Cyy3hGEecExpHfL7Z+TFqSo2D4JVV7BDabY
         q3sJ8znsCgGyE6NKZ5ysTn7ZPj1VfiimwccXyxqK5EX+LVozQfaJgV7faHKGGJsBsZ/z
         +F8ggYSVNiyrh2KaDM3u7awSEoMWsxOM6AZnPBYAu4nujZROyZUZCGsvBXw7HCeykJwp
         tlFSPsPs0bG0k+EGn8Tc3VL9pXAzihK0jLu4NQ+sX5MzD0juphEOfE+h5kTrk37Q/fSG
         C2vmRYzBjpu4ChbBC9mIIEPds2cDoAjwG1M1oUILLt8vEGF6OSkv/I0AZ+CHvujoPcMJ
         UYGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NTsUACP6DclBIgKnkUVPdxAhQrd94S/2hxbGAbkINe0=;
        b=s5OWeIWCWI2kUnu9EyUEuMk1Ffn9iZ4oCYS/47vfy5V1p/oaIQLQm+DHrfKlwucgWY
         cfCgA9WuybQeMas/BPoOHL5dzctiHXRgyljeIGCMdI10Z1H7r1GzSyhSaAkqID6BaNHk
         w+0tiDqRVmk4qt0cw1SQt/8NOSpNujY5cRPgeE4jZuRXjipQj+uqlq9bFDSrEa3VFFVL
         3e8N9Rh+ljVv+d/qQjApoc2jNnVW1XjllxtaNXQ3ar6XuWwt1HSz1jYovgqyNcxBYH3+
         OO7SU8BlW9fJnS1Ciy5BuEoq+w699AQCUCmw4gO9ksmgzSZiZE6vZN0P5qnyqmMe+che
         WbaA==
X-Gm-Message-State: AOAM5306cD/bRIXyIQo95f+I27WX+0HED4QbyTstI2SDUgyKWU2ggs3x
        bRIpq4fhSdWbiGGPbtAosQmfDzLHmOgDRi+o
X-Google-Smtp-Source: ABdhPJyrs6xoQqt01Kkns1n6fXsA0p+wQ7DgsBhdADgsSRhVMVu+m1J3/dLhnbtrTfluB0HYOEEwrQ==
X-Received: by 2002:a17:902:eacc:: with SMTP id p12mr13552003pld.123.1643473180718;
        Sat, 29 Jan 2022 08:19:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q9sm5907937pjm.20.2022.01.29.08.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 08:19:40 -0800 (PST)
Message-ID: <61f5691c.1c69fb81.2ef5c.f917@mx.google.com>
Date:   Sat, 29 Jan 2022 08:19:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.264
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 104 runs, 1 regressions (v4.14.264)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 104 runs, 1 regressions (v4.14.264)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.264/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.264
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b86ee2b7ae42b6b37a918b66236608e2cc325f59 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f5351f7b3962a73dabbd17

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.264/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.264/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f5351f7b3962a=
73dabbd1d
        failing since 46 days (last pass: v4.14.257, first fail: v4.14.258)
        2 lines

    2022-01-29T12:37:28.824122  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2022-01-29T12:37:28.833446  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
