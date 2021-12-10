Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3053D46F999
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 04:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbhLJD2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 22:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbhLJD2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 22:28:13 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8262C061746
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 19:24:39 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id np3so5878455pjb.4
        for <stable@vger.kernel.org>; Thu, 09 Dec 2021 19:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6pwxRvFUCn5UjGnBWg+FX96vKhtrEJ7hdxqL0ScYuZc=;
        b=1A76T/+qU3Vf0B3bpoFqS4tkHuLBCJ76OGKg/3p/oRxM0USQbRMr1Qkd4+bjKaaaZS
         eCThRc1XwsDDYeWaYhUCKaKMR4p2u7w+uHZLiysZnWSE/xfC2XorOfBWiHr54rx6x3ud
         JMXIFbHnLrzxBVRR2eG8YjhnFoX2HFeBOvjKzfZDWT/7JXXxd7LvJksYRgSgf/zIZuQj
         HbSTLV7u/BKTMKCs7w+so7tsQGImXNn3I6SNxgB+Tm4+7s3DjgT5wErPxXvhrZ0nm8Tb
         JGwgUkMUH+N3/fSIQGcVgCCLu4vZGRs2Kjd6NgVGzK6h4fYeEBWnCj7FLhaN3BlYM8bP
         i1jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6pwxRvFUCn5UjGnBWg+FX96vKhtrEJ7hdxqL0ScYuZc=;
        b=YzFLMItfEoxRiZ9LkWBP49b3Kgpw/SuKLA22QwV3wLvisLX5cTtBGf3IvN04Ci7AB/
         7k13iq/HjWQHvYcpydDtPunfParyGOYZbICwYKL8+7KMOToOUz8nZ2c++ZZTmARRugQ/
         geQDyAyw4BY0RQbLgqc/MkgIX0N38RN67sN8igi6UvXHZRcorKWTegYXBmo7TW1anNpb
         XdqE0b/aot4VUs5fw0Hedhj2F2niI6GSXyM+dEQ5AieyokvmUFOLKv8xtPa1+JZI9FWQ
         HRbw0KtcsUJbx51P0VtHJams/gakNGzgBApV5R8i9ofr1dKLW3BQc/In4RHqF9d2iDvK
         dWhA==
X-Gm-Message-State: AOAM531R0ZR8fusGGZ7A2ephczCuvWgbKrPXhyze2HXHyw72vldyu06c
        4CdleTyZTVAyLa0J3rfjcFVqtczViqrSdszPI1Q=
X-Google-Smtp-Source: ABdhPJzF/gHog/mU7IWhfNXljNMSBF6ZU+sTCcIN1ccrAuH3MG5YPT9hwMnLEQvq7nhUnAKJS7T+dA==
X-Received: by 2002:a17:902:bd87:b0:143:c6e8:4110 with SMTP id q7-20020a170902bd8700b00143c6e84110mr72414003pls.23.1639106679006;
        Thu, 09 Dec 2021 19:24:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g18sm1101933pfb.103.2021.12.09.19.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 19:24:38 -0800 (PST)
Message-ID: <61b2c876.1c69fb81.6d79e.55f5@mx.google.com>
Date:   Thu, 09 Dec 2021 19:24:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.256-113-gb546adcd17c8
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 169 runs,
 2 regressions (v4.14.256-113-gb546adcd17c8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 169 runs, 2 regressions (v4.14.256-113-gb546=
adcd17c8)

Regressions Summary
-------------------

platform                   | arch   | lab             | compiler | defconfi=
g          | regressions
---------------------------+--------+-----------------+----------+---------=
-----------+------------
imx27-phytec-phycard-s-rdk | arm    | lab-pengutronix | gcc-10   | multi_v5=
_defconfig | 1          =

minnowboard-turbot-E3826   | x86_64 | lab-collabora   | gcc-10   | x86_64_d=
efconfig   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-113-gb546adcd17c8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-113-gb546adcd17c8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b546adcd17c85e99cda49080c7607ac39b96d9a5 =



Test Regressions
---------------- =



platform                   | arch   | lab             | compiler | defconfi=
g          | regressions
---------------------------+--------+-----------------+----------+---------=
-----------+------------
imx27-phytec-phycard-s-rdk | arm    | lab-pengutronix | gcc-10   | multi_v5=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b292e58e8f1ecbc3397143

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-113-gb546adcd17c8/arm/multi_v5_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx27-phytec-phycard-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-113-gb546adcd17c8/arm/multi_v5_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx27-phytec-phycard-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b292e58e8f1ecbc3397=
144
        new failure (last pass: v4.14.256-106-g42fb555ea765) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g          | regressions
---------------------------+--------+-----------------+----------+---------=
-----------+------------
minnowboard-turbot-E3826   | x86_64 | lab-collabora   | gcc-10   | x86_64_d=
efconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/61b293e11f8cfc5a61397145

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-113-gb546adcd17c8/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-mi=
nnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-113-gb546adcd17c8/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-mi=
nnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b293e11f8cfc5a61397=
146
        new failure (last pass: v4.14.256-106-gdcd74d7b3f01) =

 =20
