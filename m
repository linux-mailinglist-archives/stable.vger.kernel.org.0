Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA9367EFE
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 14:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfGNMjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 08:39:52 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38264 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbfGNMjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jul 2019 08:39:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so12603259wmj.3
        for <stable@vger.kernel.org>; Sun, 14 Jul 2019 05:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F12ayaXtyNxYlNGYflDiUIBssC2bAF3a7K1iKfdmz2c=;
        b=Nu2ayg+qNjjoK+o40bWI2AXVzySJApLNqWssh7AJDQudHHcnBVleGo3l+Z7T8Ymd6E
         fqyto5tIBPBPXaB9oOPKjE0dL8dZMrNAqO5fhp1IZOBaWEyJFLD8kj0x/19ZdVAlGqyH
         VLvt8+KtFwcyKNs6jBqYyGWBBbDwxs7CLGiYaDUZZn2LvDS5vKnSmMswUebBHfurrc9u
         At4S3V9N0EKhg/NAyZAe83XBDoezDwEe8Kf7ooqpKBH6ePML2zjwLBZ1TTcd9N6dqytN
         RHds1iDbdOqa00I3Cbn7/CK7hZQ12WncXZDlxqYZPKUBqdJKxbeJurJGKtisNhz7Ao42
         wqww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F12ayaXtyNxYlNGYflDiUIBssC2bAF3a7K1iKfdmz2c=;
        b=r6wy2MX+UZ4F6u1DcaCDY/3ICXIsF5Wf3u6gG9yV2TufBbvrzGGp29ewVg44RR7bBj
         MyxoLHWuYc1c5Mz3cQkGb1yFgvC1+ojD6KlS5MXA1xJH8g9PM4V2TEuhr/nYBrHFyozd
         46HJrP1Dx/2ockfAN9179VnelWEiAow/LDqpw7E382iMJPskqjRZYevwlq/2LdJAWjLL
         1w5pPI/+C3ZSwyHI94qu8l4YKDsHrnxmE+xh/tAWekxckYZkd7ymkhvmfoXd/R6pLOK+
         ZOMI5Rr9IXl23+v/YFTUYeBPLX4Oowd+MM1KrNER0iZDUlKxIf+N4rNdgoNBs7OoxkpP
         Izew==
X-Gm-Message-State: APjAAAXne4yusW6BQOX7/02Wl9NcBcvK7bzPDDdCurTnz3GqY/e8xHj4
        EAyBy34i2jz0dH1QOMYQ0+TMfQOc
X-Google-Smtp-Source: APXvYqwM3kM3Wq5jTwvwUl7OIKisqeLRKiCKKnNNYMCE4u69BcLdSDFPZRiIWUo4STxjEH+sbVuY8g==
X-Received: by 2002:a1c:c1c1:: with SMTP id r184mr19255836wmf.9.1563107990399;
        Sun, 14 Jul 2019 05:39:50 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e19sm18550107wra.71.2019.07.14.05.39.49
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jul 2019 05:39:50 -0700 (PDT)
Message-ID: <5d2b2296.1c69fb81.14755.b596@mx.google.com>
Date:   Sun, 14 Jul 2019 05:39:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.59
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y boot: 64 boots: 1 failed, 63 passed (v4.19.59)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 64 boots: 1 failed, 63 passed (v4.19.59)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.59/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.59/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.59
Git Commit: 3bd837bfe431839a378e9d421af05b2e22a6d329
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 17 SoC families, 12 builds out of 206

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

---
For more info write to <info@kernelci.org>
