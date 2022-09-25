Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541AA5E96A5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 00:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbiIYWSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 18:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiIYWSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 18:18:36 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC882BB36
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 15:18:35 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id bh13so5008512pgb.4
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 15:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=Vg/RQVnjH5s9NjoULBEzDBv4Ju7uUfWFfNCWV78Xmjc=;
        b=0uZhYZM8/Ac3vrL9BWIatV8o5pwF2uPeEvl+Fgeo02JtaHzXMhmxScjSN3X3MfAdLV
         0nvx0QrsYMBcAj7BI3EkTrFBdxoSDVf7jcKzDOJ/vnjNy/kysD5a5+e1YlynOcVq+OpZ
         rI0lOzk41TJtBy+hSRaZ+1o2YfDuboOmcx8e/1Oexfz0TE59PKtM1aEVkQ8iA3Sh4gp3
         Yg45PPd0JNbODh1cP8moYMWERO8ymY+QpZpywhEv4xu7PFk4FfcL5TRRVv/WtVQhu8M6
         46dRwDvwutxdWj/wGOO4j16E34qRGtFpH0Sh0gobjyO1LhwIeTLjC19EWhalp5QkvP69
         +BEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Vg/RQVnjH5s9NjoULBEzDBv4Ju7uUfWFfNCWV78Xmjc=;
        b=YgJ85hugmJ9nX4+IGstmUQ8j6S2lTzPQZ1BZc2GFwsV+TUkTRmLvhzYrShBTrzCFdV
         FFOyYyOTFFhDQKA73PSQoae/i+xNR6V9eiXvvpdmqtXBFxSkZtXJ2+MqF1n2b3fzRXIm
         c9wOMTC9iXIkuatqCxHHKql6STrpApsOGsWGBo3cAeWrMz/IN9Ia8ERQgUXk6+viJz4+
         otv6AyItmeqVWYllD1d+xp9kvOKlcDY3qgGZEaOz1xiXwD0DtmFecav6I/D4kCfOsGw5
         kLH0upK/IEjcUbCrYrXg4ieW2XlGk9nUwrqePxuhWx8RBbrFc/VMQjV9xEDs5Yqvyi9N
         pdaA==
X-Gm-Message-State: ACrzQf2GhX4OPCB26en1gTupo4kvzdDDX5NM7UZ4MyfRje8fiQRCh2bM
        scyzrJfKla1aZNV/SASmBH3VxVaOv227LQ5f
X-Google-Smtp-Source: AMsMyM7oJ20phtqOaIBpmy/tuymhgVmC+I45K27QwQklKabL+frUOTFa47SatIivvIuaHaH2OmugKA==
X-Received: by 2002:a63:da4b:0:b0:439:14a8:52b with SMTP id l11-20020a63da4b000000b0043914a8052bmr16653289pgj.500.1664144314901;
        Sun, 25 Sep 2022 15:18:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f13-20020a170902ce8d00b0016dc6279ab7sm9807878plg.149.2022.09.25.15.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 15:18:34 -0700 (PDT)
Message-ID: <6330d3ba.170a0220.24a48.2a0f@mx.google.com>
Date:   Sun, 25 Sep 2022 15:18:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.11-186-ge96864168d41
Subject: stable-rc/queue/5.19 baseline: 65 runs,
 2 regressions (v5.19.11-186-ge96864168d41)
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

stable-rc/queue/5.19 baseline: 65 runs, 2 regressions (v5.19.11-186-ge96864=
168d41)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.11-186-ge96864168d41/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.11-186-ge96864168d41
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e96864168d41a54ba469f6eccf8a1bd57308fd8a =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6330a031255e6db6bb3556bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
186-ge96864168d41/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
186-ge96864168d41/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6330a031255e6db6bb355=
6bc
        new failure (last pass: v5.19.11-158-gc8a84e45064d0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6330a01058d4bd13b635565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
186-ge96864168d41/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
186-ge96864168d41/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6330a01158d4bd13b6355=
65d
        failing since 1 day (last pass: v5.19.11-69-ge9d119617721, first fa=
il: v5.19.11-69-g5e775a9ea803) =

 =20
