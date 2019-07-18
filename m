Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3C36CC8A
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 12:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfGRKIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 06:08:31 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41605 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfGRKIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 06:08:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so24812526wrm.8
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 03:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kmAC/ycpLEX93J0iUKUXohf/6B29UlbnPV2mXunqLkw=;
        b=CpGHHAWDz7gwoBJ6yzafmomYRnc4GWzFeOwgkc+bISGc9X7MjehC4Jcz8rYr9ZMvD3
         ci57KdjdfYyHAb1aFM1OEf2O8icofB/5f8V04qS3H3tzH96ugZTltoLSjCPOja6a1Hp5
         PrK4BRoj1tFDbojaN5B1pa3LvdIoCCweAU0s0r7GibuwjaGxiFrgTU+q54gXPDcsI9Iz
         S21TaoswBYo/F/4WgFwaz23w2qpIn61cCNQ223dTazUqSafNueYT5/H/xx6MckQjD1We
         sj3GFiaFNnWnWUuRFSIANiiUlNHZpd0/waeLdwOVmi+kBOCE5O1GIT4/Ma0Yc2UAsEF4
         eJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kmAC/ycpLEX93J0iUKUXohf/6B29UlbnPV2mXunqLkw=;
        b=l9n2eFNo+LUTWjB1Quq+PUeXTUMTzmwfPOtm/p8N0v+3AzYpDwZUMnD9i/X9kUX7gS
         qykYIqgchw/urSR1VQNAUAm86F5EhK3JlRPwe/N8SU7rAJzcCf9ALJi5VnKwz17/BW4h
         pWjdm3w2/XsuO1rvh/JitsxXpU+nG5lNhTsw2Q2zndkdgVY1bDEPtxi5wt+upIw2vKML
         jMS268L+9x7OXkyyF914+xC/wXj3VIWYDdGcmwMHyZOppSMM8Pu+VaiySXOuWuTi1ApM
         koqe9WeAGaCKud6SQvS+wLd73jUmrlHZc1sHiAGkg3QkVSQJA/KTZmgA4dbJdWxrtOlh
         KyPA==
X-Gm-Message-State: APjAAAVQ0ZDE5q17V+8C95gEwksKvK6UK341zcco9241IWNnAUFSuyUD
        3hYLJIE7JcKrFUUdDPp4ddtJiJxmi8Q=
X-Google-Smtp-Source: APXvYqyuB5JKILHaVKrdzWiVo1dF6rv/USMmpGHa9kUvgKRUV+9/uzhRHt09USNWshaVej0PjVJNiQ==
X-Received: by 2002:a05:6000:9:: with SMTP id h9mr50309697wrx.271.1563444508729;
        Thu, 18 Jul 2019 03:08:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l9sm23464383wmh.36.2019.07.18.03.08.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 03:08:27 -0700 (PDT)
Message-ID: <5d30451b.1c69fb81.cc30a.2ba7@mx.google.com>
Date:   Thu, 18 Jul 2019 03:08:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.185-55-g0bfad9234a3a
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 105 boots: 0 failed,
 103 passed with 1 offline, 1 untried/unknown (v4.9.185-55-g0bfad9234a3a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 105 boots: 0 failed, 103 passed with 1 offline,=
 1 untried/unknown (v4.9.185-55-g0bfad9234a3a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.185-55-g0bfad9234a3a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.185-55-g0bfad9234a3a/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.185-55-g0bfad9234a3a
Git Commit: 0bfad9234a3a02e29c02d95e2c48f4f3aa86df8f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 23 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-drue: new failure (last pass: v4.9.185-55-gcc08f2abafc7)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
