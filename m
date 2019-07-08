Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 481D16290C
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 21:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389193AbfGHTMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 15:12:50 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37208 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730764AbfGHTMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 15:12:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so665242wme.2
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 12:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=dMil1FF/9REos4dHEvshh6LKzpYeBc8wUcAzB7CI8Tc=;
        b=yRP35joYO5y3RvQxJ+Tg5qKQQHzyEjrQELOBFFI//iRwsiDLPZ2P3rhQpYDrASm5fa
         /oISGUmC//2EDrUiJ+Fc3P0o2+hhGlDL7XT3/+cdacufN9C/VyoIRNOn5hr5BD16d1l3
         EwqBv8caKn2R76pKCv0S0RLwm9fDq0CtnVxJ6UVKSzqpM22IHMNpknex6yViGuwzpFqE
         WdIJOp4YH1m+l/DLm+bgO/B7QoWXb5bD2nk/FCKmkdofItfc4HikqMJEZOIyU6xFBApR
         LOKqOuPzrWY78Vg486C7KWm8hUiqZhN6/3MmFmgM/GXNuixs5DSUCD4v1z91Z7lM/qJU
         dfZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=dMil1FF/9REos4dHEvshh6LKzpYeBc8wUcAzB7CI8Tc=;
        b=HWigSWXArsBLhBxGqiV/Z8JIv2Pgg2bzKLC/QY9Wm4K4pEwB9rVE0nmbVInOIzwnfI
         E3d4TAlYfUC5tgeHnd50UbDx6fSWQkhjXkHGK+uivdMysCqZe6opC3jcOW/zgiHWMUSw
         vtrPyoqeXVysmMuw/j3fX51WNIqDyY0+MIQjg3VdPV61hRb3U7zG90cIS98f2JwTqynU
         8KV+40smY5+tj0hoY0md+V9kBZ29eDw6JWhB87UOLBS47Fi3ghgyg1mMCA5gZaGvlpf0
         qeVa27pXAxP2WCQyDzXiykBk0LxxOIH5Yr0wZAPGJh3UqRvzKvm+A/9jnGxeTc7t2dTS
         mLGg==
X-Gm-Message-State: APjAAAUukUxMmQ1cWHou/eh8D7wE3HTejuIizugwBOy8x9grIATXiqqq
        tnz9kmZFHi2NzpkeDxm3WBuVnw==
X-Google-Smtp-Source: APXvYqzSjfPRtwxOTL9skUSR1bbuTNHs/2Tl/ZWO+lUZjmE9WR63Kb6S2H25DEBsa1+uk2sA4OWoFQ==
X-Received: by 2002:a1c:f505:: with SMTP id t5mr17559349wmh.67.1562613163480;
        Mon, 08 Jul 2019 12:12:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 2sm22474071wrn.29.2019.07.08.12.12.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:12:42 -0700 (PDT)
Message-ID: <5d2395aa.1c69fb81.75e33.192a@mx.google.com>
Date:   Mon, 08 Jul 2019 12:12:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.57-91-g7b63e70b83fc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/90] 4.19.58-stable review
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

stable-rc/linux-4.19.y boot: 100 boots: 2 failed, 98 passed (v4.19.57-91-g7=
b63e70b83fc)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.57-91-g7b63e70b83fc/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.57-91-g7b63e70b83fc/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.57-91-g7b63e70b83fc
Git Commit: 7b63e70b83fca977d86fe50ca2a48f40addac0a4
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 24 SoC families, 15 builds out of 206

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
