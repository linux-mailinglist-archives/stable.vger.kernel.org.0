Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083F0118389
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 10:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfLJJ2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 04:28:11 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:35020 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfLJJ2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 04:28:10 -0500
Received: by mail-wr1-f45.google.com with SMTP id g17so19190677wro.2
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 01:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X51lPZDN4EEiyFL6dCsogL4shqW4vwCDIZXAzP0EPG4=;
        b=kk6gT+9Rle/rNPBigWzbT55bvQaK5ZLg9iuLG1P6WXCbFOTKj82Zv1XTyzlUQXbVew
         GztL5BVpwVZkyzzkpzoqroKOZTkkrFIfWuEVPEYsRy9bap/Vy9iP+d4KodZJmQvmcqVL
         ijHYpoEjNVjdhSTuk2m6F23M6Elz8a4IQbCLEHqE1lEsiLviM2jj5gkiGUMA7YPcFvW+
         ARX1jk4Ld3p999PfnrSVLBnXJEhy51eM4YfnkOlc6R8WkOkmWmtqKjB2EJC0sNx6g3Ku
         scEk6AImtNFC2mpvwcN3W6qdJLhf7Z07YrvL89VXkgdvaxHuZkFf+YbBtVeNKsDrROX3
         Z1YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X51lPZDN4EEiyFL6dCsogL4shqW4vwCDIZXAzP0EPG4=;
        b=IviFf8+8Dl98hF3/sjSAXTvF+qq9mGxfcuZVFmHRkSnmq1XTfWymdewDZr/pII2SE/
         g/OVHZ6HE2BUo5t1grHubDC2ZTV34NB6ZawslypUAErJqC9UMABeVY9/F38D4dhAOVlB
         PAaa8DPtP+u6wNNSklF/NaTUlt5RbmwvqHnhuNvlK3oxnFdWSSirOu28Nonnuwvg+ARm
         mVAYiaaZp2/as1aXpfowSlAx3EZBkrpb2mwILZxoo6r+i8UuoElHOe41q8vP48oWvm6q
         FZ+REbwY6m7WzhS+87+tqz+o7IX+yt2apeyxYsWYbpWIkDUzVXZjkpIrS2ICTwCWicWf
         QbbQ==
X-Gm-Message-State: APjAAAUVSxhRLa+KCATzEMVVlJa9Gc3LCGITMvrv9yzecA2sgXRHILFG
        jy36TDrfotl0A/u6PTna8Hz8OA1vOllPaA==
X-Google-Smtp-Source: APXvYqwpi80P703Q9uEHPGbOcMUorQSYAUwmwn0xK3qfhVwojNZoEzL0DcFL91UJ+34mUHwpq97pBw==
X-Received: by 2002:adf:fc08:: with SMTP id i8mr2162719wrr.82.1575970088724;
        Tue, 10 Dec 2019 01:28:08 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l7sm2529744wrq.61.2019.12.10.01.28.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 01:28:08 -0800 (PST)
Message-ID: <5def6528.1c69fb81.80a2d.c935@mx.google.com>
Date:   Tue, 10 Dec 2019 01:28:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.88-242-gc0fa90c1d847
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 109 boots: 0 failed,
 102 passed with 6 offline, 1 untried/unknown (v4.19.88-242-gc0fa90c1d847)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 109 boots: 0 failed, 102 passed with 6 offline=
, 1 untried/unknown (v4.19.88-242-gc0fa90c1d847)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.88-242-gc0fa90c1d847/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.88-242-gc0fa90c1d847/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.88-242-gc0fa90c1d847
Git Commit: c0fa90c1d847eb4ef91a4056dced0b10d6291f40
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 20 SoC families, 17 builds out of 206

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
