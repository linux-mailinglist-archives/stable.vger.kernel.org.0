Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B7C50B5A9
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 12:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446923AbiDVK5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 06:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348369AbiDVK51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 06:57:27 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C7056206
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 03:54:34 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id bg9so7038843pgb.9
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 03:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=51sw1QDiGQwr/C7rmuLlpku5433hqUjAQ2kp9p84xxI=;
        b=Zq4m8nS58v7C5HqETfdRHC0hl3AnHduhBveY+oNeCQM6bwGyzdN1Gi24Xa3jfvUyl7
         CHoQpWB53XIqq9F+iDW+tblooUkzf0+sCRdxWo7AprVGToWwNjQvy1xWzmCXWnnmUuv4
         InZKJczTvLm3Ql1FaIPbjVeU3hn94GA2gVfdXcwA6azDbWWBG3n7rtJpzNAxDXwQYRpZ
         vS9eV1xNdtdwdLQNNgAosVgSqzxILFpcOwrdiUHsR2ssn7UDa8eTTCLkZP/7g1wsabdN
         Z++A78BadWLoKVX0eDZ4qD/LsGsoRz66WxT4PfM40VwER6PLXdtyWcKum1u8O8hm/TD/
         /2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=51sw1QDiGQwr/C7rmuLlpku5433hqUjAQ2kp9p84xxI=;
        b=rZq5UCTTwq/H7auFqQV9FiZZ3yJx4GHdrHaDbp7oRpdBqFt2XSqUo7WvHAIdZWOw6l
         lewaJye6eFmiCJXpwTtdU+2beMZ1e5XOsOVggXhBKqgVaZRYuLLnTnA/9gcPYT9LPAJu
         S7kDWQQLOfCLfCxoz4IWG1KEN1al/A3coEIB3irqmOUeayZ3aWUwmyqetKJunLwG6kHK
         D51FQCDroPrBR1dVd6jn4kVazJE7exaTRpuACdNkbByDGiXiP0DG4F0C0/aWBRPQNdpK
         V4ouGXvU4HbU3uxwmG7LWEONZUJluv2E6HlS6NiWQo090v7HgNdC9yr42X/TseBA5mNP
         4LqA==
X-Gm-Message-State: AOAM532+tJ/FhK7f/4G7Z814ebRugsIpqJz/3zCFKA1Y0XViNGXg9d9c
        Z16zOO25y9/q2EmM9v3q1a1XH1UwnJAyZJ6uSaU=
X-Google-Smtp-Source: ABdhPJzmqS2KdU8dNzH8urpwByHXjg7Q6akOOrJ03BI6al2PXJ9PdhsEe81GPRS9HOxNvJnruuEiqQ==
X-Received: by 2002:a05:6a00:711:b0:4fa:daf1:94c1 with SMTP id 17-20020a056a00071100b004fadaf194c1mr4379171pfl.52.1650624874233;
        Fri, 22 Apr 2022 03:54:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d141-20020a621d93000000b00505aa1026f1sm2138148pfd.51.2022.04.22.03.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 03:54:34 -0700 (PDT)
Message-ID: <6262896a.1c69fb81.954e2.52fe@mx.google.com>
Date:   Fri, 22 Apr 2022 03:54:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.311-3-g86fa99d8325e8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 75 runs,
 1 regressions (v4.9.311-3-g86fa99d8325e8)
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

stable-rc/queue/4.9 baseline: 75 runs, 1 regressions (v4.9.311-3-g86fa99d83=
25e8)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.311-3-g86fa99d8325e8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.311-3-g86fa99d8325e8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      86fa99d8325e8d654c7ac8562d6c75b260489bc2 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6261c66f52e467e269ff9481

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.311-3=
-g86fa99d8325e8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.311-3=
-g86fa99d8325e8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6261c66f52e467e269ff9=
482
        failing since 16 days (last pass: v4.9.306-19-g53cdf8047e71, first =
fail: v4.9.307-10-g6fa56dc70baa) =

 =20
