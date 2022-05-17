Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E962529779
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 04:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiEQCsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 22:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiEQCs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 22:48:29 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C945A35274
        for <stable@vger.kernel.org>; Mon, 16 May 2022 19:48:27 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n18so16170511plg.5
        for <stable@vger.kernel.org>; Mon, 16 May 2022 19:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j08AJhh9xspnJFdUR0TdQmpCkMz2IwpTRHQAww3i6ag=;
        b=nS66L5HXF67OYRUdhlWr+Xr+KQqHWGqd/DcXC7wxm1iUoDQUG1Sgw+jwf56C2o9Gui
         dW7W7h4vJtsQV0y2iqndof9e7aSOyG5HtgyiKfVVtZxyQmqzSChjvZn1E7O+dQpZoLVR
         L+scZxAniqaHvtOjYujwMSQrsY4HCYmth9fMKMGWAkZks81xqYID2yMEB9O7r0bScvwT
         eDE37DpyPHgP5wQd3vQy9zzOWJm1AiApZvXb+yYFWQlOFOvPzeEnY6JpEmMNbmlXlVpV
         S3Uxi1DHaoB2P61JlcRUKM2LQPU+VSQWupSEOEHwdaF2JWUhOL5kt43e0b+/okUYSEIA
         0wKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j08AJhh9xspnJFdUR0TdQmpCkMz2IwpTRHQAww3i6ag=;
        b=qXlpZXzzttw3qsilLw83i3EifpKBl6LG+Vfa4Xh/NbfmNbuMbbhwPz+midSKFx7daU
         L45ENldUyN5YaZIjrY4kFCKA3PobD3JvttnzYxtzDu4qmW/UUrGIe357n8sE8pjSyHhl
         fd1VPHxofsqHdtqtnR4fliPqiz434qWUJkA9CWL/bYtWe39ir+1iPzLXtlcvJISAP33s
         X+Xh88/5JRrzqw67rHoh4PD2Udfhwvl00AFfE4RXtJgs1kZGELwkRDEXTjlpF3fmYYQS
         COzvt5eIH3R0hVuWg9hPg5A04LFjpAdRgJlGS8DnifD8xev6WKYu9ZNhTPOuISCMXfQ8
         lZqg==
X-Gm-Message-State: AOAM533ElqpL7n5GeF3qKaZ3+/iPk7IHlN2oLBa3phNoKAJPfgo2Yvb7
        2rc6I8V1F2maXujDD3f6KMKd4asJZt9rcz1gSkA=
X-Google-Smtp-Source: ABdhPJzEMbO9j0eD0yeWQYir8A57orTVcDyczlc9xqUVsCPAju1o1yQCUBQF4RUsa16J5ak/Pkv8yA==
X-Received: by 2002:a17:903:124b:b0:15e:84d0:ded6 with SMTP id u11-20020a170903124b00b0015e84d0ded6mr19801368plh.141.1652755706631;
        Mon, 16 May 2022 19:48:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cp15-20020a170902e78f00b0015e8d4eb283sm7645483plb.205.2022.05.16.19.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 19:48:25 -0700 (PDT)
Message-ID: <62830cf9.1c69fb81.d7262.34ca@mx.google.com>
Date:   Mon, 16 May 2022 19:48:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.40-103-g4aa8770e7dfca
Subject: stable-rc/linux-5.15.y baseline: 106 runs,
 1 regressions (v5.15.40-103-g4aa8770e7dfca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 106 runs, 1 regressions (v5.15.40-103-g4aa=
8770e7dfca)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.40-103-g4aa8770e7dfca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.40-103-g4aa8770e7dfca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4aa8770e7dfca33d694a86ec8fc85900ada99c26 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6282d8d4b5091f517d8f573d

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
0-103-g4aa8770e7dfca/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
0-103-g4aa8770e7dfca/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6282d8d4b5091f517d8f575f
        failing since 70 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-05-16T23:05:44.976201  /lava-6396529/1/../bin/lava-test-case
    2022-05-16T23:05:44.987346  <8>[   33.241301] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
