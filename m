Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212385F4A82
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 22:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiJDUzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 16:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJDUzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 16:55:20 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F9725EAE
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 13:55:18 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d24so13691086pls.4
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 13:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=9KkNU+SofGfprPJox8XpOO3eeitrx+p8VsXkUkfqkzM=;
        b=BN+aUTjX1vHEQ4RJ5woTfNQ44ewOWUgBnC+G3o4pQaxNUtx6sSdUpmZ6pXl5l+q/d5
         pR1NVcoXMiMNVMLhSpIciHBW5mXujEwacXsvITj58L+AZcNm46AojvVrV4t+U0uBKcqI
         I4qJp0x1xmVAFR2oGf5vDf4JS+0MCheyATBmdZ+LViFfOEDxBM0c9QIm4nqq3tV+4WKc
         ug7reaQFBCFXMad9MMUqcjNrQCj6SqpevQ73N4xbd1yj9jLa2ITIvB1JN5Cif1Xg6fF/
         CGpGZ4IIJUDtr8busxXGXEBNTfOvE7ykDsaxHV/yzodWqErU/IocjDGuaWd90IFQskfD
         OXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=9KkNU+SofGfprPJox8XpOO3eeitrx+p8VsXkUkfqkzM=;
        b=3oGcb+fVn/SboVtOyhsqEAV7dLrSqTviUc3HrfPIhGdKvHFlbi5Avlxmm7SsEJ0Zj0
         GA1m3OKymtGZNFRv8s/9Re5tw4xOm4MkO/9l+mtAalf3OWL6WWN/SEpw5Kv4GkVPgYVD
         Aa302x4nLsFY6A+IoZQ7wGXus0/cv+7xnNO6t2Wm04TL7sYZnFnMFis6yfs/L4dT5YN2
         jjFujZIbWwqkeOJWwed4oxBNnuLpf2RGTrzbPe8VlgNSATa2a3D4KMXIYgbkKHtG/aUx
         h/Q8W/5HEcMufck6+VOtoxNkcv+/C55UeQTYOdPHfwnC+islJ8en+IDx2RezBYJhm1qb
         4KmA==
X-Gm-Message-State: ACrzQf0j3cDoT31ipRXWLk9htZBePXymQhGmYcvLMi6cRh2cD+syVisf
        yef9Q+CxnHIvMDYlzE1Cmf43qnoYFLEuMdLyzYM=
X-Google-Smtp-Source: AMsMyM44Xe8GofVAdlJWJ1RIFDjyVzBXjFmpojkuAhf9S2fNwvOMPMDTgyi+idJIlWsdQASaVT0COw==
X-Received: by 2002:a17:903:11cc:b0:178:aec1:18c3 with SMTP id q12-20020a17090311cc00b00178aec118c3mr28959812plh.91.1664916917947;
        Tue, 04 Oct 2022 13:55:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s33-20020a17090a69a400b0020a75cf237dsm6053182pjj.23.2022.10.04.13.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 13:55:17 -0700 (PDT)
Message-ID: <633c9db5.170a0220.efdbb.9b58@mx.google.com>
Date:   Tue, 04 Oct 2022 13:55:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.215-30-g99244f6e65b6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 99 runs,
 1 regressions (v5.4.215-30-g99244f6e65b6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 99 runs, 1 regressions (v5.4.215-30-g99244f6e=
65b6)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig | regr=
essions
----------------------+-------+---------------+----------+-----------+-----=
-------
qemu_arm64-virt-gicv2 | arm64 | lab-collabora | gcc-10   | defconfig | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.215-30-g99244f6e65b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.215-30-g99244f6e65b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99244f6e65b622cddb362b7f44422bfc3295f149 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig | regr=
essions
----------------------+-------+---------------+----------+-----------+-----=
-------
qemu_arm64-virt-gicv2 | arm64 | lab-collabora | gcc-10   | defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/633c6dd543eee714efcab5fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-g99244f6e65b6/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-g99244f6e65b6/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c6dd543eee714efcab=
5ff
        failing since 70 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =20
