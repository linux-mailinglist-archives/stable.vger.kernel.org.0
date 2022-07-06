Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61345567BFD
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 04:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiGFCia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 22:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiGFCi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 22:38:29 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EAC18B34
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 19:38:28 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t5-20020a17090a6a0500b001ef965b262eso4159149pjj.5
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 19:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oMFbhoggzqL50jM24d34dlUJXQtmfXHFw5IhjO+Hq+E=;
        b=SxwIIm6eOmkR4qxqCfz/Wk9gSViA/UafzDIazz8Cj0vUx2PsT/KAOt+bI/Ln2I7rS0
         nfpTLSEcZCk75hjtKVZB0njrB8USjg0RGiedpLhZZDOXUDviJkGZsBQnAmNqoJvisNV2
         tWWPGZ8T9H6QMmFx8ZMuM1c82Euc9GJwLv6iB/+jeZwVcSO9xRgOAN3TLTB+igykn6VF
         VflRQpBvPM6HNVV1l3k7h4ItfWoVtHLXf27Iotlu7g9HSyZBPtJcG7RVRscAeLzK9Ozv
         i5He9FjKz8rKfZX0iA8mKJEFCa6207GjtMkozAsJ4v9iueyNWbkFOcfA28ZplzSwapi4
         ZSYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oMFbhoggzqL50jM24d34dlUJXQtmfXHFw5IhjO+Hq+E=;
        b=Gu+T9x4gSIToii613ZhCs2SZgQbKQhoAtWFNq/tdMqBrxaLJ8IXNfWxTRssEJQKBdy
         qGkgHpZUyqT8RUTOm5ncEoHWmS5ibkPIdmAw+K7jKsIdtNytmOIsDjI9dUudznNFNtVI
         WbgypIL/n99E2qVjoRX3RZ6Jxbe+f94TMVp2PYyomN8Z2tEZY2qeNFL5EsmjmF7eAppL
         +/O41JL5sFt7u+wB+c4Yh+G0CKSPXSuyE3h1HUVoh5ndbh9GiUEmX6a30deytxsAs/uk
         G+nLU/F43uAN1DTrU4XDt1MH/i3S8hVshj3BRZbXshqZAyTTyxL2bwFQvhdz+LrkLpj7
         zVSQ==
X-Gm-Message-State: AJIora/lW5jfgo8klMrm6RJBSF/yolUtt84s660e1umF3NG4HI8oH16P
        R6n+MAj0Np/9KnU6xT6BGsjlYgLklV9hDYVu
X-Google-Smtp-Source: AGRyM1sQrXqoFG1kRCDgeB9+SftEGfJgjD8KqaFRkbS3PS8GdMsNYvHSr4hpkkagOMGsFjha+/oYLA==
X-Received: by 2002:a17:90b:3143:b0:1ec:be03:e0a5 with SMTP id ip3-20020a17090b314300b001ecbe03e0a5mr46930693pjb.30.1657075108060;
        Tue, 05 Jul 2022 19:38:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709027b8f00b0016230703ca3sm23908477pll.231.2022.07.05.19.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 19:38:27 -0700 (PDT)
Message-ID: <62c4f5a3.1c69fb81.93226.31ed@mx.google.com>
Date:   Tue, 05 Jul 2022 19:38:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.9-102-ga6b8287ea0b9
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 151 runs,
 2 regressions (v5.18.9-102-ga6b8287ea0b9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 151 runs, 2 regressions (v5.18.9-102-ga6b828=
7ea0b9)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =

jetson-tk1         | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.9-102-ga6b8287ea0b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.9-102-ga6b8287ea0b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6b8287ea0b9d1bc51361e370ceff498c9c02937 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4bf232d440700e8a39bf4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-ga6b8287ea0b9/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-ga6b8287ea0b9/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4bf232d440700e8a39=
bf5
        new failure (last pass: v5.18.9-96-g91cfa3d0b94d) =

 =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
jetson-tk1         | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4bdabf41f050feda39c2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-ga6b8287ea0b9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-ga6b8287ea0b9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4bdabf41f050feda39=
c2b
        failing since 0 day (last pass: v5.18.8-6-g365d872fd167, first fail=
: v5.18.9-96-g91cfa3d0b94d) =

 =20
