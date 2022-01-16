Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF9048FED7
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 21:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiAPUez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 15:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiAPUey (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 15:34:54 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB82C061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 12:34:54 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id q25so2178464pfl.8
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 12:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/5c8M8H+Qi3aJAzemmIH61ywp2NYqDxIKWajMlgUjvI=;
        b=z4QA8t0+hBQ58EvQlTaJ6QkhTzVCGYOsxjbRj/q5JDsAOMbKl6uexchVDpYZ3CrN2B
         rkTyhhRSgSNcOElDWfgTRmav43rdqtDiEwbRqA+6niFMDpbRCa+q6aAbNdUPFf0AJnBn
         HY/uGlTO2OkUKd8jb0r4tgYcttssZpS5FjZUUhJKj1OutPhewCUo9b8KFlN3TNeV+LFk
         4qdX1aixW3eKKForSvU1xZbLvulOAiJ7HtKcBzGow7YbmTCrSlLPXFw4uJjMeJfdIPl4
         sGlXFKleIV1Hbi2P8zfXvC71mbH9wMXNmt8GHdqzVHfMiRHZDTISWpGvKVSkWb1hbhh2
         R/ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/5c8M8H+Qi3aJAzemmIH61ywp2NYqDxIKWajMlgUjvI=;
        b=TZEFVHlvLHAh4dvvA4/5lxJQWe80rSA4iRZU67utLRQMS7kwjv+RcVQTP2QcnOvJU/
         KB4XrZsnX4arIjpUTkAyjFLVxysJNnrkXT06GDz1weHtT526m4p5lrfPd8dlHeVaRgO8
         2TF6p/KajOrT4Uu3q8FHHi51Cwly0AZXs2YVZRIshyzemicOlAx7EKNwcsbQajAbBOO5
         qgOQaXjJezfOV9Xn1yz3ztyRt0Kq6LwmtYaDGOMiIqDYyUXEch4dLCuY+NLtdgHbCS9Y
         nef4TnhPt9jK87kj2m9Tmgq4tYwSronRAycznzdH9KQ3eXC3AgeSQ/nyTB9e/2kdf1GI
         oWGg==
X-Gm-Message-State: AOAM533VRH0cMdynd3waDzX9wTr5ffMhmBX9TO/qnTirnUFDXdotFIwO
        pA3LXC6sp4MGMOHT990i03gpJqeY0xFuvyF1
X-Google-Smtp-Source: ABdhPJwoHKNBJxAgr2xlrFRvBKT0IZ+xcjYTTsyqzKNoS6GaD5n/wlJ1sBol580rBsrJNIK5hGCLqw==
X-Received: by 2002:a05:6a00:138d:b0:4c3:58f2:18d3 with SMTP id t13-20020a056a00138d00b004c358f218d3mr6524625pfg.35.1642365293989;
        Sun, 16 Jan 2022 12:34:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u20sm12024665pfg.105.2022.01.16.12.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 12:34:53 -0800 (PST)
Message-ID: <61e4816d.1c69fb81.3e437.0f72@mx.google.com>
Date:   Sun, 16 Jan 2022 12:34:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.14-40-gade5287c90b8
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 181 runs,
 1 regressions (v5.15.14-40-gade5287c90b8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 181 runs, 1 regressions (v5.15.14-40-gade528=
7c90b8)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.14-40-gade5287c90b8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.14-40-gade5287c90b8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ade5287c90b89e17748a0d77919e003e408d3521 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61e44cf8cbb1229416ef6755

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.14-=
40-gade5287c90b8/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.14-=
40-gade5287c90b8/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e44cf8cbb1229416ef6=
756
        new failure (last pass: v5.15.14-40-g47599c37ae19) =

 =20
