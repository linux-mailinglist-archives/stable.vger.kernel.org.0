Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7675D369B28
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 22:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbhDWUNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 16:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhDWUNt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 16:13:49 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55426C061574
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 13:13:11 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id y32so35917736pga.11
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 13:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=frFzQfRIxRdXA2Qra+S0h+GA3h6CGjwkN3TJGIy8Z3o=;
        b=zCBp7O6b7Vq1J4jDNT6D6wOKXeSQYF9/BU1cgZtMyNW8LZLbQErMQQlU42wyQkUuXR
         JW5Ys4yZmVVnVJmztEhqZt45g/DlctlrKcT2IsO8DrBX/vW3SI0A6kKHiRvSyxsVo2Z5
         yS+PaXtFeciswxeOz6+MPB+mEQ6gJG/vOVC/gRM57h6PEr+zslYnrPEF2h5ZgzmXAN3n
         mpBhGiWQlKNsej6TBmkQshMKdrYgYX1d6N+QEXJ1q/h8uO7g5/1+bP6lHAFW9L6Ne2lD
         CbYx8qbR0qQTNzG1sWu8c3vurVzde8YZaGcrIBfmjBT5AAKDwHj7S6rAF1WYZ0gf8iiX
         aPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=frFzQfRIxRdXA2Qra+S0h+GA3h6CGjwkN3TJGIy8Z3o=;
        b=GfralaWGfwzmfqm+JmfM72GY5vrCKmUNwcCXXmZTXGJQGZrWoMzGeiHD2bWQd9iUiU
         EZgy1Ty6QG3PFnKcWvQQb4Iaat3UeBLt3hFA0HOVYbxNlzRVVU/fqEpmPSbEGvkyHyB2
         Y2cshkAnlUzVRMw5vkpDAYGeyVPfRXItSqaNBe99//9ZVAGAKtYD9ScFr+wpuVRy5SAa
         m9NFFnoyzw74bQZcPphr1JixQOcfswsbm4UJmRW9UlFbcoak04Sx3MXAerNVxfcqaVet
         ekp7GOxuSKzwNCubQxuln5TvkRo/cuG0VoUMrCCqosfQg6wmXVbhf6xwqiJQUkUCa4AN
         dumg==
X-Gm-Message-State: AOAM532UijqSlG3grSxm8QQM8OwZUAFADW6xjWWogBU33I1uEjGAKEQj
        +4qqMV/lpvIzltpYDFkC69kaZnUtcvmDT4ph
X-Google-Smtp-Source: ABdhPJzHwheldtHjVl9/DsOxESebEQEA/ifMOnvz5nNsiqxOGufFBKl34PbEzijy56rs+LyTAf16Uw==
X-Received: by 2002:a63:f30a:: with SMTP id l10mr5268202pgh.333.1619208790775;
        Fri, 23 Apr 2021 13:13:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mz20sm8324814pjb.55.2021.04.23.13.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 13:13:10 -0700 (PDT)
Message-ID: <60832a56.1c69fb81.e277e.85d7@mx.google.com>
Date:   Fri, 23 Apr 2021 13:13:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.114
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 181 runs, 1 regressions (v5.4.114)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 181 runs, 1 regressions (v5.4.114)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.114/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.114
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a7eb81c1d11ae311c25db88c25a7d5228fe5680a =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6082f74001c7ef12829b77aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6082f74001c7ef12829b7=
7ab
        new failure (last pass: v5.4.109-74-g398b28a161d2a) =

 =20
