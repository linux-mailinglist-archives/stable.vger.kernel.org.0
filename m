Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A204A2AC4BF
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 20:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbgKITMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 14:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729292AbgKITMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 14:12:18 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D3EC0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 11:12:18 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id x13so7957411pgp.7
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 11:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oPtsQQ440NjNVwFlWFr7EabydFrbQOoqQU2HNiN+Yvk=;
        b=X9BL9ICrxli4JRzPwJLWacKmyvaTmwRpw7P8ZQwKjHc7qZQb5v5gEyl4NnnG/kUM9N
         LVmdyrD0bZ2/pTLRYbaspQc9avproDubZ8joAl4lRP2nbkUxbgvQQVDR4bdUttIiRVZ8
         CnkhpVO0ZV/5jBCJI69XWfFZiP1rE/UgVYDCyRNS97DjFcNgOLr+j3BEorjhoEyiR9Ib
         Sn/HkasAqF94s7TeLus/b0U0M8iJJ/mnP0feJhB8u6WnUPU8TPQFGg02RJqXx/Byr3GP
         cyzMQNW8xjYaUvbS1XJF67e4k9dnq+xrU/DNttzmQHctXthP2+JixiVyTZ274wKVVGcQ
         5ZaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oPtsQQ440NjNVwFlWFr7EabydFrbQOoqQU2HNiN+Yvk=;
        b=pK4C6An9Esy+684pG3nCHZO+nXPXEagYSOT4jU6H33U7NEPZwgRdv9DelNB32iplqz
         QzTHPbXNe2eJqjqImJP4hFNKQ9B0gxkTfZ65FzN8SEuMd2LQih3L/eERXmvztoTd5/oQ
         tpu//2zhCuiO1pD8QmyU4dpbM6nGGKsGYo1DpmDgip12iaHl1ulnACNIrMlrTpgdmGmC
         YsfEu7DxqDWScQcZy0cAfPnXxsyLfHV8kUXaLPcLCdpHz7iXhCW8a2npgusscl7d/JLy
         bQsnyI1lgzExGhorPFW0iBi4W0lzfVsUX04rDf8e4NAW4Yj45Kceqs4bzBvrR2AMNHWB
         6ttw==
X-Gm-Message-State: AOAM53101xpjgF5CABlIhb4WJV0JDCVqZNeHDlxBC9hMcjpqzwwbKqhO
        QrWapu4OHjJb5Fy5aseV31+LGTyVj3me7w==
X-Google-Smtp-Source: ABdhPJxNtAkwWeE2b1qFORoFwO9+GHvuV0SNgGX1Oq820YhuJQRdflbwC5RXIrzNwpDv7IfiN5GfQA==
X-Received: by 2002:a17:90b:d17:: with SMTP id n23mr661732pjz.189.1604949137868;
        Mon, 09 Nov 2020 11:12:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e128sm11835333pfe.154.2020.11.09.11.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 11:12:17 -0800 (PST)
Message-ID: <5fa99491.1c69fb81.5df0f.96d5@mx.google.com>
Date:   Mon, 09 Nov 2020 11:12:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.204-49-g0c03e845a8b9
Subject: stable-rc/linux-4.14.y baseline: 158 runs,
 2 regressions (v4.14.204-49-g0c03e845a8b9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 158 runs, 2 regressions (v4.14.204-49-g0c0=
3e845a8b9)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.204-49-g0c03e845a8b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.204-49-g0c03e845a8b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c03e845a8b978ebed2508e862d6a115d48abd7e =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa9616d2be7652ea4db8873

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-49-g0c03e845a8b9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-49-g0c03e845a8b9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa9616d2be7652ea4db8=
874
        failing since 223 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa960a8df5aced016db8854

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-49-g0c03e845a8b9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
04-49-g0c03e845a8b9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa960a8df5aced=
016db8859
        new failure (last pass: v4.14.204-26-gf4d6c3384055)
        2 lines =

 =20
