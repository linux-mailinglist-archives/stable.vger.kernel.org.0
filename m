Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53DB60517D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 22:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiJSUpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 16:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiJSUpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 16:45:09 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2422166561
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 13:45:07 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q71so469826pgq.8
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 13:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QGsz0UZpUHv9DXloNNNIoEreTUVSYBJHhJCi999bTZI=;
        b=VSGLiJdbQsjsc88L/TCtNji1I9mstz3P5ICoLmo+MSodPTw7qMMK977MIKxLQysLBx
         d1QSnhBSGkEHjOAqBYOS+RsqDyJsa0PWEx/u3T63ZPpP1NGrot7TRiqFWhz/O76JLrbk
         DJ9SpocBNhy+W/WAq6Yw8De5McCa7j2lwKJNMHstTlmFBR0RKSMt5AtK+HfXuH9Zl+O6
         7vqnQF7a50XwWXS5vZY0+rZatZak8QVVbeEp5jgqxInBr8X06ijumVFv/iFMkoscpxAF
         68pWRf8SPMjdmLvYzoM6WUQezvoW++7tixCSrQDD5hIIAR22waF76A3UJfliVDujhNNK
         nWrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QGsz0UZpUHv9DXloNNNIoEreTUVSYBJHhJCi999bTZI=;
        b=nGzSXlkSbe/rX1xXt4xCWvA9GZESSJ0N6Bt4YNwaBVSaTuDWiUKBdpacfGjTfffoNQ
         +pI+CKM8YNdHbKTlGJa547RtaTMGtTtLQi//wMTxOKMJMUupjcg5FEwEtn+VfyH3bbo5
         17uKFj9W6biXDocwMNKykFke6m6pBFfnKzZ6nY3uOUvk16ryvOrpa2T+BK/TRVsb9QvX
         wZkeT5Kh2EOg2wNNNDXhlsiO+hbTj52v326BXWydJJuoTJ9NWVMTxu+3E/rva7LJLIti
         lWReQ74MgapbdDrY+z5zlA91r4xStjwxcTklZaakZcJhzW24OYfqMdiaK1wFwDPSKA9V
         8Amg==
X-Gm-Message-State: ACrzQf1ZoIJrsdQCy+6k6qTAargi+JFDhTN3X5Z5AvxK3wJI2tyuNRgD
        m3fRawk75o0mMD8mIW+I1kgbVIOO1/Icm8Ys
X-Google-Smtp-Source: AMsMyM6wU+eTitSe8MXfLWH0WHOWXEoDIYM6jExe05QM8nV7zBU5U16U42g/hQJnB3Q5tyDj7jgMRA==
X-Received: by 2002:a63:5811:0:b0:43c:9d3d:700a with SMTP id m17-20020a635811000000b0043c9d3d700amr9005030pgb.419.1666212307117;
        Wed, 19 Oct 2022 13:45:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c123-20020a624e81000000b005624e2e0508sm11714108pfb.207.2022.10.19.13.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 13:45:06 -0700 (PDT)
Message-ID: <635061d2.620a0220.bee8a.6524@mx.google.com>
Date:   Wed, 19 Oct 2022 13:45:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.16-780-g145f69d7228f9
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.19.y baseline: 101 runs,
 1 regressions (v5.19.16-780-g145f69d7228f9)
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

stable-rc/linux-5.19.y baseline: 101 runs, 1 regressions (v5.19.16-780-g145=
f69d7228f9)

Regressions Summary
-------------------

platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.16-780-g145f69d7228f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.16-780-g145f69d7228f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      145f69d7228f9126c5352398ef123eef95f0af23 =



Test Regressions
---------------- =



platform        | arch | lab           | compiler | defconfig       | regre=
ssions
----------------+------+---------------+----------+-----------------+------=
------
qemu_mips-malta | mips | lab-collabora | gcc-10   | malta_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/63502fe94d46f4f2f75e5b7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
6-780-g145f69d7228f9/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qem=
u_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
6-780-g145f69d7228f9/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qem=
u_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63502fe94d46f4f2f75e5=
b7d
        failing since 0 day (last pass: v5.19.16-839-g28b57a08d7fd, first f=
ail: v5.19.16-800-gfadb31f400c7) =

 =20
