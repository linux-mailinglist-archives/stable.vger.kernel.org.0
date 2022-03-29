Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CB54EB4B3
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 22:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiC2U3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 16:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiC2U3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 16:29:42 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437241C4B2A
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 13:27:59 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so2771988pjb.4
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 13:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n7/DMKS+aUStX7gpx0GafIQMEoJ64kla4sWctVgmgdw=;
        b=5Ik5PNM5i09g4HEb+VoSrOEZoCqlHx4OZbaMAb30Cn9E5tHmSk4uef5PFjRupfEznl
         EpN/Fb55D8xs/QJ42NQkYDnKM5dniMZM9fbzS1wmY7E7wI4hmnfWaSlHw/GZ+7elKyNM
         vPNOQ4YZr0BPwgSfy6FG0P8Dp5C8DvGdMvSF+2Mde3fFA6hIp4VE1D5GkOzM768bkGey
         kFqQOAnB456jz45M9MbL+nqNADqTaKJIIJyEIuq1+vedhuBIqsdZ5FLrVUdPARAVtmIm
         zoFruodSTUhJ1QxwddzaYabVLoaJxPp0gEk1KDvQAsVCrx8ndZeI/RMDDkZWacKLvaos
         kCBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n7/DMKS+aUStX7gpx0GafIQMEoJ64kla4sWctVgmgdw=;
        b=KE9iXJQhYYyfwKaEivwFnV1hVn7nyRQlnCNogkOQicMINsJzIRzaiAXm79o0PnM95J
         uH8onhAHKyiJqL2Gda2mB8PHV403RRB+VljoAZc/teW0PdHf0qooi2LmSEImAMlE7WvH
         AwPdzFH0qkQoebCfgvehRn+dSelc3XuragsYu+etv4+mmGVIoVIcS+KFLWrs2Olh5ReG
         zm14m2ejGKpy1Sr5DRnD1jDJcOSLWy1nJMj3CtjpOOxu/HyEkLP8m5KGwTW/P1LxjvEm
         Ur6qRn97Otv/HSP5ayFJUjpZnv0Nye4kO31evML8Zwfz27J51dNjlwhJBB4YiTycCKCX
         3KrQ==
X-Gm-Message-State: AOAM533McyS4C9ooYvHfMdI0FdpHR5+5exou8k6MwwP6r7w8S7HXK1gC
        hiSvrNJutwNc10uJFVdQsmGVg147bc9T2ZK5rfk=
X-Google-Smtp-Source: ABdhPJz5MOq3+xVW+lILu5QpNN4b6b+iWSbMM4Z0HU6AISSJsw3XgSYt5s9DDgiITR0WK3D06fNpnw==
X-Received: by 2002:a17:902:c105:b0:154:81e0:529d with SMTP id 5-20020a170902c10500b0015481e0529dmr32029956pli.1.1648585678547;
        Tue, 29 Mar 2022 13:27:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a001a4a00b004f7c76f29c3sm21047652pfv.24.2022.03.29.13.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 13:27:58 -0700 (PDT)
Message-ID: <62436bce.1c69fb81.ed4ef.7812@mx.google.com>
Date:   Tue, 29 Mar 2022 13:27:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.32-27-g2277969b3e84
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 121 runs,
 1 regressions (v5.15.32-27-g2277969b3e84)
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

stable-rc/queue/5.15 baseline: 121 runs, 1 regressions (v5.15.32-27-g227796=
9b3e84)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.32-27-g2277969b3e84/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.32-27-g2277969b3e84
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2277969b3e84035e29c4fc8786462206aa7004e6 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624342974d6510b936ae068a

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
27-g2277969b3e84/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
27-g2277969b3e84/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624342974d6510b936ae06ac
        failing since 21 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-29T17:31:40.745578  /lava-5970871/1/../bin/lava-test-case   =

 =20
