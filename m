Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34393445BB0
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 22:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhKDVfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 17:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbhKDVfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 17:35:21 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A6CC061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 14:32:42 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n8so9485043plf.4
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 14:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EEM6/5lcUJxgjux7Ry5PzkmHSLCtfRYTzCp+7Il+Vgo=;
        b=aOPOPMdxnyrc1bdehERAJXioXDRNR35gRZ3huUwrC0PzL9ysFWCodd7G+dDl7YJ91q
         hyeAsGETMx9Xo8wtMXSzwUm4GHHbxdpsKfGECY1oMlMXclkkOqb2NsEXH62/CbG9q70e
         isDMZpSV3/WZQT64ALhj5kQVyRizaKxprawh99O2U06VTl14P2mYVoWd1fFUiiEJMlpE
         6GprEj2q+XK2tbWejCpqGLP8+U/gb64wI5CusRVSTF9PkbVNDkdDqeB5iMugwZWI3gu8
         GEjT2YeFQOjn449jeO89b4UVMfqutUX4BUrUmBVRZoYf45CTc56yhOPZUV/zLpwFXlVP
         JOAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EEM6/5lcUJxgjux7Ry5PzkmHSLCtfRYTzCp+7Il+Vgo=;
        b=ctvmCZJm1VoRSLOSmgQBNYQ4byeh/8ZLHKKksl7oQ4VHH1d2m7rnfGCecDzfiav4i3
         3vBdfvuWS5YbWaiV7SmIO5Bu33pbPF4C0c2rzjylYKHJ4MsbTIG4cbD+RdkZLU8rwPNv
         nTRtDb7WKRniJokL452K9q3u6v3DYR9qiODYcz3eB/VOj8lRzGz7SOHLRjlrfCmg+u4t
         WSOT9Y/cDee32fGZFaC9+ba2z4KBLwB1u1DM0loutRvwvnWkuXjMgpb9xY7FpYaOTyyM
         wyY3kiumMs+zwIZw+DQn2Ui0U1uFl4zP65VNS4oGKuOYWjIIxr3AJZWle33J1V0QbV5X
         asFg==
X-Gm-Message-State: AOAM531LVCPszbk2kBI7udUjKm6yiqTjxqnxZ7Er04Bi7dWu7WaWkr6S
        g8x2Lt12PHo1Tl9VdD7i86ncWjOoom5mRD5a
X-Google-Smtp-Source: ABdhPJyIMWFJ1D/Z1T/wrTUiFGRNT8qDzxsQd1jKAlUU/gIdwRSwasuRSknrXIBnev78paMg4FHBOw==
X-Received: by 2002:a17:902:9b8d:b0:13e:b693:c23d with SMTP id y13-20020a1709029b8d00b0013eb693c23dmr47067428plp.11.1636061562017;
        Thu, 04 Nov 2021 14:32:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w11sm4636308pge.48.2021.11.04.14.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 14:32:41 -0700 (PDT)
Message-ID: <61845179.1c69fb81.b3627.f789@mx.google.com>
Date:   Thu, 04 Nov 2021 14:32:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-5-gc1043f1153b5
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 112 runs,
 1 regressions (v4.9.289-5-gc1043f1153b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 112 runs, 1 regressions (v4.9.289-5-gc1043f=
1153b5)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.289-5-gc1043f1153b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.289-5-gc1043f1153b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c1043f1153b5b1861ff2362bbd718badf6eee7d2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618419377b9e174aa13358ed

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.289=
-5-gc1043f1153b5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.289=
-5-gc1043f1153b5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618419377b9e174=
aa13358f0
        new failure (last pass: v4.9.289)
        2 lines

    2021-11-04T17:32:20.987561  [   20.108764] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-04T17:32:21.029763  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-11-04T17:32:21.039024  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-04T17:32:21.054785  [   20.179138] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
