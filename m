Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA04D57F0CE
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 19:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbiGWRuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 13:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235743AbiGWRuy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 13:50:54 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149C81A3A1
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 10:50:53 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b133so6966049pfb.6
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 10:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dHZSuF9p1P7lXLt6kzThL4gjVn8jEFSjXo2W0GIoqG4=;
        b=MSmpxKbaIw04Pp8V+WMZP25yCdJs+q23soIeMuJACnbUE9hD3z9/dfv+/Lx5l609M2
         FaU99fdkrhVyEStfWI2W9qpn6utAHq/d80UkY5dc7G0rpGrrtHF1h4ZUnehJ0e/FA1oU
         3zSYy9VYxvD9HNEiBnJo/2ECglgHJh4q9dEHy5whUPTfm2lE5F1VX9pAfUTYCx9FMpqD
         lztakqiyGgcjGb81t3UjVP4h4UlFmP65R7fo+O8nN/6rnf8NiEhZ3Ik+H9XzSqM1euce
         Uh7TRRHtUW/YOpB+WEt2mI/pxGnYsXHkq8eR30ftwa9pmuEcmy83hOuFNHMaT+Dg4Paf
         N6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dHZSuF9p1P7lXLt6kzThL4gjVn8jEFSjXo2W0GIoqG4=;
        b=HXwgepF9hNu1ldTdeApXb4gzj7yEW+MfVh2LzsCdC00+3nUWaZDQV2wc4bmSLFX/27
         nOtBqYBPTgVyAHsiE8t5iitf3odlk3C/q5qGoBLemPN0NRgiazk3I2CWRq7TXsKRR24U
         gLuJp/E1pl35L9eJowZRcBPhG9S/VTAJxFItKgaeQrmz772Z7+vfCqo1HSUl6wKZF5sy
         0Zx/ry3NAJ8vxVUklZYrjwaiJ+vzZoRmqwk/443DJKJwvaAfJy+ooYA/heGGWUMjmjU9
         W+7S5+3O2P3yXnxngUNlaIZO0YlGUb4rN+amQRC9zYC5k5hVgT4XFTLUBTpgFPZgNV4C
         S+jQ==
X-Gm-Message-State: AJIora+HBALPUtJ8WqalTeAKNqX+iWzWiiCCkDeJBTSzIeArjAs0aEml
        t7+IiGYtCkZlWULsrX00m8kyRvmv2sodlRLQ
X-Google-Smtp-Source: AGRyM1v6qOeajSWyJIJS/bgiBrc4wVHjO5L20+7cqoa3LAIBjlPqwLAEz8I4t2jP5L9eFbsoK9bRTQ==
X-Received: by 2002:a63:6c42:0:b0:3fe:465:7a71 with SMTP id h63-20020a636c42000000b003fe04657a71mr4604046pgc.101.1658598652144;
        Sat, 23 Jul 2022 10:50:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n11-20020a170902d2cb00b0016bdf2220desm5992076plc.263.2022.07.23.10.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 10:50:51 -0700 (PDT)
Message-ID: <62dc34fb.1c69fb81.d81f9.930e@mx.google.com>
Date:   Sat, 23 Jul 2022 10:50:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.14
Subject: stable-rc/linux-5.18.y baseline: 174 runs, 2 regressions (v5.18.14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.18.y baseline: 174 runs, 2 regressions (v5.18.14)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
kontron-pitx-imx8m           | arm64 | lab-kontron   | gcc-10   | defconfig=
                  | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.14/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9aa5a042881d4a99657f82c774e9e15353ebeb2d =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
kontron-pitx-imx8m           | arm64 | lab-kontron   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62dc052965385ef8ebdaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
4/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
4/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62dc052965385ef8ebdaf=
057
        new failure (last pass: v5.18.13-71-g4142b06492bc8) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62dc040045aaa1d2a8daf0ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kuk=
ui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kuk=
ui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62dc040045aaa1d2a8daf=
0af
        new failure (last pass: v5.18.13-71-g4142b06492bc8) =

 =20
