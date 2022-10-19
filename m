Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7D6605223
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 23:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiJSVni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 17:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiJSVnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 17:43:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB32189C0C
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 14:43:34 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a6-20020a17090abe0600b0020d7c0c6650so1474433pjs.0
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 14:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4YBX+324IdvIOIjY1MKQsZ1IuM78UXeimqWHnrtvIo4=;
        b=Kuqi4wfq/yuKckGOaR+UxrTQIr7f0jH2PWPzpVPtOEXyb7IKmB+Nmxx7nvfmgdG+Qp
         GgkpZOlcMq5HM4/orcV/xDOhcNLj4XT0gwuAzIL3hDsWP2XIHTW4CO1FXinHcwEHHhPD
         daPZZznaJ8IcpMdc0QdEbJ2NwEpkTPHMSPOiIff57fHRuurucPu3z3zQmBSCQt6/uDZ/
         QlPw3C+fytVE6REUlI70u4mfNiVi7BKRlKS6ZdLKODHxzLwdOFiJUJcrLgayhret9aEr
         /qlDj1VL8O3c4kmLN0eh3Pt3HlDilcdDvLU62MvkeJi9zansNd0cfz7XdKz36NBatVmh
         wtng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4YBX+324IdvIOIjY1MKQsZ1IuM78UXeimqWHnrtvIo4=;
        b=yKMRw+Asp24u5p5PbVh2JwqJS2rYuC4jFaykvoUxcFcMCcmy38kQrzZNOYZAsfBwis
         pRmabood/l4F+ZlQnYXqPiMnp/POQLMp5ORB/F79Orkp6Vtvz/tRAe0NjY7CW8JKbJnx
         xlyMZxYUCpGrIgK0c1Ua7RqA6fgYzTZZR4AUDWnqXI0bDocGr3RsnHVc1zLSF0EtiuFn
         u6xige2YX9wUf2k0QDFK2f3GsVtFO1HxG21JOrwv2qiz7vV6iuAFsA7WUiZkXbaNWeqP
         9H+BZH46olhF2G5vED2zC88lOvF71IUMIPzzVBiQrnulE3zBzH+xL3ks9LAfpMJkzT83
         nvNw==
X-Gm-Message-State: ACrzQf01OlVq6hA9jSy0KBQp7rI6BZPQWi+cgjsHXIxV6NeHoj5oHsh7
        IkLjTRABNL1UmRhwQf4hSzWntnKGQIZMs6qc
X-Google-Smtp-Source: AMsMyM5rbI9azjl72LjT2OnLdDw5Zc3hmJZgGJ4I0EHZULDDt3nbyXAuebSMqgwdLImqrFtm8lNm4Q==
X-Received: by 2002:a17:903:2284:b0:178:349b:d21b with SMTP id b4-20020a170903228400b00178349bd21bmr10656553plh.49.1666215814056;
        Wed, 19 Oct 2022 14:43:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x12-20020a63170c000000b004388ba7e5a9sm10293380pgl.49.2022.10.19.14.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 14:43:33 -0700 (PDT)
Message-ID: <63506f85.630a0220.cf819.3535@mx.google.com>
Date:   Wed, 19 Oct 2022 14:43:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.16-779-gcbabdc13e2cb
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.19 baseline: 115 runs,
 1 regressions (v5.19.16-779-gcbabdc13e2cb)
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

stable-rc/queue/5.19 baseline: 115 runs, 1 regressions (v5.19.16-779-gcbabd=
c13e2cb)

Regressions Summary
-------------------

platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.16-779-gcbabdc13e2cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.16-779-gcbabdc13e2cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cbabdc13e2cbc7eca14a7f802269431dac1563fb =



Test Regressions
---------------- =



platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63503c94dc6ad1dce75e5b7c

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.16-=
779-gcbabdc13e2cb/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_m=
ips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.16-=
779-gcbabdc13e2cb/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_m=
ips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63503c94dc6ad1d=
ce75e5b80
        failing since 0 day (last pass: v5.19.16-838-g83e6994f1f57, first f=
ail: v5.19.16-802-ga330f8d5a97cd)
        1 lines

    2022-10-19T18:05:55.066182  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 17402018, epc =3D=3D 802006d8, ra =3D=
=3D 802033b0
    2022-10-19T18:05:55.106513  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
