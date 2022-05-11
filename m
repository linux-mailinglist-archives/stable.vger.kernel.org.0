Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66EB524032
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 00:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348701AbiEKWYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 18:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348703AbiEKWYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 18:24:30 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A703117B60A
        for <stable@vger.kernel.org>; Wed, 11 May 2022 15:24:28 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c11so3162566plg.13
        for <stable@vger.kernel.org>; Wed, 11 May 2022 15:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bkEvxmf++0/1Z3NhBLUJ0Bd0Qdckmkyapkxmn8pFKKg=;
        b=RPYqPxldLXGe5E3nLc8bQsDqsq5SKl+pVIL98x9tsZFVB9GGdiefrAetcbBPNErEtI
         tH6g3+eKgUfnuLs2XOyZ3lYHqpc2IdBNgIXPsflzEIyk5r4OzXdppdOHMwITBDoG1A1R
         IYm8z7DKh6SmjvHvR4TJXkjJIH6ogQOy4djvpy/deL/X3aHKmyIP9CAqvLpq1mJpIZXI
         RsJxSWJfmPMlESRD13T86++AnsBTjCC7cFY04+M8B50MyWzTx3Huz7nANufOmRmcQGEL
         Fu6cvG29+ADOIT7qlYSwxliPqes4oUml1dFhlL9OV2W7FbplxrvbCeI8AXKTeGyaaGso
         6mfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bkEvxmf++0/1Z3NhBLUJ0Bd0Qdckmkyapkxmn8pFKKg=;
        b=F0R1MQRQWMWsNMNu3DVc09dk36KfgZMp3Z0UDJZVPLgqz3C4VOzbtq4ZyM3Nlb891V
         XrJn0JWnmK8E16KMdtK0B+oA5njsJyNbiCQDIYz+Dw11QeoNwcghEARC+f9Ii5+3OEzx
         Q18zl6HcPKVL31Fr8jDd14AASgckXSV06sl6ggHk9f5Mma083FgLb7TjaE4fTGkcey+5
         L0uhIZ1KAoel5vDQ/66IxKfxU1PDB69pcJtrfOdkNU+0Y8l0N1QCXnivoX3S8VolvLgF
         oRTrSIdJwtBTrBgzrmyu/+B9Ee25AXOEWF9nU8hK1INzbPaseZ+M7tMZT/9/UJwge7qa
         IkwA==
X-Gm-Message-State: AOAM530nFMWHLjafwx7Poeihh4j2Hj3ialsT+lyo7/iYN4hHatAbmp98
        fCZ1czll+BikuWF8cX4haLagrpa9HC7ocn8jvTo=
X-Google-Smtp-Source: ABdhPJw2k+zNfgAxSNprtVsq3RwbVMgqiSj9O4VpfnCLNhExM/FRDbDTnr+2nEa58F6SA/0eHTMQHw==
X-Received: by 2002:a17:90b:1649:b0:1dc:890e:2407 with SMTP id il9-20020a17090b164900b001dc890e2407mr7616818pjb.113.1652307867895;
        Wed, 11 May 2022 15:24:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o5-20020aa79785000000b0050dc762815csm2303581pfp.54.2022.05.11.15.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 15:24:27 -0700 (PDT)
Message-ID: <627c379b.1c69fb81.c7cd8.51d9@mx.google.com>
Date:   Wed, 11 May 2022 15:24:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.6-140-g25206fede2d8
Subject: stable-rc/queue/5.17 baseline: 162 runs,
 1 regressions (v5.17.6-140-g25206fede2d8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.17 baseline: 162 runs, 1 regressions (v5.17.6-140-g25206f=
ede2d8)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.6-140-g25206fede2d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.6-140-g25206fede2d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25206fede2d8b0dc32c72949043e11aad9c8aae2 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/627c0610ae4f62e18d8f571d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.6-1=
40-g25206fede2d8/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.6-1=
40-g25206fede2d8/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627c0610ae4f62e18d8f5=
71e
        new failure (last pass: v5.17.5-365-gc68c3b953062) =

 =20
