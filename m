Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77F34358CF
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 05:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhJUDKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 23:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhJUDKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 23:10:11 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3904FC061749
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 20:07:56 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v20so17502227plo.7
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 20:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NFOGVWXWFFywVIwACUptCsHalDd2OI5pHrx6jqJA1zw=;
        b=731hOuf40gzLuHFEHvc54RuTusPvHIPd+NJ2239efJg0fGHPpl4t4TtoJLEiTp/eyH
         21YYlCBRP8fx1ybdhAEMmtOP8+mAoOwL9iTs8d2cgUmwxvChvv1UxAsjRoFijdW60k/w
         pI0OzI4Fk4Sam8d0NAJchzWQdlQKl+oIXxnw+tdUO7stfvIdmNuEVPFeAwhIgFwu8ded
         Kt636qQfq5o+ZUUUwaGfA1qEyxlyQPRr8kRDQoow3qrZkc7TGTivb9rwwzqwlNVlrnnT
         BQlnVrkEm/kIGXBZE0M+I0/ZYkZ1/2XyrN2Edls7Xm4FanHhiki7HeV7Stt3A1Q5EQ4X
         ogjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NFOGVWXWFFywVIwACUptCsHalDd2OI5pHrx6jqJA1zw=;
        b=ki34qXw8SHRfX3rTnNnPI05Z5FgzSKSDhjDT1Sozv6pk6tnyNUQnNJDGNV8I/3ZRpG
         qvLp2WsPoTi8tiPW21SiNGwHC1LkjPUKym5zfxTHdFpxXc0zCMxPCIGpFOl9Xo9/kAEs
         C1xS0io9lLErAN15uhDikj+jjeGTIppxLIOZMAo9x4MfK9DKroAoDwxsUPpxByasI8DI
         a1F+6u4rhFIU45Y6g3ayAZiYAgiaf9XaM2M4WNpnGDjL+iCInrdUzv/XOrIhiRrrlIzs
         hZpOYpOpZEI6kPBIprP6FAK1ehjdIlkwOkka/k1Ic+yUtul0ohKUX4H/Gr1DcRNXDFsD
         JKZg==
X-Gm-Message-State: AOAM5318GEn5vOyxNuadtr6a/8llss+OI7qUyrRotqL1we/wqlx7MJ2U
        vX8zPX8ykbiyx82rjqTVmv6Htr2jfw8QwOs9
X-Google-Smtp-Source: ABdhPJzQG3COpmMzdTP+keIxuA3hSP1h+eFy3Nt4h1W+A5qovy4en5WJYmvjrU3nznJ9KO5/A79+nA==
X-Received: by 2002:a17:902:930c:b029:12c:d5c8:61c4 with SMTP id bc12-20020a170902930cb029012cd5c861c4mr2787336plb.73.1634785675585;
        Wed, 20 Oct 2021 20:07:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a67sm3859414pfa.128.2021.10.20.20.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 20:07:55 -0700 (PDT)
Message-ID: <6170d98b.1c69fb81.608c0.c0b2@mx.google.com>
Date:   Wed, 20 Oct 2021 20:07:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.14-19-g9d51bdaa4ffc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 111 runs,
 1 regressions (v5.14.14-19-g9d51bdaa4ffc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 111 runs, 1 regressions (v5.14.14-19-g9d51bd=
aa4ffc)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.14-19-g9d51bdaa4ffc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.14-19-g9d51bdaa4ffc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9d51bdaa4ffc74384e167f3b9503f68da53697f6 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6170a1314b450ad99c3358f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
19-g9d51bdaa4ffc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
19-g9d51bdaa4ffc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6170a1314b450ad99c335=
8f7
        new failure (last pass: v5.14.12-179-g12f8c85330b7) =

 =20
