Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D27C639109
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 22:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiKYVVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 16:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiKYVVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 16:21:13 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB31B56EC0
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 13:21:05 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id q71so4845550pgq.8
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 13:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bRqJHqi6E/O+AQ4pY/G0bpF8Qc0H0hQ6qwnZRmA+CPI=;
        b=e1lC1XvMYjVikP1rBz2RmUYFgq9Kj8yE0sZwn2aJ4jpmXiRctxhZiiW2M7xMgQew7P
         RQDWQCoDkIzpVI1wkrDJ1wvGpx24u4GVzE+2NJNQIQiM4ijZdfKyXHOkpsMMxa3Dal08
         IMDfK76rVOC5roQcYX9I6LhJli3RSUu+Qqt4HrBPVp/dfCett9EMFX2iiNNIsCyYH3Ol
         +VbLqZ0O8n9KjNrZMYWBUNuX5ltTpT7WE+Nu1eR2yO2rEdXLb3aItADUdyprn5KxlaV9
         4H1oUr+S6lA829UM6wJhJ8p06yD2rSD3Pu7Ouf+HFLy6dAfbPKnDzf3nAaWbCfAwr6y8
         vBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bRqJHqi6E/O+AQ4pY/G0bpF8Qc0H0hQ6qwnZRmA+CPI=;
        b=TI4G7w9n8BzUaxaWd35dgG1bipXpN0TZsYq6RCKr6+11xglj20MYNJkMQQ/okQQTOD
         eU8BU7dtdsIeZ207VmfVe2eHvl36ynCZtywtcLQBQdjtnrFL5AmgdHHPKZ5S3f5+eljg
         bM2jLhm4GEgh7LqE+vvUTf9uYintCmFDkeIRNo+2+xX41/cSE6ndvwXUOr7zcmnQHwxg
         jVSgF/NIt/evIoRWZmOKszu2X8KyLtYYv2XLUhyOcD3EYXUCwXY0fK7BsiN4C8qIqQEA
         VvhMznt7hcQIr2E+1yQ4FV2/dh4HnI1rSKP8F5X3nHzspnZ2ERQ90s8THlABlKSJ4e7n
         9RyQ==
X-Gm-Message-State: ANoB5pld0ThoI6LrF9uDFUatoBDaCkJEoHPIa6GRPl3i9vVvJAbX8Bid
        xHCh8krRvbpR6bW8WnSLQfJDCXq1OmJpekDP2ss=
X-Google-Smtp-Source: AA0mqf4Ivy+YfAzTOIhb66PK7yYkfmVREyXxvLQ15UMMO6j5pYIZIyvFL75YmLGPRk19c3cLJyTLEQ==
X-Received: by 2002:a05:6a00:1388:b0:574:d12e:f3d6 with SMTP id t8-20020a056a00138800b00574d12ef3d6mr2798528pfg.78.1669411264937;
        Fri, 25 Nov 2022 13:21:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d1-20020a170903230100b00186ac4b21cfsm3857754plh.230.2022.11.25.13.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 13:21:04 -0800 (PST)
Message-ID: <638131c0.170a0220.98d5e.5124@mx.google.com>
Date:   Fri, 25 Nov 2022 13:21:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.155-148-gd147f70020dc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 110 runs,
 1 regressions (v5.10.155-148-gd147f70020dc)
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

stable-rc/queue/5.10 baseline: 110 runs, 1 regressions (v5.10.155-148-gd147=
f70020dc)

Regressions Summary
-------------------

platform    | arch | lab        | compiler | defconfig      | regressions
------------+------+------------+----------+----------------+------------
i945gsex-qs | i386 | lab-clabbe | gcc-10   | i386_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.155-148-gd147f70020dc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.155-148-gd147f70020dc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d147f70020dc898c65e65699851c6474f77e2894 =



Test Regressions
---------------- =



platform    | arch | lab        | compiler | defconfig      | regressions
------------+------+------------+----------+----------------+------------
i945gsex-qs | i386 | lab-clabbe | gcc-10   | i386_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6380fba9478698ce482abd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.155=
-148-gd147f70020dc/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-=
qs.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.155=
-148-gd147f70020dc/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-=
qs.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6380fba9478698ce482ab=
d12
        new failure (last pass: v5.10.155-149-g63e308de12c9) =

 =20
