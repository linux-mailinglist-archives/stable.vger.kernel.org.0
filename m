Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 015276F406
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 17:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfGUPly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 11:41:54 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:39736 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfGUPlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Jul 2019 11:41:53 -0400
Received: by mail-wr1-f43.google.com with SMTP id x4so36797166wrt.6
        for <stable@vger.kernel.org>; Sun, 21 Jul 2019 08:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+gOzytQEEsFU/QJYdCShbx0PhABTIktumiqpeE2FLkU=;
        b=MrO8fdF5j4ifFcCLyGaxYlejZx2fzEQByrDy9kAoWMkQ6W1/KIaIN5o40/OA+cWUHf
         RXg/S6KnAwQoh9gA6xoMMt0/Y1XpbloxLMkiw3AuQqkD9ewpPFMiRqk1zrmMzKdwh/dR
         ksL37yB2O71J+61kXtFz25sm1hYk0c+AA/Pc+AUCW8gU5BB9iPH9PkrsP/kc7emPdeFJ
         /P7ciDTTZvKrFS6gTEx2V9PfxoNIRw+UCm/6S1ig/zyxstxorCGK1p0ipaosmoSJfErt
         gteoCnO5/qqaYMF2Uw1VH+NKCXr/fY0QLF70qlhJSVXQ6/TBbNNDVW+69U/Zy0UBwwE7
         aMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+gOzytQEEsFU/QJYdCShbx0PhABTIktumiqpeE2FLkU=;
        b=e1r83ggGKkVn+uPcB8ZiDYw2G1W0dxVG3/fIkHbR5uP8jyP9p8FNbta71cS/iaFGe0
         pLpjH28bXG/THivhlyqd8Oq4A6oiVDPtytUHZPE9ZEoWhGLfUs7bMGUbFx+0PD94l2Kl
         nrAoElLBBPLinnde4WK3JFLeI+fpB15uvWxlhyCuylgETYfaCXhfc1jbnpG9Vo4rng9C
         6Aaw4prqz7M1oMeLKeePMPtRD26n5SeChSCwIGSv/paLMjo/J2AXFCZESOPcmG8gBZ5S
         qeJuLH80kG5zP0zDw9+pD8B/CgYyM0XjzpGzDXB2wlI78UIixiyHgroIOVNTdeButA7C
         k+eA==
X-Gm-Message-State: APjAAAW4fk0COYT5o8XOdT3msv5M3m3nnwWmDcTWKJQ7ZfPEWLu8rto1
        LhLjZgxvC8qWRVhr9Ml/6dTITvaV
X-Google-Smtp-Source: APXvYqysPK1tiW9gM2TBgHtJ31o3HpOddwSVC5eMlUvma3DE7K05y7RSwhw5CT2+xCR66BVSDI6Hmg==
X-Received: by 2002:a05:6000:112:: with SMTP id o18mr43986671wrx.153.1563723711732;
        Sun, 21 Jul 2019 08:41:51 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e7sm34778299wmd.0.2019.07.21.08.41.50
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 08:41:50 -0700 (PDT)
Message-ID: <5d3487be.1c69fb81.17cb6.37fe@mx.google.com>
Date:   Sun, 21 Jul 2019 08:41:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.186
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 92 boots: 0 failed,
 91 passed with 1 offline (v4.9.186)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 92 boots: 0 failed, 91 passed with 1 offline (v=
4.9.186)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.186/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.186/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.186
Git Commit: 35c308d7828de5c5784bb75efcf848996b3a82d1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 48 unique boards, 21 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
