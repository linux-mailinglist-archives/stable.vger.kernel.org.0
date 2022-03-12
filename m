Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA54C4D6DBC
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 10:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiCLJ0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 04:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiCLJ0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 04:26:05 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C130826C2F1
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 01:25:00 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v4so10253853pjh.2
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 01:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m+1K0MR1UBg3pscyQthFyAPcKe41LZ4E3U3WhCvJnJ4=;
        b=bl7PI3bFFoMQPIF3ikuPbnkLnqHA8IsyKtbFd6Pnv5rt4F9Ra3mvZuWIWUO/Zvxq6H
         ChpEXIMCqXStRBJNhZQ0GN61dVTim/uZFeHmDZMbxQ8W3OQS5Ok6Y+bDRY37II/xTP8t
         6HYDEw0g/hnJCIt5YWWv1SZS0aJCD18bcicd1mbY5Q2vOAz5Iuc0wobQXk/RPhBxABm3
         G9oh6J/JxL7CDouTo9g57neYMqTQMlu4jMw8MLra5JCUG5uT+QD+15IPiu2HFdVDogvs
         tysPfFbDwdbqvSAbJ7AwYief1jtHqdkcSDt0JEWfTwYhmYYjl20Szy9+i0hWa1QscTiw
         MLLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m+1K0MR1UBg3pscyQthFyAPcKe41LZ4E3U3WhCvJnJ4=;
        b=e+1p85/S61rbMelEG7dDA57l7VbMHROLT0AMgfFRWbUWMtwIJDLEPsipQyR2z/yGEZ
         x9dVtnwgYs1gi0u8LFTGMx9YcxDphRiVQyv1GeND4WPFu/5wGV5Z/Xe0E34a/CilrvG0
         xGw8atO8ihS800S56zG8c5k0zjZA6JPNQzs+N9yzRcqBv7NtVp2+sMrXssbjh2hjQmdt
         E+ohdVKqVp56UI5EMeUsuxI5eNjwT0RdbSL6os2w6J7hcmt73dcT2IRJRcBbovBfPVHP
         84kWVlJcn2kCjxSztUsOlCVaw9A0gI5pQXxGgZ97rgKi72Acuu5EqATkAxtmDrR/wzks
         xzkg==
X-Gm-Message-State: AOAM5311YfHmq0x00xw0c6DpRrtyBmTcek4SmovkockK4EDBknMutmYC
        i70sKfwLBm0pXJ1f11bqUe8p5tLfiyEvOrzKC+A=
X-Google-Smtp-Source: ABdhPJwutFUWtgOjqBKAMZvDLsOJSQtQHF1AU86LTR8vkJYh3D/8KPXDLnRG6zWPFtHOX1aPR2L/Gg==
X-Received: by 2002:a17:90a:8595:b0:1bf:4592:a819 with SMTP id m21-20020a17090a859500b001bf4592a819mr14851365pjn.183.1647077100125;
        Sat, 12 Mar 2022 01:25:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21-20020a056a0022d500b004f7a420c330sm2072693pfj.12.2022.03.12.01.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 01:24:59 -0800 (PST)
Message-ID: <622c66eb.1c69fb81.ae7fc.5a67@mx.google.com>
Date:   Sat, 12 Mar 2022 01:24:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.183-34-g10576140d9ea
Subject: stable-rc/linux-5.4.y baseline: 49 runs,
 1 regressions (v5.4.183-34-g10576140d9ea)
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

stable-rc/linux-5.4.y baseline: 49 runs, 1 regressions (v5.4.183-34-g105761=
40d9ea)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.183-34-g10576140d9ea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.183-34-g10576140d9ea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      10576140d9ea54d852c159b209bcaae2c80203e7 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622c2e3f6a8b3d0765c62982

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.183=
-34-g10576140d9ea/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.183=
-34-g10576140d9ea/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622c2e406a8b3d0765c629a8
        failing since 5 days (last pass: v5.4.181-51-gb77a12b8d613, first f=
ail: v5.4.182-54-gf27af6bf3c32)

    2022-03-12T05:23:05.644882  /lava-5864144/1/../bin/lava-test-case   =

 =20
