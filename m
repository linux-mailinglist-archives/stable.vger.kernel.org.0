Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F79945CDED
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 21:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbhKXU2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 15:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbhKXU2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 15:28:18 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35DEC061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 12:25:08 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id h24so3438401pjq.2
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 12:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vhgo8iM1Um1F59liin0AoKy5HjdsvOi6T1+hHZXNKe8=;
        b=WBSayvf/O/gbkFCvYsHeGAxt58RR7GRD+LPJWk1fPQnr1U6CS/673hVER8748e3RBp
         NyqNMD9oenO3ca1QpjdktZ1wXOWlClMrcGrByTdPzO4dbhndb6EnviCil4FLwzjFODPN
         GYfVKIoPpzDJsinz8XNgmL2ZJeiL22P+AGldjnVoRKoJuCzsdQn4pyk48LUDoTF++iyu
         /GiAdpBGoGlhUMnl5QNqdTFWx/V4RMqlM2AYtw08DjCey6Tr1UHqegOhfJij0kRLcLEi
         Pzjq9QHffsFmNIpnNraOREJ/16+lg22HY05Ej0XwfOFjVAODld8HCms+y4KO1hRhrDhS
         ZTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vhgo8iM1Um1F59liin0AoKy5HjdsvOi6T1+hHZXNKe8=;
        b=BOzqNchQjYcqEOZx1D2d8swkX4fwwK5WOH/tsXepHnNwJjZloEmdPg3p/iIxxvCjAt
         TfIo6iEoTMJDW1i+/MlzR3WJ6Hr466V3J/69lgSSyJjppanGCQOOJidTJG+1DXQEht9w
         T0Q9+Vceb+6Y7IgWPSSyv/91RDaP6+S8BkfRZPP3O9Bm6ta4aHyCZXoPFajtfrTx21uA
         k1TJqupjlZEDenskG96tEazkXDreFKDCheOJg/86pHNmfy+2OnScVQdgNTMV1lJ4Hv3O
         4IgaM2r4nGWiUwTl+d3+quqQFYvQYTtTJq41aIIRRs6fz+4FEBlRWfMyURV4sxk+dkmv
         iE+w==
X-Gm-Message-State: AOAM533KqeA6xiCr/nlJ5Vu4rB2tCZS8O5x8oLxRQSNXDwkydg3DoXZy
        VQ5G01V+eH4sbyWrDOS9pPIkPlcNJAVTaDNRLiI=
X-Google-Smtp-Source: ABdhPJw6ts9iMuss3WKjCcc9Sl0putd+5Dc+cO7IexxGWABPoImSAo3HgdQRh+Ce2ri7JP5u0d+vZg==
X-Received: by 2002:a17:902:aa86:b0:145:90c:f4aa with SMTP id d6-20020a170902aa8600b00145090cf4aamr22346748plr.79.1637785507967;
        Wed, 24 Nov 2021 12:25:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e18sm401156pgl.50.2021.11.24.12.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:25:07 -0800 (PST)
Message-ID: <619e9fa3.1c69fb81.7c072.18ad@mx.google.com>
Date:   Wed, 24 Nov 2021 12:25:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-252-g520f0138724e3
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 130 runs,
 1 regressions (v4.14.255-252-g520f0138724e3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 130 runs, 1 regressions (v4.14.255-252-g52=
0f0138724e3)

Regressions Summary
-------------------

platform  | arch | lab     | compiler | defconfig      | regressions
----------+------+---------+----------+----------------+------------
qemu_i386 | i386 | lab-cip | gcc-10   | i386_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.255-252-g520f0138724e3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.255-252-g520f0138724e3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      520f0138724e395a17465ed962139b3de4883723 =



Test Regressions
---------------- =



platform  | arch | lab     | compiler | defconfig      | regressions
----------+------+---------+----------+----------------+------------
qemu_i386 | i386 | lab-cip | gcc-10   | i386_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/619e654a1308bdb586f2efc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-252-g520f0138724e3/i386/i386_defconfig/gcc-10/lab-cip/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-252-g520f0138724e3/i386/i386_defconfig/gcc-10/lab-cip/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619e654a1308bdb586f2e=
fc2
        new failure (last pass: v4.14.255-251-g2f2090beb462) =

 =20
