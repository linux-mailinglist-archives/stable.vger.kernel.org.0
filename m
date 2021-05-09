Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4601D3777F4
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 20:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhEISiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 14:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhEISiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 14:38:02 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11BCC061573
        for <stable@vger.kernel.org>; Sun,  9 May 2021 11:36:58 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id m190so11763582pga.2
        for <stable@vger.kernel.org>; Sun, 09 May 2021 11:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nbm2AvEFlZyXjd6ypsTISad+wiUUkMfpO7oT6mj64FY=;
        b=jU2ke62QVUw2Mv4RykyrSZm52QHR9Pl4dJgQR40/9yS2qX/eI6cS7Hq2NTU+OnD72Y
         WAyfUGS2BC6foXBeuTY3cgje6h6HPP4GhJ3p0tz2kEOBJCZ8miimq2pYvJYS2WVhHEum
         CpV2/V+NEQ9ZOCc3BThgxNzXH1xrK1TMK+pP6SkuxAny9i782ol+O68U/czE85+t+YXv
         NxtwHB1q6SGuLMu9YI8xLwxadh3rbjBZRHYyOvUJ9bVxnAId96PItXMqS+SVyvvENBBP
         mOTxtYKK16RghfF9GTW5ByQNv2KGsK5qXVhjB0vJkSuPsGJk3x9UGFXfjneCT4imo8Ov
         dzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nbm2AvEFlZyXjd6ypsTISad+wiUUkMfpO7oT6mj64FY=;
        b=HX5G9E7ZQObFdq8rSUyN0POdSDYfTF4Ur79KjO8437AIT0fsXucCTqDQ0GAEzAIilY
         3CfT8ZBopnbik4LubVjYQpGRfyFdLAiksJe60k9sQPERK9Pt5NAM1J6nnjnkQB+h0vBI
         obIROG4H4mol5MIK5swzfFirf+QhToXZpUPKMYBDq1uDoJZI59RBBA5LjoxlpJTjJEdz
         rJ5vVfEiEoK1UaEfrHqEcvMaIG5/+WYXTCHoMID7jfaLQMo7VJJPiqpQY2+d8kaHrqUz
         cmJP86tKlj4lD8d/Yy9iGKaYoh9Jjd7n+/YayPTPYUBGUKf5Dq8S3s1uHGgvXPBLW9Jc
         3RVA==
X-Gm-Message-State: AOAM53147o+D0Qnn2PtafK3avMAhaRZOJMvyPQ/NArqJ0sile5saFmSJ
        yP1QkK0gEA3McZ0111sz0o8QI05t0e9HMwjZ
X-Google-Smtp-Source: ABdhPJycyAlg2QzbQ6oVNo8Cx0hc0QvfjgXEY248w5bpaUmF0oQq7EmiRgH5W7zw1if1c7UFYZm96Q==
X-Received: by 2002:a62:18ca:0:b029:28c:eeca:e7b1 with SMTP id 193-20020a6218ca0000b029028ceecae7b1mr21012609pfy.37.1620585417654;
        Sun, 09 May 2021 11:36:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c13sm9263196pfl.212.2021.05.09.11.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 11:36:57 -0700 (PDT)
Message-ID: <60982bc9.1c69fb81.8f1fe.c39e@mx.google.com>
Date:   Sun, 09 May 2021 11:36:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.2-328-g8a71744cc2f4
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 161 runs,
 1 regressions (v5.12.2-328-g8a71744cc2f4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 161 runs, 1 regressions (v5.12.2-328-g8a7174=
4cc2f4)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.2-328-g8a71744cc2f4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.2-328-g8a71744cc2f4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a71744cc2f4135663eb0b3ef3ee5fd2c64c9f1c =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6097fbbcf1b3f20f6a6f5486

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-3=
28-g8a71744cc2f4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-3=
28-g8a71744cc2f4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097fbbcf1b3f20f6a6f5=
487
        failing since 0 day (last pass: v5.12.2-286-g4dbb1fd7ec8e, first fa=
il: v5.12.2-295-gfb352930605d) =

 =20
