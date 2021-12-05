Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD43A468DBB
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 23:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239429AbhLEWiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 17:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbhLEWiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 17:38:50 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC92C061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 14:35:22 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id o4so8384191pfp.13
        for <stable@vger.kernel.org>; Sun, 05 Dec 2021 14:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZqoHG1SSv3HbxRmdHsHlT6pJywP6X2E45okusrgilQ4=;
        b=DsIndmFu5rmV9wHvbWqt/geqbxFZ+MWVJCv2Q5Xyeb1q1DGBAUrslkBtWJi+POe8jG
         7so3/CR90osWNuiyaNhlEd/z+rx0Q6NZqeykeuWSto2Hq4njC6sK6dIjUMgZQWcV5kWj
         jVCl4NNR+JAvvYryM5Td5zEFoQXysDCKhh1ar3OoBxdgKCI7bsFciFlvytYlhIWj8F+1
         40+qAzQDz/7Qh/DwEkYZg2U5dJL/4kHHrItTwDLaznYQQboDPoB2vlsOs9MVfw4Wk9SJ
         hAaOTRN6Bj8nu9XtHygJ8Ry1M88cJVxG62WzXs3Xq/eG7qx+WQO/umFu30VqIHLwMVVq
         05Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZqoHG1SSv3HbxRmdHsHlT6pJywP6X2E45okusrgilQ4=;
        b=8IudDcUW/eiOSnlE/XfhEYB2kmRCNzAEmbS1HhVvJZ5kE7r7caIEJmezn4C5QzNZhX
         EHfBGkRwviTnSsPBKsKcbmDrMPJAv3h881GdptD5RFVNhROHhOdH2kAI4eVs/TEC0Ufr
         eOMaWRNvF4xazIOOQybrLwKP9EY0LEfRfWL/3WEbI2I9/6tJ9Vm99CuLyf3qvrFzx0r8
         zoAr+fd6AnsZAR+q0Qw1snN7rphRz43IWfKRGIevmobGzjUMyMb4CBDunN9TXQ1/kkIi
         AjVj6+kjQ4IzXZJVKvRejdB30O96mq7sdGSTM6xeZQk12Ve5MDl2rjxoAfvvNQfbDJ2o
         JxIA==
X-Gm-Message-State: AOAM532prcM8B07+aj76K2WMcMEtspTZkcV3sQXsauZrWlk/3EZ2+Kyz
        BND/R5BSdii1fuW9DcpJDAyMUf4F234MOwxg
X-Google-Smtp-Source: ABdhPJy/16qqjnACIgzvehYGMpHn8iFBUxZ3iHlX4ZyrbP2L8u9Irwkefe1MPWnmN6zdF7E6whUDPg==
X-Received: by 2002:a65:654f:: with SMTP id a15mr15962451pgw.195.1638743721773;
        Sun, 05 Dec 2021 14:35:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n6sm7926247pgk.43.2021.12.05.14.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 14:35:21 -0800 (PST)
Message-ID: <61ad3ea9.1c69fb81.7f108.7bbd@mx.google.com>
Date:   Sun, 05 Dec 2021 14:35:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.83-102-g6fdd7c5fe47d9
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 146 runs,
 2 regressions (v5.10.83-102-g6fdd7c5fe47d9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 146 runs, 2 regressions (v5.10.83-102-g6fdd7=
c5fe47d9)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx6q-sabrelite         | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.83-102-g6fdd7c5fe47d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.83-102-g6fdd7c5fe47d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fdd7c5fe47d93f3dd024bc977dcc3c14b2f6a2b =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx6q-sabrelite         | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ad0ce043969b7ae51a949b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.83-=
102-g6fdd7c5fe47d9/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.83-=
102-g6fdd7c5fe47d9/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ad0ce043969b7ae51a9=
49c
        new failure (last pass: v5.10.83-52-ge7c3791afc041) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61ad0b8bb51e8c1d6a1a9492

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.83-=
102-g6fdd7c5fe47d9/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.83-=
102-g6fdd7c5fe47d9/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ad0b8bb51e8c1d6a1a9=
493
        new failure (last pass: v5.10.83-52-ge7c3791afc041) =

 =20
