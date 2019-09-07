Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B87AC570
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 11:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfIGJCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 05:02:46 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:35493 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfIGJCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Sep 2019 05:02:46 -0400
Received: by mail-wm1-f42.google.com with SMTP id n10so9507191wmj.0
        for <stable@vger.kernel.org>; Sat, 07 Sep 2019 02:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3N5xftvJAu74HdinBCqY/0zVGSbBV/X8gYBXIEw29bY=;
        b=w/ouWpBqcokEi1ZvTTv8loc8nNPWpkyD2V+d1l+z3jJk9gAZf/2QRFHV4sC/eSqCV8
         k4GnRDucWq3xEf8njl32UM5ZN3o9JGAc9PbHx+tgr/NeWX55QoHw3gP+4i9PrAuTmhjS
         vUG5Ogd6t6CRTYLLQRC2QPAOLAcFrenZqbM73BxB/FRMnPgx22ztPA0O9NlbRLHTBp5h
         IJSYqc6FOa+IMsG8nJnAtqioFtZwS7QHo7xhLSDUMpb4irGjyU3nderVI70UEfndbP4y
         wqC0Z7pMSMYL8ZYGq33c8P3VDnJir7MbXe9ee6Rf9bM+gq9KChcJq7JbJTwNbrlmTfQo
         uwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3N5xftvJAu74HdinBCqY/0zVGSbBV/X8gYBXIEw29bY=;
        b=iPbSa+ozJCDRGqXGB8cOdKnbym/8ja77ztWRx4mig//aoEAYQM1YbC59VNfLQYjnTD
         6bRIelNvZm535lWzPTwmmCzFZbbMyMz8jLTHar7wxajwzGqjDw4oJf1A7x2rb6Xoco1+
         c1HGs7SZjyAzscK9NXM2p7qMl+AdEM7hFn7noeREzf95PNR7VMIxTebiesHJf2oWKkSQ
         lUznX5qh6bYBYMcnNxgCy8Jjoc+q8Mu3EFWSNKps+rIhQgGyFQYO35hFiv6y9esnTrOg
         Gozp5qXoy9pfKIszVqxzGkKIswfTSwRJJ4/PPVW6YsHZe9ZS3fzTvCGVjqyyA7n+88oO
         wl2g==
X-Gm-Message-State: APjAAAVE8ujsp4ZudSZbEDl9SQtFntALCLEebK9+lSUqvzw0Dy+rjY2Q
        lFKjDNBGjyHsf4gGb+AnT83cChXUhyqxYA==
X-Google-Smtp-Source: APXvYqw5HfSwh+XLF0e4lmySeTF3ISJ3QdspVW9EK6HgXHxIvwfR/waSMe+t48fN6cPtBppJmIFZ6w==
X-Received: by 2002:a1c:6c0c:: with SMTP id h12mr10484201wmc.162.1567846964216;
        Sat, 07 Sep 2019 02:02:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 189sm11508024wma.6.2019.09.07.02.02.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 02:02:43 -0700 (PDT)
Message-ID: <5d737233.1c69fb81.7fd2d.78d0@mx.google.com>
Date:   Sat, 07 Sep 2019 02:02:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.191
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 114 boots: 0 failed,
 106 passed with 8 offline (v4.9.191)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 114 boots: 0 failed, 106 passed with 8 offline =
(v4.9.191)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.191/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.191/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.191
Git Commit: bf489db05ebf7106dd77f79e6edabc45fc318416
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 56 unique boards, 22 SoC families, 14 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
