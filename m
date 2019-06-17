Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA040494B9
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 00:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfFQWEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 18:04:31 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:35722 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfFQWEb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 18:04:31 -0400
Received: by mail-wm1-f52.google.com with SMTP id c6so1017705wml.0
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 15:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9HFro6cVUkI1kIP7nChyUPYE396V2mJTGQjM8gkTBEE=;
        b=U0pAdNFwGs6zKDcxZJZZdqdOHCoLdyAkWZrqdIrNqfREn0ywu8aSLhIW+0jgsKBW7I
         10kQogqNJrYoBEV1g4enfDyDjZSZhKd0zfJCtpdgUlh1hpDACkxxyw+mts0bnd2ndecY
         LEV2zKoNVXk6bGprr1n2jFUthFbXACSn2cj5DQFexM0snVhTYASkg48BKOFxDKkuPAEe
         iz1Q7ibHXweryUqsn9NP2zNcJeaP9FUBNxjRnUNcjY9MP6B6cfppECkaYUd3A49h13wa
         4HsQDW4S0RzbZFvy5eQUfuKDQDO1mqS349vLgEsp8aSclurO0R/qDvvcPuv0Z6ocibnP
         r/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9HFro6cVUkI1kIP7nChyUPYE396V2mJTGQjM8gkTBEE=;
        b=PX4SontLbAtAS62gVslfR5EfxOC9EHSw3U8LCrJX4s/xmrvbqOl3VjiNar5rQe/Mnn
         MWcbLmpHwLh0+SRCOrnfczexUj2oH8kj8jOI1nVrJM/dpZmswayEB5dy2fkEI2s6JplP
         qrdBkfEhJ4acmzS9a72qn4WNxB5BQMhuXskCrvecx7lri2WPzoNt9IMq6E49Avmcb6/l
         HeM3eeSjlgi5aAIU/93qGzvnDkqBXkUK6KonA8VLRqBywAtIY/TFM/j/JuYpfBMeSmVU
         XTw5dq09lR2vXWbIFj6Ohn3mNAAlxX9i9h+m/TWhrGwxUynu1G98AyvdtAv6C8HEZ2fz
         hi3Q==
X-Gm-Message-State: APjAAAXv7SAMP5UXYMWp4ri5tgTioHidciPA/vZ153m4YZru+tAid0BN
        JL92cfrVYeTBVMv9HyeuPS2ltAJQdSyz8g==
X-Google-Smtp-Source: APXvYqxQYGP7QhtBdnSAOjbq3899ssaxGMb7+PM0A260NtUvpM454ttUQ/cY9WgSSF+L0lYLNt125Q==
X-Received: by 2002:a1c:b706:: with SMTP id h6mr464292wmf.119.1560809068967;
        Mon, 17 Jun 2019 15:04:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w67sm685917wma.24.2019.06.17.15.04.28
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 15:04:28 -0700 (PDT)
Message-ID: <5d080e6c.1c69fb81.7731f.4258@mx.google.com>
Date:   Mon, 17 Jun 2019 15:04:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.182
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.4.y boot: 32 boots: 1 failed,
 30 passed with 1 conflict (v4.4.182)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y boot: 32 boots: 1 failed, 30 passed with 1 conflict (v4.=
4.182)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
4.y/kernel/v4.4.182/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.182/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.182
Git Commit: 33790f2eda7393d422927078597a33475792c82c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 14 unique boards, 10 SoC families, 7 builds out of 190

Boot Regressions Detected:

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: failing since 6 days (last pass: v4.4.180 - fir=
st fail: v4.4.181)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
