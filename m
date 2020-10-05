Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC10F28430D
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 01:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgJEXxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 19:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgJEXxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 19:53:52 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C44C0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 16:53:51 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id x16so6964015pgj.3
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 16:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4RjX+QI7+LjBlNcQtRCH1dwrzX3yD5BN56LFQInnjJE=;
        b=chqfBQ56FyrvcLd31XpskP+jszpF/khzGHlosguvxyYyV1EMB1wJpQz2nFiysMd4+V
         wRWzbT+7CqLL4yqelrc1uQ1hV5yBRLq0IqNTs0GivxRZt8S5ba1zqB+uUiwZOsn/2YfE
         SAzNDlTLfAxiN5Czo1TeRHMCInDoUGu5QMC78u9ACNmwJiVglza8X6hvcx9dkvOM/JYY
         Of4Z0LcChMg2EkZuwTIPoAOxg0nmb0bHuwIAzmj3lXKXnciYHAwwX+5GaNqByS0enY48
         LbjU19NCzGLYl48WPeyNiOm1iU0O27rw+Frsa247knrlX+SfqMqN4TMQY9B0MblippQj
         mDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4RjX+QI7+LjBlNcQtRCH1dwrzX3yD5BN56LFQInnjJE=;
        b=Kxj/Di8AzxRO2ja8EItWfubuHH+qW54wNtSFQsYYX/4Bst9lgXfmO0W6rUFtLLxRt0
         5jqQvO1xhhpEboAQIWSAQpDGDEyLDq5g4wLgrKALgPx0xSw/pNak8g2soQK6+HcBg+cv
         nj38pohapY6+dmeJsj3AVoUQieV/oDb2MAyB6xc3EIeNiTAs59SvCuFoXjsODy36/vLV
         fWmkm2ovcWHMOg3JjxHtssFO7fySIKvCWMd9IZWNS2OWxXHQqQ3krvsxIUO03/vkbxJu
         3A/6XLpfuRD42B4mh6nL/DMVBC2tJ6F/jpOjAJtEJaxPbxohE9ad5udrSt1vhH3AhLqP
         YfTQ==
X-Gm-Message-State: AOAM533pNMJG/pA/eNIT3YYiK4JhCmlfthttT4yAUMTInDaSNyHttgq9
        pfnGBf1wfmGzmLiK7P41m0HS82xjM/j/iA==
X-Google-Smtp-Source: ABdhPJxt18aNIgu2YZs2yoKlhA5/1bOcI4DJroWvTwu+sY/T0OYlRZIkCU+3kgJbSgfz7VYKYhwXog==
X-Received: by 2002:a62:ee10:0:b029:142:2501:3972 with SMTP id e16-20020a62ee100000b029014225013972mr1878171pfi.55.1601942030194;
        Mon, 05 Oct 2020 16:53:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t3sm760842pgm.42.2020.10.05.16.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 16:53:49 -0700 (PDT)
Message-ID: <5f7bb20d.1c69fb81.1c9a5.1ea7@mx.google.com>
Date:   Mon, 05 Oct 2020 16:53:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.238-17-g258721d49aab
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 87 runs,
 1 regressions (v4.4.238-17-g258721d49aab)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 87 runs, 1 regressions (v4.4.238-17-g258721=
d49aab)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.238-17-g258721d49aab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.238-17-g258721d49aab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      258721d49aab765aecfee41f0c48342501ecf590 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f7b7ea467001b830c4ff3e4

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.238=
-17-g258721d49aab/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.238=
-17-g258721d49aab/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7b7ea467001b8=
30c4ff3eb
      new failure (last pass: v4.4.238)
      2 lines  =20
