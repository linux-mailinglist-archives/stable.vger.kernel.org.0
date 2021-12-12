Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A52471CCE
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 20:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhLLTuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 14:50:11 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:33297 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhLLTuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 14:50:11 -0500
Received: by mail-pj1-f51.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so11267239pjj.0
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 11:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EWDT10vgXVmKFDkfqiBgRkNEsLoshpc4D2rKY3FIzv8=;
        b=NwA6TurRDUJ4Qr1RMslvgQDTyI9nk8K98E+bY/RODqfIHkmgaGPxsf4rtArJf0J1fc
         5/e25rgNfKl9w5L8pioOAkJJJ6A2JJTKDQF4+kIvIwenweD2f8vosc6qbMxV6NP8y8Pz
         B+pFwmxTLFdqDhEbis5DpeFpRWivfFvL9JdgGbtygAoFNPJKLWOp7d6T8/YE1RLSgIej
         iflSpa1hlZ+Zg/afA8f7fY5ZptCSMc2FZ5L/5AxDl2WEPg32UZqs5MvjblB7BAjeoMW9
         rbR6MjeKg20/g57oThcLZtb/KD/3j43o5HJMJyVyLDncWg20efxxa3AGCs/vZ9PPvMvq
         MqDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EWDT10vgXVmKFDkfqiBgRkNEsLoshpc4D2rKY3FIzv8=;
        b=GTXMAlheP9b1g2xmjMLSy39z1zIYYeTSN56Uov7CA0x1FAIhRI9u5enN8GtYWCEG4I
         2RZ30hMz6caTjubLKwDedMebQ2kovOVOo5+EXccjlxko7064YG7Wi59so/Xy0fCTxnA3
         OtrDXxfXW++29P6+kIRZ9XF4wkQHFDWenZ0YntpmI5osKdUJ0rkdiJfOnKifwxEr8lDc
         7JSiuGVrNWJcjLBLy2iBhSwfv5dOpZeoYIqxSW09ow3NSD3ymd1iWBEtyi5TOxUHSgbb
         hhxoEvOPZHNFBi0GCddCcTKfHIZSSkydC4q1lwC8YSaN3fNd3Q4bk7SSEcn6sr08G/cx
         wamg==
X-Gm-Message-State: AOAM530M5AuGtHx9hgbgZW3nMpPy/kilq9s08L8BgT8Mzo7Ij5HrkC4X
        Mnsthf0PlmrO2GuMUbVSF5JvKtoKUBT26EbN
X-Google-Smtp-Source: ABdhPJxXcYIQI7rURwlsyQGBy7jc3/sMzLBFbNo9qhnSETtEhN1WYpLDGljJ1JFRh5mCSHhZSrpd1w==
X-Received: by 2002:a17:90a:6e0c:: with SMTP id b12mr38428569pjk.41.1639338550711;
        Sun, 12 Dec 2021 11:49:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pc1sm5268019pjb.5.2021.12.12.11.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 11:49:10 -0800 (PST)
Message-ID: <61b65236.1c69fb81.2c5ed.dff9@mx.google.com>
Date:   Sun, 12 Dec 2021 11:49:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.84-99-gaecd815828f3
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 234 runs,
 2 regressions (v5.10.84-99-gaecd815828f3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 234 runs, 2 regressions (v5.10.84-99-gaecd81=
5828f3)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

sun50i-a64-bananapi-m64  | arm64  | lab-clabbe    | gcc-10   | defconfig   =
                 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.84-99-gaecd815828f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.84-99-gaecd815828f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aecd815828f37969e0b980096c02c0c1e320bab2 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b619f48982e434b739711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.84-=
99-gaecd815828f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.84-=
99-gaecd815828f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b619f48982e434b7397=
11f
        failing since 2 days (last pass: v5.10.83-129-g307696aadda6, first =
fail: v5.10.83-129-gefc3f818915f) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
sun50i-a64-bananapi-m64  | arm64  | lab-clabbe    | gcc-10   | defconfig   =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/61b61c4eee749e33be397128

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.84-=
99-gaecd815828f3/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.84-=
99-gaecd815828f3/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b61c4eee749e33be397=
129
        new failure (last pass: v5.10.84-42-gae3c5a22353f) =

 =20
