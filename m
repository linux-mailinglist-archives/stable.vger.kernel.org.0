Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7045872BE
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 23:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbiHAVKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 17:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234754AbiHAVKm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 17:10:42 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A19115732
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 14:10:41 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c139so11753838pfc.2
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 14:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x+gBT4FzPVDOSNfIwgiDV7+9yD1g11w3y8vu9f2BAiI=;
        b=zjYIa4z869QnbZWbk7M4aklYcT79dpz2IFSDd9MHRJIHaCtV2XECE/z02k9dpNLjC7
         /3/ZWQXRNlShWM+ZOLLkK86CNiBiRdEkjrJL95GOSnbTGsUktFPiudzDwqhxbaaiE8CX
         uh16DKHj4ZAWpMeqEFjkdsyMj6rhwjkhI58iSjVka8KQGcqhTjwG6dDcU1ctOMdSYK1F
         +piXijd3irNOOgGLcQh3puSft9vlNkLLlKSoGGX2SGTIGf1NVmj88OCjnSwVfDPCPScw
         X5NvwbWUy7A7RPzO4w3JwzzxgjzLJwwt+4ZjhVTPG9rOitP51sgPUsDhhszshceASi7W
         6Y/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x+gBT4FzPVDOSNfIwgiDV7+9yD1g11w3y8vu9f2BAiI=;
        b=mLvlf8GS+1pbeJBiEvWk1gpxCtOgGbsAXdKf2Tg+MUuVeBVsbHqS+rh6BO49xfjVWA
         h1yNk3AyBnqxgfB/lLFTilz1+eLGHmknHge6OEWCFaPhJY3fskM1Yu53Zo+78xQ5DEvb
         SJBa9+y7EwuqpZaJE/b2cJe5IG8lFUzoU+RmB9BS8IWitMehFNlKTLdNoFuzlyTISYoI
         HTIJhEEyblIgdAkOcfG1e0ddnDz6XHAm5ETFuG21ZaVF8x3GDrO/2+AEZH1szF39Pdp5
         hF6bVgCUJl/N0CWSOO1mpZO8OZ31SU5QIappu+YHx6T/qyIqzl5YfNuEcZ6ia7NbjTDF
         IHbg==
X-Gm-Message-State: ACgBeo1qmYtwwMX0o0KntM3LLrrYAXE68Sb+nqRKff1sIfZkPeHpcWwk
        MAnhSVUcCltQIvKdds+/QPa7XMmxWpZoI50EnyU=
X-Google-Smtp-Source: AA6agR7nof+0tI1OHqAYoQEhkGWCKMiq3+Bp6E4HP0xhCE0WCx8Q8GERYbDIvqK/CI4H3VgAkkSfHg==
X-Received: by 2002:aa7:9813:0:b0:52d:395d:c98d with SMTP id e19-20020aa79813000000b0052d395dc98dmr10172002pfl.55.1659388239677;
        Mon, 01 Aug 2022 14:10:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y63-20020a62ce42000000b0052dd9dbe291sm44596pfg.105.2022.08.01.14.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 14:10:39 -0700 (PDT)
Message-ID: <62e8414f.620a0220.519d1.0193@mx.google.com>
Date:   Mon, 01 Aug 2022 14:10:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.133-168-g4f874431e68c8
Subject: stable-rc/linux-5.10.y baseline: 88 runs,
 4 regressions (v5.10.133-168-g4f874431e68c8)
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

stable-rc/linux-5.10.y baseline: 88 runs, 4 regressions (v5.10.133-168-g4f8=
74431e68c8)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
qemu_arm64-virt-gicv2 | arm64 | lab-broonie   | gcc-10   | defconfig+arm64-=
chromebook | 1          =

qemu_arm64-virt-gicv2 | arm64 | lab-collabora | gcc-10   | defconfig+arm64-=
chromebook | 1          =

qemu_arm64-virt-gicv3 | arm64 | lab-broonie   | gcc-10   | defconfig+arm64-=
chromebook | 1          =

qemu_arm64-virt-gicv3 | arm64 | lab-collabora | gcc-10   | defconfig+arm64-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.133-168-g4f874431e68c8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.133-168-g4f874431e68c8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4f874431e68c8a1cf6c0d0c8353e404f9e2b6e02 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
qemu_arm64-virt-gicv2 | arm64 | lab-broonie   | gcc-10   | defconfig+arm64-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e80bd8c3560d06f8daf061

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
33-168-g4f874431e68c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
33-168-g4f874431e68c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e80bd8c3560d06f8daf=
062
        failing since 3 days (last pass: v5.10.101-87-g1f48487c6f05, first =
fail: v5.10.133-102-g3dbf5c047ca92) =

 =



platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
qemu_arm64-virt-gicv2 | arm64 | lab-collabora | gcc-10   | defconfig+arm64-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e80b45533ad1482bdaf07b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
33-168-g4f874431e68c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
33-168-g4f874431e68c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e80b45533ad1482bdaf=
07c
        failing since 3 days (last pass: v5.10.101-87-g1f48487c6f05, first =
fail: v5.10.133-102-g3dbf5c047ca92) =

 =



platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
qemu_arm64-virt-gicv3 | arm64 | lab-broonie   | gcc-10   | defconfig+arm64-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e80b9ca81ef451dadaf068

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
33-168-g4f874431e68c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
33-168-g4f874431e68c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e80b9ca81ef451dadaf=
069
        failing since 3 days (last pass: v5.10.101-87-g1f48487c6f05, first =
fail: v5.10.133-102-g3dbf5c047ca92) =

 =



platform              | arch  | lab           | compiler | defconfig       =
           | regressions
----------------------+-------+---------------+----------+-----------------=
-----------+------------
qemu_arm64-virt-gicv3 | arm64 | lab-collabora | gcc-10   | defconfig+arm64-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e80b448ee17cb1e2daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
33-168-g4f874431e68c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
33-168-g4f874431e68c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e80b448ee17cb1e2daf=
057
        failing since 3 days (last pass: v5.10.101-87-g1f48487c6f05, first =
fail: v5.10.133-102-g3dbf5c047ca92) =

 =20
