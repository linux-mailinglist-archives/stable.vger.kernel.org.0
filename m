Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CB749666
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 02:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFRAqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 20:46:32 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:51788 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfFRAqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 20:46:32 -0400
Received: by mail-wm1-f46.google.com with SMTP id 207so1284912wma.1
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 17:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V/zHRdky4UgjJIiaE4SokkCNcotzVUSbD7AcxbOEYcU=;
        b=gkRnjfLagvymfJcEq7neS5SQxyLt4qJGsdsTOqsskf3bl1s0I1i69XIWoHNzzykdHp
         aMezPcR/yQANTYEDpViQ/4QqjEKJVo4/qUPLJTlR/kPkb8hVhtx9swwfTAvosHzerLCd
         jAbnUaTrS++oifcBfSK3Xa0tWEReoCd2m9q/mU77Y1c4+HDfnGzD9Dg5SvSBG7Sx/uqN
         42JzFIZns6a9LUHeLJYDp1TJ8Wd+ZaxeZvDSLLv4PGCwawK0zUIMNKULnLIbJ/6hqgYk
         FxgidsRJREMUwTeAysZlLnX91Xr5WatJ+4aJfiia2sYWShOwOmqiTKjrZ3WKlC7xCbIK
         SVMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V/zHRdky4UgjJIiaE4SokkCNcotzVUSbD7AcxbOEYcU=;
        b=BL5dxEPceoCQnANbsAIOQtm4DSLosADxEBiZCIFyHYVR5iLRyZDNNbbDwelZ9pydmA
         8kvmlstEF8vPFq0f+W+KYgW2bvPvKn421ON4qAgk+2OVKtDk1nT4rpYZa9ZDt2G+K3sV
         UkHXuwT8xD7Gor0J47VGoukmeuFoVni3zuOGVDwLyE0sqmTPSamnVbPC5SncoHPyseF7
         Uek1jed0pviH+4Eb+uBuMDiILaXi5oDIoU+PJIrarRNG5zeK2DnmG15nYCzTZ5ivD7Lp
         RgVF9zSE2Ss3Ky+Ixjr8K23/Fu+2FLSPOwyC3zMFor19BfaDJbMi7gRuAk0krXxTXZW8
         lp2Q==
X-Gm-Message-State: APjAAAWFSsEJEetRKCuzk+Jgy2D49kLp6GNt16PLdBibX0/d7IBoQ4AR
        sFhIyXcgpUn6SV2h5RuHu5yAqLP75FWhwg==
X-Google-Smtp-Source: APXvYqzDk4b5iy42U71/UZooUwkmcqKdMPyvTdWkMyuFcu6KX8u9Bdw7SChwYmOWOK9SACYZqsu/JA==
X-Received: by 2002:a1c:e009:: with SMTP id x9mr816989wmg.5.1560818790582;
        Mon, 17 Jun 2019 17:46:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t1sm18220345wra.74.2019.06.17.17.46.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 17:46:30 -0700 (PDT)
Message-ID: <5d083466.1c69fb81.4ad2e.2f2c@mx.google.com>
Date:   Mon, 17 Jun 2019 17:46:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.127
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 49 boots: 0 failed, 49 passed (v4.14.127)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 49 boots: 0 failed, 49 passed (v4.14.127)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.127/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.127/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.127
Git Commit: e861d0673eb8dc9b616269f70bf8a07d7524877e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 26 unique boards, 15 SoC families, 9 builds out of 201

---
For more info write to <info@kernelci.org>
