Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DB14E562D
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 17:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238753AbiCWQTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 12:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245395AbiCWQTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 12:19:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AEA1B7AE
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 09:18:13 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id n7-20020a17090aab8700b001c6aa871860so2301644pjq.2
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 09:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1QivFTUmfYOFwNlYN+3aX04VmNNphXCfiva73Qicwj8=;
        b=jlFdgtVc3ZNwnbTEuX696pH8ilsujELo2aIRiicio6Rl6Lh5R6tHV7dmAmxCWIKQqW
         JVL9ZhdUC3qutPNbkhc13LUCy4W7mNnRt3OJbMp4h8VPw+LpU00X/VtOntjk9GKZVhwE
         VXRW5PsBqNT+a8/T8g+HeMjiwmRR+0oSej5Cjph+InQDiG9qR7gbh8Xz5ov92JLZxvrF
         6Lps5t8VCBMt1F30Ya7lkAMc8O7w2LAl8/TlZYcm3rjtbnILZordi/tL1Jc2TK9Y2Ljw
         qCXWOg8X9qwyFSg9tkJrE1K/8fU9aOKPMkl9GWNmMObxbKnE5F7nHK9j9dJiwL5JPLfw
         2SoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1QivFTUmfYOFwNlYN+3aX04VmNNphXCfiva73Qicwj8=;
        b=ZgHPgB6mYHWvF/e+CFM+RWtTml39UWc+mYdxUPyH6hH8EUK/xdXoYxx19gzuHctjgv
         5lL4x50RVNUyOmOAmroeVSR8uPNy/Sgpd8oqpp92rB7Av71BIiZTyOsZ6EsEOYOHu9/D
         aAQk5YIdt+TLkbD6jacQpiCt6kmSCU7/0U4KfYUTlv7AYoApl/ALkz+S3ACLwBIbeuCG
         VNedt50+0DLGyJal7Fxqo4bHRPUUw7QC8Tk9OmXhaeyjjF+HjxLhS+jWHFnojHG8CV6w
         cD6ixwtmOCgxpZSFjqXJCpEjiL1AU/3iYlO2tNVb3LHX6+u9YMThuyjoPoiHmt2uFNzl
         ccOg==
X-Gm-Message-State: AOAM533If8pahWqPAs90FLJvx49krCiffIbboEKy7JomE8D5A2+1yTgI
        CGk1StshmrcdxdMp+BAkrs8vp37Gs+g7IHTOsB4=
X-Google-Smtp-Source: ABdhPJxzgTHtMrs7lsGAEPfbBWTFOHsT0Wx/dCEvOQrZCV+A/kYABb9r3cQdieLC4QBxhjUB4Lv+fA==
X-Received: by 2002:a17:903:249:b0:153:857c:a1fe with SMTP id j9-20020a170903024900b00153857ca1femr850882plh.44.1648052292241;
        Wed, 23 Mar 2022 09:18:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7-20020a17090a65c700b001b936b8abe0sm6458587pjs.7.2022.03.23.09.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 09:18:11 -0700 (PDT)
Message-ID: <623b4843.1c69fb81.d8a75.24fc@mx.google.com>
Date:   Wed, 23 Mar 2022 09:18:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.16.16-37-gfdb2764ba084
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
Subject: stable-rc/queue/5.16 baseline: 30 runs,
 1 regressions (v5.16.16-37-gfdb2764ba084)
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

stable-rc/queue/5.16 baseline: 30 runs, 1 regressions (v5.16.16-37-gfdb2764=
ba084)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.16-37-gfdb2764ba084/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.16-37-gfdb2764ba084
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fdb2764ba084a53533729eadcf512f2ebed8ac2a =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623b1297858ebc14d5bd91ac

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.16-=
37-gfdb2764ba084/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.16-=
37-gfdb2764ba084/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623b1297858ebc14d5bd91ce
        failing since 15 days (last pass: v5.16.12-85-g060a81f57a12, first =
fail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-23T12:28:49.335361  /lava-5932051/1/../bin/lava-test-case
    2022-03-23T12:28:49.346051  <8>[   33.494790] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
