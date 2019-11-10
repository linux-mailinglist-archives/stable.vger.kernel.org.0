Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC4F9F6B0E
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 20:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfKJTIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 14:08:07 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51047 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfKJTIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Nov 2019 14:08:07 -0500
Received: by mail-wm1-f66.google.com with SMTP id l17so10298036wmh.0
        for <stable@vger.kernel.org>; Sun, 10 Nov 2019 11:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G+6aFIJf6576zHBDz5oxv9jLGIeEc6O8ND4aUJ6CJOE=;
        b=FLse7WB+6XlVoA3mkFNaZrxdITZpwg9UJFsCSAi7YUrIpLUbxaHd/kJE9Wya8WvpF6
         ZkBj2gcWOW/bVWl/2Krw/QjZ7hBJ5kPxv4TxLrEL4vGnnpq1WJKeizb/1w+rtngJttjb
         AliLWJPBxC9By8quyKG8JmwzdQ/srHthC/QRwH+QlaKElH9C1Ms2wPL9rywMIZpfbFo+
         vbn5mkAQAwQZ+GyK5NKkN33BXEWr65mNdgyBZ6z9jS2fs6R1cqXsGjd1mjHnxJJ7Ye+0
         8cd8Dr8vR7Q8LFOj8tAkN7/lpR4drWSSNWQrJlPqbKABytsLru1cp1Mu0GkALHHqw5EP
         LatQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G+6aFIJf6576zHBDz5oxv9jLGIeEc6O8ND4aUJ6CJOE=;
        b=tpBBwv5izywTTDkzJwTStK8MAactmeUKgnOra7Q9wSChlRjplhhmmVGFT6YpHMp11f
         BLzbRAzAad/P6OHEbVOPrqqcg/mfOQjfa6oNAzhkPcwqJ81viWYhAJiXqrkSw9vw8Q+s
         vXACnVsf5DoDOrsWXp/KyhnIcW4rcc9ig9di9q5gJxljLEy8etaNnqIMzkJCA9S2WD1L
         EWJBlkdLxK3vy8USChCUFl51w4aOndjPWKFTUs2iNb9rPcHkiSWVehy7zyuoZrxmoRCT
         AGvJn6lfV7wKznENyC4xbREYWzzCYHJ6lq27XC0+XDWIz1cfDc6pQNTFpEMHrSv83mjh
         i8Vw==
X-Gm-Message-State: APjAAAX+ApK8BQpVT1SxPewS9WA8AfaVustGbGNMfadW5qxu+NnvOJwZ
        mKuDk9WX30mi5IhQefW2HuZKCDg3dfQ=
X-Google-Smtp-Source: APXvYqwdSVqNl/IdSCATv6gCifw3mz9a8cauFg49FsRqJmwC93P+jXDbGJXLrlISYaqefLsXVhBytA==
X-Received: by 2002:a1c:9e58:: with SMTP id h85mr18115675wme.77.1573412884989;
        Sun, 10 Nov 2019 11:08:04 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y15sm11873057wrh.94.2019.11.10.11.08.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 11:08:04 -0800 (PST)
Message-ID: <5dc86014.1c69fb81.76c85.ac89@mx.google.com>
Date:   Sun, 10 Nov 2019 11:08:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.200
Subject: stable-rc/linux-4.4.y boot: 38 boots: 0 failed,
 37 passed with 1 conflict (v4.4.200)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 38 boots: 0 failed, 37 passed with 1 conflict (=
v4.4.200)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.200/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.200/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.200
Git Commit: 1b8629e7c9b52079a6471973a1e2e14012b885e9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 19 unique boards, 9 SoC families, 8 builds out of 190

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
