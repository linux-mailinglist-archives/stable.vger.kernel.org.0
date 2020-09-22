Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD229273B83
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 09:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbgIVHN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 03:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729741AbgIVHN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 03:13:26 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA71FC061755
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 00:13:25 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id z18so11620165pfg.0
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 00:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CiM1bWrmNu3ZrzAb+yaF5jKMPnz+tqbVJEYtMzE95vc=;
        b=qNsP+ZC5aljxSYEgi70+TjrFrgrzlq7WQ/dJTvCd7IasNDdSIQBAU2T4cs2l0jHvFb
         Ir6BLagN21n6s2172icN5us7mf23ASJQ8/gadptaOY6Q4hYDpGHxiXZIbLMiwFfHg/tN
         ToT43lnpRZWvi0ANHj5cD061D8Zt9tAtbVeSNGWhs9WB6gbjdDaOWvk/wtr2q9YRK4l2
         kqzF5iMjJqe4MEny9lt+Q49wpB9NlYKVnYB1FBNkFbxx7nI/PkxPl23GSnbFCuzFxqht
         v/H+RKuA9DepYPpFpn2bwStOhfFY6tbbiZv0hbw5yEeD09fJ9qAEDKjkIDcuSLXNQQAk
         Befg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CiM1bWrmNu3ZrzAb+yaF5jKMPnz+tqbVJEYtMzE95vc=;
        b=cDW9bqvOP6nGdgfgs6L6KoA6YBobFQWA/1l0T4LduJx83R4LfwNTP8YVRhsLIl0fpJ
         fSXA2+jLm5cHasz4TvsJiOLXr8y6pLc4/2HsZWR5StQ4z2Ek+xu3Ul7V/E3DXunESSl2
         LJeoLrx6QCWTBYDQ+CsWrutGum2s/6L708DF6kVfKMTN82r+eAlAhWmdZp8vHoxoLy6K
         zJfD7WFq4pXOaQbnVbSCdwrCxNTG9tzH88083sDo5ID0OLP0ABtBjHNq9pxK5W3VV0YO
         4YOEETSaldGoFOIz8u1Gt46PC5pDV0DGeNXMSg0BcrGY8d0UoLenjCxInCrEj1/o6Xyo
         YMIw==
X-Gm-Message-State: AOAM532U+LaHjP2ETN6pT6GVoBun9MNvyLZ0XttOR8hPKv6KvSYjJwmi
        3D31NCtSv9KKHkJd5g9Fzae4JqfXTGpwEA==
X-Google-Smtp-Source: ABdhPJw7MDMxxcXYcbh/2l83JhmJHN3fOCDzTNiuJfHKUPGzhvs8G39ok3liHRg0owcpTQg+isMwhQ==
X-Received: by 2002:a17:902:ba88:b029:d1:e5e7:bde1 with SMTP id k8-20020a170902ba88b02900d1e5e7bde1mr3497420pls.65.1600758803892;
        Tue, 22 Sep 2020 00:13:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w14sm3919994pfu.87.2020.09.22.00.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 00:13:23 -0700 (PDT)
Message-ID: <5f69a413.1c69fb81.b8ab9.b043@mx.google.com>
Date:   Tue, 22 Sep 2020 00:13:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.65-203-gbe4995216657
Subject: stable-rc/linux-5.4.y baseline: 174 runs,
 1 regressions (v5.4.65-203-gbe4995216657)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 174 runs, 1 regressions (v5.4.65-203-gbe499=
5216657)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.65-203-gbe4995216657/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.65-203-gbe4995216657
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be4995216657106594a642263c66b9f043323177 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f696ccb1304dc78c1bf9dc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.65-=
203-gbe4995216657/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.65-=
203-gbe4995216657/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f696ccb1304dc78c1bf9=
dc1
      failing since 163 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =20
