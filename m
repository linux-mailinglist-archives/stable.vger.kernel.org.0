Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AB35916C1
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 23:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbiHLViz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 17:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiHLViz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 17:38:55 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633C89F1BE
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 14:38:53 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id f30so2001158pfq.4
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 14:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=lvgwfodFggg9jVVKkCXxPIbLxP/vSJsEuz306hrlQFk=;
        b=hf2E25G2q0Bpq6IwE1OWiQkqNfkf5Pq1eRs+0lAwkaPrxXRsvqgfhXzaME3i1SCKQl
         qUWKVOx2BoSa5JwYuRQoXBOVHhaKQ6Yc+/vdZ4o251UylVhxY9qZy0RzSi2LKHFNbZYR
         LqwpS8YRyyQxZ8n5UiRhfXFAF/W+x4Co3WD9eai9Kg5RcJ7TTcZuH2xBd661LS5zbNo7
         k/pUOah5/PhgFEliGPZMOdSdfI5s+TzpLxlFgyaZ/JmyZAV4GSKMyg7bWqG8lDXb7szx
         iQOe1cxCTqkzw4wHgE+BXD02CuMY37Hed6BGX4+j2b9B/4Zb96hpaHqew/0hukpenyfI
         nDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=lvgwfodFggg9jVVKkCXxPIbLxP/vSJsEuz306hrlQFk=;
        b=aVAZdMDn38Xd2VPvk897yPIP4/Hz9nsJLm8ikEXezjojqKqHbP+E5Qaqk5W4VVtCIV
         +pIpXnGkwHoQ0OvxBZhF+/6p7i5GaZlbakABbz4AZ/m5S1LwkvV9Ih5Wo+F0f8c0uuXb
         ACDvVM/CZlL0bUM9SD5N2o99PsOw2WnAehW1FVHBvKp52RCN9YlfiUJhTkbqoCNcLAwj
         5zywW15+RwEilagDJReeEaRQYeU91qD3dD/iZXCsd4SnrJxYFa63qGLDxqbbIKxgnYZK
         fvrfgvBx0Um9CR8UMoX4zJ5PrhTixygL5DPQuNWN5MyJ2JDQAYgGxfAz4eLasUvIRn9v
         cZ6Q==
X-Gm-Message-State: ACgBeo3ItfR742/igrcCSEkSZn1Bfr8W3LW4Ug9H3GTiZhS4qq+LixN4
        EPmtn9JAxxH8mts9JrKuSO9Zwy//w/v1wzji
X-Google-Smtp-Source: AA6agR59h5n9r5lkXmj2yIptSnvJxrLdEhhdO1ZWVxMuFqOxnIU5cjV7T896Mm1RdOINqMB9WZVP4Q==
X-Received: by 2002:a05:6a00:234f:b0:525:1f7c:f2bf with SMTP id j15-20020a056a00234f00b005251f7cf2bfmr5761829pfj.14.1660340332770;
        Fri, 12 Aug 2022 14:38:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y9-20020a17090a6c8900b001f021cdd73dsm293905pjj.10.2022.08.12.14.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 14:38:52 -0700 (PDT)
Message-ID: <62f6c86c.170a0220.ddbaa.0b21@mx.google.com>
Date:   Fri, 12 Aug 2022 14:38:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.1-45-gee0f76071c2b9
Subject: stable-rc/queue/5.19 baseline: 129 runs,
 1 regressions (v5.19.1-45-gee0f76071c2b9)
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

stable-rc/queue/5.19 baseline: 129 runs, 1 regressions (v5.19.1-45-gee0f760=
71c2b9)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.1-45-gee0f76071c2b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.1-45-gee0f76071c2b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee0f76071c2b9118f92200e9af590c02c4d691dd =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/62f693601d73e60513daf060

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-4=
5-gee0f76071c2b9/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-4=
5-gee0f76071c2b9/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f693601d73e60513daf=
061
        new failure (last pass: v5.19.1-25-g07ccf42c5e7f9) =

 =20
