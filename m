Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6FCE4F7D3
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 20:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfFVSn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 14:43:57 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:33933 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfFVSn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 14:43:56 -0400
Received: by mail-wr1-f49.google.com with SMTP id k11so9678664wrl.1
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 11:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b7WSt83E4qRAINy4by4/dqIvH+W+atdW3e9597yM2Ik=;
        b=xZroI+SIfmECJVwTd+n2J1b5b8AypWarRQykInm/P18o+N1llmnPKsLCcvu58s/rtG
         LSO2wGVKoaLKrZtfh/SaOhVTUsvaToGt67S2M6nJJA7iR+rXwJ5VUgCOOjTdx6vSDsgB
         fmJx/hltA4Ls36S7ojv4zk1jw/n1PkSPrB2swD6h57d9oEn8tGkMcss7ZPqbLMTChXqr
         hFFq3eKj3clxQOCWwTLVtf1N0IWDzVjVSUwXlgOdqbmepm4I+2z/KvDe02gHeeV9OPJq
         IgBRhmEzbt6CZBCgWi18RJ3djq0BUDnIKbKstirp7e1vkqn93QzkH/YtZm8zP95r5Bpo
         25Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b7WSt83E4qRAINy4by4/dqIvH+W+atdW3e9597yM2Ik=;
        b=mYx6+ZNykWIJUishQRKKUt6H7ilvPr8SSoL9bEMzumiCjKqZ8IFexoSRUhuAV4xDXu
         xxBBh63rTgCSXcvtF8xF5GTCvDbzCkAcEpiu6g4BHSlMcwdF6L9C43PW17yH7MB9Qkra
         KJLXq6msDn0uEU9WZkyizEXBZ94R+CxC682q53iPmWyWCBIOl6TpVOWb2whdbQDyrx1C
         JzzkZlpAXPGSSZzEBeyI+vw/iKvKw0NFgPZ3y+xbSrRH7fyq4T3btTcbcnPJfdDfz2P7
         e+wfRvpop9B/f8zP0suj3LPJbXb4QMeZLhjS242DGIdMEk8C7Vs2V5tPakSG/0J2PaW7
         vkoA==
X-Gm-Message-State: APjAAAVAfQ5L7BG3NYW/hhlHs3pJEBta4EBZyUQGj2pMQKNQEQKomp1S
        Km3hb5IcQXxaoOMFp9IPpMLASqH1Cnvfog==
X-Google-Smtp-Source: APXvYqynNyVxIDwqv12Jvuw26Myvccs7YL9As3IAx2m5HDvJ6dPXYiptA7fof0kjd/T+0NzFYgg0ug==
X-Received: by 2002:adf:de90:: with SMTP id w16mr69091406wrl.217.1561229034763;
        Sat, 22 Jun 2019 11:43:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s3sm10482306wmh.27.2019.06.22.11.43.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 11:43:54 -0700 (PDT)
Message-ID: <5d0e76ea.1c69fb81.2bf47.aab0@mx.google.com>
Date:   Sat, 22 Jun 2019 11:43:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.129
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 130 boots: 0 failed,
 122 passed with 7 offline, 1 untried/unknown (v4.14.129)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 130 boots: 0 failed, 122 passed with 7 offline=
, 1 untried/unknown (v4.14.129)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.129/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.129/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.129
Git Commit: a5758c5311775625be7f6dd54757ed356dbf2977
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 24 SoC families, 15 builds out of 201

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

---
For more info write to <info@kernelci.org>
