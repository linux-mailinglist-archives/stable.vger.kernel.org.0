Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214C02A2885
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 11:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgKBKuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 05:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbgKBKuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 05:50:12 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5F7C0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 02:50:11 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id h6so10455074pgk.4
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 02:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Hudo7cvBXfmT7tn96TNhb70FIs2SFwgxp+lQVKf0WVc=;
        b=WGwMtW7+wIX0nDMn+tGUIRY08+U0nuhzzXRdKV96fXxEoNX2XxCKNgIxz3btjChYYX
         8KG/Y+kDeOnFq0o6SAhVUUODDLby5zXsC9LOPHKwo1F4xYgwkT5c+TbU3Kqo6d4Ct0+N
         sp4bdkLSkoOztqn60kHGsuN9CMAFjTPpmGdj4hVsEuOKXEaHiuOaybdfsY6YUIMGd3Wf
         7QRa1N6pOrEXgtRlyzHkSzqt+h/+MppJukDK6gIS7kguktkEE0O9q6TWKBTJDH00IND6
         haJz+s3KocbjNwe6ERY1vXpdRARg+ubu8d4/RhMt/6iIl6jBHZuiVNNlZL/qQvwr6Md7
         UdgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Hudo7cvBXfmT7tn96TNhb70FIs2SFwgxp+lQVKf0WVc=;
        b=E962IDXsHeXodal7E0Yn3qFpzQwPOOWsDcl3XSnf6Bn+eDkCpxlQ3L4ImJw4W9TXx5
         A7uIg9Tj3Xz8AvkNYcjGbDs1VBIZ+9TL1CYZAFL/nes0M8/4VrU5I98re8Gj5UWQyiT8
         dV+dPGoPi+afKmKI9tOfHioEcyqW/PkWyBNGpNyQ1oz3qoGFNcToBq2/q+DxvOU5/Irp
         lpYnOlEAB0j2V4XM+hXr2oBBTTwqzPF2KE5FDAtV/PoE5dB4Oep/03yaH2C2AHcCqXwF
         y6IQFL6yFCn1HILCRxllFitXIw08hKoHGApvQwpZWu8TGV9/P6AU3H/EeCKJPMGQZnOs
         rbSw==
X-Gm-Message-State: AOAM533SzRhV8LIEYfOfqmbIfpEuOVL0qV/dBPuAeUWzqLFrDqRuaLpt
        QH1ox8L64zFtG4ReBgIn/70u+JCkrQS3GA==
X-Google-Smtp-Source: ABdhPJxgO50QA8W4VWAAD0sE4J34Cnx+mOvDLSV7wr84/BibBRrAdyZEclRNQjMTqG6Y/ZQdbo891Q==
X-Received: by 2002:a17:90a:1f45:: with SMTP id y5mr16373540pjy.16.1604314211223;
        Mon, 02 Nov 2020 02:50:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b16sm10716044pju.16.2020.11.02.02.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 02:50:10 -0800 (PST)
Message-ID: <5f9fe462.1c69fb81.76324.dab8@mx.google.com>
Date:   Mon, 02 Nov 2020 02:50:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-44-gb43e22b7f986
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 120 runs,
 1 regressions (v4.9.241-44-gb43e22b7f986)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 120 runs, 1 regressions (v4.9.241-44-gb43e22b=
7f986)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-44-gb43e22b7f986/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-44-gb43e22b7f986
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b43e22b7f986815ca4fd686d5af929f362fdbe8a =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9facd54d036308303fe7eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
4-gb43e22b7f986/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
4-gb43e22b7f986/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9facd54d036308303fe=
7ec
        failing since 4 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =20
