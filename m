Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A7DC190A
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 21:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfI2TAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 15:00:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35978 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729155AbfI2TAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Sep 2019 15:00:33 -0400
Received: by mail-wm1-f67.google.com with SMTP id m18so10338158wmc.1
        for <stable@vger.kernel.org>; Sun, 29 Sep 2019 12:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=edoAIkAZL7speqG34C2NioOQY0eVyzL3Fpq0+FfX9zU=;
        b=KNvLuqg3QGY8t5gAOq9u5CsuTAgMa3ulmWeDdjOmanLRpBARGtuGg4nF8cqri3YAZu
         fRdKDe9QkD8k83tKkYjhpeOn/xkf6ub1L1Oj3Hrp+czQCH73gpJnVi8gUNFZo9Vql5GN
         sIuUpQxSnlxzyAVcUaVRBTdRH34/s0W4fjKTDjWVMGq08D/POKiHlxd4AkqsyfZUnYji
         s1QmfQAWTV6z3PXHl8VmCCJzxYFvJ3+zf10piDeNU5emq/3bt+lqSeTSl7wows2whsWt
         0rhRSymiEzq28lE9MbkiOS4CgkOufC2WyiUZst+/5LcRaxbCpeetvwQg60siSXUiRL6r
         +OxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=edoAIkAZL7speqG34C2NioOQY0eVyzL3Fpq0+FfX9zU=;
        b=NtrajtAk7rM0r2n/OUdTfYEM+PEpPU+rfZeh3oHqkNdY/uDXNKbI9meivhJ9tnNQrD
         8ZmFjHagfcYK81LMTuGw4j3qAQHV77yVl7t++jasnkccfvHYIm5g3wiNATef1/BKyHkU
         kaMrtWcC3C3Gei+mWUbZjxJVqFn1A4pkZBy42lCa5CLWT6O3WSGV+U7P3GYiddeKtWG/
         NlrSHg0oTz8Vpa1iYGqajnXBIFg+H/pDyWxYS5SbH7WuQIfO1mZdHyuvNiTbGq4gyMuY
         ObxipVrw9Jet6GNOCotLW8Ciw550AjM6zNC6NmhyTL5OQLHeb3eDu6fGj05ADHYYHY9v
         CFFQ==
X-Gm-Message-State: APjAAAUkBIH9mwX5ckflX6HglcmLoDJx763t54qIrygHSH5GHoxaCqxD
        c61A1az/OOfY6mfTTUsO7t9joA==
X-Google-Smtp-Source: APXvYqxMeO6G11rp6qRCQeMh5IaoEORNbCWi4jK+isZNREj9LgscjRmspfYHEwL9IFtK7dwaXM/Hqg==
X-Received: by 2002:a1c:2501:: with SMTP id l1mr13368399wml.74.1569783632235;
        Sun, 29 Sep 2019 12:00:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a18sm15838475wrh.25.2019.09.29.12.00.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 12:00:31 -0700 (PDT)
Message-ID: <5d90ff4f.1c69fb81.c48de.7865@mx.google.com>
Date:   Sun, 29 Sep 2019 12:00:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.17-46-g70cc0b99b90f
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
Subject: Re: [PATCH 5.2 00/45] 5.2.18-stable review
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

stable-rc/linux-5.2.y boot: 83 boots: 0 failed, 83 passed (v5.2.17-46-g70cc=
0b99b90f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.17-46-g70cc0b99b90f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.17-46-g70cc0b99b90f/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.17-46-g70cc0b99b90f
Git Commit: 70cc0b99b90f823b81175b1f15f73ced86135c5b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 46 unique boards, 15 SoC families, 13 builds out of 209

---
For more info write to <info@kernelci.org>
