Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339633C5C2F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 14:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhGLMdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 08:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbhGLMdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 08:33:16 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8427FC0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 05:30:27 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id v7so18069784pgl.2
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 05:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ly2ZYkzzwf2rWpO6Oz7TFJkt1xtlGK7GLWP0wfemC+g=;
        b=LVrMTNRFTXg/ANBw2f8XHbkwJEJO2NG68ysOQLpBUFzFxoeLiwhjMGvoHBNJOM+a62
         Z7GOMdukVWXU1ubSGuYdLT/wXf7V0TgoC/CeTZ5z1XWCLcnciDnzDkA3cgxJt5b+eaH2
         6NLvfSfLGlNr3AuU54g40EXYHP1hBr55Prii00huUMVC3/cVPHIhNhpwFKwnrb85wOcr
         dvYQ9GAoo41QU0Ca6uXWTUi4yX/oXSwAu76xkSD/bCH7Jz1qxwi+LVWyTKULXVlDG/C0
         IJhtc7D+prXMCMm6vOgPweCJRyDVE1ibkc+KxT0AsW8ONNvQrQQf9crGi/piQ1KFLsxh
         2aqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ly2ZYkzzwf2rWpO6Oz7TFJkt1xtlGK7GLWP0wfemC+g=;
        b=QVs1wKnwaKaNVCzfjBjPRkITXJqyW+N5eOtm10zkutmgju/onRuu1BbuyYT3gglWDh
         /Vh8NOLyOmCBmWIeNXrkKmPNFWEpxDpfMJbhAkvbJBi840uhh3aNOBr+315KklPxYh5D
         AwQ7IYCUaX3kEB2/je8sDOltXHZmCl65p88afiQxsIG72CnJY7F0ObCvBdAn8dpvPI9A
         F6jL0bKDBbI7BfWto3Ico3AkcjMNYA7KG5vQWDw3+rqKynUjLQhRjjrOGSGNAlNOJouH
         G6czijnDj54Bca8E718YSMCc9yewRWXhX/4K8WSZqOcBW3g8/Lf7b/iVJW7AY9SJXdoL
         w8sQ==
X-Gm-Message-State: AOAM530SqH1ej8pyhM9zP0jSJMhRCLWyQaCtjEm+7cQhY1t8zJFSOna3
        +5BGIMBnDEG+eHHBN55xpDWy1pgQDL0yBecu
X-Google-Smtp-Source: ABdhPJyV+8xrtk/gMJEeeFezSyusneEJdo21JX8dVikRDu76GkjjBBM5xybp/7rjqLGVWsBREz7Ytg==
X-Received: by 2002:a63:1e1a:: with SMTP id e26mr10629909pge.20.1626093026819;
        Mon, 12 Jul 2021 05:30:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y8sm16336443pfe.162.2021.07.12.05.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:30:26 -0700 (PDT)
Message-ID: <60ec35e2.1c69fb81.9ca86.eae5@mx.google.com>
Date:   Mon, 12 Jul 2021 05:30:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.49-592-ge2899f499d8c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 165 runs,
 3 regressions (v5.10.49-592-ge2899f499d8c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 165 runs, 3 regressions (v5.10.49-592-ge2899=
f499d8c)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
 | 1          =

hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
 | 1          =

imx7ulp-evk        | arm   | lab-nxp       | gcc-8    | imx_v6_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.49-592-ge2899f499d8c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.49-592-ge2899f499d8c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e2899f499d8c1007b495d87443e449b25ac0a683 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebd5032508a83a01117984

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
592-ge2899f499d8c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
592-ge2899f499d8c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebd5032508a83a01117=
985
        new failure (last pass: v5.10.49-593-g1d9b6799b02d7) =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebddffa4ba2deaa8117982

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
592-ge2899f499d8c/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
592-ge2899f499d8c/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebddffa4ba2deaa8117=
983
        failing since 10 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
imx7ulp-evk        | arm   | lab-nxp       | gcc-8    | imx_v6_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebd9bf5bda71ad3f117aa1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
592-ge2899f499d8c/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
592-ge2899f499d8c/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebd9bf5bda71ad3f117=
aa2
        new failure (last pass: v5.10.49-593-g1d9b6799b02d7) =

 =20
