Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2395174852
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 18:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgB2RMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 12:12:25 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42622 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbgB2RMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 12:12:24 -0500
Received: by mail-pl1-f194.google.com with SMTP id u3so2491184plr.9
        for <stable@vger.kernel.org>; Sat, 29 Feb 2020 09:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k5eyACNYQ+aaCX3DoC8PNRQz0CL2zqh4NYSJo0pAWbY=;
        b=NQkAlqGz5dnC9CS/GNKVEt3d6fa3Cu1v/Y2UAbqQKVSGX/JPnO+2t6SCbqxCacfKyZ
         6K0FWQX490ZY7q/gBGdG3nkyWQDyp1eJqWhw2OlbbU82Am8gX53SLXVvqs+ZkFho7SIQ
         xFkCGdh2zt+h/PtBzf1szTIq5q4cQjM7pu1ccl/GGoteuTz/7PzGBpcYTZVwjBoPA9mR
         4KDqhl2mqK/vo+Xhfcqdl1Yibbli4J986nILJsBuMtT3PnCe8TrSUM+G370DugktmuzZ
         M+/pYVHOcKzqfCm9YZGcLfgEejSz3oXsPZv2YtFDYAJd0iqZhiaWJWwENZF4BV+PE0Zs
         rlDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k5eyACNYQ+aaCX3DoC8PNRQz0CL2zqh4NYSJo0pAWbY=;
        b=VUIzYLHeTCIt9PFzPKd/ivgdnKoQACAok8bUVbnoM+OfAb27haGGAgKX8jSatX6mGh
         POOU/4zpp82L43voyHD//GT95Uay815vDMPYn83G7J5OVnkhThc8d3nKhyT0Ews+7TlG
         aCINQtPqGmBCTS7Ke51s0jo06C+TOzqKksiDkgSx2Apz6RvWjaPUWSBEGnXmiCOLteoI
         I+HvtEjZryp4tbg46HEse31wBMlEVbs5vJ6P1RUSmRN9lpTu1HI8XDrp219wWGrfO725
         FIaR9HmesLleOitnjZihTqc7ub9kcXPtcN+U7SNxpYc0fTnImEKk4ewy7ZbrqqClJBrj
         8jZQ==
X-Gm-Message-State: APjAAAWD4BIe9DIbF+TKYjjOYQmzwJsHn3r2TYQdvqfyZ5k3nBskjtTr
        M4uPMQD2LcBJIvR4tuCwYqkz0CSHFSk=
X-Google-Smtp-Source: APXvYqxzdqswublbMH6hzpro5Xk7D2x+/UQU9vUFpXK+IJzUdi9fL0f5gA6YUazw+8HSo+vz1yp1wA==
X-Received: by 2002:a17:90a:1f8c:: with SMTP id x12mr11429606pja.27.1582996343579;
        Sat, 29 Feb 2020 09:12:23 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t15sm14648598pgr.60.2020.02.29.09.12.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 09:12:22 -0800 (PST)
Message-ID: <5e5a9b76.1c69fb81.403eb.5790@mx.google.com>
Date:   Sat, 29 Feb 2020 09:12:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.215
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 15 boots: 1 failed, 14 passed (v4.4.215)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 15 boots: 1 failed, 14 passed (v4.4.215)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.215/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.215/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.215
Git Commit: 1721173ef18200e8e8265568f13942d6e19c2c83
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 15 unique boards, 5 SoC families, 8 builds out of 190

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
