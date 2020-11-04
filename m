Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65CC2A6709
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 16:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgKDPEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 10:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbgKDPEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 10:04:01 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CC8C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 07:04:01 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id u4so5015796pgr.9
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 07:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EOpwxsfoDqfFwiBXk0j9KOmlTktOlUxGZKW85ii9a+w=;
        b=Qk21omQoyNpgoHcfyU5levppoWfpqASvVTNopnA/cNvnIOWflBCuJWvPprUtyiq7na
         9/RrIjZx4X5osfAQTLgNw0KFcBE4NTbUhrdp0Eu6jM70qIG/ktcvTruETTvNwY7s3hpe
         E0aXlmYyB/drUjJhPSGt1oc9ttkSUNV1n+lN+AAlUN2kqwp+AOLb3nc7Syn0wL5swCLQ
         h58J6TYH6fdMPwyKVAYPHDQw/vpuD96DENpz2VR04oziWDLppyOruwsCmCbE41zdWRAv
         vm2qmx3e3VMkGZZlAf2HJvvTCZkH1o4WZPoBC/pOaZ54iGaClBCDB/zqwJT/ML7o7+tQ
         Vktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EOpwxsfoDqfFwiBXk0j9KOmlTktOlUxGZKW85ii9a+w=;
        b=baywVBdW97vCrb4XspWg4awwqavAsxHWg3NKuUneZUhm99ZalRWpaQTQ0Vh4BUvX3S
         wJEesbco9hOJfUNbX5HDUDEJIr7L66eSgXtEsoRj3ygOQ+oyu7oHzR+Yw9shdMrxYpFP
         jAuuGI2yF7cgaApoJMCv25gooeqO0Bts+aBXToo86rHmlu1EZhcH5FWvKi3R6pbV+cHo
         NEtX/Ij2qz3aXrn9j5ifB7FTknWiDDi6GeJU2MI22E66ZQFoCYqhKLsFyOrDh+A6czOM
         gEwSWw0uPwTVBFBUqjgP6/P580ZARqdJethxjAJx2YeLbWMtH6fBcAKJjAM7gKDNIMc5
         X3rQ==
X-Gm-Message-State: AOAM531hehanc/xIG4vgLl87JIsdYYFdIZqIMO3FFp+r6RyAdDcCb0j/
        Q3vzaW6k0KdySxaHUZMxGx46jxA8VgZwaQ==
X-Google-Smtp-Source: ABdhPJxYdA8Ty9NyDs+BauxgmZbvtwvd51Ur2nnJYEA3fmMumVdAf2s6kCKl/0JU+NF6NrVVTy0ypA==
X-Received: by 2002:a62:f909:0:b029:18b:588d:979e with SMTP id o9-20020a62f9090000b029018b588d979emr3086859pfh.48.1604502240448;
        Wed, 04 Nov 2020 07:04:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d22sm2348348pgv.87.2020.11.04.07.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 07:03:59 -0800 (PST)
Message-ID: <5fa2c2df.1c69fb81.2b8ea.52e2@mx.google.com>
Date:   Wed, 04 Nov 2020 07:03:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-91-gc8dbdf908cf1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 148 runs,
 1 regressions (v4.9.241-91-gc8dbdf908cf1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 148 runs, 1 regressions (v4.9.241-91-gc8dbdf9=
08cf1)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-91-gc8dbdf908cf1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-91-gc8dbdf908cf1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c8dbdf908cf142bc8dd73875e84fb4796f42d6c2 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa2904818ec8c3576fb5313

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-gc8dbdf908cf1/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-gc8dbdf908cf1/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa2904818ec8c3576fb5=
314
        failing since 6 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =20
