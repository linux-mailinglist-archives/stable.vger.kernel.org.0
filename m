Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC3647D3C3
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 15:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343501AbhLVOeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 09:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343504AbhLVOdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 09:33:38 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B583C061747
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 06:33:38 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id m15so2249875pgu.11
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 06:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7qLxOdUeIoiU6KYTX8R4v4h95CFVBu150rTF/aigLFg=;
        b=d8aZ0eMBewSj7rCYCTcjHLj1d99uzC9SzNKj/S/IsCwSZN7C9MT62PCl9i67IeB3XV
         gBVqh2wAIemqDXmKN+YR76vRWsQnHPijPRN1v/cCqPetG1kvFVo388wXYiZGdZjPXymD
         mHYJ3BpQg+9j/UNF9nAkctSmpr53jiUxifW1g6JMwqzFEAQkTWmAskXBBBpptqpsz5ZW
         WqxCcc9V6hjqLMk6SVy53nuh1FIdlZ8ByZHkLXaPAad9T7PdBpmpxQvmjMYICZM+fy84
         utaijL40HwUKQitz5AnxJ6YmItYYOJGpzQZxGBKEi/4j3iI9RfxmMMfstf85ucySsWp1
         XpeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7qLxOdUeIoiU6KYTX8R4v4h95CFVBu150rTF/aigLFg=;
        b=sS0jydD4sUSLnDZwktryDGEvlIkt3+NADlKu1YwchxsVdxM1zyVHWkOmAH/lS6oXc5
         EBV0qDwfFM9xZkWd+pQuwSb5zVWWWo7TDe6TUNK4A4gwuU/LQ5M7+0SDl/byXsSsY39E
         sKVWHxoVh0Os7lAhSnQNCd7HDa/kjDwfw9/J0XeSUBIQ2RWU7QGNhTMneJsMoXxpmnR7
         1Fyg0sGfcsOXL0dwjFe3Ql7P1ichld3g0/rIV1xGCzesHqvZsS//Klht/c5isI8mxeO9
         mS7TmgTeBD8rSy/s9qbeNsbEcFTTGfhn3p6xaoQbgTU1w0qh7W5gBwPwv9eyLbZhac1w
         s/gQ==
X-Gm-Message-State: AOAM530t6UO32693neivYJe2OqacXGZyWX15Oz1Uj5Kqje0OCDshX/Yt
        loqOAIwGLo6J7IiqLPezZNAtgOAE5Wp8NlJq
X-Google-Smtp-Source: ABdhPJxuFhOzCWzktn19281bgKsm1VJhWarZQlpZb40WvhdY/Jbrbg/RyvAZanV9tZkv27viC4WUsw==
X-Received: by 2002:a65:6a12:: with SMTP id m18mr3071885pgu.124.1640183617709;
        Wed, 22 Dec 2021 06:33:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k6sm2807450pff.17.2021.12.22.06.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 06:33:37 -0800 (PST)
Message-ID: <61c33741.1c69fb81.a959.66fe@mx.google.com>
Date:   Wed, 22 Dec 2021 06:33:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.168
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 168 runs, 2 regressions (v5.4.168)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 168 runs, 2 regressions (v5.4.168)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.168/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.168
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8f843cf57202d0db77b31adb8d2ebb93690e91f2 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/61c2fd02a6b735ae0a39713f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.168/x8=
6_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E382=
6.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.168/x8=
6_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E382=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c2fd02a6b735ae0a397=
140
        failing since 4 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61c3041fd3725c30de39713c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.168/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnowbo=
ard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.168/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnowbo=
ard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c3041fd3725c30de397=
13d
        new failure (last pass: v5.4.166) =

 =20
