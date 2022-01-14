Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AA748EB17
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 14:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241453AbiANNth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 08:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241439AbiANNtf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 08:49:35 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F496C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 05:49:35 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id g2so2822936pgo.9
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 05:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ou+RLF5tdgm/iNHs/9s0v3jKB07NChrzZcVaOhkXhIk=;
        b=CtqxAA8+Y6OMXhqyayNonrCDPHmtXraZrcm1jtd2wV6wie2w+Qd7VNO0DEn8PvzUcu
         g44TnJ4Ms9hoa93ZZ/hw33daqWeYpYE0jttwIZTGaDehsKxMFEsEg19xkm1zJICOokgB
         mFhmL+Qk1MFh83F09j5RsylJQFApypIa9yv47Uz6nnk7LAKsrHL9mxzajyzytDwxkZwb
         6b0dcaPCWSa1qPbznGIJEuPkURXPMcaI1BcaoI3D96d+/vZsNwWrPMOJnto/vwEUo2jI
         /0h49QXKr5PSs8ZxqMMJyyu3j+vDMF022jjPkg7W1328r7sfOBcIwSHBtw6zHbGE4jC2
         6xgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ou+RLF5tdgm/iNHs/9s0v3jKB07NChrzZcVaOhkXhIk=;
        b=y3u43Z8V6fkQQQFh6vXZ6Vouze2IDZ8c6EAWAJ+268OfxLYz0wFM7RULGCtgyh/SnS
         Q70czvrh6Ylg4Es/uzZF3bNiwuC1QY6642MLVQlsGWo3t9mTpm5WD/+Xs9BVEXtutikf
         bqF+tqBggu7+dzcp9+qu1zJwVZJgbkFWgqHS7CMSi/RtzOrg11HvNt2svZeBBpuPRgpI
         OYzHtiUr+L7GiaajvEWfLRAUNx9wRQ/reuJLVOAFXNdtLYw5ha3mKCFcMNOtc2F03NCc
         QXfJ4uJcdD8VFXYx5p6ZKnoCVga/E1AUYXR4hayR29lKoSxEWpuefTV7s05BTwF+CpTL
         Lo2w==
X-Gm-Message-State: AOAM533ieAYXkR1CnCP7TlpTz0BoTeY+Zj1C4dvlsmwq3xvoDKukuEXd
        Rmnx7i5vNEpsR+7go+mTNrayoC2RuTF4FHOv
X-Google-Smtp-Source: ABdhPJzlpDUoyIoufSoxx51boydcuiesVnn2AnaLfyVh1xk4s2lyt5kedChUnymj1g8vqG+xcaDDJw==
X-Received: by 2002:a05:6a00:26c5:b0:4bd:4ad6:9c71 with SMTP id p5-20020a056a0026c500b004bd4ad69c71mr8989787pfw.45.1642168174732;
        Fri, 14 Jan 2022 05:49:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y4sm11370083pjg.43.2022.01.14.05.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 05:49:34 -0800 (PST)
Message-ID: <61e17f6e.1c69fb81.88206.d97f@mx.google.com>
Date:   Fri, 14 Jan 2022 05:49:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.14-41-g89b979886f80
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 155 runs,
 1 regressions (v5.15.14-41-g89b979886f80)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 155 runs, 1 regressions (v5.15.14-41-g89b979=
886f80)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.14-41-g89b979886f80/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.14-41-g89b979886f80
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      89b979886f80154aa61bed1cf4a210aeeee6b396 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61e14d2b98b068a76fef6742

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.14-=
41-g89b979886f80/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.14-=
41-g89b979886f80/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e14d2b98b068a76fef6=
743
        failing since 0 day (last pass: v5.15.14-30-g61a4fd6dbce8, first fa=
il: v5.15.14-38-g674c2698ca85) =

 =20
