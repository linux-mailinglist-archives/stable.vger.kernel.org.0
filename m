Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E06523D1C6
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgHEUGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgHEQfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 12:35:06 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF68C001FD2
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 09:00:44 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id u185so22959423pfu.1
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 09:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yDjoTAL+ODpi4HR97d7sPyGRn6pUw6OUqHGVQ5CYyYI=;
        b=yTT+UYRokQRMYlmTQdzuHLfdRY0qVZszSLkBzrDn6Iu1ANR8jWIO0kACpSISHeKBvL
         pyCDLb6ocFOWQzqGNQbSyhVmUGLcIy2Fy3O2dTH9gK3drNf7aJfNz+iWFAj2NojwhrZB
         7ZJZNmF+Kd2OeccjGyHskHjBcq8c3wih9YqHH5eybhyp5xAukJ2B1WISKr6TeXOT5PGu
         Nqf5DRWjSjwEsfQFzprMXD/tHBZshAr3842F+w0VvdR65F1tdccJ1GqEpBKdjLm9WEtM
         5OwhByAVyKWUaUp+5uwdXNrZ1yY9pkF9YHutSKXHZ/IclypyaMjlx9k99aQceg6cxGXf
         2PZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yDjoTAL+ODpi4HR97d7sPyGRn6pUw6OUqHGVQ5CYyYI=;
        b=q0U4ygM5ldn2IkFpzgZTyx8yDKlzaRGSASJz2wOfy8ap4t7cyYYHO4MbnBgbUNYJpj
         cwX9CkQyFkQdWB2B40NsJX6hqRq9/HLexdilL4pMNelI2YpGPqp2Rj5MRVDqk8mP4P1x
         OdzGJ7Q8ULy9zEXGQgnsUy1h1eBb81eSLFqWt/PqTVrqSaDl1bf4s8fHBe+hPqMWyQIk
         kH9kWWlfVmBKcXfu3Oo1UrstYiqdQDHTr5UTx78p3AYYKdw85J3RDJuqfAijvobFxmaQ
         PX8pfuycRItZcvoh4HxUQ/KcHamj2+SkTKeigF77ADv3VKqLcyEZXRtv9Jj65PwdjGnw
         0rHw==
X-Gm-Message-State: AOAM5322nR7sjkeLSjgTHCzcu1P4Qe4M2rLHyB1gSQEhHIAaoAaNvsGA
        xBt3Qhw349vXqooSVHAY1zQyvNB2t7o=
X-Google-Smtp-Source: ABdhPJxW+U1Mdh6Uf5Fa0Gf/dSxRCruNiV1LR8FFmZCDuhVy6eZHf6HKDg11/Ctj0/mXnYG5U+RjiA==
X-Received: by 2002:a63:fd03:: with SMTP id d3mr3578596pgh.76.1596643240785;
        Wed, 05 Aug 2020 09:00:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g5sm4202906pfh.168.2020.08.05.09.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 09:00:40 -0700 (PDT)
Message-ID: <5f2ad7a8.1c69fb81.a17a1.a552@mx.google.com>
Date:   Wed, 05 Aug 2020 09:00:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.137
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 144 runs, 1 regressions (v4.19.137)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 144 runs, 1 regressions (v4.19.137)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig          | res=
ults
----------------+------+--------------+----------+--------------------+----=
----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 0/1=
    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.137/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.137
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c076c79e03c6094e578df5d210fde808b3ad32e6 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig          | res=
ults
----------------+------+--------------+----------+--------------------+----=
----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 0/1=
    =


  Details:     https://kernelci.org/test/plan/id/5f2aa12c850e2b6a8a52c1cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.137/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.137/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2aa12c850e2b6a8a52c=
1cd
      new failure (last pass: v4.19.136) =20
