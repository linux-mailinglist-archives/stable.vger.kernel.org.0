Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B85E4D91A3
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 01:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiCOAf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 20:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbiCOAfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 20:35:25 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0C03B007
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 17:34:11 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id s8so16854008pfk.12
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 17:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4vsgXeuJg8cq9x++F/r0WUDA4h2++1V0ZE05TLXx3sI=;
        b=f5ql0jQUo8rzD7n2OaT2rvlfA06BjpRqwPR/k8LCnEMZDj/XNyskB228wI3ehHmYOL
         HsTwkQHlxR5Z530cVuhGi8dF3pFCBiJYeACRwtDG7CKl9FQX/MYIpjrcn1iSmq0ZXTH6
         eVLkvr9RefEMw6+mzEUbQ7eWcG+adcqK7w4R/mL2bBoNpV2e8g0FWhWx9DpmlN8kYDU0
         kEi2qdwAqLXI4CEYamKUc/5r+Ikp8iGIJ0L36i4hg32EAI+QuywYSWyvQ26RneIUSnF+
         e5NhqqMav1lrYPjGbLnQiDDuqdg1RfSHmq63Oa90fZ58D08OdvwcqXScnBmi6v1asSSv
         keNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4vsgXeuJg8cq9x++F/r0WUDA4h2++1V0ZE05TLXx3sI=;
        b=CxmpfNqwWbzmxzMZIeFJxDXMuG523w8Svci5fFpDjvbH+28vf3NBUOgigetfZBy6F7
         X9giabH37RlC5lne6kRC5s3EG1w9ARHQWrEsSGBY8vEFgsDM2WCD5XVxE/w/VgRzYjmm
         50ISGwSu+A1YH7F9fnx0aLKRmAhHZW/s2JKcQ4zTUGqYXDJeEkaIKZZm9Hm0Ldb+qbTb
         Vbo6oxxKKuue4hpjgzTjyFJJRpM4Qo7hWnQL/LLEI/MM7hqbg3YpQyKkSb2eQM6hXrZG
         uSLzajQevdepvaATpVWX7syPtLV7EFHcr+N3yUMrUne6ehD9UliE2GjBlPk1Z7GzWEFH
         qvRw==
X-Gm-Message-State: AOAM531f8/9RuTAG+92aVX7DMpEUwPbKhPEMnhU2qVqf+hhf0SYB3i7k
        ZuwrmQ4a/oIGIZiAj6x2zX6L9JSu9OruP9P4qeo=
X-Google-Smtp-Source: ABdhPJw+IJoRZz9uRt7A8x5BeD9xOAxKC2bc4QH0MiYyX/9xHw4SlMEl21OSeGcCHfumao6GDR78OA==
X-Received: by 2002:a05:6a00:1894:b0:4f7:288:9844 with SMTP id x20-20020a056a00189400b004f702889844mr25718115pfh.28.1647304451128;
        Mon, 14 Mar 2022 17:34:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t71-20020a63784a000000b00380a9f7367asm18514902pgc.77.2022.03.14.17.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 17:34:10 -0700 (PDT)
Message-ID: <622fdf02.1c69fb81.e9d5c.f3b1@mx.google.com>
Date:   Mon, 14 Mar 2022 17:34:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.28-110-g008946945c93
Subject: stable-rc/queue/5.15 baseline: 62 runs,
 1 regressions (v5.15.28-110-g008946945c93)
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

stable-rc/queue/5.15 baseline: 62 runs, 1 regressions (v5.15.28-110-g008946=
945c93)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.28-110-g008946945c93/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.28-110-g008946945c93
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      008946945c93dace8ff6d69e8e8fa4ea07f93e3c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622faaaf6a84163501c6299c

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.28-=
110-g008946945c93/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.28-=
110-g008946945c93/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622faaaf6a84163501c629c1
        failing since 7 days (last pass: v5.15.26-42-gc89c0807b943, first f=
ail: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-14T20:50:44.898352  /lava-5878561/1/../bin/lava-test-case   =

 =20
