Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5ADC462A
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 05:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfJBD1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 23:27:08 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34674 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728980AbfJBD1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 23:27:08 -0400
Received: by mail-wm1-f68.google.com with SMTP id y135so3894533wmc.1
        for <stable@vger.kernel.org>; Tue, 01 Oct 2019 20:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OZ6Gszc68wUKJ0sqYGifbwRhLJgddeJ6++xFyqmqWDM=;
        b=uhZ5LQdPaCpT3uAV7S8DYnOjbbxhHcVHzaG39D5DutRVQEArTP8G2vpXLCYGQTnj0z
         xxm8taxkIWy/NGKmBYDVb9L7Dui8B781sfmcG2TQTqvu5P2YuNEi8mKCVl0YhLyXKh50
         sXhhF0N3S3L5GLu+Vwsg5qrdqfnyefFP2DQRIkaQ2Z89K7Z8XRM4GOuzCJV5XxRZBGdF
         iW3d0eiGY0TaCUYZrQ/pEKUZiHgJVoHFY5a9TYIE3PuJd0Sc4nwdztFsHAZxo5fSQPgL
         /sONQNLCDOWS4qbBNCW1PbRFQtoQVlvnrhR+FqvYn7jWOXeYeVhUlw5FsRchXW4GwjuW
         cG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OZ6Gszc68wUKJ0sqYGifbwRhLJgddeJ6++xFyqmqWDM=;
        b=LZ83rimW9iM4bLHWIi1TiHuP4Q/IPQZ4aXNtYki7n2Xupav6D4CwepKDocqOe+PLfJ
         gJ8jHWnFvOtMsHVQR/f/YEQ49spk73lNPSRIsVZF37FZy25t6JH5bzrQoXC3ZBUisvmz
         RcM2bGdkeHXH5yvkAPGVm3lOTF9IKYcXngXNaxZ4bBiGSfBzEwlyZfoF48AIBp2fyPX7
         +jFTxmaer43UwEuYKHwV6O+I2xH6kldR2NL1tUSibe6UxwemC0GFiT7Y3H8lEeIQ5s2E
         Gst+pPGbmBe1ivOqC5m1+gEFlqSPkrhSyBRI7Isk3oXVcQGB/x0wPQNBm84pMnMPro+E
         c2EQ==
X-Gm-Message-State: APjAAAU1+3KF2qRPETtqAgcyQvuXAhi6eHAkLoRn/iUXxIUWu6TL5+aX
        Ey4xIooEXDuPkIHknNk4MndwexTWJlxJdw==
X-Google-Smtp-Source: APXvYqyqXDN0tH94XfCVjkLekThkX/+dwtilMPe9E9PuuXplP4gELZa2rjZy0oyK195kRmQyewidrA==
X-Received: by 2002:a1c:a516:: with SMTP id o22mr991576wme.116.1569986826206;
        Tue, 01 Oct 2019 20:27:06 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t1sm15278727wrn.57.2019.10.01.20.27.05
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 20:27:05 -0700 (PDT)
Message-ID: <5d941909.1c69fb81.7cd70.4a8a@mx.google.com>
Date:   Tue, 01 Oct 2019 20:27:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.76-158-gf07bbfbbc9ab
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y boot: 81 boots: 0 failed,
 79 passed with 2 untried/unknown (v4.19.76-158-gf07bbfbbc9ab)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 81 boots: 0 failed, 79 passed with 2 untried/u=
nknown (v4.19.76-158-gf07bbfbbc9ab)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.76-158-gf07bbfbbc9ab/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.76-158-gf07bbfbbc9ab/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.76-158-gf07bbfbbc9ab
Git Commit: f07bbfbbc9abcf05b4858ee5da09deee7ce9b4bb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 16 SoC families, 14 builds out of 206

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.76)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v4.19.76)

---
For more info write to <info@kernelci.org>
