Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428C44D4D26
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbiCJPfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 10:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiCJPfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 10:35:41 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C939158DB3
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 07:34:40 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id t14so5025904pgr.3
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 07:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JnVrbnHGPATTFsFwp1+qaVSalF1iA8viHFr9EeAz5ts=;
        b=kxnroBN5N4uesC6U+QdyuICnzuQLFudVLFTkg9cdOVEK0t4uNSXw3qxYh6/DjIEfNR
         daeU3hyI6qU5+vhUMVkSv27Rqn+xQt/7uM/6BSboQlqK4FXgKXu8WBDoV4hTDI+z0xgy
         3QwOOoBSW//OYvtgGBsusL0Eoj0r5VQAsDf5nJqY1gtoamBhKvQh54bZnNZY10X/MHF0
         3wDY1d5r5KT8EVnOaTpQPoZgloiLMmTE78ukHt164cjgjspqXqvDey4EtHEI/rXsG/r+
         QfOkECkpukj9KeYE4/ofxdOTd9mV3Iv28ldotQThS0lHjPAgTdlFGOGaqND29+NnS9Kk
         MDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JnVrbnHGPATTFsFwp1+qaVSalF1iA8viHFr9EeAz5ts=;
        b=erTr9+tDg8gMQ6GCQyIvDfOPZxymI2Os5mPO/z17g7lGRhu+predwbQsCijlr9Gbc+
         UbmVjVsmQgp2YP++Thk+UPD7Yk2nQUAR+2SawW25xALqxu1wezibk+tOiNZyW6yn2mr1
         2dC0FtiwygUmIUPM0MfQFsTUNlNGzHC0cdnsWnYqI7iiMZwIXw/GfjQCyOIMmR0maIf2
         AaboPLkrzC1p2l36T9UKt0CulZA1AwFjqI9p2FoNxbeUEYV8ijJ9bfFpTd8+75Pz4laI
         5sZS0q9jUHfQCqiA4zPo50bk7w6tYPxH8qwuO1Mm/44M8gSRcSZzlRGWII/ArixgSmkP
         DPYg==
X-Gm-Message-State: AOAM5307Pzr3zGUSV+kShY2mdoAD2GPcaQCqIB5YXflGl9wuxQnxvuBX
        5TS5ptiwhHeuA/ielY15wEuJb8W4IXYSJVdK0nk=
X-Google-Smtp-Source: ABdhPJy0hA9IrwwKILwUp9nBi/jbPBXbmE2xGa2lwAytEQCxD7mP50pDWVdbjfoCFmzxc4JAjfWU2Q==
X-Received: by 2002:a65:6751:0:b0:363:43a5:c7e3 with SMTP id c17-20020a656751000000b0036343a5c7e3mr4501897pgu.46.1646926479983;
        Thu, 10 Mar 2022 07:34:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6-20020a63b606000000b003808b0ea96fsm5733866pgf.66.2022.03.10.07.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 07:34:39 -0800 (PST)
Message-ID: <622a1a8f.1c69fb81.53d74.dc38@mx.google.com>
Date:   Thu, 10 Mar 2022 07:34:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.183-20-g8a903f3601e4
Subject: stable-rc/queue/5.4 baseline: 74 runs,
 2 regressions (v5.4.183-20-g8a903f3601e4)
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

stable-rc/queue/5.4 baseline: 74 runs, 2 regressions (v5.4.183-20-g8a903f36=
01e4)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.183-20-g8a903f3601e4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.183-20-g8a903f3601e4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a903f3601e41b3623450664ca46d8bda20afd37 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6229e3185337e3b310c6298a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-2=
0-g8a903f3601e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-2=
0-g8a903f3601e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6229e3185337e3b310c62=
98b
        failing since 84 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6229e317a348645295c62975

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-2=
0-g8a903f3601e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-2=
0-g8a903f3601e4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6229e317a348645295c62=
976
        failing since 84 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
