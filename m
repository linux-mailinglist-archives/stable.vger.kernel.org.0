Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A133B4732A2
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 18:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbhLMRDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 12:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbhLMRDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 12:03:42 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F703C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 09:03:42 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so13863658pjb.1
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 09:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7MluCahkcOnpJBFrcSDSRNCfD3JrVdmaIr28cMv7MEM=;
        b=YspzpNItNT9JcGC9UjfgIjLpB/jhfgcpe4e/hFAV6mH+oE1vtF8vB1vILwL14AYvLi
         TttkvmUNU4Dl+6DCzLEsrGSBx4gpYnj5Q17G6yM3ka+YH4GiwckynCUysuMKVWHtJWW8
         8RmMI584LWrZvMYQjxvnnUkAJvGoHczsRN13VlsRFCmODyKWpZiBZYJmyHTybj9r9mTW
         7FQ0CeawIAj/6a26WMRokv2CsNNwQYlHdTe6iSFbmLP1GA6/5YwZ3E2vUgiQji5XdbZI
         RTHIGiZvdYbpwqz+v5QUFe4xXdRYnXiHJ4MXTCTd8q6MbYXRUUUAip66t5dWrwdhmP8d
         rAvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7MluCahkcOnpJBFrcSDSRNCfD3JrVdmaIr28cMv7MEM=;
        b=kokUVM/a0HB6yQDtgIYGZTCgqvAeU6sNWKRxwdGBUrz7Idg9nEx27p+KX8iJcD+ef7
         YxTAFrwa3zqoG0HKAtrX1EhbVsZURx+VEkRImnUS7v7aTdgoejjrp4slo0JiZRnRX50I
         wTCkvxBPEip37IWOUwPwqysA6gm3Rf/vK/j51zeoiPEnpYgfCKJQ6vaqEQrneKLGY7fW
         Wn1huxxtz4eBkXIT00sauEJPKyA2ZFFbhWz6r5ALofueuwT1yKgwhVR6cZ+nzfLZ6eJA
         RngE7gJnAHlKeoYOjjwor2qjI91SgMu/EJpMuiB4BKhr2dwaIpfo6kk9Z6TaV7NYU2EC
         2vgA==
X-Gm-Message-State: AOAM532QP9vCJW2t8pgtvZag5q0fhkeHohsbeHfqiTPbANhIjpHjyq1S
        VofpiGGiQHJxDoUjy/YltveQrmh50THXSzMi
X-Google-Smtp-Source: ABdhPJwzvIn91EhUPx39l3KyVSpOKnQbOYvWSGklz9EtTdWhYogBpF1sp5V3MxxAN2bOM+/7e/hcig==
X-Received: by 2002:a17:902:cb8a:b0:141:f601:d5f1 with SMTP id d10-20020a170902cb8a00b00141f601d5f1mr98020496ply.77.1639415021302;
        Mon, 13 Dec 2021 09:03:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n3sm11073412pgc.76.2021.12.13.09.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 09:03:40 -0800 (PST)
Message-ID: <61b77cec.1c69fb81.d8a5a.f375@mx.google.com>
Date:   Mon, 13 Dec 2021 09:03:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.7-172-g5eac0dfa371b
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 212 runs,
 1 regressions (v5.15.7-172-g5eac0dfa371b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 212 runs, 1 regressions (v5.15.7-172-g5eac=
0dfa371b)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.7-172-g5eac0dfa371b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.7-172-g5eac0dfa371b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5eac0dfa371b154308861ff6fc0d6ae0ad568e56 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b743f200e2424c3639711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
-172-g5eac0dfa371b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
-172-g5eac0dfa371b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b743f200e2424c36397=
11f
        new failure (last pass: v5.15.7-136-g8bc44bac3d83) =

 =20
