Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA36524007
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 20:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbfETSIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 14:08:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45104 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbfETSIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 14:08:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id b18so15597617wrq.12
        for <stable@vger.kernel.org>; Mon, 20 May 2019 11:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=2WY0IabKSdQhHGJ5mcTL+5/L5bLYjovhd3hAWOIllWs=;
        b=tRz/WmlHPyh8SdWmeh48sbakCyk7rDXj2hTHyCaFKwDFJkYkLZSeXVlqk3g9gggX7s
         XvMknAJvkPicQS9omRWDgONCfiulxCX4m0PwEhD9sx+VssZEvdcx8SxLtnQ0JHZd9+sQ
         G3hbIq+esyLkgOyZ4MzCVS4pGgqzviA+izSm2j0XB/UGoP5Q5A0CRVCaFTd7h8f/++qV
         TBnubt1nrDjtBlSpn/mNsgzo1CQxEozd6dvLc5/i+X/rVqqhh6rPSpo5w0d37csEZNWx
         gnyE4fAmCfevn/l5Tzk4HOZkPWEsh1nMN4KacY8tP/qa3Ldzomlht9uNKkW6qAnREpKm
         mO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=2WY0IabKSdQhHGJ5mcTL+5/L5bLYjovhd3hAWOIllWs=;
        b=UdtMUd5kst6Jfa44ACTa4rQdx9gem0uBONEm3ZnNMbHZyofQdW2dx6kX0x6SSGcGqo
         xydPZItBg8cnfI72TTIDQaADVYokmrBfwx9jLLmD1zDIVPF3E9jyViHB0UfnD5ah/vtz
         0VyCJADfD/d9zGi5ODI/mOGV5JFd7pdVBRqg2E6Dl3Sc+wv0cjkCJRKhJU56ePdLD682
         VYK1Zi9K9bqh2pNVyAUxAxX2LOEjkbgPdHj/+7cXw8DYya1VPAM5J1UtRk5SxlDevAKw
         edx5vdJI6Xy4Pm9sx+Bs9Pyt8i5bFjjXcnGZewdhA+3zSId6PuLPBLPa9eSs5CwLP5yG
         YBcA==
X-Gm-Message-State: APjAAAVVqFI1QUeSFa7Na0xWff0JiMfcEu9dC+pDqkOXUiNqu6mFVD9l
        C+lvNp7Wi2R4S0MzG2Mw6iXM2g==
X-Google-Smtp-Source: APXvYqzSqj2tJEX6nCeGUhHqDCMpIIF4fCABH3JVhbUJ/BmwBED02/6XJBKXG4O+r59W34px/bgJQA==
X-Received: by 2002:adf:de82:: with SMTP id w2mr2526724wrl.53.1558375695272;
        Mon, 20 May 2019 11:08:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l16sm29694590wrb.40.2019.05.20.11.08.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 11:08:14 -0700 (PDT)
Message-ID: <5ce2ed0e.1c69fb81.60b3b.2811@mx.google.com>
Date:   Mon, 20 May 2019 11:08:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Kernel: v5.1.3-129-gcce3bc9ebd2f
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
Subject: Re: [PATCH 5.1 000/128] 5.1.4-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 128 boots: 1 failed, 125 passed with 1 offline,=
 1 conflict (v5.1.3-129-gcce3bc9ebd2f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.3-129-gcce3bc9ebd2f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.3-129-gcce3bc9ebd2f/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.3-129-gcce3bc9ebd2f
Git Commit: cce3bc9ebd2fd2d9cfc0bfe53abbf3525a7fab45
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 24 SoC families, 14 builds out of 209

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.1.3)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    omap2plus_defconfig:
        omap4-panda:
            lab-baylibre: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
