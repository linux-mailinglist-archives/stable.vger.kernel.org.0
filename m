Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51AE63173C
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 00:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfEaWcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 18:32:19 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:38475 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfEaWcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 18:32:19 -0400
Received: by mail-wm1-f52.google.com with SMTP id t5so6802694wmh.3
        for <stable@vger.kernel.org>; Fri, 31 May 2019 15:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8J88Cz5tv57Hd8JUDKIw5mSqayHp/I6H7+n+yZhCVzo=;
        b=HPE96weze6sRCMYWPVzkUMFc2YMMQZhMmxU/N9GWU3WinQ3zaBNbkrPAF3XC4adbGp
         21LemduP5rpivwU0nl8ET7EA/LErXSyD0xIcAqkm1N90bIHNoJN4xUdr9+466rcwpPJW
         cwoj0VRNsbeTq9l4Dygd/t5oXLHcvQYE0rCxo05mzt0qFyZQzEWfJuJFkVrBMNPyiKEn
         +hk0NbB6Ru2KP1/iZM02eKjGegKEdv1yWu6nYbLqpH2koD2JDf54oELbil+19zHX8CXR
         zM0rsYsMhDDdYwbrK/C53hTFOb0pd8gvq5JLHYiA3UpJMbphTZ3bch38uLG1bgcjhBk4
         pUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8J88Cz5tv57Hd8JUDKIw5mSqayHp/I6H7+n+yZhCVzo=;
        b=Yvgm2xmJRfv2NRkq6/QMoLG7nbtdfuwcs7d7ddfRndh7/h+0CLxYmwiohYzbLygEmv
         yjEh4U+y077ex3GP6Y202F+t9kVLIQUuqnM9YVc9fH5BGoVSvizEIH+xgQyg7PBD5kXW
         vpC2mUCksgiXgRzUrBXFQiI20agfKBZePv6jUTIVk0ZBAhV0XrM8cR/7FR4m434+PLvA
         uYGUeZeiMlatDyru96idztGQHL10fafm+/OYGBv8RX3GuGihihc6Im5etn3lX7V7VmKg
         wMCxNEb00cwy/JovhI7HUKzG+xktOom9qWI0+BSX+mAVDXwCJ9K5EgxcL+hzTRXJANGp
         xUCw==
X-Gm-Message-State: APjAAAXPzBPCL956mJKLO6Jk3i7X+viw4vE2pH7lXCh57WDwqULAWNHt
        iWAhxifIhkx3I7q84gnePRGkebn6gBQXHg==
X-Google-Smtp-Source: APXvYqw8/eX5vEp1dqrNFUl/tak+PRN5nuk7du3/Zy28nVjuSKHs84j75/1d49wVdBxc4539qGkyAA==
X-Received: by 2002:a1c:ca06:: with SMTP id a6mr7053031wmg.48.1559341937381;
        Fri, 31 May 2019 15:32:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f197sm7765512wme.39.2019.05.31.15.32.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 15:32:16 -0700 (PDT)
Message-ID: <5cf1ab70.1c69fb81.30960.9446@mx.google.com>
Date:   Fri, 31 May 2019 15:32:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.180
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y boot: 106 boots: 0 failed, 106 passed (v4.9.180)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 106 boots: 0 failed, 106 passed (v4.9.180)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.180/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.180/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.180
Git Commit: b16a5334ed1211bf961c5883eb0f3ce35e90b4df
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 21 SoC families, 15 builds out of 197

---
For more info write to <info@kernelci.org>
