Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E532547B679
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 01:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhLUAh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 19:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbhLUAh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 19:37:58 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8763C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 16:37:57 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id v25so5717331pge.2
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 16:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lnLqZlOjWGn1FrJvWn2Jp/4kT5X6yfCUXqzm7FABTtA=;
        b=x139KxDhyCCMiyAJmIW74w15gqrdxDiZQHKHoaiI73vM7yd6/OaCXdjP+8hWZ5UWoJ
         KpKr8/iUxKpkgHvJw3PaU67BGohpI5f3IEOPI3CXd3ohrEAdxAzSYHrj6sODQmYRdXwQ
         X7FuflGhAuxF9UEHb4U8LDumXN1/5ITx3c9v32DU7nnxUJAf4Co1sDN6Qulns4FpKzlj
         ST8xHukr8lgewUVgK5tAbT5Pey+QcWazO4kzSYWR/Aq6YUlkuXkrsJm3wpamG49jayjC
         HMmqkijUHUoDmz3JJk4U7gC5AhQn7+h07ex5sfbv5Dx/DDt0hANDcvChIkfkQrbNdCSc
         iccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lnLqZlOjWGn1FrJvWn2Jp/4kT5X6yfCUXqzm7FABTtA=;
        b=vGqkhbILT3ClHImbxf2vathYBpXt+Sr5OvWa6IlEC0/c8wa7z5bqx7Nbu1KjPhk39n
         t5UjHrrJm6Z0az5aVnvRqE4LBJ/DC7mq0ORUNavLmClDue8BwZPaGntYzGYEV0fLUEd5
         lm7dOQ3CN2RRAPGf0qC6dNZS6Ay6DEUWPneB0ur8QzRqqj3UmSWtWNLLOJyRxQ1AxfdQ
         sYrTmWE6Fj4KW+gz29pXIs7CWdPcbKrYM4OWWWKRX9j2YKWYUN/G4Ji7enBcjdEcET8c
         EWf3+I5nRhlgwX81Uh93cQIQS0V60NXCa/QtjKYr2hjZzWnLbGzmgASrGa4+G7gqH/48
         LO+g==
X-Gm-Message-State: AOAM531rI6ziyNfMv4KUVMCkJMBwFP/Y15HckOc90iqg2D3oES/r/G3i
        M5hqJuqyE0mioZomH5xbwM1ncl9uxhNhs5Qx
X-Google-Smtp-Source: ABdhPJwyB9KF+iUrxKyFMzZ9t4AePi3Q+jOUUSbCl+5fPHScCarLW5YLEBVRFZnag5RaROd0wT3UgA==
X-Received: by 2002:a63:65c3:: with SMTP id z186mr606917pgb.308.1640047076969;
        Mon, 20 Dec 2021 16:37:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f20sm4659281pfe.166.2021.12.20.16.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 16:37:56 -0800 (PST)
Message-ID: <61c121e4.1c69fb81.31ac0.ce9e@mx.google.com>
Date:   Mon, 20 Dec 2021 16:37:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221-56-g9f6406625bbb
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 151 runs,
 1 regressions (v4.19.221-56-g9f6406625bbb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 151 runs, 1 regressions (v4.19.221-56-g9f640=
6625bbb)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.221-56-g9f6406625bbb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.221-56-g9f6406625bbb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f6406625bbb07737566962028df57ed2e9e7bc0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61c0edce0c8181c1c9397140

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-56-g9f6406625bbb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-56-g9f6406625bbb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c0edce0c8181c=
1c9397143
        failing since 4 days (last pass: v4.19.221-9-ge98226372348, first f=
ail: v4.19.221-9-gf48d5f004d75)
        2 lines

    2021-12-20T20:55:23.650822  <8>[   21.105651] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-20T20:55:23.695633  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/108
    2021-12-20T20:55:23.705382  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-20T20:55:23.723158  <8>[   21.179077] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
