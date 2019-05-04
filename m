Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522C1139C7
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 14:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfEDMct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 08:32:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37699 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfEDMct (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 08:32:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id a12so1031352wrn.4
        for <stable@vger.kernel.org>; Sat, 04 May 2019 05:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o3YyNy84+xiEXT0x51v7OXH4/kpRicV3LdrZa1r4hTQ=;
        b=bsGEHmXfcY5jfxLV8KmIkd+31bAqtq2sOgwYQkqQYOrOf+MxnAAOHyn5kkjzcjOt/U
         Q9aLuzik6Hvy3v+pJ7NoU8i8eKv4FHuP6hC/+R9Ycjx2vMehFGrGN6NTKgdYZ2EG3IDz
         Q1uK8zhw5HIzHPg0eWXZ2wNq/csxCX94kojOIMQ5SyV+JcYjBrHVizswPHkg9Wyq6MUI
         w/4E2s9A5GVaQGVH02A1duUK1QFGNXduTNhCxpqXEMbwa5ZgnfIS4Zk/G998BOYTw1dt
         Ejb/gmMsT3P8OgyvoPQYidGIC3NLMywWyQaqqsbIVLYXnO6yshVYQQVDdCOTF+RY2aHI
         L95Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o3YyNy84+xiEXT0x51v7OXH4/kpRicV3LdrZa1r4hTQ=;
        b=bDZbQN7gmnkVw0ey6muguYCCB7acYFviR+6jniEMHCSuMq+zpcEahQdFeOVUWFTLvK
         13pZRPglKFLcNyvAb+15LTeGNZ9ywBwBn4qFSX8PwWZ9NUZ6lHKrNHgMP3YzDM5fD5qc
         4xTChxN+60Wo5jGY9G76R3mMKZDx9yLvZgINDaazElPZhPbz7cxv6OwQdzxXvJhc6FQf
         PEt/lpycDa5a55pc93bxweYJIT6iCA3iIlVuMvb3WdXclBH17G6dp8X/xCc5zMPdyFgT
         +1cVKNm/9wvxccBzKWWhMO23OtNvJspKk+4kUuy9qE5fbvEkCRDkUVrQiSJ7sQK3QEPP
         8bqw==
X-Gm-Message-State: APjAAAUuQr1CdQ9qz+xhKxdTDZ5Q5ib0fueBhIJ11GNYdIJb6XaPnK7+
        /grirOAcfGR0XVWNeHmBq4yoRYQ1asTAAg==
X-Google-Smtp-Source: APXvYqzIdDytm5uB49njio9zHw7mhYUYq/PXkuLoJaev+UdC9/Tx9alKmiFm+hA2cE7Mdk2aS0SLSg==
X-Received: by 2002:adf:f68c:: with SMTP id v12mr11245225wrp.40.1556973167990;
        Sat, 04 May 2019 05:32:47 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o4sm8016370wmo.20.2019.05.04.05.32.47
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 05:32:47 -0700 (PDT)
Message-ID: <5ccd866f.1c69fb81.50301.d804@mx.google.com>
Date:   Sat, 04 May 2019 05:32:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.116
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 57 boots: 0 failed,
 56 passed with 1 untried/unknown (v4.14.116)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 57 boots: 0 failed, 56 passed with 1 untried/unkn=
own (v4.14.116)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.116/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.116/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.116
Git Commit: 6d1510d86ef67e5fadb8038671e2ec43416daf7f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 15 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
