Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F0E485923
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 20:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243505AbiAET1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 14:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243475AbiAET1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 14:27:00 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095DDC061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 11:27:00 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 205so299308pfu.0
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 11:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H2PiKK21XBX8k684jcblNCwOs8y6cvKXkvxVrhR+azQ=;
        b=XtamX9ScGmVfXqTzzzyoUtbka71SkkFPSn3TBC11VDRvYUYmoKSwJc1W16aBzeZ+ua
         6e43v4QZ7DEFi4RRaZ3/9TOzC4wxGrq2QPnulhti19P/ztphA9zlRrJNwyi0ypO0iruq
         V2IOtu6xrjW43iujOx2uPoLrxjAeqw6XqMfvBzrPv0w0XUWZff0vK+esfqbneMzYvKHD
         Jd7HSasjsT4Fc6ujbbnJ7SH6wZ14tadZ3U5QZ3eNsyfj8kg57fnZLe19KcSpF5yogqNQ
         Lcmih0aFu4kaVjOVLDik5W8pw5zT3dA3yVDMYC/a01M+ZKWhjCrxnPNlP3sKpjTiSt1K
         tkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H2PiKK21XBX8k684jcblNCwOs8y6cvKXkvxVrhR+azQ=;
        b=AQ8qwmOpE1ua+9BVxRVBOXOiLdwg1DbcUeoBBZqaKc7Ya7bms8nDaOT7sFi4F9FmKT
         +bKf7WcwYmWbCjbq6DOxoSHwXxPEUFVxbSJkorjkIbMoXGT69wosRJZLtKOjEyW5sdim
         3ydX3Izgf9Ahmj5a/CpMW06IJDElpxjrdv+lxMDhIKQaG6IquCGl0BcyKfaonPTkLIZZ
         X+pUSGtfMDOrDs4UDKIAKMY78y8cVFUfshGD2rW93xG9hUA0kUFqosYIpgiF1956Clr+
         uo2iURpnMh8d538QrUeB7/LkMFk9D1GN3t07tmyYY6wbtK/MCWV2o1a8f++Z71T4S38c
         qxLQ==
X-Gm-Message-State: AOAM532dFCYY+nya/JQfBNtzlnw5BHvGBXizIiupHhcC4HP1m2Kl7U7N
        klOqEhw2HKqVTHaKQzLFz42Q8aYfvwSu7cqJ
X-Google-Smtp-Source: ABdhPJwjrL0dDZo0zRSSifyyChWFIMo215Hog+I51NSBas68nGI1A+nQ03hq9ZjTWWOZKKM9mQp4Sw==
X-Received: by 2002:a63:794d:: with SMTP id u74mr17952929pgc.326.1641410819527;
        Wed, 05 Jan 2022 11:26:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g7sm43495305pfu.2.2022.01.05.11.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 11:26:59 -0800 (PST)
Message-ID: <61d5f103.1c69fb81.a8e72.56d3@mx.google.com>
Date:   Wed, 05 Jan 2022 11:26:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.90
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 164 runs, 1 regressions (v5.10.90)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 164 runs, 1 regressions (v5.10.90)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.90/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.90
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d3e491a20d152e5fba6c02a38916d63f982d98a5 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61d5bc26468872f07aef6742

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.90/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.90/a=
rm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d5bc26468872f07aef6=
743
        new failure (last pass: v5.10.89) =

 =20
