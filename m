Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7751E60C75
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 22:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbfGEUiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 16:38:00 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:51918 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfGEUiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 16:38:00 -0400
Received: by mail-wm1-f48.google.com with SMTP id 207so10320429wma.1
        for <stable@vger.kernel.org>; Fri, 05 Jul 2019 13:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o5ZSJcqHW/RYg42UtIxKFdF84f5SenvWjhC8Bp6cgkM=;
        b=2HeNeQk9M0NyXP0qE/9aKHZxW2jv8ncRhyeDtEDSh8Y8LwIvAkRLo30mVNa6c37bX6
         9CBDXmhKTOlOiqJhMkvnKbjfTDJVxTvWpV4YmhD+rpGAe0txgVHfyqTjlXU1T6KH8EVD
         s88ZtNZVVAqN6F1nlpSaRIKvWe6fan7yjPsBwU3210LNteJrNSZoIbgksGnf20gp12Mg
         pQQP/TPLANHRgZdxh6GlSAdgyiWCk/5SJgeaYQbDgwlEXR8nf+lsOSxjqKay4TATNQQS
         rgx/2LizxwxENV3NYiNtHl2pkDCuhOXnNrERZEGPZbc41UYK/DhRzS5mh92AZeKm6ym0
         FUaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o5ZSJcqHW/RYg42UtIxKFdF84f5SenvWjhC8Bp6cgkM=;
        b=lyEPMHNwTdJfNahuBBsivHLrYwnlUYtaymO0bvMN56FLKEIHMBHi/UF2Vl3hIoYJqy
         4YTrRw/ysgeBoQF8l3SnSgMbGdZtbIT84kt4aST2P86zlp4u9gL5HPqZLj9soUUd3H/O
         VjFyy0BI4ja+ff5ZStEKYADw3R70EClEkxWOYcKGOq88a3oEuyWGYylAj8AnxvUUSObn
         oDkzsQLlwdDYFnenYgB/cC3NGg6dNS2Bdl/mYbySybVsvDqXj/NByaaZyK8KEHv89eqS
         7Imt+PQF7TTjfMoh9yAC97vEVg7VsowWTVgRpBZI2MuyLz0PzNAzelPzNQp3PWSLITya
         fjwA==
X-Gm-Message-State: APjAAAWvACdhRQoFavS90QtFo080tfQ4G8H7UwIVDisSquu33HpPRU4J
        sZfg3mdExuRmGFpAulpGmjyXcxhspgjxyw==
X-Google-Smtp-Source: APXvYqzKK6ARUgskbASaDLFu3KcxeZCSRnG+ua0Nk1BOhMnNYhttpFO6AuQxp2oGItDMbnqK+DLPcA==
X-Received: by 2002:a1c:9c8a:: with SMTP id f132mr4596383wme.29.1562359078017;
        Fri, 05 Jul 2019 13:37:58 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f204sm14235120wme.18.2019.07.05.13.37.56
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 13:37:57 -0700 (PDT)
Message-ID: <5d1fb525.1c69fb81.9d876.1e32@mx.google.com>
Date:   Fri, 05 Jul 2019 13:37:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.57-63-g66c8f2a0ee1c
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 132 boots: 3 failed,
 129 passed (v4.19.57-63-g66c8f2a0ee1c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 132 boots: 3 failed, 129 passed (v4.19.57-63-g=
66c8f2a0ee1c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.57-63-g66c8f2a0ee1c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.57-63-g66c8f2a0ee1c/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.57-63-g66c8f2a0ee1c
Git Commit: 66c8f2a0ee1c7d20d9a3328dcebc46aa3a31151d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 27 SoC families, 17 builds out of 206

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
