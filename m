Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7297B59006E
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiHKPlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbiHKPkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:40:23 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96D56E2C4
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 08:36:02 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gp7so3605598pjb.4
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 08:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=9JwoH04EsSwVt/y83uWovtRZx9SzsGnXyGRoga+meyc=;
        b=c4liipg2LHvdjxYOtauo3JZfK/TPexuYGU3NLHk4vINiTj+Xt33+W20Sm/pV0MLvi8
         l1bRxMO6Flye0au7x5gHcwSs8+LqKNSeFmU4lDeCFYV+UFrUbyWFkNzNOm+s2Mb5Wvqt
         RXnMy0E2w62CpYAVSUBs2uZKf56mwRmHgeFm85et7FT6ebLFGx4sljRPTjFAMByqrzqf
         aSNpm20jvNPB+R9mRxlxB6uTeja2MUmVddi9Z6Ceo3xE9nMiS8/LfNuIGNlC5NmOJRbb
         MyDsxI0WQ7cosE4Yv+AHoXroTIiborcNmdJt3AowgyEwWhuTABzMsDLisxYiJkrVloFR
         LuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=9JwoH04EsSwVt/y83uWovtRZx9SzsGnXyGRoga+meyc=;
        b=1OXPjSEC94elN+D1P8Q+OwIBI/eZTbYzUF52OjJ3l7Y9Cwbjfbd2F3CPFAaDcwA2rf
         2S3/ittpfwRXbhU/UmgK4ijNIcklxonm3BZRZCloyO/7IZAz7/xDo96UzzFY+JBat0yq
         0QXh3guhZ/+lIbbKq2FoxNozJKQ1EkXXJbboOFIVxiSDWWNl2sP+/fp8SreR6jgu1DQw
         qrGpaKT/cPUStJHLEQNg/wgjuJt9WVm6mdDAaEJR3W7VCUvL02gmk6zCUcFs6o2nn+4W
         PAgtGXNnr0HNhwFVqgbvBfGKyYgMc5Xfqy+XWYMVMQW2tff0zyh01SGKxDjepnH8nt8c
         ApsA==
X-Gm-Message-State: ACgBeo3I/9PWZzbbySoXzgOyCV2vn6IQ1rgCzaTpOcMEYJ/JkmCazL6o
        RXAnXkcCmph/sZSaas+bJpMHOjSX39oq8zMqg4I=
X-Google-Smtp-Source: AA6agR4hT0HVGp3As8GMjNGgyyRzwLCQ3FYMhbHAYtjMFVNQditftVXpX9PwZOap26p6P00w2+J0cg==
X-Received: by 2002:a17:903:1ce:b0:16e:f510:6666 with SMTP id e14-20020a17090301ce00b0016ef5106666mr32491937plh.158.1660232162237;
        Thu, 11 Aug 2022 08:36:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902e80d00b0016cb873fe6fsm15126435plg.183.2022.08.11.08.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 08:36:02 -0700 (PDT)
Message-ID: <62f521e2.170a0220.5b5a2.9c9f@mx.google.com>
Date:   Thu, 11 Aug 2022 08:36:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.1
Subject: stable/linux-5.19.y baseline: 151 runs, 1 regressions (v5.19.1)
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

stable/linux-5.19.y baseline: 151 runs, 1 regressions (v5.19.1)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.19.y/kernel=
/v5.19.1/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.19.y
  Describe: v5.19.1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d654f7e29909ce602942a1cd927d56d5aa397ed8 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f4f0d6c594912a32daf090

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.1/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kukui-j=
acuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.1/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kukui-j=
acuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f4f0d6c594912a32daf=
091
        new failure (last pass: v5.19) =

 =20
