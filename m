Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF64465C08
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 03:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhLBCQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 21:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238982AbhLBCQX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 21:16:23 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EC7C061574
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 18:13:01 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so1226320pjc.4
        for <stable@vger.kernel.org>; Wed, 01 Dec 2021 18:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3/GPl+SNJJhGTlKqrcTAo+Df6myM8+RSrBnrTlw/Lwk=;
        b=h3VL0mlgMbBXKSFJZjJstDU7g/HEDF78hQEMrVE0jI5LZmDOIjCuJqod7hL0jmKpJP
         Nv9X/SI5BBTOTAKmUxhJEUmdhRb3mpJ/r/wwGrlApWfIvaLXpBCM4BSdeGyWHD4UDgcJ
         aubPIldYbAmubEMN2EC7m5YdngV9hqLfAQyilWMN4sS6ejboe//g6yBII5lC8PB+HLxm
         T3js7ZHhr1H18lYOYOciWRsfhoeVkeccrpLWG5UH5kWFURpC2AUZANyqhJKOr3VFZwUm
         kno2qmBW2dXwdlOcVGV/aGFV4KUI6i9j4HadrkBzm3yHmLRp1s7uK9l2S3Dn7Wael1R+
         y49A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3/GPl+SNJJhGTlKqrcTAo+Df6myM8+RSrBnrTlw/Lwk=;
        b=M1burhrmLbAFwlMKAcQi/6Cdax37e4iM0s5lVnag9VEtnW5i58sl18DxXBXbRdgoao
         b/XCPUkJCoNKb0rLrcdeG42JpZ039MNkbAjNGJIy3A4XJuGPfHDs8T9Ls+n3yXg3opuN
         RDvTWI68hvzxXBiS6Z3ZLd/ivoaKGRK4vk9xSOhD1J6VG40uPUtt+kMyw+r+nU5J6csu
         1OuCdC4RDjgctmQuR7uOuydS0L+vM5Nbn9jioCk6FT8ssKeS7kG1KEoQbcxmS1jCSWM0
         mgjQ4R6VXrNa6I1n8FFtdKD+xkniH1xUU3GwNxTGDv4tzKFSWaEcJrkuz+5If6yOC5BG
         kvXw==
X-Gm-Message-State: AOAM532PI8jIGpdclOGO7BKVx6qbl3iroazMJOdCFB3mRlTLXp2y3wXz
        OWECPN4lYrNIYd/wey7DToqUFNMc3nmphv2h
X-Google-Smtp-Source: ABdhPJy6XUDCqKJqqZ8uSWWOf3lyYj5ZQrOBXL8q8Z6vtR40VevQfcTjBTptu+0bpAYia5JBwDlYEA==
X-Received: by 2002:a17:90b:17cd:: with SMTP id me13mr2548686pjb.79.1638411181205;
        Wed, 01 Dec 2021 18:13:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h186sm1108892pfg.64.2021.12.01.18.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 18:13:00 -0800 (PST)
Message-ID: <61a82bac.1c69fb81.711a9.5199@mx.google.com>
Date:   Wed, 01 Dec 2021 18:13:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.83-1-g0440bf08440b5
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 95 runs,
 1 regressions (v5.10.83-1-g0440bf08440b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 95 runs, 1 regressions (v5.10.83-1-g0440bf08=
440b5)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.83-1-g0440bf08440b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.83-1-g0440bf08440b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0440bf08440b5b735fde5e2b309d0eb278a94264 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61a809fbfb6854936b1a9487

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.83-=
1-g0440bf08440b5/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.83-=
1-g0440bf08440b5/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a809fbfb6854936b1a9=
488
        new failure (last pass: v5.10.82-123-gbe94beeac2486) =

 =20
