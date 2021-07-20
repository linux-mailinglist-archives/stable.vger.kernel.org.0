Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5093CF271
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 05:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245262AbhGTCbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 22:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241721AbhGTCbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 22:31:04 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4423AC061766
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 20:11:41 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id o201so18417211pfd.1
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 20:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Da5NqUJthtxccdFGpjyt53jxwItUdaChQItGCyabw0Q=;
        b=iEn6XAjITZEbu6cNUBGATCA7mNBe/F+CxQtjcuCb/l2ECIXpmHObKBXf65IfUaTC28
         gFlQoxKW/LDq1A6wKk2ARjC6GbjrWN1HRgSuYI1t+wpm2n611rAf9N+6yiuGuKENmQJH
         xaGnJPSxC6oeLQylaTO6+xkYwpyJQaHIXdobKaBQuejciCE7kVarTZeaLRUDFmwGresa
         tkpcQkqmsOvERlRlp6nQ+PBVqqOBNSOzUSjmrhTtxxdOezv2rXNIRsnQMnaNYjAooiQ0
         2Guh4niOrRhZepE4u9m5/EnTpvehceNAbwR1i404/TuG1QNgHPPg1+XBxZYDqZExXLYH
         YIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Da5NqUJthtxccdFGpjyt53jxwItUdaChQItGCyabw0Q=;
        b=fy3KCUF+T3oaUFGEGsKHNn1MlCNevaGbmp4HTdgLUAYAY3Go/n4vNhgFPYccxpovpU
         rty7eyGl46yBbe5/p1EPKRoOT42T6h20Tifjx7fUKdB+iorhzllG5qbRj8os8FWYWDcr
         kz6dNA/o5nIR5pBz/V0pX9bLH7AsfQAWCZ5z+HV5BXplSsoX1zSBXurizQAmNQhxHQxm
         edBj29CiGlXVxopJ6/tKIyZjwvMmUv+RzCv92qQve++D8WeyUj9Y37Zwc+ZwXCVhG8AZ
         +DjRrvq+fWntn3Ns43rNV2pRNUNDnLxrXszwLmbaex8eYKs1Q2X2MR7mKSoxLENgn1qo
         CO/Q==
X-Gm-Message-State: AOAM5319I08UpdqjnE6YrXPjeRvx6OjaTg7wnJxaNSMGDwcJI2Duo7pj
        Wo6UJy5y8NbGhX158Nu/huhVjqoNV1wtzA==
X-Google-Smtp-Source: ABdhPJzFJnqwr+PfV+00QKqWDK6f/8rU8Tvo+DkjKy80zNWiY3aT70tBzo26xj8NSFFMVUq6vqwjkg==
X-Received: by 2002:a62:d108:0:b029:304:33e5:4dde with SMTP id z8-20020a62d1080000b029030433e54ddemr29311797pfg.74.1626750701228;
        Mon, 19 Jul 2021 20:11:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x26sm22428770pfj.71.2021.07.19.20.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 20:11:40 -0700 (PDT)
Message-ID: <60f63eec.1c69fb81.a69d4.271f@mx.google.com>
Date:   Mon, 19 Jul 2021 20:11:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.18
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.12.y baseline: 142 runs, 2 regressions (v5.12.18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.12.y baseline: 142 runs, 2 regressions (v5.12.18)

Regressions Summary
-------------------

platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =

d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.12.y/kernel=
/v5.12.18/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.12.y
  Describe: v5.12.18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      094d3b83a818415339015c4c7ae67955a6dc3762 =



Test Regressions
---------------- =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:     https://kernelci.org/test/plan/id/60f605024368194dac1160cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.18/x=
86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.18/x=
86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f605024368194dac116=
0d0
        new failure (last pass: v5.12.16) =

 =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/60f607c17fd75981bf1160bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.18/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.18/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f607c17fd75981bf116=
0bd
        new failure (last pass: v5.12.16) =

 =20
