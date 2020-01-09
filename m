Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F19135EC6
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 17:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387560AbgAIQz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 11:55:57 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38596 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbgAIQz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 11:55:57 -0500
Received: by mail-wm1-f68.google.com with SMTP id u2so3631699wmc.3
        for <stable@vger.kernel.org>; Thu, 09 Jan 2020 08:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lmqBnBT1Hq742OLa0bwrwAUJdIw3fdw5RkMD+Xl3/Cs=;
        b=wGePHQv3vLwixrW1h+pgQpleQhhvOWAPZLeKlKqhI09BZ7MsEHAFCFku15RCJwjbpd
         k1bCYgWvZqujVcap9GalXIftDJeOm3AgbpbYOq+i3QOZoS3ywMskxx4LmPiyJ7wAz+LV
         4AnpDFq9SimVyn8MbiDHQB9CkRQ9XxbcJ31B+QHlCOPrMkmSkNMp6ktZGBnPuBRUQC+Y
         oDe5vz4GvDT83fTMmVjylA+ji6VIlO786LS1njh9ItAa71jSxGnGCHav90KAmgbVCpdV
         PZzWdfMA7yx6C/wQtyRHhI5kx0dYxDFbXSWpxQci/iL8I7tkifnZYyGnISxDNOytc/f9
         Heyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lmqBnBT1Hq742OLa0bwrwAUJdIw3fdw5RkMD+Xl3/Cs=;
        b=JSKhn2l/2QMEfPZJGGbIZUaNjjVsIIZAqdp8V3WclBhO/nwp3YfOoszzBPL65D6jaa
         A3FWtLk/wtl8IbwvMUHHIQQsXCG3iYT06g5oKpcpQWNW3+klXCZFonci1UG5d8CMvNDU
         DXbEXOHkkjP8g3Q07PNSxF5xB35XVvts5448bJeMEbgI1y2bIIZhBtYC352fJkcrwEpN
         bjqkb/zPCqy0+9N820Pi7ieDPTM7gDOwrLakq0ar4TXkk6n+V1i104B8Ei8caIUP+BR4
         HLcyjRfS314B31JhpZP4+stn26eTU3vT5P3yZyrx4pzNpIBbzv5OTiQNVomOPO8MU19V
         j4lA==
X-Gm-Message-State: APjAAAXhsdEb6De4XVsvz1OfBXb83OvnDnEnhEx4w+xeUFEnQbg2WUrJ
        +QZqKlvBA/yeIVewjYQZAVNMgfk+1if/1w==
X-Google-Smtp-Source: APXvYqy2GJ9VCJzOvh7ij42wUc09H4xkh5cCv9ZG5zyziFTLw8+AVSGyQxXqeDQxAbEAHWkKC0/OrA==
X-Received: by 2002:a1c:4144:: with SMTP id o65mr6118691wma.81.1578588955094;
        Thu, 09 Jan 2020 08:55:55 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id u7sm3434058wmj.3.2020.01.09.08.55.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 08:55:54 -0800 (PST)
Message-ID: <5e175b1a.1c69fb81.bdc04.1c1e@mx.google.com>
Date:   Thu, 09 Jan 2020 08:55:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.94
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 76 boots: 1 failed,
 74 passed with 1 untried/unknown (v4.19.94)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 76 boots: 1 failed, 74 passed with 1 untried/unkn=
own (v4.19.94)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.94/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.94/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.94
Git Commit: cb1f9a169a0e197f93816ace48a6520e8640809d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 48 unique boards, 17 SoC families, 16 builds out of 206

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

---
For more info write to <info@kernelci.org>
