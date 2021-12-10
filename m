Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2AE46F946
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 03:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhLJCmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 21:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhLJCmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 21:42:43 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593B2C061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 18:39:09 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so8422554pjb.2
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 18:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uZBfir3wNPUEBiAPudvNjBE4fKz+SPAgPtgoMXOuEBs=;
        b=RBRXO1KO3e7kcff5FtMlWWjxWRMu4YKHEvq9JwPI/PQK9+pQq07SsbhZQge9DXHUsG
         j26c36GjwLwd+DFn5Jb8OMUpqnaJW9E5HjwyfM1UeZF6sQI+2dZpRMo9QaOmCQIZAuaI
         n/P8X2eTTmzxqMqR9v2TC6n+zSvlJYfeuh1vx0XVcZUl87a9Ku8Y7aSc4t/fadAScYc3
         D/ee7x6SlxxwofYgsovjplzOXmjVXHofw6rW8psWpz+3yav/N1Fn9ZyWzyLTleokI6Hc
         Zgsbg9Z4BOLlc8Az+jHzgyY91ZGT2Zl1XX7Ob3PVOmKxDVkzt/RMBkzd34a+TuVx1Bg+
         Qspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uZBfir3wNPUEBiAPudvNjBE4fKz+SPAgPtgoMXOuEBs=;
        b=MOJALenkUKfL/HbPdFTjKkAkli9TBBojrQ5XgvgQQBAJkrYGqEEEUQ6LAqqOX/86mn
         K7sw/TlPlufHangaOxZsEZ+qlHAdseD3jdgk/IlkqsXjgZ5rh/Nruzh+KIaGghC04c47
         VoA3CpvunxKUaAh9gdaZlORHZ5aey6Lsw7+jfjzqcUrFajbL21y7xgeUz+HaWYUVHh7S
         +rNoOfRu4xUGyDETUnF3S/2VczYFvK2v5wG7v1Pa3r5Cpfz//4gVAM9Lcg3edku+ITGj
         /Z7Hk++bloIXr2KaCRb8mY01KUS7AYLL+VmUAR/XR5Q1MTQBdytEMP1qfs6Ar/Nt/lfK
         z/0Q==
X-Gm-Message-State: AOAM533nQU82LWygfK2YxBF8XSuliGLg/pc6ugMd1Fu9bKCWuddWgPJ3
        YV5ZEKRxS8bUZnJSivo8KNOGbtsU+LExtCJT7CA=
X-Google-Smtp-Source: ABdhPJyfyg4JkfWJ0cZD3q/yDQLZTXaXTI+I3WTTtpl75Ia+GDTqBpugawhCS4RwfmX8Q3SHm0DSGQ==
X-Received: by 2002:a17:90b:4c89:: with SMTP id my9mr20493094pjb.229.1639103948627;
        Thu, 09 Dec 2021 18:39:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b9sm1070121pfm.127.2021.12.09.18.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 18:39:08 -0800 (PST)
Message-ID: <61b2bdcc.1c69fb81.dae64.50c9@mx.google.com>
Date:   Thu, 09 Dec 2021 18:39:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.6-219-g484e8ba45ec0
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 189 runs,
 2 regressions (v5.15.6-219-g484e8ba45ec0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 189 runs, 2 regressions (v5.15.6-219-g484e8b=
a45ec0)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig           | 1          =

r8a77950-salvator-x      | arm64  | lab-baylibre  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.6-219-g484e8ba45ec0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.6-219-g484e8ba45ec0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      484e8ba45ec005a05a99c99d286dc8064d063038 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/61b286aa6a74cb65a439713b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.6-2=
19-g484e8ba45ec0/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.6-2=
19-g484e8ba45ec0/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b286aa6a74cb65a4397=
13c
        new failure (last pass: v5.15.6-209-gc6ee141f922d) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
r8a77950-salvator-x      | arm64  | lab-baylibre  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b28dae1a90677d94397164

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.6-2=
19-g484e8ba45ec0/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.6-2=
19-g484e8ba45ec0/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b28dae1a90677d94397=
165
        new failure (last pass: v5.15.6-209-g82401ab89557) =

 =20
