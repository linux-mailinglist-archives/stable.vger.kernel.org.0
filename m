Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56BF35B70B
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 23:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235388AbhDKVfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 17:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbhDKVfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 17:35:06 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D3DC061574
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 14:34:49 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id b17so7835930pgh.7
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 14:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d8cHSpjcdlQB15BI3mSXG7SUP8iQu1DnG5URWXakbeA=;
        b=tJWPQlNnT3787+yfFgTsFhMc2r7cwlU2zLzu6ArxDPfutLN6Vjcg5d4gDtgVXjw08k
         BJ175hF1hcJKULhyBP45Zl/4nLf4S2PTE6kUKq4OS06VaI9J9EHzKtg4s93Ln8EPvtXC
         ZVcP6u9LEaBWKG8FXmzooYtY2TDZo9batP8c6CGmHkftnxEKYkcIeXTH7RKikm5UTLkv
         +E15HvfqrnKIlqjVO8m1SQ2oUOlXDEWZyWVXEOB6sQG219NRkq+bhdtApS8txNv007OP
         WuL3nc+d4bX3Fx7ToF0H3f2TDAwv7+7X3K+OqbCvbGvh0umSYEdA0DP229dwMgSSKlSY
         6i+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d8cHSpjcdlQB15BI3mSXG7SUP8iQu1DnG5URWXakbeA=;
        b=AjPzH7BOD1LsplzrsYYpBQ0TPewKPG1afy2FE/NynjzjEHY64a5tc/kwo/g4JVJxT+
         Gbbm4fdLrItyEKeRXRycxpgwW8+1uDudN4CZyPxh/jVreY650ouTXzEP4uwpCxBkeuiT
         1hxW5E+j9t5ivPXyMKHMCHHO8DOmoDVeKQAOyO1IiAMSxUOHFHL217tX0q1o6stx0nlF
         9AsvyqZhSvEpUNy4t1pvKC2uqy8vzAjbBTZzakyXYb3E9g9HtkRJ6yg8tauTbPAOFpX3
         Vd369XFRm3/kC3UygtcRrMBeMBL1rM1Z0211BQcs8PeP7FHddLw/7RSogH8dL0HfW1Bu
         TtrQ==
X-Gm-Message-State: AOAM530imPimpbXYtWcm+AyGMo+1TSrlX+Br28XZn35sbiSjIp1b756Y
        hnIKzsZIyhNi8tLHDgNbf87zxIpwMZWWtuSB
X-Google-Smtp-Source: ABdhPJzIDlLs3xDwB7grnfF65RD5o1sqfq1fweRjkVn7bc6ji4DUDLusHdyKRvAUfOaSa3FD6SwFUw==
X-Received: by 2002:a63:2603:: with SMTP id m3mr23293367pgm.202.1618176888510;
        Sun, 11 Apr 2021 14:34:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i22sm8992342pgj.90.2021.04.11.14.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 14:34:48 -0700 (PDT)
Message-ID: <60736b78.1c69fb81.9ac80.59dd@mx.google.com>
Date:   Sun, 11 Apr 2021 14:34:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.29-90-g9311ebab1b30e
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 155 runs,
 1 regressions (v5.10.29-90-g9311ebab1b30e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 155 runs, 1 regressions (v5.10.29-90-g9311eb=
ab1b30e)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.29-90-g9311ebab1b30e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.29-90-g9311ebab1b30e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9311ebab1b30ec960688dbd41ab90402c69283e6 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6073327d71cf0f3314dac6cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
90-g9311ebab1b30e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
90-g9311ebab1b30e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6073327d71cf0f3314dac=
6ce
        new failure (last pass: v5.10.28-41-g300d8849aaaa) =

 =20
