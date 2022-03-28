Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938EA4E9837
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 15:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242367AbiC1Ned (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 09:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234437AbiC1Nec (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 09:34:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE97260B
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 06:32:51 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id jx9so14062322pjb.5
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 06:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i9a+JE8dzRSr3g+tNqf5/U4yt8P6giYRJmfiIIkwz6w=;
        b=sTNN4niXqFHRk7abeXYTDh4gx8JztIBuiJL5qEmoylblmQpbrYA7kmqh1i1SerYTA5
         PBs244eIchkiWRtiUL+cqGRpB7mQTEII5qxHK8AK4RlWDRzVC5ycvHgCUZZ9/tmPZqS8
         7M/+9SCdVnh6+EjEQTRV8+8VeNLd+u5ScFhGJddIHvKNKFJblODjZg/YWSPCozxup4af
         7EidaBC+XI/ect8LS4WfhasSoQaJv/J9Td/+V1hHN48qtPJGH0J/hrLg+Fjorm1kIVh0
         jWP7u7JaG82x48qFOyenOjBRRCICukbYOJrQZ65IRyIyFNHSGOS7OJumUBvmo5o1Azic
         w4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i9a+JE8dzRSr3g+tNqf5/U4yt8P6giYRJmfiIIkwz6w=;
        b=z00FHpJt9ws8MofuK4xUL4jxSQvstOoc3RPLij+7G7+ZzYmn00tXlR3eKndzSV2HDp
         TG3iD3UTxMopgDTB5JHrjN8gHUyJUXe2Ln3gzr4GY20UL69FAyvNvNNd8wRKTOgEwC4K
         RNRVGG4Q/UeYDZNACsdb2kXu8WxhkzvKoxDzfpCvHkZciKWxKYrlIMCYbQj6iaG4hXkl
         x3WNGH7pbuL3ODHn/kVlPn6bETFEni5l2UKjIw3iDKrutEkGfygqeeo6Ss05sL0wfwrf
         Jvt+W19dRChUZfAG/i/BMaeLVTDhvDO3WU43h19YpAVN6su50OD3HJXd85jXN8jENIdd
         Ui3A==
X-Gm-Message-State: AOAM530h4NoNPwGhsm+w6S9u/8n8K4pDdqbQI4mEziHhDSxX0HFDwY7H
        W8xuLjhLrngjfRAYe7+4ZHfoRxACFtnQH2MX6Dg=
X-Google-Smtp-Source: ABdhPJzHtG+YaFSpjgYZo+8P4yYJ8ZQLeqf8IbNf3AB/+KCGMpxowb2Ara8kBUIeuA+iKBLJ5yv7ug==
X-Received: by 2002:a17:903:2d0:b0:14d:8a8d:cb1 with SMTP id s16-20020a17090302d000b0014d8a8d0cb1mr25936007plk.50.1648474370711;
        Mon, 28 Mar 2022 06:32:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g5-20020a056a001a0500b004def10341e5sm16114239pfv.22.2022.03.28.06.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 06:32:50 -0700 (PDT)
Message-ID: <6241b902.1c69fb81.d574a.9972@mx.google.com>
Date:   Mon, 28 Mar 2022 06:32:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.274
X-Kernelci-Report-Type: test
Subject: stable/linux-4.14.y baseline: 55 runs, 1 regressions (v4.14.274)
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

stable/linux-4.14.y baseline: 55 runs, 1 regressions (v4.14.274)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.274/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.274
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      af1af6ebca0e28a97e5f802b9da695678fcd226a =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig          | re=
gressions
-----------------+------+--------------+----------+--------------------+---=
---------
meson8b-odroidc1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6241891711af6e09e2ae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.274/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.274/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6241891711af6e09e2ae0=
67d
        failing since 39 days (last pass: v4.14.266, first fail: v4.14.267) =

 =20
