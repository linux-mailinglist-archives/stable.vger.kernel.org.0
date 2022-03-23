Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3200F4E540E
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 15:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiCWOMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 10:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243372AbiCWOMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 10:12:43 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF4C7CB38
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 07:11:13 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o68-20020a17090a0a4a00b001c686a48263so3699030pjo.1
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 07:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lK6rZM3cL4NSNBJRgYzkS1AlOYLz1Ogbe5W9+BYI6XU=;
        b=wa7OLn9YwwzOeq/21av7EdFcgifnZXuY3YKff2L2xUyQ+Llmta/Kms3RuMX8tmg0k+
         sSzyVqLSi7D/dOOvfkf7HrXI5fehJb0jGq2dSUTgguvheXDLS13mk/DonGTIVrpanmY5
         k4HEaBOmmWKOimF+KMHRj06poHMM7y9sIAWzr+XR45qUOg4b7A/iAK/S6hkXNsej8v1Q
         ljDOSdY1s+fjNWS6zINI/CydipIsLxrp+faUhqMMp/OCpjxglaN4NJTNwydp3gCbQUll
         Rh0Vunf2fZ0k6zip0L0ehBc7vpXa5A4fodupakQi4JST3inlegNWRUpDfdBXVvW9rZSr
         /8xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lK6rZM3cL4NSNBJRgYzkS1AlOYLz1Ogbe5W9+BYI6XU=;
        b=xMV0K975klruRt4Ivb+DyjZa6PNCPNtlutrBELq4BEsbCGLTQepwbFc5Sj+xxuOTOY
         oJA/3gQJSWV8JFfyluxeb7onMzQHwRXD3oe31d/Uwm+xRBYv2/xHlnpH6YMmnLs4mvjX
         rITZGiIhJ6qtOf3Dtcuj31RnTcAv8TkrC9+Cyw/sZ+3Ya5Xzm20hIhrrq3u38/Tnv6qZ
         ZlwOdIsYAH/klojwhIorC91asFh0DvjFkcYeyjgCuYL7EjBqwPv//VO57GEwkL6MjEj/
         6iAxhvQdQ819KNDB0298u6b3BxiT6wPcL3zzUkvxT9sxs7SceGM09usVURvE127odykh
         EBkA==
X-Gm-Message-State: AOAM532x3YnQFXr8eqWbQ9iNpDY1yEYkZoK1Ej2x/xV6AvRz3Iwo0zwq
        czUf6AIL3DPLkDljtPr1oEpnxkm4Dcww4Axk2ts=
X-Google-Smtp-Source: ABdhPJzn+QNW6clDNmeIeaxoaLBI7ArUnb2aH6muBZuZ6XSDozEYUc5GUrgAACXRl3Q69MZn2zJUiA==
X-Received: by 2002:a17:902:b183:b0:14f:c266:20d5 with SMTP id s3-20020a170902b18300b0014fc26620d5mr134205plr.136.1648044672555;
        Wed, 23 Mar 2022 07:11:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 68-20020a621647000000b004fa763ef1easm102507pfw.125.2022.03.23.07.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 07:11:12 -0700 (PDT)
Message-ID: <623b2a80.1c69fb81.1f006.0520@mx.google.com>
Date:   Wed, 23 Mar 2022 07:11:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.31
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
Subject: stable/linux-5.15.y baseline: 43 runs, 1 regressions (v5.15.31)
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

stable/linux-5.15.y baseline: 43 runs, 1 regressions (v5.15.31)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.31/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.31
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      96e48ac9a685f2f5855e2820496ed6ecf893febe =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623af9aada7c754d65bd9204

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.31/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.31/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623af9aada7c754d65bd9226
        failing since 14 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-03-23T10:42:28.976230  /lava-5931200/1/../bin/lava-test-case
    2022-03-23T10:42:28.987039  <8>[   33.543639] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
