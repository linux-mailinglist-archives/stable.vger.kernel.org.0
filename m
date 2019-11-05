Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7369EEF509
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 06:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfKEFde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 00:33:34 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:52290 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfKEFde (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 00:33:34 -0500
Received: by mail-wm1-f46.google.com with SMTP id c17so11963900wmk.2
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 21:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Rwpy/hz+Y6vHPNiMzwH2wgQ/mze4+tUWqXAlT+MyOKw=;
        b=bHH0YXnBspbYkS8gY2acfMQ/mSbYhGZgguBImNBCyISUT6GY0Hid1nWoiMaYUtCSNq
         OZf2nukJ9zXP1Sy/hJOtGwvLC/QXJ01qsjj18nUYplIfWuvGqhMs1L+bvvI30rGp/0y7
         4jLqPpZmqDmdVHb18vlCECnswms7QuFxgUUz1J85tRZEAL230FaOaJwRlpNr4I98bRoe
         5V0tTeAlt1wRiIk4MKPP+qfBuEhz2xY7Z7t+X8FvGvL2veTun+41QrpzBNxXCfcNC8LY
         0bNQUQ2ACxp0iLnKGE9V+TuTpyJTA41AIWyC15ptL8TNRHDuRVmkTseutwE/f65xkfaz
         dCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Rwpy/hz+Y6vHPNiMzwH2wgQ/mze4+tUWqXAlT+MyOKw=;
        b=RLzJJkmr2FpH/xMlbQmP1MBs3Cy2bp48BxOIxwVdK5yLc6rLQUQkz5pMY2kAZUOhC+
         tWocHrbXazdJRsfEhViGxnXyKTJTNqTwjq0Eip7HYzKyBDk5eIeuLGvXtqHLLmDeL07t
         PgnS53J9ZaKPhGYpN/4AT7ggIfF8pkiDYrSEyzejj+DRtfFebHdEnDrl2IEBlt2qoMt4
         k2xDaCwMBcMoM/zrRSo5JSyH2oxaTTnhUk2YQARzdHloo+VlqewiWJdEQmuCdPMZJ8bc
         8C6qGGGuIeHc6z/u4Wc21WxlNvseGwlwzCOuOhf2vcw9g8p9srAdXlDBekY96x4NsiSC
         2+CA==
X-Gm-Message-State: APjAAAV0NuGe+lt8sNVfLMvQL8/j2IaOvw33+Mlmukn8ajq1FSun8IF1
        kbwjN73ZSksYcckJhaj2k2P7+Yry7w0jxQ==
X-Google-Smtp-Source: APXvYqwRMhWjjeUnY0O5dGHKXQvdE3e6k5B+5NZK0S10rc+sqDUCH8VezPGn1ul+MKqCQlPA6uN/rg==
X-Received: by 2002:a1c:9601:: with SMTP id y1mr2229161wmd.157.1572932012216;
        Mon, 04 Nov 2019 21:33:32 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s12sm21143186wme.20.2019.11.04.21.33.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 21:33:31 -0800 (PST)
Message-ID: <5dc109ab.1c69fb81.1e8b.3cfd@mx.google.com>
Date:   Mon, 04 Nov 2019 21:33:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.81-150-g3d3728a67bfc
Subject: stable-rc/linux-4.19.y boot: 118 boots: 0 failed,
 111 passed with 7 offline (v4.19.81-150-g3d3728a67bfc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 118 boots: 0 failed, 111 passed with 7 offline=
 (v4.19.81-150-g3d3728a67bfc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.81-150-g3d3728a67bfc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.81-150-g3d3728a67bfc/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.81-150-g3d3728a67bfc
Git Commit: 3d3728a67bfcb7460a6f7c5417a2d9a4ff180c58
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 23 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
