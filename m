Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0D5510D3A
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 02:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356380AbiD0AiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 20:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356351AbiD0AiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 20:38:19 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D28225F0
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 17:35:10 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g3so225085pgg.3
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 17:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o+qGkf2S3/x0xbaZP2aOBILagHlJghcBh66UP9Qh1yc=;
        b=G7mYkqOtH/mJz4pDLHUY0l3r9Dg6Q0rDtYsTs5gKtcrSl89bHFnToOXuzYCfl0/Fir
         fNyD/abJnS4zgtwubQKzYcFU1Y6elRLhufmGR7JwTeJSekelQb9CbMMwqmLpOMyNMVJM
         tL5c44R+MG9x3tipmRwlY8CxTeeSMjizh9Ki4aWHYR5AKeqLSAwnEX0jnj7e8Ngll5Mi
         OYZk9iM/tLYwRKiXdPlyE8cpaI7ppbSLGnCgT6W8Qk7hl+6O9rEXClV7CbG/z3aBsGYq
         9sFPmCDtAdvYUWfQP66uysrMBDQ11N/V5+ipMzmtQoSYlYGVDDNzb/0xk9kqNN9iVQ/N
         SphQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o+qGkf2S3/x0xbaZP2aOBILagHlJghcBh66UP9Qh1yc=;
        b=DH88Fnq4YiSImBX2NolxQQxkYpeOpJ0X5Hc4dmaib4gHFv6zoOqkHcjY1b82eq7U4/
         U3Dt1LiM1OmcdtRBSuRt6lmfU6teECkh/hO3Yw6aG6zIMkdfcEexVDwXIWjkIH0Dcoxu
         qKo3mvawES3y3dKqxYEqg1uUtYaB7OGFjs8vT0DswjnG1y/ABT95+z5RQMHCg0APCvdI
         GCu4R2oJvFrpYvjno1kad22F/R0vLkcPVVxHo3wT0++RGv6dt9cpo8TOKK/TPn8AEzkF
         dTDhKJb3HQI0NlQOT+7+LqlycK3zyavMuaH9CHV4Ye0zliMAvz6J3X4M1RpYF/BRuk9D
         AEdQ==
X-Gm-Message-State: AOAM5304NE4NYkv+L0R5qyAii8vydcSU8bLCP4XyxArHDN0NTVpNLctK
        jn3ugyxxt3M6Oj65KFYXSLGEiqWcaVH/oLaQeYs=
X-Google-Smtp-Source: ABdhPJxUeaHZcXEVIf7oWS1AJJx5XFIPYKnn/6WjDp/Hku9N9ExhukUsK5TsWnpQVDdhWIas7K0SLQ==
X-Received: by 2002:a63:85c6:0:b0:3ab:4545:e29e with SMTP id u189-20020a6385c6000000b003ab4545e29emr10672820pgd.573.1651019708379;
        Tue, 26 Apr 2022 17:35:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004f0f9696578sm18399435pfl.141.2022.04.26.17.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 17:35:08 -0700 (PDT)
Message-ID: <62688fbc.1c69fb81.3ce36.b420@mx.google.com>
Date:   Tue, 26 Apr 2022 17:35:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.112-87-g889ce55360e75
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 120 runs,
 1 regressions (v5.10.112-87-g889ce55360e75)
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

stable-rc/linux-5.10.y baseline: 120 runs, 1 regressions (v5.10.112-87-g889=
ce55360e75)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.112-87-g889ce55360e75/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.112-87-g889ce55360e75
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      889ce55360e75088d2b85d71e5119d5e3d45c90c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62685fbc9e5a6d270fff955a

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
12-87-g889ce55360e75/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
12-87-g889ce55360e75/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62685fbc9e5a6d270fff957f
        failing since 50 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-04-26T21:10:10.799990  /lava-6183187/1/../bin/lava-test-case   =

 =20
