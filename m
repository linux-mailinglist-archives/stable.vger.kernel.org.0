Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4A2CD98F
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 01:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfJFXBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 19:01:19 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55749 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfJFXBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 19:01:18 -0400
Received: by mail-wm1-f65.google.com with SMTP id a6so10569521wma.5
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 16:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=5FhZ36jnVtPYp2moexL6x7c0xT4VPQ85lGFj06T19kk=;
        b=GqqTOVSZIr3FtNHbKEemaBipI0ksciIpK94L55r6xyQADmrDCEpceNnIyI1tYgVx2a
         CgHgEjOd51WP4RbhohV5p9r+ZCH4Wvwar7oAB7ESB/x9xACr/ZfL2qDXnXkPEYL8UL7z
         VKxxXkKQFt6m0v7ehkLK2IseCYBT9wxWEt1a+NWLonnBbSpGlJx/2C7Blnula3CcYBXE
         EZlU/z/XAekdeNRvIPpZSkYf0RT9g8eMHZPYs4ZE1civ1TyEzbrP5lZ3Y9OUaQGDsBcb
         Tw7YcGaMA8IbC8EX7wlsLq9Ust2OlziR1yd2W5ogKF+Us8UtoO4+kGWb7FxT+94VbeiI
         Vgyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=5FhZ36jnVtPYp2moexL6x7c0xT4VPQ85lGFj06T19kk=;
        b=m2qRhdtc5X64Eqkok8dnar3kKVrAa7aZlGVxsMBQSiV31MQfjer0sgn3hTHZJX+Fgq
         WJ4yf2C6hEH+gHnzw6p8XEkeoUbiF6lw7CkjqIpE+ZWEq5ooHM/PkrU+Vkrw6W/y8ALv
         K+iM/als+s8lm+t3W82Lnzsiki9xBy/ZhAC95H96BIwLpLAIwzJvszsm33I79w1DJpx4
         mMXnk8ND9blpLUP6Rw2fX7yiTAQ8nic+PMw90Gz9pevqpXnBxNktWqfxStgduSLZQNCD
         xPljVtEAMdvmL1yNwPOu64EdmLOljGSFZVg6XR8hyxmCJex6xLb5CsEpqlchPy53ViFN
         OPsg==
X-Gm-Message-State: APjAAAUDXh4n2/tjFCjXd13w4gkIa8s5ECLGKPoluuMaTH/P7Cx5X7bb
        3YWcKZbk3BUyv2a7WkEb1OeQpA==
X-Google-Smtp-Source: APXvYqxVS2qrSZsKDHou5yu2ujmMsKdmvnS/UbAQbGKRBDBbKNG4Sx7mJJNRQq/Hwu9eQTUqNyjr/A==
X-Received: by 2002:a7b:cb0e:: with SMTP id u14mr19896306wmj.115.1570402877056;
        Sun, 06 Oct 2019 16:01:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m7sm10293664wrv.40.2019.10.06.16.01.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 16:01:16 -0700 (PDT)
Message-ID: <5d9a723c.1c69fb81.5aa5b.d173@mx.google.com>
Date:   Sun, 06 Oct 2019 16:01:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.147-69-gb970b501da0b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/68] 4.14.148-stable review
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

stable-rc/linux-4.14.y boot: 54 boots: 0 failed, 54 passed (v4.14.147-69-gb=
970b501da0b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.147-69-gb970b501da0b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.147-69-gb970b501da0b/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.147-69-gb970b501da0b
Git Commit: b970b501da0bee5eba4e61ea7d424adab428a165
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 32 unique boards, 15 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
