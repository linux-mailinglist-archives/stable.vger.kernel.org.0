Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B3128AA97
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 23:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387399AbgJKVFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 17:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387398AbgJKVFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 17:05:40 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32E4C0613CE
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 14:05:39 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id j7so1396033pgk.5
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 14:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Su0E/bYoD3n7UQqCYT4fPk5vyn+127U+Qp+9b+91yHk=;
        b=XGxiT25StGDMnvfl697T+nucvdLOU2bB+T0NlNqklMtFB54vArnnEC+eY1WFe/YS0V
         v7dhT520+XX6+4m+mKQwwN560HaAGGxSGCVkXc2NJz5NajEdBcRijLuUAsxGVm3QGd9p
         QaO3oLIfjXMwr/6iTA5RzK9nY/XJq6ke27/hJBDuXLkcSp8VVXp9kvdPm9kaXA+xL0Kk
         ZGqX5v/TXKnzvSu00qhWE2nzOdROT5mI+kI84EhjXzn7i/ABJk7Cr1WMd4u09jwg5pj/
         JPglAzOvW/iPN7NZWoqqp9x5vj6+YSiLp+U7VpDN+6V6/oAiuWhHamArHEj+qjX/ALBq
         74sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Su0E/bYoD3n7UQqCYT4fPk5vyn+127U+Qp+9b+91yHk=;
        b=fk5AEpJHfthtawSRGOrXAt9UHcjmZ8Ml8rnxIoO0WKB0npVHT4kvqAvsjkCsVqfyy4
         I7qfghxoNKwVLm3/UOR9ujOGews5olbe6leRjWqs+h1kahP/wR8FtsvDP+DRLerD7ILx
         Yc+Q1CDWxXe92pWsTpLWLFiyTMo1hhR+5N5dTNFGeYyLW3/SVsI8Mioc8JKEgeQY7tm4
         Fjft6M1O4OIzQsW1KnxKzMK1ubS68NoBzT/sMHUS5IZTFDslgTnqEdbLaLnpi/3AVWQU
         8DkjTbBYJtLHGJ0NLIRvdke8g5lJMb97xYH0q6BWXTlzHmim/LxYJlFGu6iI9iqyomks
         nr7Q==
X-Gm-Message-State: AOAM532X1FXLCepIk42twLIMNZ+v5+9YZZFgSV2yifsyNpMiqvU+P5ux
        lNMxIwLR1nkcoi7SlGcvH4PFlCYRZj6hAw==
X-Google-Smtp-Source: ABdhPJx/5EbzI5AiE5W/mjGkBm29QPvApCml8j51BeaiA3s5kzabzsbWkIjXqhL0Vj2M31367FhOXg==
X-Received: by 2002:a17:90a:1704:: with SMTP id z4mr16208576pjd.7.1602450338920;
        Sun, 11 Oct 2020 14:05:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w19sm18433031pff.6.2020.10.11.14.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 14:05:38 -0700 (PDT)
Message-ID: <5f8373a2.1c69fb81.a86d1.36a8@mx.google.com>
Date:   Sun, 11 Oct 2020 14:05:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200-52-ga168ae016734
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 124 runs,
 1 regressions (v4.14.200-52-ga168ae016734)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 124 runs, 1 regressions (v4.14.200-52-ga168a=
e016734)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.200-52-ga168ae016734/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.200-52-ga168ae016734
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a168ae016734b6fff48b64bfb075e62dc28ac392 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f83379b5e777ebc524ff427

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-52-ga168ae016734/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-52-ga168ae016734/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f83379b5e777eb=
c524ff42e
      failing since 1 day (last pass: v4.14.200-39-g650bb80f17b6, first fai=
l: v4.14.200-44-g1bef439a8958)
      2 lines  =20
