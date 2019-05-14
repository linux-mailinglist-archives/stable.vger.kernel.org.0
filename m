Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790EB1E576
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 01:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfENXJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 19:09:31 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:43375 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfENXJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 19:09:31 -0400
Received: by mail-wr1-f52.google.com with SMTP id r4so518223wro.10
        for <stable@vger.kernel.org>; Tue, 14 May 2019 16:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bU6mVkg3LR0ldAUPycrSN3WjDfFn5139Qv0HUFS+t6U=;
        b=O/lTCDtUdPyC2ID05Mpm3bCbafg9dX9xgK/ljXNUw35jBovp8LttItcDWk5QiQ/UHM
         dh2xdlL0L0YQtwZD+ULtiX2T8n78Mk+lg9YW5hxrrkFbUcLjWGYFoxzY/Mu5HeGwy4LP
         ze2bPxLyC8TpBCSzg6eixT4pSMNL1ocuNe8ytABPXIVlVoLVtXV9kT+/fTEQM2bH64Tt
         TU+sD3+52qN3FgtNHbRuTFoWsc4QgpdLV/MNZNjFsftguqCXMFaqCu1qs8fCnNV6/gM7
         JfJEPo1V25HpsI2jEUILqUbjSQSet0v7DEsnY0kPanBj6E7YJ7mplQlrepOCvYZ+uNX4
         TM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bU6mVkg3LR0ldAUPycrSN3WjDfFn5139Qv0HUFS+t6U=;
        b=Jj5Chp+S1rkUkLdPUCuvfpQ4I/GTx8nlMV4GUap6zyq87HAkuzuzV1X4ADpGvrKm3k
         jcgwoLXbVtUlR8/DAI2mzHZO/VkPzep1TdTscLajWsyYw2HX6hmmRJhZDxBxktz3tB9E
         W3q3gksJlmdtLE0BgkH1IJj47w6GH/NsAWB5nJkyMkRbL19nHsJ9DZjCdzqWDjMkk5I+
         reyJUM/xVISQoWRb48VZDv4KlEYUpqyDKx30YaKTv8aG4dclfm1ubsc/EorCq89ztL+u
         /tnTCE8E0ZOy2NYO9wgO8ujkY6BHz8xcb/Vb99wd4qCsNIRJFB/XZsAS6Jgr3kj2Rxc0
         Ga4A==
X-Gm-Message-State: APjAAAW5D7jGOvwhV5cDN9oZoFoS7eBnOpX8W23YxC41nEErJBwprfiu
        TErf5ENIcGEAbPWqoDMUkPgpzZtc0s7sng==
X-Google-Smtp-Source: APXvYqzDc5VhFofs9XIdYsQZu4wU4nu9nFaKSactW/E3GJ0JlMxUsc5F3iU67I/93YZO3RnoHH4AHg==
X-Received: by 2002:adf:dc4b:: with SMTP id m11mr24208585wrj.66.1557875369898;
        Tue, 14 May 2019 16:09:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i185sm808106wmg.32.2019.05.14.16.09.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 16:09:28 -0700 (PDT)
Message-ID: <5cdb4aa8.1c69fb81.97ae6.4bdd@mx.google.com>
Date:   Tue, 14 May 2019 16:09:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.43
Subject: stable/linux-4.19.y boot: 66 boots: 2 failed, 64 passed (v4.19.43)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 66 boots: 2 failed, 64 passed (v4.19.43)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.43/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.43/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.43
Git Commit: 3351e9d39947881910230a73be77e6f29ab8b72e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 34 unique boards, 15 SoC families, 11 builds out of 206

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.19.42)
          omap4-panda:
              lab-baylibre: failing since 3 days (last pass: v4.19.41 - fir=
st fail: v4.19.42)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab
            omap4-panda: 1 failed lab

---
For more info write to <info@kernelci.org>
