Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEF5671F5F
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 15:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjAROVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 09:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbjAROVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 09:21:16 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403AF656FF
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 06:03:50 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id o13so32359809pjg.2
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 06:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8vhwfuFad0WJTBh/ajJdgz/l+diXFvAUbJUWyhT7+30=;
        b=4Jru2sFUcmLb4Rmrl/oPXM3oa2Hhk+hlXMGfEJ+6H7jWEJBOJoQfACrj5X+PMueb+w
         eTtVfdsE/BDD+/MjN0C62QykSTCn43cIdd8k/5kboL1S9YSLDqAcfwsJxFqmsDYKdFmx
         bIoPaKS9fqtTXc3F7fLi4E8Mj8atnkqebNxSVdiIcCL4mkug9K1kRZgm5viQjDx0jOvO
         y7XE5JPKytxbbv9SbbYTQQWvP0kc4dNAvWCjIZTvg8oGxeZsF6iduV1MsDJ26G3J2MCi
         /0BGadA1tjHTqXkAnLV4FR+AecgD4pmM12eAFFA5JIqY7XQMQJ13b0TfxChhUJIpdujx
         cjTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8vhwfuFad0WJTBh/ajJdgz/l+diXFvAUbJUWyhT7+30=;
        b=0by9DHbDw3UVogcvkuQA6ibkJ/YRjTFdBcWs6Z7DN+JusrfHhNEmAAqpV0Y4hUui5o
         khXb7vjGGOBRe7eYkaVENJW41mjwtQQXnpMjd++s+1T/i5829yB5opgHfPxXqVDC0Z/H
         ehq6WORS63CW1xIv573DpNhzwrkRIJeTG8+GbXTytJ2Je42eUYZJZXo5278GonZMD9oc
         sJhjJZzU2+J1Avh2yv5tyflF3knC8KR6ojJWwV3HOLhik6RTLN197PwJwok6exCJT4e0
         42vZUCiTTiY9D73uln8zs7UVCuH38LX/VhzvQKB6mgrlps1AprjP9bK/tVWFi6QwOub5
         yE4g==
X-Gm-Message-State: AFqh2ko6OYdU3lAXoEkbJLVPQ1Q0lmOqY3S9e06Z32PPd30Ltuh2o0pf
        mgYqn0zli3a/UewtwHBQvxE7RsnolFaPwq4gs+Fdng==
X-Google-Smtp-Source: AMrXdXsIN7IXDId+26MrE1RFNmi3lT9+STYIkoo+4TFZ12qa0jsmpNecK5eLhYC7LOj2DU7Tq9ynMQ==
X-Received: by 2002:a17:902:f2c5:b0:194:b745:5eaf with SMTP id h5-20020a170902f2c500b00194b7455eafmr2834512plc.42.1674050629535;
        Wed, 18 Jan 2023 06:03:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00186c3afb49esm23090777ple.209.2023.01.18.06.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 06:03:49 -0800 (PST)
Message-ID: <63c7fc45.170a0220.c8a16.49e6@mx.google.com>
Date:   Wed, 18 Jan 2023 06:03:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.162-851-geb4da590103d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 166 runs,
 1 regressions (v5.10.162-851-geb4da590103d)
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

stable-rc/queue/5.10 baseline: 166 runs, 1 regressions (v5.10.162-851-geb4d=
a590103d)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.162-851-geb4da590103d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.162-851-geb4da590103d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb4da590103df10932ecd249cf9a955694676f77 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63c7e5a65a4cdf2c06915edf

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-851-geb4da590103d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-851-geb4da590103d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7e5a65a4cdf2c06915ee4
        failing since 0 day (last pass: v5.10.159-16-gabc55ff4a6e4, first f=
ail: v5.10.162-851-g33a0798ae8e3)

    2023-01-18T12:27:06.350451  <8>[   11.057212] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3156185_1.5.2.4.1>
    2023-01-18T12:27:06.460582  / # #
    2023-01-18T12:27:06.563901  export SHELL=3D/bin/sh
    2023-01-18T12:27:06.564724  #
    2023-01-18T12:27:06.666675  / # export SHELL=3D/bin/sh. /lava-3156185/e=
nvironment
    2023-01-18T12:27:06.667058  =

    2023-01-18T12:27:06.768382  / # . /lava-3156185/environment/lava-315618=
5/bin/lava-test-runner /lava-3156185/1
    2023-01-18T12:27:06.769058  =

    2023-01-18T12:27:06.769234  / # /lava-3156185/bin/lava-test-runner /lav=
a-3156185/1<3>[   11.451230] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-01-18T12:27:06.773975   =

    ... (12 line(s) more)  =

 =20
