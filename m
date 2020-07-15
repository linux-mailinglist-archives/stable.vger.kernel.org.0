Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05422204E5
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 08:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgGOGWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 02:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgGOGWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 02:22:37 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7D4C061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 23:22:37 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id j20so1641027pfe.5
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 23:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eRGzYyp3e2i0uaHheTjgAZF3qrl0CqWbOJLxqnPXDCA=;
        b=nKHOHB8qoZWGMpzAVcHuq5p5JKbJgxfqR6NUcg3uf1DP6pk4dvoxMWewUurQa+n6Qk
         ZCT9jBQ3HQj61a4ShYKlUUmSLtkDNgI35hBFBiSbIXzRzVq50PJDyRzfDWVxYQJ3rXgT
         l6wHVryiC9qOWQQKgTsMQ3IAfYBEH6Aom12Dm3lB9C9aFFiI16e+2Ue0z4J7FfiFYR64
         UjIkaTtPCwcKU0zLxnk74RkdEAWuR95NNDFMgoKesSwfDYCMgtKkfqGYqivNecQALrZw
         jxJiw8YcZGxBSOmqoQ4y+v6ZVtGmziOii6Unz7gDZDKpmJLc9karM1XRySJtLZKhQ9+m
         TIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eRGzYyp3e2i0uaHheTjgAZF3qrl0CqWbOJLxqnPXDCA=;
        b=TJneheRwJnXfASDREnPYzvi7hPCZeQF8mv+eK9rFov9d7o1CdjIp4w+oB47xEhvU7j
         bqfF2KLZCpmpsPJFOzpgeYZilRkWdcBtOqsdJ5tZkqw1OCKp+pki3fUY8LZCUE1PZCNu
         gpykhwwu+lMK722Ws0pABE+7l3Yk/S+TPx06id/g4dKxUDFEb8N6nwyLs1/+M62ugcC3
         jCWeqS3I2pQlsc93aWlOM+xEz61wFgKSRcg1Yhe3SP/vA/XzMLj4C2ENz6gnHD00yeA0
         YKeqpbEuCIbRa8C2NQk7iGN8gQS3v1/Wb9oX2fAm2hl0gsj8wd+vjhuaiIPjz1CdvA72
         o3qw==
X-Gm-Message-State: AOAM532lzWexVS9q2zz0PbQYphkjXs1iX4kI6hbpu+uN+IP47YvJGg7G
        i8rT41pU3ourRIBL3IYFLRpCPVRy7Sc=
X-Google-Smtp-Source: ABdhPJzFNCoitmS6xf+pYe7QZnwcyFURDTkvWSNOEcqP4n4keiuGQPfeA9opKkT19mcuV70qzoBFoQ==
X-Received: by 2002:a63:8ec7:: with SMTP id k190mr6521974pge.261.1594794156762;
        Tue, 14 Jul 2020 23:22:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x66sm1074055pgb.12.2020.07.14.23.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 23:22:36 -0700 (PDT)
Message-ID: <5f0ea0ac.1c69fb81.85398.3ce2@mx.google.com>
Date:   Tue, 14 Jul 2020 23:22:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.7.8-167-gc2fb28a4b6e4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.7.y
Subject: stable-rc/linux-5.7.y baseline: 60 runs,
 1 regressions (v5.7.8-167-gc2fb28a4b6e4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 60 runs, 1 regressions (v5.7.8-167-gc2fb28a=
4b6e4)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
| results
-----------------------------+-------+--------------+----------+-----------=
+--------
meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
| 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.8-167-gc2fb28a4b6e4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.8-167-gc2fb28a4b6e4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c2fb28a4b6e42b090d478b30aab47f3fef177964 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
| results
-----------------------------+-------+--------------+----------+-----------=
+--------
meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f0e6ea74ee0942abe85bb18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.8-1=
67-gc2fb28a4b6e4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805=
x-libretech-ac.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.8-1=
67-gc2fb28a4b6e4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805=
x-libretech-ac.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f0e6ea74ee0942abe85b=
b19
      new failure (last pass: v5.7.8) =20
