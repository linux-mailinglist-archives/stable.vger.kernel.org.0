Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E874D784E
	for <lists+stable@lfdr.de>; Sun, 13 Mar 2022 22:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbiCMVDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Mar 2022 17:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbiCMVDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Mar 2022 17:03:37 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDA579C49
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 14:02:29 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id t5so12591073pfg.4
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 14:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l3YEBAjMtRZxbgtaXIIB5YqWykDE9O9wbhv2CGs22Po=;
        b=bOnFFE5uykbNYZRNZfQZrAsdMyii1h8a9/3yuYLRlAW7Mx8l3PpTHX9IdJ0Sp0xTL2
         xpwPuYKZF3wwGWFTLKP6SketGs7VDoxoB+G8fdL0K+AAbl3HoGiawmXlEQUnYUvfzObj
         A8uhyWC/lMYaxpGovg7Fy261pAmlx+fVgLZ280AcanLsORpmLRuT2GWA4jAvYdpoAb+I
         4UF4YqXFRMS809QwxVq23l4KJQJOGH+4zHyBd5M73Zm9KsRUCSHPY+5aSEjNdHbK0OLW
         cXrG9bjACUWT26WZ2pA0M5c4o8y1XWIBaUB9JuBjPEvElhiecG2nMkIz3MFI0ZPWmtvm
         L7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l3YEBAjMtRZxbgtaXIIB5YqWykDE9O9wbhv2CGs22Po=;
        b=aaad1IgKE7DS6shQXyogcJjmTl3mS7ORLLvH75yAoMVL3J4F3hDr+9PwcVA79PqUFk
         34f+9K3k3jeJ1+mUKkWXCEKB9NcEMRbWxwnoUhTtJvkaIMGrwUOPeUyN4a4fQ95OQqYX
         ptCbaMhuW1Vw0VBeEAAvp+Ftp1Eonbk7vIQ6kwqEr/WPHkxFpjr/gC41Ssf4QWRdnHl0
         lvA1G198p3kznnCr35hiU1HuefE751PpNMVxyS2gg/Eag99IV4YKFE7pN52jFeenugLa
         xHaxnIY8OphXD3YSLYIfMCwTBz6AclXj5RbpiM21tZclix6VU/3IYSmHoJZ43XMsXiQm
         0lcw==
X-Gm-Message-State: AOAM532CCH0tHABYPx1YAnswrG18QajwGteF5T4/qSkI7PRAfgtjvey5
        gr5N99axqQYG2zAd8MkWDGLP51TLs8sH93gDOyE=
X-Google-Smtp-Source: ABdhPJxSqmGDf6pSBAXYQxiHwXhq2NLzE4K52UqJlBHV9Z5qA19yzAnDPb++laIOAR2ZlSjalU1Fzg==
X-Received: by 2002:a05:6a00:162a:b0:4f6:fc39:c076 with SMTP id e10-20020a056a00162a00b004f6fc39c076mr20815670pfc.24.1647205349338;
        Sun, 13 Mar 2022 14:02:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h14-20020a63384e000000b00366ba5335e7sm14305829pgn.72.2022.03.13.14.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 14:02:29 -0700 (PDT)
Message-ID: <622e5be5.1c69fb81.7f2d8.4838@mx.google.com>
Date:   Sun, 13 Mar 2022 14:02:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.28
Subject: stable/linux-5.15.y baseline: 68 runs, 1 regressions (v5.15.28)
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

stable/linux-5.15.y baseline: 68 runs, 1 regressions (v5.15.28)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.28/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.28
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      aa79753319d8b2361631438c609901c3e4cd5a12 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622e25becba2cc644dc62968

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.28/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.28/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622e25becba2cc644dc6298e
        failing since 4 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-03-13T17:11:06.714339  /lava-5871998/1/../bin/lava-test-case
    2022-03-13T17:11:06.724211  <8>[   33.194597] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
