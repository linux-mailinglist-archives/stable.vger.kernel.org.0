Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E144B73C
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 13:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfFSLmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 07:42:03 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51826 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfFSLmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 07:42:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so1408327wma.1
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 04:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l2bDB1rqmgINjxfnfb4HRCgHFIfi7D7d/Qn+OY3A9KQ=;
        b=zEMvisWZV+tJkUTOE28HU6SQG6mFTlbGR3Ro9ODq15LbXsmNm/r1yTxHB0bJmbYe7r
         ztdTTPfBPC1+AXeE+Hp3Xyl8vwAqPn5PbtWXIw/hKF5WCdD97BRJLv4d5/TXOSPyYOhW
         YAralfyfDK6W6BLwyLSw8VoZyntcvoMQwkkHZb92Yv1Yx6+TuG1ZDpISp3TPbTkr8UF4
         ZJMHFHTCF6YWKit0mP8rpq6xJJZ4URU/cNblvRVVv2TTe1Y7x8yO9NUpFiNfyiQyLWp2
         S21ikQHKC8vwMCvuPAXl6tHhacKe2c9+KkhhoDrzhanU0lRk1h8k09lvTziB1Ggh58Ag
         a/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l2bDB1rqmgINjxfnfb4HRCgHFIfi7D7d/Qn+OY3A9KQ=;
        b=ZpkRjwwnvlmXg9wMaijOaKxwRZtkApoA4ug6UQweCVAtDraTUgvz2S4k7nFdooJgWZ
         QmOjz9r6O0eJLZQ7GZc+ZzH8dXjEJNYk001/0AUUh1mbXYjeOBgSaXIO8r8Up/QaF6An
         SquFI21cybcInugXIrV0nnQVsICR9mxxmvYv9EjEzSe6FrxLTckK2T1h+okxWLbDjPmf
         FaLeJRR9c70q1f+i8QngmwE74Iy3NSDO0PeLgHkXpByBI0GIoxgf9MeyfcSxKurdmlNO
         7A5rnGfNTshOxZssqO3XeUSUFoOjLYmaM6FCu80ARQ1Q2akRlZjcJ0SGQnFwwaFoeLeJ
         HRcw==
X-Gm-Message-State: APjAAAVngh7z9/XPvZwzdt7Bqvod3etLiGgiDDeeNTc1+HlRj9Axg4yP
        av/Td3ZvQj+JNhaapNxlzk2gZ/rB8wKmZQ==
X-Google-Smtp-Source: APXvYqx0ynLoa4GQou5y/k10vn7w3O/MOAwqSU0IeGessBLU68oJ2mKtT9TSFIPeN0i4s71tkuxkBA==
X-Received: by 2002:a1c:9d86:: with SMTP id g128mr8592565wme.51.1560944520758;
        Wed, 19 Jun 2019 04:42:00 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b2sm23075552wrp.72.2019.06.19.04.41.59
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 04:42:00 -0700 (PDT)
Message-ID: <5d0a1f88.1c69fb81.209af.dfa8@mx.google.com>
Date:   Wed, 19 Jun 2019 04:42:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.128
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y boot: 55 boots: 0 failed,
 54 passed with 1 untried/unknown (v4.14.128)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 55 boots: 0 failed, 54 passed with 1 untried/unkn=
own (v4.14.128)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.128/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.128/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.128
Git Commit: bb263a2a2d4380a56edab6dce5a2c064769676fb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 29 unique boards, 15 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
