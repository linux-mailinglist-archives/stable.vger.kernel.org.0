Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6A6628CD
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 20:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfGHS7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 14:59:25 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:34699 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728562AbfGHS7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 14:59:25 -0400
Received: by mail-wr1-f44.google.com with SMTP id 31so1516691wrm.1
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 11:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K91t+FtsfBSUcSDS3x3jNNU8zFh5v/uXYLs4sWDTadg=;
        b=DZVrqJoBvkrvYdaUsrMLA8ZgqAskYunUE5IEMgWjG+/5XdnqHae6aRfBqY6oXkWJ98
         1xYkIlpIfoFe8fXg1XOb3fSIkdnjUpf2DNdPngPAJ8IOCxCBrogLWtDk9mOpilZd+uA8
         Qk9RMUrIy4hUingWuGGnmGGVpnTGERHXs8cEANEj5u4y+7/MNh53i1dZwjGLUUglSEnX
         tTjD9vXhoKZFPNSCEBJjqqeYc6F0iA6upjHmiGT/MgY/Vuqs3CBV3VSwdktGZabGWLvo
         G/IxaxboRoRWKcmC67+fusHrkBZ+WPhWRSGM1LmHb7Y4ZkEJOUVcJ+Vbuzm1XeLppGbA
         KK+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K91t+FtsfBSUcSDS3x3jNNU8zFh5v/uXYLs4sWDTadg=;
        b=m47FJBNjbsskGXrrk0RWSSn/CNWMdlNR0VojTOlUgP61vZKwlj1yLFH3iOcpgDUkAW
         uI0dIOFVeN53lIaE6OdYZOlKqzSTlWjQKwpGTLBJUelwz/RuHE8DuwxEJXfKB8n17DBu
         GVzwOwCA4fIvG88bk9BkdTD4Z6eULrfB3GfbYvbeHOEMnuOD4062miSSKxhi+oJBuIh1
         /hSJR8XfVz1RLCvlL5I5m8twd4nnLjRjpHAaqRWNgTAZ+DryI1++ZNlashIMlVtpVtIU
         ry4Tw11ZskaKbVkxSx6Rcgq54k9+1NWpTHe01+vH5/c4m7eOAp1V9y+k91/KZ28Xyb0u
         rPgg==
X-Gm-Message-State: APjAAAWXj96V/1Mt/Bx7XKCsPmWtjh0cpUy0uT9wxrSkHIm92A39M2Ib
        bAJGVORpm7XW4WoD5uMODXTgeyuguiccFQ==
X-Google-Smtp-Source: APXvYqwa2f+KJiYWaFJ5cavkF9xtUjzw/2xlLpiC+CwsGU5ID1+Pzt6VdKxU3e7MWSgLeLQPUHhLvQ==
X-Received: by 2002:a05:6000:1189:: with SMTP id g9mr1398157wrx.51.1562612362761;
        Mon, 08 Jul 2019 11:59:22 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g2sm632168wmh.0.2019.07.08.11.59.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 11:59:21 -0700 (PDT)
Message-ID: <5d239289.1c69fb81.140cd.45e2@mx.google.com>
Date:   Mon, 08 Jul 2019 11:59:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.184-102-gf075c4e9d730
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 94 boots: 2 failed,
 92 passed (v4.9.184-102-gf075c4e9d730)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 94 boots: 2 failed, 92 passed (v4.9.184-102-gf0=
75c4e9d730)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.184-102-gf075c4e9d730/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.184-102-gf075c4e9d730/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.184-102-gf075c4e9d730
Git Commit: f075c4e9d7301b229ebc16b6ae51dd5094802c48
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 21 SoC families, 15 builds out of 197

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
