Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FF8490FB9
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237976AbiAQRgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237896AbiAQRga (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:36:30 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76016C06161C
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 09:36:30 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 78so10792760pfu.10
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 09:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NJY9XSUwJEoX9fe8tbjcO+KffdRiUvfZRp2c8uErS6o=;
        b=pEcMq0DrFSqg63UmTFIbBl2faWMM2TOAIxTIk2Os4fwnfco5N3QhLyrA7t+XJGgxgh
         6g1pCrfOIpJg6AIJd2n65lwU1D5h0Qs47LL9LFBWh09ZOI13JM7d7bS7aDFlgI1Z3Qph
         6Ov6aRicC5N3GuagxOxizI/0lgt5yJoh8Xz6pD5A9OweCInNOq8h9GJLA7N3+thUpRSt
         9O4lS66iMFEu6jF9yDN4Q2z4LcXGVo2t7wFFNsbj2zRGaoosYUeKmdMqC5uSTaW/mmMd
         lBpV1Hy3BdVmPHMT3/jL4tX+3tpc12rgVx94Yu8TryKdXbH8DUQ+dv46CcijVUOvWXlI
         VTBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NJY9XSUwJEoX9fe8tbjcO+KffdRiUvfZRp2c8uErS6o=;
        b=bl17ubCeKTJOR5CbsaXXMpP2P2XsoqqfQXBMhritbi6n18YIhGv3QJ4Wp7AQLStRKs
         TezS+qtWj12tt4WpkB3YTTE5oJncXqBaJ4D0hcuLnfvvXF0OEKscqFuxkP5vPWCkzcXm
         R5qqim91VVFgHDkZ/dLvPmT/Mi0W4r9bOdIZChYlTKsQ0JSg2KVBeovNR+qK22RKrsC6
         +bvP11bCbVS3qQGtGN75+jK0No7NtUD6YpQLlFdFgDd1dp/iYyGEzxECZemFk00FJZI5
         zx3+C4nWZAYGpbwQGinhcOsqQAAitF8JbAMZvUvthDS6baaJeMd7sHsvuO9q50LGOK0R
         hXtA==
X-Gm-Message-State: AOAM531tsWUh5yNxOo68VWmp1uhOlJ2IJXohVNjOKvX7lhwB7PLWeR82
        Xg9nzK3OzZndbjhYN0jyARYshHvQbGts9UWu
X-Google-Smtp-Source: ABdhPJw/Y1+rAcydls9O7w4JSWoADB4lPuXkEaAjHT1yH0EQPcN5Exff3iB4bIBuDjW8+zxRNZCtWQ==
X-Received: by 2002:a05:6a00:a0b:b0:4c0:7703:2e8c with SMTP id p11-20020a056a000a0b00b004c077032e8cmr22565105pfh.38.1642440989907;
        Mon, 17 Jan 2022 09:36:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y79sm14326096pfb.116.2022.01.17.09.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:36:29 -0800 (PST)
Message-ID: <61e5a91d.1c69fb81.106cb.7196@mx.google.com>
Date:   Mon, 17 Jan 2022 09:36:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.91-28-g7507400c81eb
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 184 runs,
 1 regressions (v5.10.91-28-g7507400c81eb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 184 runs, 1 regressions (v5.10.91-28-g750740=
0c81eb)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.91-28-g7507400c81eb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.91-28-g7507400c81eb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7507400c81eb1b2d7c7a4f8908deeceb981cf942 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61e571d21498fd06a0ef675d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
28-g7507400c81eb/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.91-=
28-g7507400c81eb/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e571d21498fd06a0ef6=
75e
        failing since 0 day (last pass: v5.10.91-25-g3eccd3159d8f, first fa=
il: v5.10.91-27-gf01179c14c07) =

 =20
