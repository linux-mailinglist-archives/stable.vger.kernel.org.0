Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F546CAAC
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 10:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfGRIKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 04:10:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42593 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfGRIKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 04:10:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id x1so12603393wrr.9
        for <stable@vger.kernel.org>; Thu, 18 Jul 2019 01:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m6v76uLNAhe76m2yoyYYvuAgJjHyuB/rHa+1oEoNBb0=;
        b=fdqQ1DNQWEYrx14yqh9aaIQjnpx21roztQ26D0wC5k6GYeUQcKjehtHLFLXC7ct1xj
         olU1wrv1U05bvk91mLw7U00iaNnACBYDGQo6ZhkjO3qxt1BOt3FXsjOnz2KCVPPKxm7P
         IO5f6nQePLv3cB5kEUy0znx6uY454hx7b5RuPmSLAWhmeg6jf16Jn6Yyd39SxJJDZ0hD
         9/b6lRVs+SjX59XDBzQdbF5LFt20E9nEAFZHfVuRAxkiqLNWXwPwySlYRscoRNUcjAdk
         ejjSOtj+4cAIK+cbfoj76gK3LCDL7LlKByo9iriS28gUDkVEhqe3WOZhTCSpUQiUF1ok
         KAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m6v76uLNAhe76m2yoyYYvuAgJjHyuB/rHa+1oEoNBb0=;
        b=SXmDJ/n3wfM2ItO5+ivsJKIagNof4b0ExgUXBEmZ9iwdgrGhh1yiWH3YGyu03mOEAN
         /yyGejcDctw3KYZTQ29BeDqE/uGa2VKauhY+2Id4IFzE5nn92O08R/uqjm9ctS4BLBLd
         uMj7g2b0Hfy7RbO+t3ghNVxGfw4iWy8Pz7GN3JY79i263BK9sK4xdYBAnhkhg2w6BJCb
         wGm9q4AK8b7b7APBv4Tj5C5L9FL3e8FbEWwhfb4IzZ86Nk0zrQNhCY931OWGbgfXviRu
         F4V4klBot+xj1aRpnH1gp7za9aYqeMlTveBe7ON4l42P4S0G6Urj+0iR9XeZrryWEFvM
         +PWg==
X-Gm-Message-State: APjAAAXytAwpB05h76pnOo/HRF+BpnD1RY2vCRC+OkqEJWodzNxeQt3e
        4nuhyjt8kmqkW3W55fhI5yL7eLCj0WI=
X-Google-Smtp-Source: APXvYqxe4JeKz5w+bVM9ML7Mgp8lbNSnhS06jkAPp2zp8XTZacxloPtbiDo4leSw4aBzt0FennPrZw==
X-Received: by 2002:adf:fb8e:: with SMTP id a14mr28873537wrr.263.1563437429910;
        Thu, 18 Jul 2019 01:10:29 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e19sm36098198wra.71.2019.07.18.01.10.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 01:10:28 -0700 (PDT)
Message-ID: <5d302974.1c69fb81.14755.f85e@mx.google.com>
Date:   Thu, 18 Jul 2019 01:10:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.59-48-gaa9b0c7579ba
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 127 boots: 1 failed,
 124 passed with 1 offline, 1 untried/unknown (v4.19.59-48-gaa9b0c7579ba)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 127 boots: 1 failed, 124 passed with 1 offline=
, 1 untried/unknown (v4.19.59-48-gaa9b0c7579ba)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.59-48-gaa9b0c7579ba/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.59-48-gaa9b0c7579ba/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.59-48-gaa9b0c7579ba
Git Commit: aa9b0c7579bacf570e7e430fa563e52b6b4ab15f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 27 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          sun50i-h5-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v4.19.59)

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

---
For more info write to <info@kernelci.org>
