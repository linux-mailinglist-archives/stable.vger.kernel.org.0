Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75E762B45
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 23:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732708AbfGHV7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 17:59:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33560 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732609AbfGHV7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 17:59:04 -0400
Received: by mail-wm1-f67.google.com with SMTP id h19so960276wme.0
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 14:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=npjs8zmHMIAK9yjt/PnyN9/5dfJ0FZUNFqmNA4IRhfM=;
        b=yDeIwJ4F35BBs9dFqKiYM05CN4uzwKRFGKe5prwT+ggYVm9W1tq9nuJa8MfSJc5ZPe
         RcB98Yub2tLpF+weu39qVG+GmIHHXxjZCfLVtNmsmS8V8a/u2uJSqWLNDizBZSJsFqtg
         weqlhjrh5+fwI6YwGUpnBPpEjp/U+pYUNlFjMzjKOH6NJHL+1YU6/7e85LMqm6/Th99K
         ePqLLocMr4uiCQTKhSCLJBRk7sg0XUtJRCXNNt70s4rgZAxOJG9Xb625V7fRJEav05BE
         Y7SgC8ngGzADwE2vsvmMMkWL+7wpWtypLqMhbI03FSaf94mkNqspaCn13raXMLgWAhUw
         vWAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=npjs8zmHMIAK9yjt/PnyN9/5dfJ0FZUNFqmNA4IRhfM=;
        b=tOB4jB+G9bI8cd0SPoTywoktOXwrNeOjEjIU5XOMYDB5aH9psXaK07AgTnU8eifddH
         0usZ6DKWgYbulakNW5WQYz41qK1CJU+dGLKbnQ+cJCQfsJge3G3IBkRrJxzldiE13s8N
         bcPhYtkGXzJ4MWTJBpUn/L5YGrfTZ9SL5gYrT0KiMkpZl2IAU2Ts4g6pTF7ZpUZbHd7s
         kHF2dNpYPm1a95eibPPm1chlfar0cxPx7xAhGkSH7Yk8LWEG2EyfWK0rykMm1T7IIMfI
         n8VaRk1pnw2PHYBPRvH42A4qvF2PA5N8Zn1NAviZ94G5wRXXpePe5lXP4QnYo4z6XpLm
         PsrA==
X-Gm-Message-State: APjAAAVPBWQWLrxiBofxGTKquVvAOJ5XdMkKd9JA4SoUdpB+rzTyoPCz
        Vp+Dw7XXH4lahIQ8QW5d3A/ysQ0+JgRz4A==
X-Google-Smtp-Source: APXvYqzkhFAc1D654DobHQgZDpfIAXy2hQG6hy+i0W7G3ZSRQk+tMIQfBtzRbH4l7d1a0qyw9vr8cQ==
X-Received: by 2002:a1c:e409:: with SMTP id b9mr17507853wmh.110.1562623143550;
        Mon, 08 Jul 2019 14:59:03 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n1sm14021389wrx.39.2019.07.08.14.59.02
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 14:59:03 -0700 (PDT)
Message-ID: <5d23bca7.1c69fb81.3921f.cbb4@mx.google.com>
Date:   Mon, 08 Jul 2019 14:59:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.184-74-g1ef1d6e05dcd
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y boot: 86 boots: 4 failed,
 82 passed (v4.4.184-74-g1ef1d6e05dcd)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 86 boots: 4 failed, 82 passed (v4.4.184-74-g1ef=
1d6e05dcd)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.184-74-g1ef1d6e05dcd/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.184-74-g1ef1d6e05dcd/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.184-74-g1ef1d6e05dcd
Git Commit: 1ef1d6e05dcd8a34ef188796843b380d0d4e4408
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 19 SoC families, 14 builds out of 190

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

---
For more info write to <info@kernelci.org>
