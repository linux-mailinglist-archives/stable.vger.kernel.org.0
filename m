Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5002854FD
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 01:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgJFXlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 19:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgJFXln (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 19:41:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEDCC061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 16:41:43 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id a1so126824pjd.1
        for <stable@vger.kernel.org>; Tue, 06 Oct 2020 16:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qbe5fPeKX3W6xw64na5vO5i+A8TJYrkcF9rY+mfSgvw=;
        b=hwDtSA/MlB+blJtYG6guS1l0UsOZniIITFHTcYivSwTgXajBH11eBzQ3P9TgBsxTRv
         gDDlrSbxjswjtseGiBQX8S6Arjn66jgCaElCEGDZLsCLzNtARBUMtEsJH/eVrdeF4KAo
         jSA5tuBKmLzknsVmwr6hpKqw7ZPvXXy7hWX2RowHzrMy6RJPLNCSSxWPvpXenwdrMOjt
         XkGBcZcT5Go1Vd2eoGKICr2gzzOzVpnD0f8jIsbhso+MxKaGgvhXWA5JOHwb/ttr2ZjS
         aPVgCfDaOExBGglryXeF288/KtpNTneu8GD618AQIS7cABC1sqXyl8tM1OKpwpI8gL6g
         52Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qbe5fPeKX3W6xw64na5vO5i+A8TJYrkcF9rY+mfSgvw=;
        b=ooKNa9Xq++JD8WiQFUpO1+BKI5gwdkI7zTjzZFPGYIYpUmQKcpfE1QnuRR6vHceNv3
         BFnjkNRTZKPu8lc1uagh6LODVW540uCOa6q8UoRycX32s6jRUvDJDjhU3PvkMsLP5Rnp
         pUAOM1ddcfeiJKp+pWjSaYGFvcEBC913cNuPPJQpKANwm9RKoffVvuLFg7UrRH8lvDM/
         umN3wgqz+xgJJsQ7mY4UZvC7jnSY0xeIT5bRsijQ62wW6roSYHd1qeWq+4nuAvamQX8h
         +wkC4rscW9pFnOlekTtByROVWvk5tZb+gmlgfqAHvPlSS1v28A+R94rlvPhLyON+hn4H
         F7Eg==
X-Gm-Message-State: AOAM530+pqtGzO8I3dXq10fz1KoFAvvD7yYrpqJESxzQK7EU65H8H5Lx
        whd29vcAAshf12r6klfYdal1wYayr5L4kg==
X-Google-Smtp-Source: ABdhPJzEXXbIb+jWn56KAtnzO/nHoMFTMV3HTSdQAdynKyQfe7niuoeiaungaU5EdX3hA4KITRnOSA==
X-Received: by 2002:a17:902:e782:b029:d2:ac14:2a8d with SMTP id cp2-20020a170902e782b02900d2ac142a8dmr320670plb.82.1602027702590;
        Tue, 06 Oct 2020 16:41:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r1sm276746pgl.66.2020.10.06.16.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 16:41:41 -0700 (PDT)
Message-ID: <5f7d00b5.1c69fb81.60749.0bf9@mx.google.com>
Date:   Tue, 06 Oct 2020 16:41:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69-57-g6e2946aac4c3
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 130 runs,
 3 regressions (v5.4.69-57-g6e2946aac4c3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 130 runs, 3 regressions (v5.4.69-57-g6e2946aa=
c4c3)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.69-57-g6e2946aac4c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.69-57-g6e2946aac4c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6e2946aac4c3f55c6bb9a94e02fa4e15e7ce792d =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f7cc540b7ee6562e64ff3e0

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-57=
-g6e2946aac4c3/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-57=
-g6e2946aac4c3/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f7cc540b7ee6562e64ff3f4
      failing since 7 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-06 19:27:43.829000  <8>[   22.951186] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel0-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f7cc540b7ee6562e64ff3f5
      failing since 7 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-06 19:27:44.851000  <8>[   23.972933] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f7cc540b7ee6562e64ff3f6
      failing since 7 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)  =20
