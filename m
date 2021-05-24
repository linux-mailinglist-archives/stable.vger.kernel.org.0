Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983E438F06E
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbhEXQDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235864AbhEXQCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 12:02:25 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C48C04C4AC
        for <stable@vger.kernel.org>; Mon, 24 May 2021 08:13:36 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gb21-20020a17090b0615b029015d1a863a91so11417196pjb.2
        for <stable@vger.kernel.org>; Mon, 24 May 2021 08:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h8ec80TByf3DbbxwJPijgKiDjyx46Va2KV7MomRk1xs=;
        b=p9lCuHG+GnpSTB5rdPfhlLzt7iqVwyjriVG0kqgly9rDhdwaVJ0p5UIQyXhk982fgV
         LoWaaISXVCA5kdq05+2ExHxjky5u7CsR9FEwna9Y9d7CI2FuGNAcxEDFtV+e7Xm3ddRW
         sYrmt4Rt+gbWNW5gq2oJdOdoMQ7hJB84jg/NapJvDQqXEzxlXJU+k+tfMIIXHCToHoC3
         NekoKS/2eUmBMCWvdrJztGInZp3Qon++fv1K5Jr5kUTFresoJ4DnNR2nZ2m5kPrKxOxx
         AvsS2v0J+zgSvpERexWpVafJPhaVkO1vj1AHPEiJu/CgCVqKYRpiQO7fYazVLat7c6zl
         2MSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h8ec80TByf3DbbxwJPijgKiDjyx46Va2KV7MomRk1xs=;
        b=XYOcriiUdCMbwFet6uaURdtDeW38J643bWwqYCB4vDj0odjba80pDxFS+HHTmfQ4T8
         T5BHi7z60IbVlvUcRKyb6uQsVli2IrTha1B0YS3YinolpErA/Pfr4zGZXlhup+MahObF
         RtG0LEUElFspSf0CH9gBZW4yvfeoNnr6Kxq5njaYNYMmF0r51KSDwhAfX8F1K8x9TBqU
         OZ/4iCFwNBoCej8n90RWLP7XFRQosBx+zwP2W1oEaExP4hHOj/y/M7bnFI6lZtzdki5H
         dc7dYGOLUS1pNFPs20u0IW6FT/IwMsO83wIoXxNTdz7euhuPGrv7hhVj8KM4R0IBlHQt
         5Jjw==
X-Gm-Message-State: AOAM532/dyWOsMt6FsJb3wtjgUYz9b4w+VnUoYx5w53tFaVK05IQVGXm
        bLgzpn6gArrRYxTEMznsXm9jW6O2cqDw1CNV
X-Google-Smtp-Source: ABdhPJzqRznzdskmIsqlq2B4cvFUTxuCicLEUR//9l5CB7tT8dYafCAoGcbxHqIti04vWqFWW6dFWw==
X-Received: by 2002:a17:902:222:b029:f5:c251:a6ad with SMTP id 31-20020a1709020222b02900f5c251a6admr24052149plc.84.1621869215865;
        Mon, 24 May 2021 08:13:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i5sm7501189pgr.54.2021.05.24.08.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 08:13:35 -0700 (PDT)
Message-ID: <60abc29f.1c69fb81.d6484.7dd9@mx.google.com>
Date:   Mon, 24 May 2021 08:13:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.6-95-gbb1483055945
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 110 runs,
 2 regressions (v5.12.6-95-gbb1483055945)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 110 runs, 2 regressions (v5.12.6-95-gbb14830=
55945)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.6-95-gbb1483055945/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.6-95-gbb1483055945
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb1483055945147d3f924f7c2b0530e48e31f758 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60ab8e51481869681bb3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.6-9=
5-gbb1483055945/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.6-9=
5-gbb1483055945/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab8e51481869681bb3a=
f98
        new failure (last pass: v5.12.5-79-g3f03da12545f) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60ab90cd498901cfb4b3afbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.6-9=
5-gbb1483055945/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.6-9=
5-gbb1483055945/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab90cd498901cfb4b3a=
fbf
        new failure (last pass: v5.12.5-44-ga4238f2183a8) =

 =20
