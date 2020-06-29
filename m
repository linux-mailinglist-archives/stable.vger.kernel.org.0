Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFA420E8A2
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 01:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgF2WPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgF2WPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 18:15:42 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A24C061755
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 15:15:42 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id u9so4029489pls.13
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 15:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pD/q1Md8kgQ5ZmjdICivXWrz6fllxxF9hnFMCzr2dyk=;
        b=M8Argrm3y/QdbVeJjVBMJPZfWah7nlpqsppapg4twT7PlR9k+cUGy0ItvBJB1Tgn/6
         QxZHvBAf6xap4NRC90FtGpIuf/z4scDCxZ4CZIExsvKqccVuDzIaCFRcqIMzN26FTdqd
         BPjwfwY0UZDJpjOecs7rJhIWkk5rh8LHGpGBK2ongBO2FNH/tdVYMefxuIQ0h1ZuK7eR
         c/hxZsJKYUaK9gAJeo21oOhnxbb5isJuIY9qr5WeKOEq2Wnn/wv8r/vxBcRa6I8MJJju
         GuC5xdWimkfHljB+x88namLv61XvnOoaHf97R+nvcW4aSgcRQOJ119+m1kstS4jkD4ka
         +oVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pD/q1Md8kgQ5ZmjdICivXWrz6fllxxF9hnFMCzr2dyk=;
        b=Ngqhm8zFS7q8T2ih6HdN2VBZmY8tKjcWBe1hae3SL6+/vDRzPQzhQCm+RpeOx4iRTZ
         pnGoancTPAXMP7oLJcYyTRp9ds2szuRF9/ep4/ksw4lgqjHrTDkE4u+KRsY5nBPg2KD4
         /r1Yil34ZZ+5IHcsKy38fZ2Juw3lbc553dL5GiX8uUSqBeLeyCluqbIcthc/PhAVR6WG
         +HZnF+KPh4dxY9De8OjoAQskpNOFp6UZIz5d9OJb0cq6NYmgVACsd7hP6BA4XYbQJprw
         QYn9aV4nFY9cuATKfYCjA/KC9ysFnnK1qMXfhJgZVCIvXh0GaPxppNVYI0gz+3Y5wv9v
         tCyw==
X-Gm-Message-State: AOAM530vMxLjB5uWJcxHRPdCgQzB0tQjoEIq2WcRXYhkTP9qbcuwSir9
        NNrVdmB/GYMgrlDJAbU6tSr6Qd1nFCA=
X-Google-Smtp-Source: ABdhPJwPYmGxysfkuse6FTuj7Gs2i63igbdjN4vfh778YVj1k8zIDJUI99l9uG3VjKZXWiFlTtO6Pw==
X-Received: by 2002:a17:902:7b89:: with SMTP id w9mr3560060pll.175.1593468941217;
        Mon, 29 Jun 2020 15:15:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w1sm584985pfq.53.2020.06.29.15.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 15:15:40 -0700 (PDT)
Message-ID: <5efa680c.1c69fb81.84441.22c5@mx.google.com>
Date:   Mon, 29 Jun 2020 15:15:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.130-131-gd77d34fc4818
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 62 runs,
 1 regressions (v4.19.130-131-gd77d34fc4818)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 62 runs, 1 regressions (v4.19.130-131-gd77=
d34fc4818)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 0/=
1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.130-131-gd77d34fc4818/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.130-131-gd77d34fc4818
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d77d34fc48184da0390d7f79bdc17f44c512c458 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 0/=
1    =


  Details:     https://kernelci.org/test/plan/id/5efa31043bedf2a50085bb1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
30-131-gd77d34fc4818/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-om=
ap3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
30-131-gd77d34fc4818/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-om=
ap3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5efa31043bedf2a50085b=
b1f
      new failure (last pass: v4.19.126-525-gf12dcdbf9d54) =20
