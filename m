Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0753F297D19
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 17:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760919AbgJXPNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 11:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760918AbgJXPNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 11:13:45 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDADEC0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 08:13:44 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r10so3401008pgb.10
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 08:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2/YawIwCl3gCtbpa4WtaJNhyv7Nzy+0yNRC4qLkPZBo=;
        b=GfR1vxmlyr0KuvfowH9CdhM7ET+lWXmNvvTru119g6cBruWA2+HOeIJiRRUUOeE9A1
         n3GnmBycrSxbybkaPv0wkTaEZeijr7T5QYf3OkoTWr1v2lWHBho3oxBU+ab5amsOHFRo
         Bq0mpI+46aBVvrBVljwsfHx8BMPqRLpx49fGhHjSJPC0s4y37d++jUivQ0Hg/c5pVFdF
         I4HI6nvveJt3ESysm469jtAku6srieslfLQHp/Q4XICLvpWYw7Ua0qIKZACC2ghC2jgM
         1LkJOHW7wufRciQUpKCdJVSoUp00n8OXZGXKmHEHWiQeCpO3XtC36ZKpZHe3PH2IZZ7o
         WU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2/YawIwCl3gCtbpa4WtaJNhyv7Nzy+0yNRC4qLkPZBo=;
        b=VVwkdSBxwi5EPG2MgNoJ0hO9bgTxlLias9Rz4Mwsq1s2cENKAW9Sh36Q8BrpJeFu4x
         rVwjpBQ+wTExstTUaB+3yU08UVTBr2BwEKdcN3yVbvaLxTyAYY9TjUy31AlgjI0PRsH4
         FguyZBtZAUNWL0GHGw3gpXQdyJC9GyXOSU85Epj90Ene1vlORkpr7n1phWLN4z4CFzfA
         4/YUAZWVoAhELZZ7PJOwj6iwvuMvxKBlEe3qrEbKucWsfnUd+shukikL6O/OpfSO6VIe
         hC+s6VRyQmFC6MuOoUsTBjVUaQOVX0OEw+BRlrD+ny0aK6h1GgXvOsw9sCDM+QOA7N1F
         bjEA==
X-Gm-Message-State: AOAM531ttA85VVCYUMJRdQVPakUeWYNDpXwJH64JT5VbzSARipMzbjVF
        U+QkQZSW1vjcPQcHkT3kT13Eq+r4RucZbg==
X-Google-Smtp-Source: ABdhPJzvD/8jS7g/sLZDJV2ty6LK7iAv+HHkiU0qQJHCzB1vU6agJB4OGCHZJIuAX29LrxVKN6b4qw==
X-Received: by 2002:a63:cd48:: with SMTP id a8mr6070402pgj.83.1603552423631;
        Sat, 24 Oct 2020 08:13:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k127sm5475550pgk.10.2020.10.24.08.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 08:13:42 -0700 (PDT)
Message-ID: <5f9444a6.1c69fb81.a4261.9681@mx.google.com>
Date:   Sat, 24 Oct 2020 08:13:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.72-54-g5ae53d8d80cb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 179 runs,
 1 regressions (v5.4.72-54-g5ae53d8d80cb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 179 runs, 1 regressions (v5.4.72-54-g5ae53d8d=
80cb)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.72-54-g5ae53d8d80cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.72-54-g5ae53d8d80cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ae53d8d80cbd1faa032c23821f8ee16a689e71c =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f941127756ffab882381023

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-54=
-g5ae53d8d80cb/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-54=
-g5ae53d8d80cb/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f941127756ffab882381=
024
        new failure (last pass: v5.4.72-24-g088b4440ff14) =

 =20
