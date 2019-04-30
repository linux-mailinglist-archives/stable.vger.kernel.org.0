Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 223A9FFF8
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 20:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbfD3Sxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 14:53:30 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:55263 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfD3Sxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 14:53:30 -0400
Received: by mail-wm1-f41.google.com with SMTP id b10so4960351wmj.4
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 11:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KOC8am+a2nOdN4WYbe81JkusFOlmT/wzWfYRV8sMIdI=;
        b=awDnIeTMhSCVflp5vhNG90/636Ip3PXT/yYBDP/b07KhldrdscJTDRWQeqOgirsFN8
         ZBYs/2dor4eNjJbDYdt93DMF18JLqidGrUH9QUch5P3oNCxujgiZh2UhZBub8i7zg3Gk
         Xgb02bcR43/J9SrwEpY9gFJcf4bKjI4m6KSlKNo9hlrbkgKijQQKVM92P94+NczVw3k8
         oGGvTy1ZUvmHunJk3RIIs9pbzbgKvzedtYaPCE1cqh3A6CoTZt8hbBbfwf6iRmXjzpki
         Gll1Jk1gUhi2mHULrLMY9TE2d+QD+rILQ/K5HIVSibElh6rHQa1aCYWB1BKXXOtGLcTQ
         Z5DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KOC8am+a2nOdN4WYbe81JkusFOlmT/wzWfYRV8sMIdI=;
        b=NoiE2zp9F79S6ZyrrAxU5WRneDJnEEiLV2yNdGMUQxth0OieVOJUdzFiaXV9LOPOoW
         cRb+yaHugIGpoQSH4WmSrFCDzn7YtmUmgSFdYCXGhw5niayfSJcmR1QR8dxfR+xSeHjS
         5tplXVZD6avq+nUJYEpOg6sxifqWSTpCPhk5Shd2RV+jNfqnSslLyBHWad2JnRSeR+dl
         0iRP3rWOMhjBsDMbLwID8cF11skyXFVm+ZcAQ1Fre0PiOBTOuJ9nmU0fkLMAHWczfd3A
         45tUQR/QWLEkxP5MZ43I2tHp6NSTA8AhCBrUQLeXa1YI8FoS1PVX3sqVj0SSbumgcZDi
         yWKg==
X-Gm-Message-State: APjAAAUYyyrwRHuwZVP1ljanJ6P91GkqW3pTexEJgZ/Bmtx7h2OsyZJr
        JshXEMEkXQdbWYrPNneWnB6YswNcCGMfAg==
X-Google-Smtp-Source: APXvYqw3xg89lTyeEqroBSDIIT06MzBHK5kL54EaSbdQ0ZqITFKjkJ5ErrNFPmnHTFRnkc7pyflnLQ==
X-Received: by 2002:a05:600c:2206:: with SMTP id z6mr4424164wml.80.1556650407948;
        Tue, 30 Apr 2019 11:53:27 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r2sm12186062wrr.65.2019.04.30.11.53.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 11:53:27 -0700 (PDT)
Message-ID: <5cc899a7.1c69fb81.37300.295e@mx.google.com>
Date:   Tue, 30 Apr 2019 11:53:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.114-54-gdb44a158d937
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 117 boots: 2 failed,
 114 passed with 1 untried/unknown (v4.14.114-54-gdb44a158d937)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 117 boots: 2 failed, 114 passed with 1 untried=
/unknown (v4.14.114-54-gdb44a158d937)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.114-54-gdb44a158d937/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.114-54-gdb44a158d937/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.114-54-gdb44a158d937
Git Commit: db44a158d937ed88d91fa55f1df54c11490a5b57
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-7:
          stih410-b2120:
              lab-baylibre-seattle: new failure (last pass: v4.14.114-44-g8=
da3ae647284)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-7:
            rk3399-firefly: 1 failed lab

---
For more info write to <info@kernelci.org>
