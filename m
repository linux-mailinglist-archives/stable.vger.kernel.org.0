Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106986103D
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 13:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfGFLEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jul 2019 07:04:01 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:46597 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfGFLEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jul 2019 07:04:01 -0400
Received: by mail-wr1-f53.google.com with SMTP id z1so7623413wru.13
        for <stable@vger.kernel.org>; Sat, 06 Jul 2019 04:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zZ1nD3EQzfVhq6MPEoDfd3+0b68mSQdK0HwtydATwng=;
        b=h6tVNu6Xx3NHMRJdWNHSkFSVYA4v0POHKIY4cNcmDWwcbAGZu4zHeDoU92uj+j8mxY
         dmuisDEnGCpsHro9SrsUmjHywjdzt5d3fffCcKeDJXgwtolnYJrNYfQ0CyuX3A0g5smn
         H1rqOxYpHuY971LLWoycUpKF2Be1lZ2MH6JGu4plmMOgZWerDLqBFhC7oGlV4bcqOQAa
         suPlDnQpDx99bIZQaWmkhOtlEffoupNpsGZUJKfpcVXbyhk4jXX0HXVn1gVZE/1L9WPv
         0U7pgX7uwoQk8YVDm89r75DudiPoYjgpIi4pEI6LJ3FVV3XBdUDcPmht30ujuSeIz4LP
         tUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zZ1nD3EQzfVhq6MPEoDfd3+0b68mSQdK0HwtydATwng=;
        b=iYBPTLXZkVIwjg9H3fqryYy2mey/eonPZTa0bnvCPb3Yk6h6J1P4fxDaw0M8y+Rbf8
         L+Gb5QCuRK4OboJufGP1NVQCFOXBmgwAxBygEbczYk2BxRe/NYolGOTuLw6jv87eUNq2
         oE9DQs4M+tsx7Ilxyc0PD57CCfLCYMcUdL8UTIkR3+ZLcq5xUW0OE414h0iVQ/ifLkvO
         TG2PtyOZaV7kBjNkGLra8AqrDyZIkzS8lNNILCYm8JGbaRgiBNHTdLaBSW7+vFvV5pJy
         YxvDehaYIaFpOPfS+iZgLu3llEDE/ItGxs/ssrF8voNbdVzFxQRcWuIKG/M3tMD+MSN7
         uLig==
X-Gm-Message-State: APjAAAVJLBIPxdHXZdzhbXp196hP/SxYEHb93V2az1EowMDjsuO3/2LZ
        an0A7edF+7Fbc6i7H7f0iBrWsiO5Igyjog==
X-Google-Smtp-Source: APXvYqyhKMda9132nrxyf/1OXwnd0Rz1d/aOSnOaLP0gxoPxdstQKEaVu2DtGvr83U8jFkfHwkZM0w==
X-Received: by 2002:adf:f902:: with SMTP id b2mr8924850wrr.199.1562411039207;
        Sat, 06 Jul 2019 04:03:59 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j26sm2489667wrb.88.2019.07.06.04.03.58
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 04:03:58 -0700 (PDT)
Message-ID: <5d20801e.1c69fb81.5bff.c8b3@mx.google.com>
Date:   Sat, 06 Jul 2019 04:03:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.57-86-g8d95b9513ddb
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 131 boots: 3 failed,
 128 passed (v4.19.57-86-g8d95b9513ddb)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 131 boots: 3 failed, 128 passed (v4.19.57-86-g=
8d95b9513ddb)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.57-86-g8d95b9513ddb/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.57-86-g8d95b9513ddb/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.57-86-g8d95b9513ddb
Git Commit: 8d95b9513ddb95fb0987162263d3da9031d83d40
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
