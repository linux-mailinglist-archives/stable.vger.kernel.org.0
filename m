Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FCC165777
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 07:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgBTGUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 01:20:12 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33915 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgBTGUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 01:20:12 -0500
Received: by mail-pl1-f193.google.com with SMTP id j7so1139197plt.1
        for <stable@vger.kernel.org>; Wed, 19 Feb 2020 22:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GOXHqnm0xQQ1lzQBpeWUCfzV9orVS7NZQn/deWDFwGo=;
        b=VDIQiwvuNonY1CGi2nmjJ20ailUTli+3NwM8lGh4orNxQvsuTFlOCgJGPxzRhM2ACl
         B9N6cFJnFY9dvBtxmz3ogMlU4gXMwgynyLruinAVoV92veiOYnuaSRhJSEFKAvUpliYQ
         E3XGuVwWauV+ouBX41rkrFjsejxV7QH/8V2G5yu2ZZ0SyERiSXCNv7LgBFy08+DCZRYa
         MB2mudBUz66H65szjxlGzuqP+rfKVUE1QYyBiVhBrVBGVDhW22TAdWUBaU9s0oYj/qag
         Ga7Kthbd0Y8Il53bZXWROEUN1QMUqaporz5td9YK9gYTaMvJtLkj6iInaRlythj6hAAH
         HrqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GOXHqnm0xQQ1lzQBpeWUCfzV9orVS7NZQn/deWDFwGo=;
        b=gZOgWnwXReTIkb2IzdVym/cWeH04VGOUCjxQLiTza0CQN5V20aWrv6ChU9fSpdA4sc
         uCx9uqo5F7mM5HdyEKkW0nSdwX/b0JzE+G/O7PmddbuJJWze+3y/OTwgECTzh1eupmSE
         XMbgvLQzUKgSV/LZJChdFN1xeKy0IjFTjUQreX9LyClRQjt7P2Qua1q9yqf5JeS/Xkps
         4ZlcyCh6Cmb6o1YnstmhgvEW9+f6fPhTeQ+et/TBG9fiqdSN15jegWhhU8IuijixnIlz
         4VHNdrb639jk3SmpENfdbtzCnGrKphQQq3M9sa+mnJzJjHF5hiAb+MbPYR3Rjw1PzzOa
         pHZg==
X-Gm-Message-State: APjAAAUkySpnp+j9nes4XjwlFqWECUJdn+1vKrCm6SxO7aO/NnSmxVfa
        eJ/2B0dPTIHQTkSPon/zAf7tI7WDQKA=
X-Google-Smtp-Source: APXvYqyPJVjzhfURwUFmKwOuqCJBqSr37i7APS/D8aK7rVRZpT7uf18slzHzVyfW5PJTW2PbELeMTA==
X-Received: by 2002:a17:90a:1697:: with SMTP id o23mr1798735pja.62.1582179611382;
        Wed, 19 Feb 2020 22:20:11 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l5sm1796402pgu.61.2020.02.19.22.20.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 22:20:10 -0800 (PST)
Message-ID: <5e4e251a.1c69fb81.6eafd.6534@mx.google.com>
Date:   Wed, 19 Feb 2020 22:20:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.21-7-gba7360881c6c
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y boot: 52 boots: 0 failed,
 50 passed with 2 untried/unknown (v5.4.21-7-gba7360881c6c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 52 boots: 0 failed, 50 passed with 2 untried/un=
known (v5.4.21-7-gba7360881c6c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.21-7-gba7360881c6c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.21-7-gba7360881c6c/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.21-7-gba7360881c6c
Git Commit: ba7360881c6c6d9272de721a0d923c59c1a23a43
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 12 SoC families, 2 builds out of 23

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.4.19-97-gb06b66d0f2c=
4)
          sun50i-h5-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v5.4.19-97-gb06b66d0f2c=
4)

---
For more info write to <info@kernelci.org>
