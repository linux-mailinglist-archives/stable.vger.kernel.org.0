Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698B64D2AC1
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 09:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiCIInU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 03:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiCIInT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 03:43:19 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F3FEC5EC
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 00:42:21 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id d187so1616155pfa.10
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 00:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1MAPa2O7RaMHCvRoQ2eWF760BxLsH/2kg3VKMtWHJ70=;
        b=2S3KQRiKCJUEnvf1jgd84Jws/dRFjqoQpiHlfyhIQ6S9OwuMl0X5fe75iLg9Azupw7
         w3xpZeAMOBkZNmXKyZLK9yjEmqdWOfDVFsL8vMct2OGLYq1WA1kBu3pQdE5/CeLRgTH0
         5ko+Nih2LIPrxaZWDsClVXIWpuc8nmFORUrQfF/83uJRNq7nQleYLmdwRDWdSuR6sQnx
         DrmkiKg4V1rzIXgRDw4NvJvYBFdRrDOOoMYTDx0iJDG/edgkChfxPbcLlDbB69Wua/3v
         YkhOxapJFxZUetYwu8C9dRGsrvoHZis83QNWWSeK/JyQ/uLLkMuFKRPeIarKwN86LIaB
         IWvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1MAPa2O7RaMHCvRoQ2eWF760BxLsH/2kg3VKMtWHJ70=;
        b=PpzVzg8C87HLKyr2ndcLR9yzFS0zmivAPq13FbD21H+DeVbTkvK0XiThAs3UJiRxOM
         uHr7NaHBxegR1iV16Y+eNJgRb7dzV+hZv4dG/Pgx367DGNDAU4c7l7c8nHHG3z40JZ3+
         0bOOY86PiXMClg9KsoizCV+OH6fZ17VQy7aVHD1ZO7xhYfuKaMuHBT/h0Krf2m1AgxlT
         t9YB+NCSgLMSiP0OLMnfseEBolLgkdLr303ZyY2QczwNzDuEXvLKOPBnGsI7JqBxbgqz
         d4+OTEqUjek9CFqV3Zg2VU7WsHE39MPR7Su1C8/E/3FhpckDrsYskKJIbEGa27yTe2ZJ
         lHgQ==
X-Gm-Message-State: AOAM533xDPEtF7T/4wqJ3lGrwrSfO+nECbJhxot6MjaLojhxM6KSFmxU
        2gbV15WInLp/ypVw38XgIKN+LmXue8VI9sXGnUk=
X-Google-Smtp-Source: ABdhPJy9R20vvk/hh5IZhmA2GFin/sul2a9xZD2PUbWR3kK0vPavC9/xbTXiszfgiPXP7chTDJHYyw==
X-Received: by 2002:a63:5a5c:0:b0:378:73b1:e1d8 with SMTP id k28-20020a635a5c000000b0037873b1e1d8mr17463581pgm.364.1646815341041;
        Wed, 09 Mar 2022 00:42:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm2046750pfu.202.2022.03.09.00.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 00:42:20 -0800 (PST)
Message-ID: <6228686c.1c69fb81.7f5b1.5183@mx.google.com>
Date:   Wed, 09 Mar 2022 00:42:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.183-18-g706b33173b11
Subject: stable-rc/linux-5.4.y baseline: 41 runs,
 1 regressions (v5.4.183-18-g706b33173b11)
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

stable-rc/linux-5.4.y baseline: 41 runs, 1 regressions (v5.4.183-18-g706b33=
173b11)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.183-18-g706b33173b11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.183-18-g706b33173b11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      706b33173b11edb712358d15ec95bb04cd033515 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622831d859afbee684c62975

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.183=
-18-g706b33173b11/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.183=
-18-g706b33173b11/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622831d859afbee684c6299b
        failing since 2 days (last pass: v5.4.181-51-gb77a12b8d613, first f=
ail: v5.4.182-54-gf27af6bf3c32)

    2022-03-09T04:49:07.035901  /lava-5843237/1/../bin/lava-test-case   =

 =20
