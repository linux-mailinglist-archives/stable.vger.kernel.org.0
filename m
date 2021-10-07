Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF7B425871
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 18:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242854AbhJGQwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 12:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhJGQwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 12:52:54 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86373C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 09:51:00 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cs11-20020a17090af50b00b0019fe3df3dddso5766822pjb.0
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 09:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fSbgU3ISBRgRlS1+YSsV/26S/a+IYBoftGk/kuNN+xQ=;
        b=NfsYGlANDwaLErG8m6NprncrHboq3GsyJopYjiXyd55ygkpW5v1zijdFeyzsFgwpwO
         V8gnL1sQ6KoT8m0duPMX8MVuFYbWxMhutlKPu2mVr4nFu6neKm4KfWhBAZy0QuHIRqUj
         8pLCdW5MBO2EagLtcKTQh7WBlhOd0AEVecKoAaCTE2KxsLM/EHKD0x8pNxiMzLbqzWN1
         gCzReYdNiYEpC2X0Aqr7LtGkVY9Diei2i/ZWiqU7d5gGgFedrHBvuqNNQJ4CboKpcSAm
         sg6GooZ1eUMV9fXHiScE/RubWkkJlhk7R5S3JORd+OsMdH9lMQI5j+zPOvBnmdh/UNvV
         zp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fSbgU3ISBRgRlS1+YSsV/26S/a+IYBoftGk/kuNN+xQ=;
        b=FlQ7NaswdOH08WqyfyegAR8SHs1e95OqMloXgmMkICDfbKGj7yVmBGHkq4PEGOymD5
         1a3GRh/CuT3N2lD66/eSfDaEZirIFJj1i7x3T6DIeIhZorXg+K0+oy9JSSsfQEWdyks9
         aR0tWNyiOLjKsaBHlKMwGqpk2JUpW6W25VMLgQdBjDPU17ZwJQTuWbr5C6Zc7oM0BBeB
         gpevYUWUG4hDywiS8rPl/mQ4InD4bf26RrFbTidit6Chjbhk+oBfssFt24b9lfMhDwBH
         1Zdx8FyCcsmwCU6hWRAljRAGtxXH9sWZjzmBpqZUHD0lkbhRqchsg+SUrsMyupkmOgo4
         pYJg==
X-Gm-Message-State: AOAM532YJDFi1UR/MMIJ5YUaEylCWyMNSYYy0RFHNzJlgSz6y4R30jVd
        DE3XFtW/MIFP573sfP5FQYrAB8cxyxuamBrf
X-Google-Smtp-Source: ABdhPJzXTTrs0MiL1/KhPIflk25jnkAaj3JCVkIzBsTD7tb4gjf7QcJmCimnPWwIP1NC4x53vnu6Lw==
X-Received: by 2002:a17:902:6f01:b0:13b:7b8b:84a3 with SMTP id w1-20020a1709026f0100b0013b7b8b84a3mr4723635plk.40.1633625459835;
        Thu, 07 Oct 2021 09:50:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b16sm115841pfm.58.2021.10.07.09.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:50:59 -0700 (PDT)
Message-ID: <615f2573.1c69fb81.7a61c.07b6@mx.google.com>
Date:   Thu, 07 Oct 2021 09:50:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.10
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.14.y
Subject: stable/linux-5.14.y baseline: 154 runs, 2 regressions (v5.14.10)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.14.y baseline: 154 runs, 2 regressions (v5.14.10)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig          | regress=
ions
-----------+-------+--------------+----------+--------------------+--------=
----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1      =
    =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig          | 1      =
    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.14.y/kernel=
/v5.14.10/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.14.y
  Describe: v5.14.10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b133f076639b918bb6ad157f6308b0f595058959 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig          | regress=
ions
-----------+-------+--------------+----------+--------------------+--------=
----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/615ef34642a96737a799a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.10/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.10/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615ef34642a96737a799a=
2eb
        new failure (last pass: v5.14.9) =

 =



platform   | arch  | lab          | compiler | defconfig          | regress=
ions
-----------+-------+--------------+----------+--------------------+--------=
----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig          | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/615eeedca3de08f45099a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.10/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.10/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615eeedca3de08f45099a=
2f8
        failing since 6 days (last pass: v5.14.7, first fail: v5.14.9) =

 =20
