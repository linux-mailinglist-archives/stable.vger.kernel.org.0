Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B333479576
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 21:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240765AbhLQU24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 15:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240718AbhLQU2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 15:28:53 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C96C061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 12:28:53 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id n8so2832613plf.4
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 12:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GhOPX82kx7BRg3sCeb285wWODkewO+ztJC3J3XCTY7w=;
        b=cyxZTnpPuSNapf3RWODkmoEfxyhKjS2vtIZvYz30rbNk3DVkn6f1/p9Oa1VA44MV4M
         G+sARg4aGmFyUXo4co9kJXka1l6d2oij4WGE4EiqrjWF0UQYNM2KH4X/5q2CEgGsqfC/
         JeykDZ/kUCNvfwbe3mlmMy0+UTLnvMrM0Ypxm5nCvfgenLBW7LTJXZjKfMQVM1SwWxao
         4hkYwk6MnF6U4ohcIINR9rU8WKxrPNu+MxsdbYGtGMPdx1SujW5Ce4HxMK9dFhTpW5+w
         Q7qI+Y14MumVuD2iQUBotZtTxb0fMN+L7+KLagj50BlmCPCd5CsbujO6aIvhfXusEmBn
         VnYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GhOPX82kx7BRg3sCeb285wWODkewO+ztJC3J3XCTY7w=;
        b=JuGmvhKHbX/zoGiKQCMA3v34UrZCgSE3eUxZUmShL4JyLhiCrKuZR7x6oJ+SDWJyck
         wyK3cuO0MGaVI8s6du45CuUjv6+54U7m6e1WBzoD34PXhE+cp7QHWWiO3LFxTvYQFGsp
         1BSVFvjhxKNgnP6oMnfUX7Td/hGlMJ0Guc8WD1bk/f2pAuQJ7X0xmHGL4NRH/fZ1Nh6T
         ARY0Aqn8+frTDhJb+r5sOR3V6n3MHilsOZOA76EHk6pCwE2jo7zIXm+J+91pYGa7qkWM
         C0EniB2qylWD5An2/de/xhfQPmsCORIZredb6t4gwwRpw2PmAV1YrVl2P8Px50mPpMNM
         L4tQ==
X-Gm-Message-State: AOAM532P7DVPRQY681uOjKGFpJe3EddWwzd6HI3CJU269A5kfvu1RzPL
        dpNf57QwkVYp+8dUajgoIEHWG8WP/lQz0Yu/
X-Google-Smtp-Source: ABdhPJxOJjOrcJqDQujhWlxfqd9cObGN1PaxlH8AE7hX6Y6YLI7Wl1PZZKBx+zKVKu/x58RquI2rdw==
X-Received: by 2002:a17:902:cec4:b0:141:cfa1:f7e with SMTP id d4-20020a170902cec400b00141cfa10f7emr4618862plg.13.1639772932780;
        Fri, 17 Dec 2021 12:28:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l16sm6718533pfu.115.2021.12.17.12.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 12:28:52 -0800 (PST)
Message-ID: <61bcf304.1c69fb81.da1bc.380f@mx.google.com>
Date:   Fri, 17 Dec 2021 12:28:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.10-37-g0041cbeff09d
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 174 runs,
 2 regressions (v5.15.10-37-g0041cbeff09d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 174 runs, 2 regressions (v5.15.10-37-g0041cb=
eff09d)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =

r8a77950-salvator-x      | arm64  | lab-baylibre  | gcc-10   | defconfig   =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.10-37-g0041cbeff09d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.10-37-g0041cbeff09d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0041cbeff09d39ccfb2bbc0a00573d675030e229 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61bcb79e192b461a90397127

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
37-g0041cbeff09d/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
37-g0041cbeff09d/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bcb79e192b461a90397=
128
        failing since 0 day (last pass: v5.15.8-42-gadd3d697af60, first fai=
l: v5.15.8-42-g0a07fadfda6d) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
r8a77950-salvator-x      | arm64  | lab-baylibre  | gcc-10   | defconfig   =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61bcbf433bb65c09f4397133

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
37-g0041cbeff09d/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
37-g0041cbeff09d/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bcbf433bb65c09f4397=
134
        new failure (last pass: v5.15.8-42-gd38bf047f9df) =

 =20
