Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8F0ED7D
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 02:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbfD3AI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 20:08:26 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:38478 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbfD3AI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 20:08:26 -0400
Received: by mail-wm1-f48.google.com with SMTP id w15so1567704wmc.3
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 17:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qHpG5TAyz9x9MXqvBBEPbF2jQp+CMM4ojbE7fEETSgg=;
        b=oUb/7OgI/qtlg/wBnczFY9WrdDR+IdXUww75U107PA5gHDVs1919Nxg1xjcoa/ciJt
         TB3xx7yay/lY3puqTjbEsGSNEvtHg226v9A7epMiQ0Xo0VAwoeLofgeZo/xGb+TbCLUd
         ivTJPMNS6NPOUSOUTUB8hbKFG5EsTi4nKXrJ5oQZbxwP6nEQFQIqsl0NmCZ634PYPYGf
         3CTgwx8Oa9VkxeG/pWfQP7G6VpXqlGQvzAp5U76VAVTUy29k5WPOaWb5iXDgcE7pBHQa
         mZD029MDLFpzv+U6B41dNgb37qTHDWftPwyyz54yFPt5zSsq/Q45jAoir5MzyzG4KUqQ
         dVgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qHpG5TAyz9x9MXqvBBEPbF2jQp+CMM4ojbE7fEETSgg=;
        b=Lu54ucQynIISwVqoUQI3Qt1RXrcBe/6OWxOeLWRLuJaUo7qpiGfNRyk9nf3yKjDelb
         OHk82e9LKBrIwGK+uf/0gZxK4YkffZu9W2JTVRoaHH4loZwkCxg1ilr1ZxrqiszdJZg8
         NoY8wQnsf6uGPzqnwdRVNl5wLWFDG7qDaNxBANEcGQnr/Qf6tHRGt379kkI+R+xk2S0E
         tzbmXkcvIENk77SjlyA2Zb6hixkROlat6J4pxIKu76NuabE3ioj+dY+oVHX4au0Qzkag
         /6ujo3kzoyKAN8qldCId7DnihE0hLTWLblt3XB+Nfq1TLscsGWse8hVrgEWDaxLCR0kV
         gAug==
X-Gm-Message-State: APjAAAVntXOhBbf/n7rVQ2VonaGwMTieUGdv+APlIiPnJWsBGZNsNj0B
        qeFsvZuMnhRnvut4+/0mJCbW0Hyqx45Hyg==
X-Google-Smtp-Source: APXvYqxY38SFx8+2hGMjAZ93+NEYPAiXfH1wvzZLezZSd+2zagQ8koyB4No7UR2dNds9d429eY7VBg==
X-Received: by 2002:a05:600c:204d:: with SMTP id p13mr1080421wmg.53.1556582903872;
        Mon, 29 Apr 2019 17:08:23 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t67sm1906072wmg.0.2019.04.29.17.08.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 17:08:23 -0700 (PDT)
Message-ID: <5cc791f7.1c69fb81.381b2.b792@mx.google.com>
Date:   Mon, 29 Apr 2019 17:08:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.171-30-g7fce9465d078
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 99 boots: 1 failed,
 95 passed with 3 offline (v4.9.171-30-g7fce9465d078)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 99 boots: 1 failed, 95 passed with 3 offline (v=
4.9.171-30-g7fce9465d078)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.171-30-g7fce9465d078/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.171-30-g7fce9465d078/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.171-30-g7fce9465d078
Git Commit: 7fce9465d078bdab5b38b22c235796c88e721930
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Boot Failure Detected:

x86_64:
    x86_64_defconfig:
        gcc-7:
            x86-x5-z8350: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-7
            stih410-b2120: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-7
            tegra20-iris-512: 1 offline lab

---
For more info write to <info@kernelci.org>
