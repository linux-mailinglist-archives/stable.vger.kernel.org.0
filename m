Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8024CD8F9
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 17:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239053AbiCDQUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 11:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiCDQUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 11:20:11 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD02E0AE0
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 08:19:23 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id k1so8021384pfu.2
        for <stable@vger.kernel.org>; Fri, 04 Mar 2022 08:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LGY7Ko0l/yg7x3TLdgQBPD/a4gH5aOMfWAzboiTJt4M=;
        b=lQvaL6LHqNLEoaLvO7Fn1aE3b5wq+TigN2cwsVd6W9qe6iEGwmXB3Db0pz9EnbLSsi
         GHFE7dnzJGJdZrcgU9rNubFQTzgXWIzXOrWodqywq/mlopRIvbNQLzffdoWcW2W7jld4
         4tRNjxZyBS2buHgbi4XpTQIebI66t1+34v0uaoswzaS9Z21I6fzJ8pkl1lzTDMcX5BJf
         2K+1Vaqi3irhlZdhPX0/wOqnHKWCB4oObna5LPGYctxMjDsT8oywakNJyfLtGFcXjZnl
         J0yLA9IneVc9Mlfegr+DEgaQTAeEHEVFg76eqKz/Hz4Yu8L4xR7r2FI8xQOC4ntRGiY8
         DYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LGY7Ko0l/yg7x3TLdgQBPD/a4gH5aOMfWAzboiTJt4M=;
        b=voe9J+Rlk4hsg4lleeqsEwjP8mxAUPPjIv4y/3/USDNRDIva56XDYP8kTZm8uAwEEj
         wVoOE/DNMTespJc/NRYIqQPuARcpzmuDUl7Dyo8KcQyvuWSQEN+KUjnTWzQXL104SrF1
         36IiZsNqEx7c3h49bPtpbo/E3z2LRKWHIzIFYlN8gj1aBx9aLhQjFqjXD+bBYKWSmYXF
         DxIi96JWI+I1w3n4yPzILm59qx5m5SfBM7rQ74DptQ4UVEMD1l7eF62VDqcTerrhTPRM
         v0USJfagu2ld3l6dIE6iFn5J3xT8vQuhkH6SL5VCZ7PRhW9fcCnoK67oC+3bM5RZDgRd
         dRMw==
X-Gm-Message-State: AOAM533OBkbOze1TsjPkiyxa20V7HOUdXg34W+KbE5RkG9RIOa4byeka
        4HbR/9w+gjTTBvzgIjk9SbxOuq6Ixc9FSKmUTkc=
X-Google-Smtp-Source: ABdhPJzrNOvvN9Zz5L1EpnZLUXNmfJqJ2rqXnKX0Ok96NEm3GtieVKeFzDSMjn/NlUaCOJPxWVPKMw==
X-Received: by 2002:a63:2142:0:b0:35d:a95f:d1e9 with SMTP id s2-20020a632142000000b0035da95fd1e9mr34304739pgm.237.1646410762253;
        Fri, 04 Mar 2022 08:19:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11-20020a17090a280b00b001bf23a472c7sm2558229pjd.17.2022.03.04.08.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 08:19:21 -0800 (PST)
Message-ID: <62223c09.1c69fb81.68753.76d6@mx.google.com>
Date:   Fri, 04 Mar 2022 08:19:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.269
Subject: stable-rc/linux-4.14.y baseline: 66 runs, 1 regressions (v4.14.269)
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

stable-rc/linux-4.14.y baseline: 66 runs, 1 regressions (v4.14.269)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.269/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.269
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e853993d29aa42ac4b3c2912db975a0a66d7a5b0 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6222052ff6736dce27c6296c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
69/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
69/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6222052ff6736dce27c62=
96d
        failing since 18 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
