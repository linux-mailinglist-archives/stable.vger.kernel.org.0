Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126C665AE9C
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 10:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjABJU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 04:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjABJUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 04:20:54 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F83DCF
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 01:20:53 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 18so6130978pfx.7
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 01:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FDYJWOElJWZlEnHJQ4/2TazFVdr8kUIN6moBBwixKuM=;
        b=3dEXdJhVHPQJPCzT+LD8szgwwGtpxpet6Wq1xD8qNydVJDfKFLArLsyP3nXUlJQ+pa
         onSnmwvswM2DoGJcg9HiJtDXzq8C5m07CLYcarg7DUzsYdBVarPn0hpgbYPg/inrbPKl
         Zql3ahcuhzvLj7mQ3/s2CcUF9op8FGd9uWqhBRpM1PsQjWVjRR7GwxXzhuMgCEOXdYw8
         keJduHdwUWBo5JswievA4Zcw4sCzygUYTqwjR6ZF4NnAPuNG+q2LwaDcSjZx0OT75pEG
         HjFz+AxsI3z8UlegCdxT5I24fjJTR3wAWghh6cIDPTzVuROufL0XAwZElzRrieUy/FUZ
         7GgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FDYJWOElJWZlEnHJQ4/2TazFVdr8kUIN6moBBwixKuM=;
        b=zKgOp8YN9JB5xNhqJqDLaQAHTL5OridoRvHkghCW0RGb2EX4/kjHIBgOiAJImrTaCc
         XH+3g98tTmHVOG2nl7N1e4jN6iOmtNkB4uQaedrvnbpRgRkx+gq8+/yAoVRFJ89XzN2K
         3tsN6cJiZH9kU50YR3cqUcNUTiaha5j9Q1h3bKYWnj1poXtT0OB1ghjl/AvkvsowN70G
         EXuToPFCp62jUGZuav4Q/YFctTmeMGfUmmvd7/ZMCEZA6f99kV7v3t4d2rhqfVIXxrwU
         fMJajsq9gJXCT1Z+h51ZqnY4VR0ojUZVwTh6W6Xg/OR7q8ccdGGCyWkQlg3MvhC+6znx
         BkvQ==
X-Gm-Message-State: AFqh2koTsRTaU65/GKt4JA2daFiFoCs2FV7aqWMf3SkewJgp2MZAi9ql
        LApwkYWxTrS1qj9P3tvqQ8zbOB3fxCSUn6YnVCM=
X-Google-Smtp-Source: AMrXdXuIa3Ijmz7NxAcZxoQ9Q+IvkqKw+2gCAMJdQsmvfqpLzVLdG2p5dYaeEhhOVfxjy20gg3MYng==
X-Received: by 2002:a05:6a00:72a:b0:57d:56f1:6ae7 with SMTP id 10-20020a056a00072a00b0057d56f16ae7mr35908019pfm.33.1672651252869;
        Mon, 02 Jan 2023 01:20:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w5-20020a623005000000b00575acb243besm17962410pfw.1.2023.01.02.01.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 01:20:52 -0800 (PST)
Message-ID: <63b2a1f4.620a0220.b4443.d068@mx.google.com>
Date:   Mon, 02 Jan 2023 01:20:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.86-36-gdb12b47fc012b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 143 runs,
 1 regressions (v5.15.86-36-gdb12b47fc012b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 143 runs, 1 regressions (v5.15.86-36-gdb12b4=
7fc012b)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.86-36-gdb12b47fc012b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.86-36-gdb12b47fc012b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db12b47fc012b576dac136a8a2f8c2def937ad8a =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63b2712d52d766eb014eee24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.86-=
36-gdb12b47fc012b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.86-=
36-gdb12b47fc012b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b2712d52d766eb014ee=
e25
        new failure (last pass: v5.15.86-3-gc97485fefd33b) =

 =20
