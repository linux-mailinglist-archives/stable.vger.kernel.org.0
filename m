Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6B1531A1D
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiEWTyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 15:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiEWTyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 15:54:52 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59086D953
        for <stable@vger.kernel.org>; Mon, 23 May 2022 12:54:51 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id m1so14029144plx.3
        for <stable@vger.kernel.org>; Mon, 23 May 2022 12:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zOIcLdpzPFRPT06VKtNWiyryxSZzfc1f1GS+DqZzBXg=;
        b=u9Q2BL+IPP9qqYMYEW9qaaJNFFvTfMdBcI8Ri7wRVmhot4R/8EQfpeZGTRPiq7yi1y
         7YI4x6TC45JSc8eYPr+/27ABy+pr1IjEOocOWH8sk5FRVBuTIGulkOFjcUaqb2DhhQkI
         RjJv5vsbzW6/9yS8GX8Si/UR45fkqBj0mDTd498xQrPRZpTjfbOOuykOzSi1LByeurnO
         wrhdZjEMXBzfMIDFx/tNhi9SsMnGCofW+dtgJL9kyftD1mbxCct2yTynJl6/JJIq/PnX
         I0JNn+uluXsFT8MLEPrgzxhXHxHq6Wkh7WheewVSisQst9ZKbdkymyMhrpYYCrTVwMk4
         SVpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zOIcLdpzPFRPT06VKtNWiyryxSZzfc1f1GS+DqZzBXg=;
        b=pMOCkvOG5byEXbz11aa+MCf6cdGiac/3w2DeusSK7BP80OzNWTlpTUE6uHqKP8fvfC
         gLqOegNGT0Km35D6i9zTQS/bHi8HRIhOf5xyog5AUyhF874VZzLPsXlaoIyjtSln+1Yu
         /InwX+EYl0Bsw5rFajV3CmFaWk+/eHJpfi1IUmkTrF6rBc30S17mKB16CtyQ2Kc09W4E
         HoeFhxV5HmxGHQL/FpQYsshBgsKpu/uDrDCP/jSdWTGchitD5rLy1UPAD+rJPJJdmsbZ
         TV8UnKcSh+FT/TeZKTY7nOGlSJzT9BHfrAoh3DlvPF6JZtqV+ObEoztHnl+TObZn3GK2
         B8/A==
X-Gm-Message-State: AOAM531JfEloC1VDQY8bHWAPVWaBFP6If0P2Ta0hWQ4v8V7u01uYxbq/
        z6p2O3YJwgGs8PaehjDkp0LqxFnJ0fBNlHJNxbE=
X-Google-Smtp-Source: ABdhPJwTxqZ8U8ePAVIMZDhld57i3PdFeQpUCPahhyZCDTbWMKIein/YTsoPmIQGKX93yOXXMlmTag==
X-Received: by 2002:a17:90a:400e:b0:1df:5b69:892 with SMTP id u14-20020a17090a400e00b001df5b690892mr672774pjc.38.1653335691103;
        Mon, 23 May 2022 12:54:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m16-20020a170902db1000b001618b4d86b3sm5596532plx.180.2022.05.23.12.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 12:54:50 -0700 (PDT)
Message-ID: <628be68a.1c69fb81.ce92b.d52a@mx.google.com>
Date:   Mon, 23 May 2022 12:54:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.9-158-g0fff55a57433d
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 165 runs,
 3 regressions (v5.17.9-158-g0fff55a57433d)
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

stable-rc/queue/5.17 baseline: 165 runs, 3 regressions (v5.17.9-158-g0fff55=
a57433d)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =

jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.9-158-g0fff55a57433d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.9-158-g0fff55a57433d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0fff55a57433d6a300059bbb5cd509837dbf6363 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/628bb7ceccc793dd81a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.9-1=
58-g0fff55a57433d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.9-1=
58-g0fff55a57433d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628bb7ceccc793dd81a39=
bdb
        new failure (last pass: v5.17.7) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/628bb667b9b8e2dacca39bdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.9-1=
58-g0fff55a57433d/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.9-1=
58-g0fff55a57433d/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628bb667b9b8e2dacca39=
be0
        new failure (last pass: v5.17.7-12-g470ab13d43837) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/628bcb221147f382b8a39bed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.9-1=
58-g0fff55a57433d/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.9-1=
58-g0fff55a57433d/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628bcb221147f382b8a39=
bee
        new failure (last pass: v5.17.7-12-g470ab13d43837) =

 =20
