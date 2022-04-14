Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C140C50040A
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 04:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbiDNCRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 22:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiDNCRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 22:17:05 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EF841F8E
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 19:14:42 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id k14so3538295pga.0
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 19:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3/XP2NW+gEIzx4TkbJVjQ9/qpjtcKsC+NaaxCockQ3w=;
        b=tDH4ZU4Di0CDbVQz1QlbUJ0upqjUeDr48QTuVmTSG1JNl2dwXPh/9FHFyNdhd6a6mz
         wLjv7W1nWYNBEXyFReCsjpQJDAPFsqivrvXayI6hDkFNhhCLmeBaEUkUeBSlaJolaMs4
         pCfIrG6JDl+s4MPb5qdF4NLfXAIr1cu/TiSAbOgIpbHzRMBe304eMUcXGvap4LKBfgkl
         xF0A+RI+6MLdjctSG1AQXhDzTGInrYzSslvt8ZBzhgXnUiZlHubGkO7ywBoJDPTyZhNl
         VsJX9OklPWmCv7HnQC6xFFWDYRQGq6k+PrQtH1B6O8NSouxvZSKvv2DUTfKTL7TaRkKJ
         YAUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3/XP2NW+gEIzx4TkbJVjQ9/qpjtcKsC+NaaxCockQ3w=;
        b=YzNgSAFIrgL+507TwPgP+FsYU2Dfv3/aRjejLxwXDn2DH0rxm4hPrRYnRFcivHrNmS
         tMZViH+e2MFM637/+WzhUnsH9v6kXN69UobbobK2WdyjR0Bc1UlqzKqWjqAseZW5Hd+c
         BeUQAXzeark+bx01VJmNGU56Z5tfxm5ks+wZJy0bI59hqP7qfo1Pu/Gh6VMgT6I8payJ
         /5NK6lceU2ajMT9IEfSsF6KGfgoR/gp6/YY2KKm57IrLNe1UR1+Ca+KLY9N9uYK3XL00
         ElpjKxm/KoCKaWvdRaz5aq99gXwoVm26Fe6iS75CBS8R/d+svEwU87eRBHW1QT3pF3DW
         avHg==
X-Gm-Message-State: AOAM532fiaypZVNi/2CJgJMpRkWnOr2weiJvuNUi1z95PieCzrLIhMvY
        SNazRQB688+9VjqQTRYJNaEKvTPeD3p89S0k
X-Google-Smtp-Source: ABdhPJxiBqMQsVH2iqs/Ft3KMhuHJagvRCEK6N6EUZN4Ak+gKBzxENFJacp/s+nS/or25nrfX187LA==
X-Received: by 2002:a05:6a00:23d5:b0:505:dfd4:2f33 with SMTP id g21-20020a056a0023d500b00505dfd42f33mr12636354pfc.59.1649902481928;
        Wed, 13 Apr 2022 19:14:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p34-20020a056a000a2200b004cd49fc15e5sm387769pfh.59.2022.04.13.19.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 19:14:41 -0700 (PDT)
Message-ID: <62578391.1c69fb81.ba68.1a66@mx.google.com>
Date:   Wed, 13 Apr 2022 19:14:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-329-gcab7b9c540e8e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 30 runs,
 1 regressions (v4.19.237-329-gcab7b9c540e8e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TVD_SPACE_RATIO,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 30 runs, 1 regressions (v4.19.237-329-gcab7b=
9c540e8e)

Regressions Summary
-------------------

platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
asus-C433TA-AJ0005-rammus | x86_64 | lab-collabora | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-329-gcab7b9c540e8e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-329-gcab7b9c540e8e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cab7b9c540e8ec0b6501d8ffbb22ba7a8767c4d6 =



Test Regressions
---------------- =



platform                  | arch   | lab           | compiler | defconfig  =
                  | regressions
--------------------------+--------+---------------+----------+------------=
------------------+------------
asus-C433TA-AJ0005-rammus | x86_64 | lab-collabora | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625752ce26c21ecb24ae069e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-329-gcab7b9c540e8e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-329-gcab7b9c540e8e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625752ce26c21ecb24ae0=
69f
        new failure (last pass: v4.19.237-329-gd4bbba6a976ba) =

 =20
