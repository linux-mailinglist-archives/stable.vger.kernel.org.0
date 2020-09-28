Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DE427B6B0
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 22:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgI1UwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 16:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgI1UwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 16:52:00 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F934C061755
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 13:52:00 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e18so1967179pgd.4
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 13:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RCcgYZ0mi4sLxs+FHWUzUCJgQMVekMLT/l1uqCIRaWc=;
        b=qJMsH1I4QYDCcejuTBWJgjbo4fuXyXAMJ4qKwu3Ls2y6BRU7xRUm8+tepCTfCxx6En
         5P5ylud+tYdlAN91d4Ck3S8M7l36qbjcL3gCJ2xOXh5CL9SvUyb1l2daAyQUtjrUmPwe
         LrnHrhKVhIz3x6GfKqLw0MUh860aU8g6hrNX3EOPqOgYtDPlT09yjCiYt1usNlFzacc/
         eF15eyrKO7W/ApPNAKLXaYfV0f/NbvK+VPffsxx5ZVCUiQxMz+oxWpI59dEY32KTZR7O
         VlQH/b34/8vBBvoBDVwr4FITrHeJmzYXXdhVNtMjnTnJ0dOuQMsm6CNm2DXIQNOmhYTY
         p35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RCcgYZ0mi4sLxs+FHWUzUCJgQMVekMLT/l1uqCIRaWc=;
        b=Q7F2QgvvTqqgPf3StNLzbUCYctTEMDB5krSPiROWxPQQaO/hc/rmPg4ztmrfK4qDvo
         zIs7uOjfkfE9A8PzAlDBwfj+DpMjQNNFjD/OD/2XJBgMeVZg8+S9EEV0HehH/lfqaWJ5
         2CKdd3IBZiO9MDSrVlf/JIV56v/kPTSK/ChtWhVw22BemZB6OihBff5mnoarKacJkaLB
         cejWm3JZH8JioHHYkPmIf89851NPCZyWViyNq7DcAPm1ZKxmpjKxxgv7Y9vku+PpMQpG
         WpVAb7xIkrvcNtSAULycBv2hwsmsGBnb6YW3AwzU5e+3e7R+Y7IODkCx74LHQOmn2Oql
         ZMhw==
X-Gm-Message-State: AOAM533Z9KGugNrmCANBYlxtK1aUdtkCSNH2NFdKYgH3FfSdVoMSo1cV
        mf8KCglEWnAYY1zOW/KL+GPuhuT6y1BJIg==
X-Google-Smtp-Source: ABdhPJydWrCz9t5DzWfiZ13em93c6X78DA93us0nq/0I+JO3Ohe0ZDCKOt3phXrU4AiQ1HFfNGJqtA==
X-Received: by 2002:a17:902:a502:b029:d2:8cdd:d912 with SMTP id s2-20020a170902a502b02900d28cddd912mr1165011plq.45.1601326319639;
        Mon, 28 Sep 2020 13:51:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h12sm2501500pfo.68.2020.09.28.13.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 13:51:58 -0700 (PDT)
Message-ID: <5f724cee.1c69fb81.b48af.4f9d@mx.google.com>
Date:   Mon, 28 Sep 2020 13:51:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.148
Subject: stable-rc/linux-4.19.y baseline: 170 runs, 2 regressions (v4.19.148)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 170 runs, 2 regressions (v4.19.148)

Regressions Summary
-------------------

platform  | arch  | lab           | compiler | defconfig           | results
----------+-------+---------------+----------+---------------------+--------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig           | 0/1    =

panda     | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.148/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.148
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      10ad6cfd57360760116cde00a8ef756e121367a9 =



Test Regressions
---------------- =



platform  | arch  | lab           | compiler | defconfig           | results
----------+-------+---------------+----------+---------------------+--------
hip07-d05 | arm64 | lab-collabora | gcc-8    | defconfig           | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f72172bd27690a4c7bf9db3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
48/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
48/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f72172bd27690a4c7bf9=
db4
      new failure (last pass: v4.19.147-38-g1e68f3302e6a)  =



platform  | arch  | lab           | compiler | defconfig           | results
----------+-------+---------------+----------+---------------------+--------
panda     | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f721c4022ba416543bf9df0

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
48/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
48/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f721c4022ba416=
543bf9df7
      failing since 2 days (last pass: v4.19.147, first fail: v4.19.147-38-=
g1e68f3302e6a)
      2 lines  =20
