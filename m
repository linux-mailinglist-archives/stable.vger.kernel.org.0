Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BDF4704F5
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 16:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhLJPzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 10:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbhLJPzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 10:55:32 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2654EC061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 07:51:57 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id k4so6539227plx.8
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 07:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=968YCGedC6Cmy8I05d2vLzvjEbahZ10H0VZuI3fE94M=;
        b=jCv6lq4ielAXkWwcgN5/euVNLJlJRyd4+i0axlDTAUiHK7wMGRUp3vtI21qVlrtB8d
         QCiN7pf4AQLElTE6lWVuNuD/4AhZeJIqn3x4v7EpBpLXqBNQJdhQH+D5i5heNl9/OFwY
         zjQiDA84qCCsrkRo07YjUva/LyCArZDY0b8Bgl+A/vCxH9k1j/eDv1cfSoaCJPghT+q2
         FxBRz+1Vqkr5hfOWj14eJddc4dmWkJr/PtTCqL/SF3anYntlOjd/Dlhr03MJxZgXlJGi
         94iyRmuOAfFKH8Z9SM8jdxCcB1CNdjeS9PlB/bBYtyHdGAfSU76fxXFWPOafNJozLB4l
         7hEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=968YCGedC6Cmy8I05d2vLzvjEbahZ10H0VZuI3fE94M=;
        b=k8KLKGkqk3XIJ81KU4SdBYgMkJ6U8Vka306FuKf4vTh8cadsqJuvgCd4EkiQyLrGoE
         K8wQuSq3n2Fu4m/xrqzdk5Xy8FV5UUA9vA5RKXtwnNUaGEEypBnzfaxAQUOryO/KsJ/P
         8oFiIvR/RKPTNkm3ku2rqLkPfFqEIQzBHXES43vPTDyBble3NpXjJgHMbA/1rb3HBjqQ
         y9T7toHLl/mxsM74w/5qxrLE1w/l6rv38vLlpLhkdzy2rNtTlwQo3oflOjzDOHoDIxMh
         kbFJ/C6k8/Yzh1tNoHXPtI6B6Ds36M/G5LDL6z78053p6rjo3Wr8UfqQkchGQd5esyER
         3kMQ==
X-Gm-Message-State: AOAM532dJk71J5wpiHLr3YUuAp2FN8xA/BMlOggdmkvL27j2DsdhVE0u
        tuE8KwYKX/ZJ6MQjo4kFcKjWysbKnBo8rVfb
X-Google-Smtp-Source: ABdhPJw9MEbNb5AVMmHhvDdTGzOiMxNSYbCLqiW37uSVHicSdgHRNXM72vIot7M4ztHz/cYVrPijlA==
X-Received: by 2002:a17:902:b189:b0:143:8079:3d3b with SMTP id s9-20020a170902b18900b0014380793d3bmr76052000plr.71.1639151516400;
        Fri, 10 Dec 2021 07:51:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 38sm3013487pgl.73.2021.12.10.07.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 07:51:56 -0800 (PST)
Message-ID: <61b3779c.1c69fb81.d2913.8cce@mx.google.com>
Date:   Fri, 10 Dec 2021 07:51:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.164
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 153 runs, 1 regressions (v5.4.164)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 153 runs, 1 regressions (v5.4.164)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig              =
    | regressions
----------------+-------+--------------+----------+------------------------=
----+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig+arm64-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.164/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.164
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3c95128def1c937754a5cdc3d297fa47968e9f6 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig              =
    | regressions
----------------+-------+--------------+----------+------------------------=
----+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig+arm64-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b340f8dd8ee9374239717f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.164=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.164=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b340f8dd8ee93742397=
180
        new failure (last pass: v5.4.163-71-g5d289daa9fc2) =

 =20
