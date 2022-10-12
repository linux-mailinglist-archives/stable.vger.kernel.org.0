Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D4D5FCE87
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 00:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJLWjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 18:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLWjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 18:39:01 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406E2D57EC
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 15:39:00 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gf8so319925pjb.5
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 15:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+9OdVBO941y+lyr8KMirGTH0xz3XVfHXdA0QbqWzNA8=;
        b=rco5rMrySpkWlQyzlMCaR0O1lbwCS76Vw4mCfiDUwxYlFK0yNqT+NeEQvHyo1sG7Sp
         mzDYA97+uBFCqglXzMxEGBSvakBjy4kkQiXTcTFGHh0ZWf0FI/ovgchT7/MGaq3dPwM1
         pOTQLbSL3yRl0hP33PAn526H8cPSmnpPQ4dojzj2K1uUl1k1LcKR5gGR4jDvCP85j4j3
         0SMY5lufCh5DMCZYXkcngXt6z+MIv+FU7fTohGRzHns4dgLqytUxpVGTZN4ngsOc26TN
         ztScnrAyRNZn+dkyeRFqIkTggqpj4tNbHAmZCSpHpVwsmHWcRQr7I39og5gBP1FC51Ni
         vsJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+9OdVBO941y+lyr8KMirGTH0xz3XVfHXdA0QbqWzNA8=;
        b=rSa5Ux+UA7qcgSenMRrF19I1vmgAjO1If8PxrwiEMCx0xUq/ZPkhcLrrxyBVfz1RiN
         xNwUqWVdfUqQxJsJSCmv+gAwAfhRs5b4weuTt2ZlBRNOk4tht6olybg4knW+BZ/f2tt6
         PM/LcXvyg/7VYges6Mf4DtShZfTltbWdSOxnyKWCOhuqDNyhYCpEbRCtNa1ZBNpoMhI8
         rkSQbJL+sbm4wX0w3TP43ApfcExkqNMEnu4+NFUkwyzDELuLTYqLjw6cro5L3dih5s4m
         ZzX+LpdY6GjsyR+jQKqGeIB/6Q0ZTKfsKcVty4hPLrKNatP4ercQM+F7HgKiNdV/Tb30
         PuWQ==
X-Gm-Message-State: ACrzQf17yoXGbTX+f0ppjG5NqApxOEV/SB333OtYsrRGfqb923YAquVo
        AwBlgWFFLGC5uJ4vFKvVodyllIzRO4RcIzXrZAk=
X-Google-Smtp-Source: AMsMyM63g9WoOkebn/RikBQqMLTsSxjRwnaZBhdXYyk9+Fhtp2jlFSRvXXrFK6cLDy6lo13ZTpPOfQ==
X-Received: by 2002:a17:90b:1d4d:b0:20a:794a:f6e7 with SMTP id ok13-20020a17090b1d4d00b0020a794af6e7mr7656422pjb.151.1665614339635;
        Wed, 12 Oct 2022 15:38:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 5-20020a170902c20500b0017ec1b1bf9fsm11155964pll.217.2022.10.12.15.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 15:38:59 -0700 (PDT)
Message-ID: <63474203.170a0220.2d733.43a2@mx.google.com>
Date:   Wed, 12 Oct 2022 15:38:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.15
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.19.y baseline: 115 runs, 3 regressions (v5.19.15)
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

stable-rc/linux-5.19.y baseline: 115 runs, 3 regressions (v5.19.15)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.15/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      51dd976781da8c0b47e106ed59a96d7c28972ce4 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63470e7c56d5a92cc9cab60b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
5/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
5/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63470e7c56d5a92cc9cab=
60c
        failing since 15 days (last pass: v5.19.10-40-g8d4fd61ab089, first =
fail: v5.19.11-208-gddfc037235223) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63470fe4153e6a1da8cab5fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
5/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
5/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63470fe4153e6a1da8cab=
5fb
        failing since 15 days (last pass: v5.19.11, first fail: v5.19.11-20=
8-gddfc037235223) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6347114ecd4632e474cab5fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kuk=
ui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
5/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8183-kuk=
ui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6347114ecd4632e474cab=
5fc
        new failure (last pass: v5.19.12-110-g30c780ac0f9fc) =

 =20
