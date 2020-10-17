Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1B8291432
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 21:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439623AbgJQTxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 15:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439611AbgJQTxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 15:53:43 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC26EC061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 12:53:41 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r10so3495272pgb.10
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 12:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V6FIVeEbK7uClJCAtaL3OY9ep/MW3bxWjnK6h1iSu18=;
        b=eTBJtYZy2on7oLMf7GIQe02pviSNxkeoEAGmKHo184ivI40SQ7jhamkaKBgb4XD1pd
         51lFk+u1y9pdfMgPZWTom9M5rT5Wqd9Wx6qlIg/Lq5hBmp26oj6+Z+ZAheUFuEQGlEwG
         uA/wPrslQ3vGYchRL7ILPHXEth5ild1/KJ0E9KqHmHsGLuwXy3vsPTMEQ3vB7q6MrL7t
         YIrD7wy2pfqLHOAWDWQibZOyqKNt9RhtooHW5kxAqOtA7lgFTd3zhe85I26tPzXfAkVz
         k//YWcBM49hfeGu/tpzJWe4EYDbQrF+AdCMGyrDeNQAYH5yhzMg1iebn/AJyVEWrJ2Rs
         3yTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V6FIVeEbK7uClJCAtaL3OY9ep/MW3bxWjnK6h1iSu18=;
        b=iBmNumeJ9V6Eu0x7GCU7Ff9M+6mxhPed9Vct3myHd3nVhYHUKD0r5HJ8vPdtN9zsom
         xC9nsvYri3vbkVMJaCbNH9JhDPRSyHhwQkAod65GE6OGzMsOap7FCPYf35bMaPtIWSgm
         TuOCY7v5mvPeUWG5wNMYOIB6TtN08JFBZSrgaCsrNyBAQqEW371IKjLqBpX7VTanEHwX
         LmX+mnZ+1cvfvFnO9OpAwWrmylXHNGkZMuWiYDxx3jIDttJ6V5Qqux0aKGa7u3rgFTnm
         vQQFrK7dGM5gytEX911Hm26uKq4N3MrZQINhRZ+WnBj8IG4IbdAxYIyTXZZS0ygE8dqk
         aNmw==
X-Gm-Message-State: AOAM533fUD5emFJKl/AQdO/b4KoPGWf2PRvWM8jFT63hn3bjExJxvGKo
        ehH0wSVShl1qrT5QnqTqZ8CRMFlZWV8w/Q==
X-Google-Smtp-Source: ABdhPJw9axVxoCfzXpHDTmzW6AbZ1t/iA0qNB7ax5gzOQEZ8E8Rli1XE42hJb5zgtQO6Vc8MFGVCiw==
X-Received: by 2002:a63:1e0b:: with SMTP id e11mr8053974pge.72.1602964420707;
        Sat, 17 Oct 2020 12:53:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lx5sm6243179pjb.33.2020.10.17.12.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 12:53:39 -0700 (PDT)
Message-ID: <5f8b4bc3.1c69fb81.db7bf.d6cc@mx.google.com>
Date:   Sat, 17 Oct 2020 12:53:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.202-10-g337afb44c54c
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 172 runs,
 1 regressions (v4.14.202-10-g337afb44c54c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 172 runs, 1 regressions (v4.14.202-10-g337af=
b44c54c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 2/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.202-10-g337afb44c54c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.202-10-g337afb44c54c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      337afb44c54c87e117e3b3883a6925d194f2b911 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 2/4    =


  Details:     https://kernelci.org/test/plan/id/5f8b14015188f9bbe84ff411

  Results:     2 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-10-g337afb44c54c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-10-g337afb44c54c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f8b14015188f9b=
be84ff417
      new failure (last pass: v4.14.202-8-ga2d62e0a327e)
      2 lines

    2020-10-17 15:55:41.527000  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
      =20
