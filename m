Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2905BF6ADB
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 19:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfKJSoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 13:44:22 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37735 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfKJSoW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 13:44:22 -0500
Received: by mail-wr1-f66.google.com with SMTP id t1so12296434wrv.4
        for <stable@vger.kernel.org>; Sun, 10 Nov 2019 10:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dOn9bDqdgYUbBht1/3oUTHKVM4zsfBR6wX7o03jVGwQ=;
        b=rnTXLu+qR3wRJAIuqzbjJYnhIWF+MbLkiUFNxObVlL1FB/4ZSwg96wwo2LAfheorgj
         XhCYtXQTsBnw6R+oVnN6roB0AX/n43TgJNwmQ+7JeOeKbzhCv+U6YpGYbgoqaXP8CT86
         lrRBRrWkWdNk8ChVlKuNDi44/QQZ9IJF0BTkJwZ/0hfca9TvnFmbks5t2horyAK3pLHk
         4G3xc8X8oMCslCqUIORDc0YOXzSYPo6wDa0hkMpn0SYm4XhtgRpAcOPmsVQqgJoizApo
         my/Z5H4tBjjHv/Dj7Nkf/32FzZAZVPUDX3EiAGAelbyrbmiwR2A97UG+OxziCgIqTG3E
         tLQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dOn9bDqdgYUbBht1/3oUTHKVM4zsfBR6wX7o03jVGwQ=;
        b=LirZV/wRX9eK07cCCBvIZmm8ME8pgTLtutCinMHw4ehnXd10k03eqtBxXVxQg7sJ4j
         NtJx/0euTNyCQOODjsT/4rFvEX1L94LZD8vggMjueBU3xmsXQPpUBO4FFkyhN9UiypGH
         WlqbXny8NdjVkHKyp/sVMxy5QIEneY+jWe0kom9n7P87XsnTjRkzIWvVbZq0u8nfKg56
         EW09shXMsZkhVxl2vwSycQwJSKNS4PEakFUW2vi03Yms7+oPCcYRogz/35WtuZO5tUTo
         r05g12mVod8MQS4txQlSZO2xa2FO7js5MVWekcWEsm+m94lM2i2t/JM3nvx9T7v/55tm
         YW+A==
X-Gm-Message-State: APjAAAVlMRSxsgXrZG459cl7bi0aGonT8UMcAnvKZLlcEysw7r8/leXU
        Ru1Dj8f13Cyu2obFcUv6DzxFfXJnoNI=
X-Google-Smtp-Source: APXvYqxHxzYoLrR//0xV6pqz+J7cBQzLnhQb4nygORcjY7GHdLrTBUcwUbQDokjobhaDZvBNFCaCEg==
X-Received: by 2002:a5d:5191:: with SMTP id k17mr17102275wrv.350.1573411458003;
        Sun, 10 Nov 2019 10:44:18 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 62sm15545153wre.38.2019.11.10.10.44.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 10:44:17 -0800 (PST)
Message-ID: <5dc85a81.1c69fb81.a65c2.cd56@mx.google.com>
Date:   Sun, 10 Nov 2019 10:44:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.3.10
Subject: stable-rc/linux-5.3.y boot: 75 boots: 0 failed,
 74 passed with 1 untried/unknown (v5.3.10)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y boot: 75 boots: 0 failed, 74 passed with 1 untried/un=
known (v5.3.10)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.3.y/kernel/v5.3.10/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.10/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.10
Git Commit: b260a0862e3a9fccdac23ec3b783911b098c1c74
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 15 SoC families, 10 builds out of 208

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v5.3.9-141-g11077993d891)

---
For more info write to <info@kernelci.org>
