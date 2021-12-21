Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401A847B6E6
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 02:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhLUBf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhLUBf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:35:27 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCADC061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 17:35:26 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 2so4087795pgb.12
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 17:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/Smp1fdiYR5dDNiMPriFF/dFzgarzp+oAhkrCJjdt4M=;
        b=xEh6f+xwJXRW2y/ENF38/ztNw7a4tiWVI/vi0wC22auYjRLyjw0e9xzIvH7jJQ/MDC
         2OhvMk2XeEL3sAjqzlQ1aaMUdWXGCYeAUhXBFXfbJJeXQcySd3Frpq90eySe36Wzux92
         MS5QwLImy5wHlGzB8/tnTKmNjFkFiJGnrD3Xt370VPTV+Ma7afKAZalGzrCqrCkEryl2
         q5A6Mf+HqW6ppe2smOsZVCW+9RRMtNZhPIbl7Rn1xe7T+wHL37zFoweAZB5z9DCuT5Vb
         YiN9SLL7hKfxAR/VL2MGgT08SiS4Y0csWMu4UtRH44NnpzWS30AY50Lx1KE5x6Dgjb8P
         8ejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/Smp1fdiYR5dDNiMPriFF/dFzgarzp+oAhkrCJjdt4M=;
        b=h13l4uR7SOieoDlkqrcrsNIT/A8Z1HASARZWPh9rt9CRzHAsJ8/s7Jl7zbbOGnML6G
         ebCutC6DpADPToy/3SuLBf9Qr4NYrlDKRVF9lbR9RixiVqQRER8rNTdaAfkKqAwFYWks
         7vIfZ6d2bme7NYJRIbV9s9Kk5CH3SOHEiA8FBABdfT3we+QVarpPSu7f3jZZd+rd1U/g
         85hjB+iZVh/dep2S1+pZjgPP3seCObInhOoyAmzdcedbGyWKqwp6UkaSGtNPCBHEZad+
         qWwex8QLLGXotg6JrXILVXtxMKXJskpqtDRyXNworYj6W11WbDRhpIXTTaQfN8O6QezT
         j3IQ==
X-Gm-Message-State: AOAM530g8pYooSL3pcfNU6j/CPwCZbOFOdH8siDVjrfKxmKGARr/DEpS
        ASa2dzfXTOnb3mghd2hfpqQtFfgrVP8hQ+op
X-Google-Smtp-Source: ABdhPJxKYmnutjC5Rybe/cpqEwA8qa0lqt2e++WqREOK9EBsqS6aXFAu5l0ibG2zpqNg/yDgEoAMJw==
X-Received: by 2002:a05:6a00:1945:b0:44c:a955:35ea with SMTP id s5-20020a056a00194500b0044ca95535eamr696122pfk.85.1640050525800;
        Mon, 20 Dec 2021 17:35:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j4sm3631205pfj.34.2021.12.20.17.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 17:35:25 -0800 (PST)
Message-ID: <61c12f5d.1c69fb81.92ba4.988b@mx.google.com>
Date:   Mon, 20 Dec 2021 17:35:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.10-177-gaed9163d4cc5
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 190 runs,
 1 regressions (v5.15.10-177-gaed9163d4cc5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 190 runs, 1 regressions (v5.15.10-177-gaed91=
63d4cc5)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.10-177-gaed9163d4cc5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.10-177-gaed9163d4cc5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aed9163d4cc5fd06b5b67e129e28ac78311df559 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0f728883f57c5b039718d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
177-gaed9163d4cc5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
177-gaed9163d4cc5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0f728883f57c5b0397=
18e
        failing since 1 day (last pass: v5.15.10-112-g7598a4f34463, first f=
ail: v5.15.10-111-g991fdb79a273) =

 =20
