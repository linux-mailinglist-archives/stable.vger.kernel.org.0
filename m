Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5D123F2E9
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 20:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgHGS41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 14:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGS41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 14:56:27 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF229C061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 11:56:26 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id j21so1365159pgi.9
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 11:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MUHL709k108JrQYQrNvEQBTkZPoUW9DPduj/gPQk6lE=;
        b=aqXNf95DtlsPNHiWUBjA0g3l1Ja4NGHid1gMoxy0sHuS+hLzYIwrLe0HoCRkCqzVPx
         8YqDR9otNcsY5GcUo3eFbPHvdm7h5ssM+oB00XQ4NV17bOpqt6n3biXvRP3+qLfIfpx5
         YfmD1/79U3wFg5HNYR74VzTshyIUPRtrRQraXUwSxRk73rgRGNgywn6AePGXA2SSdcTS
         WBzQJssopCdnc8PjAFhZ+q46VnLyRqw4SN2lacABZkQtWDRWk4Rbc96u/9v1GTZx1ATm
         azoS91tCNMz9f/NjFylHxseDipzK7u9Z/gsqKxh2/53k0bDn30W0LRQY4xET85AR918a
         lORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MUHL709k108JrQYQrNvEQBTkZPoUW9DPduj/gPQk6lE=;
        b=HuHOysuFPTOF5OBrOMhfAj8Ntfz4OvuFVYdhbzJqqNyJ+MtlSSDhVBGswDk365W5TK
         1Egqdi3CNjMdkneMqGJOQHO/xMKbgfNB/tDt8uLr/ncgzBlNxpJIlAMDk+0i8z/8+PPw
         1/x88+7nTE8v9pU3NmLXuboQtrCzAkJbl8azx/Z2VYIaM0iMqi+WTX7RrI9rjnCIY0Ys
         vhfIzJ+ib4Z48ktLOeGPDHZu39KcohqrkeBsUORFWi/il5ENcuX2Cpwdmf2jCN0+Qk9l
         jK5p7oLljmXxQLQvoCCw1StvtKUgLZX5lXntOdA3kXWfEx89KX0snJubGJC6TFIK+bms
         aBBA==
X-Gm-Message-State: AOAM532PROlrjcXUZBVzKDz9ALRMylbWH5CHqw7AvLME0WxrMNAasOxi
        dkhL0RDDLPc2oi+Kcmz/bCzuXNxheDg=
X-Google-Smtp-Source: ABdhPJwYyM6GBEJ359Q3RXJVSfsWtClRxa1wjOxxE2pBb9NkmhM/NI8Hgv2oPiIAVthxnF1zshyASw==
X-Received: by 2002:aa7:8757:: with SMTP id g23mr14240442pfo.283.1596826585076;
        Fri, 07 Aug 2020 11:56:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o134sm13769083pfg.200.2020.08.07.11.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 11:56:24 -0700 (PDT)
Message-ID: <5f2da3d8.1c69fb81.cdb1b.0421@mx.google.com>
Date:   Fri, 07 Aug 2020 11:56:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.193
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 119 runs, 1 regressions (v4.14.193)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 119 runs, 1 regressions (v4.14.193)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.193/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.193
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      14b58326976de6ef3998eefec1dd7f8b38b97a75 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2d6f405065496c3952c1b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.193/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.193/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2d6f405065496c3952c=
1b4
      failing since 126 days (last pass: v4.14.172, first fail: v4.14.175) =
=20
