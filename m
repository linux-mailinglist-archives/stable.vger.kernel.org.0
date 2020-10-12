Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CF428BF1C
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 19:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404081AbgJLRjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 13:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404054AbgJLRjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 13:39:42 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF981C0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 10:39:42 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id n9so15000594pgf.9
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 10:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8yCVofX6EK/M3+wlxth+stymdsjqcMumN8dgOB8gGRY=;
        b=yO1Fzi5ycJ7yFerJ8ZqB7qpIbuB3GoHZ8k3rmLdST3+g7PJoOnkWZX+xAXIksMYuEz
         T8vihQYEpoNuX2W+B3lLKi5mcZOkX0ZjE2gjrj75gmo/XQpe8FKA+ep87/jVtL5GQ7Z+
         WplGs1kXvcwOHqqE3d85cmGd0qYakrHI2yFwTtcbWTlPfW4okAIwQK9NOTcUqKqQYJE9
         T2rwzQcYCC4oieTf5I9S79YjHa2F3MfAJCiOnsS8ht+qYFl/rhrQktxhPbM7PDOCTSba
         qqAOuqc6z21vWaqQPKcsMVQPo7azKn27r9HVFkr1kQRjCg5ieefflwzUJpGOE6NRJxma
         YM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8yCVofX6EK/M3+wlxth+stymdsjqcMumN8dgOB8gGRY=;
        b=eEO4xmFn/FXrzDDhhKETVu2ZbhjnSuZ/FPk6oj+utRHy7PvoPXrSoJfAXSfgtuEDal
         fCNx2sb7fFag8t8XL92/8WjfELbhs82WYEs7Nt4iwDExsMco9tivibTJzkaXcJFr5OwR
         up4IV1ivbKhZvU1GK5DDzDjrPLbjSP3Q5KveKTvN+nJr89FJJ8TBujiT3uhlVEmvQVKs
         VzZm+hs4rlXOl7Rvz5CnZQEqfDn114W2mrPw5ghy630p2i7+0HnDp6A1m9xR8qJ+4n/q
         Sk+bzyWQi7sGgfsnAQl1bG3PHUyZeXeNJv2DINgVRX2KyFeXQdnUgyZQPvLNLS+oT723
         7ClQ==
X-Gm-Message-State: AOAM530YdAeRMcwKXc6cnttYylwJJ+ys9HB7BbmRP1B2Sbd6lvqwkYM2
        JZUysngKFZzS/zxz4ahmXfe1eCms9AmGZw==
X-Google-Smtp-Source: ABdhPJz3m0UqPVZOqhSvDHBUZHM8LccJgyT8VUr9lHnAorxQBrLyU3ekHrXLOJ+ODEh2opURSwfXbg==
X-Received: by 2002:a17:90a:1702:: with SMTP id z2mr21247863pjd.88.1602524382011;
        Mon, 12 Oct 2020 10:39:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j23sm12260058pgm.76.2020.10.12.10.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 10:39:41 -0700 (PDT)
Message-ID: <5f8494dd.1c69fb81.80873.7a39@mx.google.com>
Date:   Mon, 12 Oct 2020 10:39:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238-53-g3bfeb60986ac
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 122 runs,
 1 regressions (v4.9.238-53-g3bfeb60986ac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 122 runs, 1 regressions (v4.9.238-53-g3bfeb=
60986ac)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.238-53-g3bfeb60986ac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.238-53-g3bfeb60986ac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3bfeb60986ac5540c0260d9b412cc8b164f1ba42 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f84553f03274262824ff3fe

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.238=
-53-g3bfeb60986ac/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.238=
-53-g3bfeb60986ac/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f84553f0327426=
2824ff405
      failing since 6 days (last pass: v4.9.238, first fail: v4.9.238-23-g3=
14770acbbde)
      2 lines  =20
