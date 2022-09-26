Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1965EAD13
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 18:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiIZQsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 12:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiIZQsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 12:48:07 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D225282629
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:41:26 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id rt12so6689032pjb.1
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 08:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=VaqL77jMV+IidPWWMgeEUFPW7KiMHy9msz6jSea5Mwo=;
        b=IX6h5OgF0ltnBe1ZMefrQP5GOveZH5XD5+dpsDLcU+Q4TPrdvcDFCsYsVauihauNTb
         TVTjgvxGLUGD7JEWUnzO6UkO6k2xuhJB0233bHvdnT90OcAGX48dcDqohgXAWEG5MD0L
         9bQ9zu920+oMPOvqUmh07ufI6qu8rat+xBqCgaAuNNZIuaarDlOy0iqi0/vZwBpoASp6
         CM2nvi2sNbONQSuJdVxiUcBg1F/5iOgNIbv9skMapZfPNWQ1VEkpVWh7f2RW5xLENJYb
         dCWAJ64V+dR+HTJ+uTdKIp0BvmMOV7qjALOlYPH4qGnxbJbPfvp4HT8lszQXDlFICPey
         H5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=VaqL77jMV+IidPWWMgeEUFPW7KiMHy9msz6jSea5Mwo=;
        b=FZaijtHFBHh4j9S6g5ehd/a0UJ6SZGzbNcZm7Flps2knA6ILTG/Ia6M/hKsqFsWmgh
         IabI1JVtGSd/XR47sDAwM/SrpOjyaGdU1NJ1R95SC33GGjI4ehnXTdt5+saWpyJU/WOT
         TNM+envFk2nO2rZVqBchMJ2PIOXI0Cvswn5f/+aEwmLMUswlsacEzehB37WbMMp6VtEZ
         2y1xqp4nGh4NNCtyPjUZEOXIfIHsJaZ17XxoVNErMHk+ytYDVZ5UKr4cEExP9LqG07qo
         kr8+ngNGjISZVkgmj84pJ17o4xOQQvs43QFDnd7n2xPs6y2VjbyxZyzytuvmsBHLM/5c
         ZaeQ==
X-Gm-Message-State: ACrzQf2SrUxjMFp+Gxwyk14SIuTGJc598I6B8ws+s0b6uHG7cPBwsFBJ
        cAJMtcSyZH32fU89bq47YwGZcDCA8+TRd64C
X-Google-Smtp-Source: AMsMyM4YCbrWE7THVbjgwK2/Nh1Si3nzFl9X0EYOjdZIvUm874u/2VBekpO5Nioj5+6SQpxnDFnhqg==
X-Received: by 2002:a17:90b:2242:b0:200:1c81:c108 with SMTP id hk2-20020a17090b224200b002001c81c108mr25069580pjb.89.1664206886205;
        Mon, 26 Sep 2022 08:41:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 100-20020a17090a0fed00b001f559e00473sm6601142pjz.43.2022.09.26.08.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 08:41:25 -0700 (PDT)
Message-ID: <6331c825.170a0220.cce2c.b1d0@mx.google.com>
Date:   Mon, 26 Sep 2022 08:41:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.294-41-g959fe4ff439c
Subject: stable-rc/linux-4.14.y build: 162 builds: 3 failed,
 159 passed (v4.14.294-41-g959fe4ff439c)
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

stable-rc/linux-4.14.y build: 162 builds: 3 failed, 159 passed (v4.14.294-4=
1-g959fe4ff439c)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.294-41-g959fe4ff439c/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.294-41-g959fe4ff439c
Git Commit: 959fe4ff439c8dc73f28f08635fe7b9e94c426fa
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

---
For more info write to <info@kernelci.org>
