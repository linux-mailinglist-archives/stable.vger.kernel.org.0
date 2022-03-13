Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF614D76F9
	for <lists+stable@lfdr.de>; Sun, 13 Mar 2022 17:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbiCMQv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Mar 2022 12:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbiCMQv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Mar 2022 12:51:57 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5771D98595
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 09:50:49 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d19so4985773pfv.7
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 09:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bq7nTyYrb5aMF7ttLSBRr2/i/HWrDCB1QKSfS+Ox4zg=;
        b=cKtZVaICYq1voB3zt+AMuNTPkocTkIC6NgGwb2QbZWA7Bb3YLeT6lePd0bLNd/SkIE
         IWTBzdpKVqpTg8gTJSxNKAQEmncaBfS/HDd+3a//ZbMKHf6BrIoe975hqwtkm1VDghiw
         6HzRj8QwXPNHL/X9A6ooS8TeU9sUkkYbQkFzhBbh9v/2Lr5IAtS+fzQCSeAmnSQx8SZM
         D2cK3Kwg2tFfCS4P5TF2aHn9FPuoiJNGNGLA2zj9Kc1RH8R39XOoqDW7+YzPkDCAKcnG
         ynA0ZxFQqodcdyqHTz+Ct7+CV5qdBYVzFiAfMPhrLl0+cLPTeTQtd1rdFPHnWMRvyboV
         3AjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bq7nTyYrb5aMF7ttLSBRr2/i/HWrDCB1QKSfS+Ox4zg=;
        b=OV2xrr0NrSXLqwgOmFtifn8yUsBKa4QxG3OaVzkF631unSuLgZeHTR5PV56G0ssa7w
         6aejObRnzWhFUysw5OQ9VAF1Ub+2f2XdyRMiOs+H4aItWDwWRKgLGJvNdujCaEYIvoVD
         OtymP7yxe2yjoxKEhXo1BG1LutOpqkv3DSFaKGaTixv8173BysIc/ohK8OUfoomBg7kW
         PFYKv7ZMOIOntv614veGji8ximZx6OZhJZ/agsW1KY0PkYAQlVO4C74QjpNivJ0Lc7PT
         evbZu02uGpAOBmsORkS3jylQrpqLgiexELXjdkBbDkW6pbfT+ckhkXBFK2GXNKhFtjv5
         tquQ==
X-Gm-Message-State: AOAM531dSz9ApgO8HRhVkoKuQwjHM0WpQR5x66KLtGGHjueWXwQHgpHq
        Jua2oej7nRAnclGUzeWp99Ooh+GjYNBFuey4V6Q=
X-Google-Smtp-Source: ABdhPJxRcYf59se8walkEqEy33pLLIGhsQhAzfYwP7HnrwbFZwVgkFoFao0P01aV2zmnhgONBRLoAA==
X-Received: by 2002:a62:55c4:0:b0:4f6:b396:9caa with SMTP id j187-20020a6255c4000000b004f6b3969caamr19981469pfb.19.1647190247777;
        Sun, 13 Mar 2022 09:50:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f70d5e92basm17224438pfx.34.2022.03.13.09.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 09:50:47 -0700 (PDT)
Message-ID: <622e20e7.1c69fb81.76e4d.b602@mx.google.com>
Date:   Sun, 13 Mar 2022 09:50:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.14-112-gba4f1fffbebe
Subject: stable-rc/queue/5.16 baseline: 102 runs,
 1 regressions (v5.16.14-112-gba4f1fffbebe)
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

stable-rc/queue/5.16 baseline: 102 runs, 1 regressions (v5.16.14-112-gba4f1=
fffbebe)

Regressions Summary
-------------------

platform        | arch  | lab             | compiler | defconfig | regressi=
ons
----------------+-------+-----------------+----------+-----------+---------=
---
bcm2711-rpi-4-b | arm64 | lab-linaro-lkft | gcc-10   | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.14-112-gba4f1fffbebe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.14-112-gba4f1fffbebe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ba4f1fffbebefbfae793f5394627c48c15e90740 =



Test Regressions
---------------- =



platform        | arch  | lab             | compiler | defconfig | regressi=
ons
----------------+-------+-----------------+----------+-----------+---------=
---
bcm2711-rpi-4-b | arm64 | lab-linaro-lkft | gcc-10   | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/622deb5984b25a88bac62984

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
112-gba4f1fffbebe/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-r=
pi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.14-=
112-gba4f1fffbebe/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-r=
pi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622deb5984b25a88bac62=
985
        new failure (last pass: v5.16.13-53-g2ec2cdfafec8) =

 =20
