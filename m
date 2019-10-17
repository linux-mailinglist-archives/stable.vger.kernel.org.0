Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDBFDA4D0
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 06:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404642AbfJQEmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 00:42:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37414 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407756AbfJQEmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 00:42:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id p14so662101wro.4
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 21:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=IJlnbnyY5cuX1Hnkfu7X6odyaf/nXbeywPLfKyjn1qM=;
        b=emTDyMBcY7lv/zsUQKHKUYVj2Upyj+63oi6HeQ0WcAcRxiN0/wQjiPY1jkwKbz/Nt9
         edTl9RpSDVglsXx+JMWFuES1xsHslfc+fbTacFhHGIK19yFEM5KNf3PNJh80cyjI7eCB
         zVWzcMfEMzj8vWVwnAktt+138ytzp+1lUtX0d7RXv8hFBJcDP0fdPwymqBsARAouTES8
         v/rfLxGQUdeXQw/azT56SNlT0pZiZEHFBqcyh79eozC09TPV8qSUc1C9tqeG2m3Rej86
         3gupOOFDNFI/9PAUH4qokzAVrNjTQgQkv4g/PCU4Bh8dlhHa8VFnbA2li0UGIj7Tr6fF
         AqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=IJlnbnyY5cuX1Hnkfu7X6odyaf/nXbeywPLfKyjn1qM=;
        b=V4cAkTt6xC5IhMaMYUb275K+G8Opwu/XOe2SlEYgaGM+nq+h6yISMiZjHgp/MUXgbW
         Dr9jXRO+C8phfKjKYc6WhF+Cizzkn21GPqSV0BmERg97ccFdpn39bfS6hrFZ4yGmRBEY
         29sS9Y/XulmcraMxESD2W0y2Ra8cdqRyrtVNs2SJ6BBnWlkYYthLMC3Rf6H6oswqAo3u
         BdvFqlCk+pqYubPaKRMvmGs3WslL6abVBMI45yeFW5tG/bS9marPfbU8zhJDwRX4d1UL
         grALk1A8zbSja5HmW45j7mQXRpw2ZCoT23FclUUa0x6X5xuv2EHpS4irpzQcVGl5xYQd
         KjRA==
X-Gm-Message-State: APjAAAXsa1wSt+hqnirkSvsUSC5sleJIRZomuvM0J4cYw+L45j+m9wvk
        LKjqigTmKrzmsFFPAuQroKcmaA==
X-Google-Smtp-Source: APXvYqzzyGjZ2T00KOXjU9A57EDR7cl3i+BjV3HxdjzZLZcsUmmF2MCVUPRNYxYWd64UFMbO936gSA==
X-Received: by 2002:adf:92e7:: with SMTP id 94mr1157436wrn.199.1571287331742;
        Wed, 16 Oct 2019 21:42:11 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t83sm1570936wmt.18.2019.10.16.21.42.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 21:42:10 -0700 (PDT)
Message-ID: <5da7f122.1c69fb81.430a9.6b76@mx.google.com>
Date:   Wed, 16 Oct 2019 21:42:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.79-82-g99661e9ccf92
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/81] 4.19.80-stable review
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

stable-rc/linux-4.19.y boot: 106 boots: 0 failed, 99 passed with 7 offline =
(v4.19.79-82-g99661e9ccf92)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.79-82-g99661e9ccf92/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.79-82-g99661e9ccf92/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.79-82-g99661e9ccf92
Git Commit: 99661e9ccf9206876ca8f509555b7b0d3e45cc13
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 23 SoC families, 15 builds out of 206

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
