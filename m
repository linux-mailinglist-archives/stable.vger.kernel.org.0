Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A113E2800
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 12:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244496AbhHFKDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 06:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbhHFKDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 06:03:13 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D0DC061798
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 03:02:57 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u2so6371304plg.10
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 03:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zv1NIHHXuSO6MPXPah1BOXvqyNlUfMCKLSv6XwYDJ9Q=;
        b=YkncIXAmKTZy4zoxEwrWLILbh2zmvIX5z6/J+BOntvNSoFA1JmjCkLJFMewpQc+E/D
         1uHrSddLNQWMCeEA/5/NoMqkWroOoLYUjjVOpSP2hYcCZyIk4fo7j0hbT94ZBF6DBvog
         5r7qCSsEqrjA/ZK9i3zJECR10L865jKe5ztH9/ZWjYmhltpAX6VNT74IjDxGrwZCsfsW
         VkCQ25DJgHIquJPU/Ibm+pXBU4OPpfoDAvXNs8qmYho03P6e7riOZB6eZNSwVfZf/jGj
         6GgD4WGhUwDGgeao4W24odSbMj+VSe/hSCfbjDMQVxT1uknrKNR6FUw9lMcQpPlVnnyD
         fSSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zv1NIHHXuSO6MPXPah1BOXvqyNlUfMCKLSv6XwYDJ9Q=;
        b=PmxoAW0xjQ+00mO8mfXhR7L3M4IMOwLHOhqmttOP0QjVe7EcWQGFdZlnOTrld1/fFV
         wrWiSHQ1B/ZL2PczlKJ+Iz8zsk4Z3zwf5wQrP4w+x29LFlFvZy/GFCsdtejgZo1LS1zV
         Ce7uo4ruOrY4KnY4sWqW7ieD3IdPxVvb8SV9Ydx2R+Uz05TYV46o0qv1JhJFr70qR2Le
         blnSX7KS0ocO1g7QBkiEZ6m2X+JPj8RVSePuhy1W9e7FsOCBEk4muxnupy6xpBU7nvQu
         cM7ZZGvNHx2PWnQ8cRUpdcCsUwz9lSNx95Sxvq79F5OdL4Ne/Z8X9Cy8UhXqWIGOhqUY
         tSjg==
X-Gm-Message-State: AOAM530W4pEbf7e/5+xiPho9OAQ81lPZ8iEIyGdk+dNwiqVM6y+Q8oVI
        Ft5nZ6eSblmxHzzY/RALY9OxVdCTzOP3oQ==
X-Google-Smtp-Source: ABdhPJzR48P6AYpP4gY4M8BYqKe4gNuzPjmsRXauMQ5MQM/v/HpCwdFdRynfk20oRAxNKgg+uNFlEQ==
X-Received: by 2002:a62:ea0f:0:b029:319:8eef:5ff1 with SMTP id t15-20020a62ea0f0000b02903198eef5ff1mr9989424pfh.74.1628244176928;
        Fri, 06 Aug 2021 03:02:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z14sm9955973pfr.121.2021.08.06.03.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 03:02:56 -0700 (PDT)
Message-ID: <610d08d0.1c69fb81.21c8a.cfc4@mx.google.com>
Date:   Fri, 06 Aug 2021 03:02:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.242-7-g4bbd5ca11953
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 109 runs,
 1 regressions (v4.14.242-7-g4bbd5ca11953)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 109 runs, 1 regressions (v4.14.242-7-g4bbd5c=
a11953)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.242-7-g4bbd5ca11953/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.242-7-g4bbd5ca11953
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4bbd5ca11953dc9887b678dcc3df51edf3ab9dd0 =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610cd715d9929a90fdb13671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.242=
-7-g4bbd5ca11953/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.242=
-7-g4bbd5ca11953/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610cd715d9929a90fdb13=
672
        new failure (last pass: v4.14.242-5-gc92cb2563574) =

 =20
