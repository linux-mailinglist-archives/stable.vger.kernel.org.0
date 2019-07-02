Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5505D11B
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 15:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfGBN7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 09:59:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46572 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfGBN7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 09:59:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so17929435wrw.13
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 06:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HBd99GYbwRQMd1kR7ghYA5X8SNd4z0fQ7hMPObU+8aM=;
        b=CDyqJAnZYlYcyOMDqgsBDVX3KuGfflGpPFrXA8AyLwJ3oYkYFYP93IJp++e3g0Zejw
         pLRpHMje7TG3c7iqHF3sq2oo/qELNKabVYBS8vHHgKhcNQlUiAMTdMQsPi+O7UOacBLL
         UrregFPD0gHjmfGTgAwHOSbSJ7+l5GlusN42Mim7IYhkKGVKtsz8lJasR5FWMSQo2QJE
         7qWz4dPE5iYo92IqYkqau9ABHzfSZM44PjMJ14KZl0ZBWSql/2M0nntzf+/+C93jOukf
         nSA6guqQyXVwyvYRWnTj9Kghu0O1CdfhU5/t1Pq4wlFKJ3Coc6I22nhC5PpvXIvuG/OI
         Gu3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HBd99GYbwRQMd1kR7ghYA5X8SNd4z0fQ7hMPObU+8aM=;
        b=ChmIZ9mLonDu29TIsdYSKj6WL4Zzdwj04pwUyWICvCnA2d7XxbvWhSLYA+B2U55VrG
         1oxSpDMwj/WaZZjGp3b1aTrwciY9EoAmFGCLZh3d+THwQC37WbUEuTg40ZMMaorNq4o8
         OhV/awz9QDcpWnk/VR7Mh4qFUB7oTpjHqQYQkEj9b2pZtu556aZD+tN2MLBfsPmCh6kF
         dWrghLxkDZuC6Smp99pSAFcpjkiLG+7n3EbPn0dBNZKIR6mu1GwFEdqBnkxJO9jqK6jh
         OeChORoLWDo8n8xCyHAHUQM66b0F9YxelQzVt1uuYsmrAxfaVlPmg01taVtaLlTrO3rt
         oPvA==
X-Gm-Message-State: APjAAAWRWObDbTrbVtSejiATcGGoRnWBn5kRiHWor5KoMnraoVgCPGvy
        jv9FwXFs0PB9U5V7iAz/3McJ1vBh+tLPNg==
X-Google-Smtp-Source: APXvYqyqolUKYuGKUtt9/XIRY9J7BveLHEspCu+O5KOIZ0Vxt7U8a1IZbn/C2iPejEvXkp8xcoOlAQ==
X-Received: by 2002:adf:dd8c:: with SMTP id x12mr24027860wrl.212.1562075984968;
        Tue, 02 Jul 2019 06:59:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o6sm31958825wra.27.2019.07.02.06.59.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 06:59:44 -0700 (PDT)
Message-ID: <5d1b6350.1c69fb81.a3beb.fc66@mx.google.com>
Date:   Tue, 02 Jul 2019 06:59:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.131-44-g3734933c2330
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 126 boots: 4 failed,
 121 passed with 1 offline (v4.14.131-44-g3734933c2330)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 126 boots: 4 failed, 121 passed with 1 offline=
 (v4.14.131-44-g3734933c2330)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.131-44-g3734933c2330/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.131-44-g3734933c2330/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.131-44-g3734933c2330
Git Commit: 3734933c2330c5fe94ed2724033965b2eb545028
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 25 SoC families, 15 builds out of 201

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            rk3399-firefly: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
