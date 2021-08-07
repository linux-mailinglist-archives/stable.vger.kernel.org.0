Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6CA3E3640
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 18:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbhHGQJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 12:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhHGQJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 12:09:50 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BD6C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Aug 2021 09:09:33 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id a20so11488203plm.0
        for <stable@vger.kernel.org>; Sat, 07 Aug 2021 09:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vw5xs+JQ2/SO8m3ycOEI4XPcCXhJW42U0Aob+AUutqg=;
        b=qx8o0EUvJCaXyw5ghqsT3eCHfAgaSP+IRaXqnXO0Ds+3GycPpOW7x9NfbEHMVzq4pp
         2954mP7qO9wYPDhtm9oah85BqKqAwViJc1IZmBzMBdiuEwq9hqAIGJpY81nVCoPf0RN7
         +WP/eNS7vlmHuvIw4OefhflFifihL9qc+/4vGZGkXLkMhSiyyNsgucQw+QQBAj/BLc3Y
         nb1PUwugUOGIaSTaCs3zaS+zDEbeA5uLf2lMiQPAZkn86Q6MuS7QhVLYUpFPpvCDjfL8
         Gx8LoLOA+rXYptsDQfR7OcgRwwm9fM78E4LVJa0FiIPO06z/e45L9WtaQRNQboX4/qxu
         hxtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vw5xs+JQ2/SO8m3ycOEI4XPcCXhJW42U0Aob+AUutqg=;
        b=LKm4atwCXRhgD2jUgsonl+EQJOS88uqp+/vQ0B1LP540hccX41IzRO0d306BRy+6YN
         8Vhk27kWzOqUzTRjTS5vCUW0m1ZfZX5Wn5SA/LWsNuRXa9/RxRkwunGK+q9MEbvj78wt
         HCcxZMV43Fc/QHQcAgemgsBfBBZhScWTYZO77mKRTR12UnyRiQ8wEe/ebT4QQg+LVJz2
         z75c22tgVjT4Dk5PjWPGRffZAbWL9AiTlSUAWdVC50+t0/r/9P0pFsnHmTgAfl/jI9oA
         ZGnLQk1bau2r8iWOmM226lLM61KtUQ2Itvt08R0N7Lv0fGw8fxudi02dKCIcaPa8kZ0k
         inWw==
X-Gm-Message-State: AOAM5304oaQ2cPwT9Y5JwAXCsrp8k1+P7x7jmJKh0olGkWa58XE1w2N+
        qEFlvXVW63xF+xU42ryFrvqpsidIj0pZcFNk
X-Google-Smtp-Source: ABdhPJwhl83sqqSu910FDK/oJjkSlH2d80l37YGA+JhnlFLxkPruJ4Le5aw5gmQKJesVOKnDGI8h0w==
X-Received: by 2002:a17:903:300d:b029:12c:916f:fedd with SMTP id o13-20020a170903300db029012c916ffeddmr13297866pla.19.1628352572698;
        Sat, 07 Aug 2021 09:09:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x14sm14279404pfa.127.2021.08.07.09.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 09:09:32 -0700 (PDT)
Message-ID: <610eb03c.1c69fb81.c1d6.9ce2@mx.google.com>
Date:   Sat, 07 Aug 2021 09:09:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.242-11-gbc68288883d8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 92 runs,
 1 regressions (v4.14.242-11-gbc68288883d8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 92 runs, 1 regressions (v4.14.242-11-gbc6828=
8883d8)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.242-11-gbc68288883d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.242-11-gbc68288883d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bc68288883d8bb5d3e9b5c189a29e08c2be3c04b =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610e794426e2aaa51bb13663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.242=
-11-gbc68288883d8/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.242=
-11-gbc68288883d8/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610e794426e2aaa51bb13=
664
        new failure (last pass: v4.14.242-11-g10da3cd37db2) =

 =20
