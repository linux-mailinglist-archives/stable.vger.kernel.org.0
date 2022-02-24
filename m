Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D45D4C22C7
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 04:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiBXD75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 22:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiBXD7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 22:59:55 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B8D25D26F
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 19:59:26 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id iq13-20020a17090afb4d00b001bc4437df2cso950553pjb.2
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 19:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0TlaRjYBpW4gMJoxK0uvn0HqduMHt98XuUoLNRlpas8=;
        b=015cC8YUy6gmbCK2fP9c3vqRlKr8m14dBty02+AIlWBZnrweXI9nidEogdMLeX9A9L
         4ebCdrSv8Hdfvva2whioLc6/wWLqRtwYUZHAxTPwpWk4dWU47YTAJZ95PUXf09sM3kA0
         LInsDVniOL06IhnECM/MhCpjlAx1tdturYS3Nh4rpKjsaTVAxrfyT6UV+Gu9NLpTfCCp
         Wejkxa3NVzb50HV+lScEqPmYEG4ykkUqqKwwWY1nT6PAUkAl6zl3PoaGScv6CevXYLNQ
         67f1WoByCUHbu8zfRbecyXtMrAc2ACxY644dA2zRCs79ATh43zdk3MmPSZvK516FnlZH
         wyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0TlaRjYBpW4gMJoxK0uvn0HqduMHt98XuUoLNRlpas8=;
        b=KH2qbBpxC/IFtKTwMR7HtNEW9+R4B2S/sqFJM/MeLYzcDqkdydKbOByH2hjkf2XFAb
         mpzpzzifdi/82ex7najjhC6X3/25UEHpT+1sOMVh7nq+yf4t+F+SyDO7JF5u6X6BRINu
         HzVvSzUmmm6mUzC7e4ZkjwNegw6nAiq1a2kfwIFEprUiaT142hBUggTYq1zIhJKCGzdD
         NVh3NWozUc9HCZiRNKRprvV1aRjnhuszCI8sByasCjD2WVggZB8ursJCK04PpDqY4OG4
         JUu4CrIouzGM34Ziw8dOJIJpMhw5QeG1ATvGOoUNJWv2W56Nk0j/Kom2Ugu0CgZKBkxt
         9x6A==
X-Gm-Message-State: AOAM530+HEaBjAg8mUNPPTvn7cZpUuk28MM4SD55y4w9K5AxapZfw6SZ
        Ltu3/tef3Os7+2zBSJJS4jl1xqzsOc/i2tJWvoo=
X-Google-Smtp-Source: ABdhPJwEo4nnuguWpKl3ihFqOu+ckigjhRTdWeNVRRVtXkYk+pi3AQAFwh42PleW2NyEDxrNk5qyog==
X-Received: by 2002:a17:902:8509:b0:14e:f9b7:6cab with SMTP id bj9-20020a170902850900b0014ef9b76cabmr1029031plb.162.1645675166155;
        Wed, 23 Feb 2022 19:59:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h21sm1122441pfo.12.2022.02.23.19.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 19:59:25 -0800 (PST)
Message-ID: <6217029d.1c69fb81.98cbd.46b5@mx.google.com>
Date:   Wed, 23 Feb 2022 19:59:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.268-1-gdbe46bd35b2d
Subject: stable-rc/queue/4.14 baseline: 75 runs,
 2 regressions (v4.14.268-1-gdbe46bd35b2d)
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

stable-rc/queue/4.14 baseline: 75 runs, 2 regressions (v4.14.268-1-gdbe46bd=
35b2d)

Regressions Summary
-------------------

platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
meson8b-odroidc1 | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  | =
1          =

panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.268-1-gdbe46bd35b2d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.268-1-gdbe46bd35b2d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dbe46bd35b2dcc9ee1aa0fdd864d0c04a1c916f9 =



Test Regressions
---------------- =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
meson8b-odroidc1 | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  | =
1          =


  Details:     https://kernelci.org/test/plan/id/6216c90f9247051f56c62988

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-1-gdbe46bd35b2d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-1-gdbe46bd35b2d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6216c90f9247051f56c62=
989
        failing since 10 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
panda            | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6216cb4bc5bb4666a6c629a3

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-1-gdbe46bd35b2d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.268=
-1-gdbe46bd35b2d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6216cb4bc5bb466=
6a6c629a6
        failing since 5 days (last pass: v4.14.267-16-g29c6a7cc89b2, first =
fail: v4.14.267-19-g5de9d8e4b432)
        2 lines

    2022-02-24T00:03:08.010839  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2022-02-24T00:03:08.019950  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
