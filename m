Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5A45344C9
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 22:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbiEYUTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 16:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiEYUTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 16:19:39 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD8D8B0B4
        for <stable@vger.kernel.org>; Wed, 25 May 2022 13:19:38 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d22so19509304plr.9
        for <stable@vger.kernel.org>; Wed, 25 May 2022 13:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gwLoy6IyPXbtB3Ak0WKqkjgqJWbPI8sUKIGgDql6o+8=;
        b=U4NL9UUsZCCDVWDkZglHMHS2fGxsF9FtHdJyORXXPO1UUQoNPYAqPErcyK/lEEdWSx
         iJCcFkBnhJMXEZDjtK6xJsOFnsC+fCneAUILIMCC78QquUwVZHk3qfwlV0f4+xVaDVZg
         VR+guF8dvI6jlXLGhy0oYfwjDc/6Ukq6j18sHhDmrqggtsICbL6mG8xbci/D5/1RHK0x
         /nkMtnfLvsd6r1YYNdLqgMuNpBSUBrA32mMf83ISXWV5MXlsCDGm7RubiKaa2Ovyjsz+
         0z1suYJ6RsijSpd+MxtJkjOd6zZzVqPpTqizCr20qB3j7b6H19owH/Y56b5U8pRyV8wS
         +i/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gwLoy6IyPXbtB3Ak0WKqkjgqJWbPI8sUKIGgDql6o+8=;
        b=DOThIEVJblOt7TuYnHaeOYm/l2WziEj2D1xblTK74sraBreXVoXsP7ts3EI/qBKfI9
         bWnyM1V8ZScLxX1kzPsRFi/4rPlgGXfWNZhWaTe8DICI8MCcHANTistbQjpMBB6+fTcT
         X9BKRb0xWMUGP5gxsmqQ+5qb7DyQziB4j5FVj9Y7Wtj+DYzw/Y0OlVOYFam0oXvAYvz1
         yTMptXlfthml4oZEM99TIiu/Fc+jOhr4Et2jk1zKmkHj5BLdh3Q0LuoB4drLI5H4bhEN
         CybvCe6aYj4SEcRk+MEngbmFJU/MamNbflN55+OHEe00+wxPAeF9qm6BuHJdNDAod4AA
         83ZQ==
X-Gm-Message-State: AOAM5318hjm0aN4gzWyj/iJeItG08D7Rbk0EtK1QVyE8e6O9R1SG+L8Q
        kyxzDafCJcjb92ZGteVZSjubFEWMk/MR+cvtGVk=
X-Google-Smtp-Source: ABdhPJxvX9QMVHSo/03b63BwvUxWFW0iBHvToqOfySnY/rGj6JNfSq7hn9q1uRkbJsCWOuBmHsc20Q==
X-Received: by 2002:a17:903:1210:b0:15e:8373:d4b8 with SMTP id l16-20020a170903121000b0015e8373d4b8mr34597175plh.11.1653509977608;
        Wed, 25 May 2022 13:19:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y68-20020a62ce47000000b005184af1d72fsm12533511pfg.15.2022.05.25.13.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 13:19:34 -0700 (PDT)
Message-ID: <628e8f56.1c69fb81.fbf08.e461@mx.google.com>
Date:   Wed, 25 May 2022 13:19:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.11
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.17.y baseline: 82 runs, 1 regressions (v5.17.11)
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

stable-rc/linux-5.17.y baseline: 82 runs, 1 regressions (v5.17.11)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.17.y/ker=
nel/v5.17.11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.17.y
  Describe: v5.17.11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e960d734930b58bd6ce00c631ea117af0764473c =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/628e611733dfb06efda39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628e611733dfb06efda39=
bdc
        new failure (last pass: v5.17.10) =

 =20
