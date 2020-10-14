Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120BF28E118
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 15:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbgJNNR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 09:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728420AbgJNNR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 09:17:58 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69417C061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 06:17:57 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 10so1974996pfp.5
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 06:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FHulKiEl+BZq4+SnWiPZyrn19J2SK+oTq7e8y2Hx1PY=;
        b=l9IgEnkOCQuxXB7vCBec+9D1RlL6xlEeiTkz1045IcVkUFyQjtyWLGAWcsEavZ9AVJ
         uMxq16VYS5GAlIcgmqqscnSXiwvgSaFGVqreeMQ1vQTUUwuM4AgM41gc3mwiE0s4wHjH
         h8QnRcz6xMlBgeydwWk+HUoMiBaSv1O0Gk4q0WN3mevJtzLYhiZr5KNHxIn1bwY6CRJR
         hUC1M0UczBI4uP8E7au2pYNUqDXjsaNW0OzLJA+7Ofj76qLmvUH6glDOk+no13tnjLTp
         LQdffYBUQgyUyN8InxTKg6dC8KW3J88tSGvHySuFL5XIwIMYzBF8agP+ZPysPJiulZAz
         Cg1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FHulKiEl+BZq4+SnWiPZyrn19J2SK+oTq7e8y2Hx1PY=;
        b=KZkhyOY1W5zRctpW3LrhjNZkrqzfsDYCjmE47gl/Jt3LzbZEn3pjPB5oETMREURoCE
         sNCQJv4qXLeIgTDMQCfmYwaqH1qlz6KEWIo2TBX/ZNZHDCeFhELONCj0oat58TCm+3qA
         WEstwwczrZKcBT3pfC9cP7HON7E3xP67jZmesHLlqwR9V3qVmIjw5kHZAj4epbJrWmFs
         spnIwYaoa5+HNPApYXBr3COYcL7x5qJuSvGyG9f2fSdyuZ1CtjNMMk/u9oDD/hNzHfN+
         UiEJi04GeFo9+ygf5TT+V5niRrgBXO5rEL7JL05WasRaxJHXQVtHrBqRmouorMyhIg95
         kbhw==
X-Gm-Message-State: AOAM530uxmoBJH00ATzhjpqKqC0nBB0SvjpCmzwYG3Wkq3a7k+QyE8XG
        3CEIMbgsbz4Tq0621GSTAq1p+OYM7PDwHQ==
X-Google-Smtp-Source: ABdhPJxVjVE/wgllYT77mjf00u+9+yt19nvH1EUvxS53mA0B+UEdzZEGxdxImEAg0tU3YSKhTIlBdA==
X-Received: by 2002:a62:e104:0:b029:152:4f37:99da with SMTP id q4-20020a62e1040000b02901524f3799damr4382280pfh.17.1602681476671;
        Wed, 14 Oct 2020 06:17:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21sm3280178pfn.173.2020.10.14.06.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 06:17:55 -0700 (PDT)
Message-ID: <5f86fa83.1c69fb81.6cb22.69ad@mx.google.com>
Date:   Wed, 14 Oct 2020 06:17:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.70-85-gc647c27bda05
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 112 runs,
 1 regressions (v5.4.70-85-gc647c27bda05)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 112 runs, 1 regressions (v5.4.70-85-gc647c27b=
da05)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig       | results
-----------+------+---------------+----------+-----------------+--------
jetson-tk1 | arm  | lab-collabora | gcc-8    | tegra_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.70-85-gc647c27bda05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.70-85-gc647c27bda05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c647c27bda05d314ab0124f25dcfb4943b6fb83f =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig       | results
-----------+------+---------------+----------+-----------------+--------
jetson-tk1 | arm  | lab-collabora | gcc-8    | tegra_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f86c2b1d4594b95144ff3e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-85=
-gc647c27bda05/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-jetson-tk1.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.70-85=
-gc647c27bda05/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-jetson-tk1.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f86c2b1d4594b95144ff=
3e1
      new failure (last pass: v5.4.70-85-g71d398be4665)  =20
