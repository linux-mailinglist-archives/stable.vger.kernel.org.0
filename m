Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1440429FA1B
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 01:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgJ3A7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 20:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ3A7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 20:59:24 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BB0C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 17:59:23 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id j18so3844211pfa.0
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 17:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JhiUNmyX+UC8DlimLgUKLJOMhYa+yK8dyCQ3ne1Fd/A=;
        b=JWVqz6bEqJDRk5Wlw0jXRXYhHhuo66qpit7z0GS7xgSMgRlv22JL/OVmVb1NllhXd0
         ucXZOyR8FqZeQ/TnV/mxo40i+mCTyj0T5Nx7siLGyij93Vmy0QEqihNqzYQZer1v9n92
         EMF2Y8ws+eEsqVZUof4HzC2vynrhxRM8WQ9oy/nVcMS+f7ZYSeSy2HD8tMAo+5kQlqCZ
         VQdWUuWKZMjgK4Fo00PZhKbJ4clLtisZq8dL++SraJqB6BKgaBHAiP7in2lC4HWEDSBW
         ZVzW15XGrbAIQoXXUxzHaAjqBOlatFqKOCv2uz21ny0fW7mHWYXMPKUmF0f53agP6sZf
         sARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JhiUNmyX+UC8DlimLgUKLJOMhYa+yK8dyCQ3ne1Fd/A=;
        b=fgbRPSihofPxQuRIUczvoNv2+81Jn7NEpdAgIbYEeUBnuO9H5SHZHqdzIsGgqTWMYv
         pg4n9DH40WDrv1Gv1w4Urr0ioPSgS6HjTyYgMxcMpGwVWseLl5I1CFN6voypDIowQJxx
         i9BP9/xT+wJDX+BDewhqlmQvmQlvLQH/dPTtW77y6+X+pSJZo/u6EXZqIWKWCdmRQcOs
         LN9c1Nlmi38yI/a8qDwf05AIq1eI0thz9vCwLSZntkFpzBhUZs7Rkoi5O63GHu1Ertg+
         nCzwQ8IMw7cf4cr+e3l9OTc9z7kTZAkskruAyu9zBUlZnnjDqBkiDV9gq4NU5yozHRxC
         4uQQ==
X-Gm-Message-State: AOAM530wTePhMrKnTgOJuRQqvU7RASxUZEzl1yNPBj/n9h2YZckZ1SVd
        oF5zRfbgkmeFCsyfi6X/PYcj+SdGLkEnCg==
X-Google-Smtp-Source: ABdhPJzJMOKag0Y3jc9SS+sNCpQ2Z79vRG5csr5nS6Xll0m3g2Xw02EOKBLUtghV5jT33HVbtKJyAg==
X-Received: by 2002:a62:7b90:0:b029:152:ebe:828 with SMTP id w138-20020a627b900000b02901520ebe0828mr6966463pfc.38.1604019562490;
        Thu, 29 Oct 2020 17:59:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm3754287pgd.24.2020.10.29.17.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 17:59:21 -0700 (PDT)
Message-ID: <5f9b6569.1c69fb81.aca4a.8801@mx.google.com>
Date:   Thu, 29 Oct 2020 17:59:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-4-gab5ad3794a4b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 144 runs,
 1 regressions (v4.9.241-4-gab5ad3794a4b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 144 runs, 1 regressions (v4.9.241-4-gab5ad379=
4a4b)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-4-gab5ad3794a4b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-4-gab5ad3794a4b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab5ad3794a4bf24de8b88796f950a603f4fbe195 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9b338abfc112e200381046

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
-gab5ad3794a4b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-4=
-gab5ad3794a4b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b338abfc112e200381=
047
        failing since 0 day (last pass: v4.9.240-139-gd719c4ad8056, first f=
ail: v4.9.240-139-g65bd9a74252c) =

 =20
