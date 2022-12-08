Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C406474F9
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 18:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiLHRXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 12:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiLHRXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 12:23:34 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5524528A1
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 09:23:33 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 65so1806194pfx.9
        for <stable@vger.kernel.org>; Thu, 08 Dec 2022 09:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CR4+RnKqmKSFwP9WXQmLYkCkoGTcuDlzo2AtGWtYB64=;
        b=Mo83hVoRCY91rpSh+en9ql3JKUnXqdyU177e15LVv/dQKWZiyDU/Drjq7bCxcoDhUy
         Amif710QfWEL7CO583xoBFHQCISVQtFkVsE9PHAcRbcaYYWuuSrYd/DHPiNlmPedRYY5
         mVcw+9IkPmvL7mOkMuU1QrvUO2jtLy9jE/qWkSNR6c0vYjCEqq+Upo6V/oAy94Yz+PZB
         lIX4+nZZhxLjR9+z9dYZwSj3/uvIhoPm+QkW76iWx2jcI5i1jdFUS7pfo93VBl9gRqXL
         s8OzOrl/Z9zvMI24NhYNyzCndzBwDH6dsqSRc/1j5nchHagzx3G5+kwNrMNEOeiQ1M57
         Lo4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CR4+RnKqmKSFwP9WXQmLYkCkoGTcuDlzo2AtGWtYB64=;
        b=c02csKePruBdQtGi76PqdKOZozfRtvt/BvbON+VuRSzNGqgQFYby0O4ksZGcEpbqo3
         v9uMq8SIJI4oe9m3Svu2SjtZ+9Thw5bPt8FfiU26pznWoGNB09oI26kcl3oQsaoui3No
         CjM0GENyh5AeF3Is53MaTbJcdq6tK+QgpfRy3ifj+rPbmim0T6yhWfCqLiuObgq7t0FS
         d0Z+8dAA6ibazZnqUfB/Wv8hWwiY1RRcoBHxdVTPENUSzQQdpOClUhg4yVm6h0sBiRNi
         C6LukZoSFgo7idCGHU8ffWYkku2VRFjDjfTsoA8+PQArJtsomndZYroeX1//7BX7C6Sc
         JZ+g==
X-Gm-Message-State: ANoB5pk5lR8n4SVG3GsYzSaqvcUpiLcVEWknHFZBTpfdfYqPllDUMNNX
        Bep3UysM8jqOeTdGgo/heqWSxNz6wuktnCAn7BSIlA==
X-Google-Smtp-Source: AA0mqf4dCSI3U072EJeVXHb7g1/VYRlP2eMuwv1QPFQ5fONQz7Glyn9tTDPA73jowumFA9bErQBU9Q==
X-Received: by 2002:a62:e50e:0:b0:574:9e66:1bce with SMTP id n14-20020a62e50e000000b005749e661bcemr2580619pff.5.1670520212940;
        Thu, 08 Dec 2022 09:23:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h64-20020a62de43000000b00572198393c2sm13668906pfg.194.2022.12.08.09.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 09:23:32 -0800 (PST)
Message-ID: <63921d94.620a0220.9910.a4a1@mx.google.com>
Date:   Thu, 08 Dec 2022 09:23:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.157-95-g602512855c6c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 144 runs,
 1 regressions (v5.10.157-95-g602512855c6c)
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

stable-rc/queue/5.10 baseline: 144 runs, 1 regressions (v5.10.157-95-g60251=
2855c6c)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.157-95-g602512855c6c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.157-95-g602512855c6c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      602512855c6cb2cab24a23dd69c8f072e5da17a2 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6391eea46b7f9006c92abd4b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.157=
-95-g602512855c6c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91-=
sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.157=
-95-g602512855c6c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91-=
sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6391eea46b7f9006c92ab=
d4c
        failing since 0 day (last pass: v5.10.157-92-g362267195001, first f=
ail: v5.10.157-95-g1edc4f6de8b5) =

 =20
