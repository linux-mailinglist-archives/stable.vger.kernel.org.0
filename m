Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5CB46290D
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 21:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730764AbfGHTMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 15:12:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36127 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731463AbfGHTMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 15:12:44 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so18377651wrs.3
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 12:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=RDRGTN8x919ptUJcgdMpXaqUnSA3Nby8GPaC88Pdh/U=;
        b=Sg2Isfy1hv15iggO33sYxOcwXs6PmseiDANYxruUcg2O/wvklzYEHPhvKXfln0Gayw
         ZbNd4sJ3ZwNYadfoWYPzPI2N2xakAONONQGMuZgOTawXH8j9kAZ7ayn+mdEjM6pZOjMq
         hWMJJAF1mK01dqyy+NGewiWCPTwQfr06vC9sxKiildLgl0CsydxPxsuG3HHkoW6JzBKg
         FzDVIEyqMChGRB1ziA1ezDfFoPIBFpTtLqRJ21KlW5Dnoqjc86Z2mCxEh0U14IvQBVAh
         vEOGpLjY5wVN+u1nkzKLn4ghOIM0shjq/KyxrwyvP2FmIm3nOUzycpVAzedDtaRzBnPc
         eyYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=RDRGTN8x919ptUJcgdMpXaqUnSA3Nby8GPaC88Pdh/U=;
        b=Lxp/f08b8J+zDRpqKufIUUH/JMCe2fhd82QBrMFT1O5k91OWwUMTrxYhwtcCx47AHA
         xst4e2fyXe7yHAKpfcCxujsdzNJKW9jUZ9caV0QgLqH+J2z/EAmDQbwizRp+BPG0xU1k
         8pUpP9t5gza7FaGTLDIBaHpb07ppCLiYaeFCkzqzHG245rLDr0O59qa5xKMqbKxiWEqn
         N6fl9oAa8ZCGTc38kytGUUF+6aPJRY8ZyV7KH3z9t+yIeLJCXttQaG5ehzBKJUIjMS6B
         2QKx8zYV3Frc3DnxX2OmmfWuVvky6SZTP6gCynSAnwnqQAJCWgU9MvKfKjSLD+/GYGVj
         1/SQ==
X-Gm-Message-State: APjAAAVrr7G/qxYPe1y0rHPqkWOqjRT7oSTBMO1/QuVhfbt077e9NyC2
        BOZSvkCwB0bN6gn7RQL7iJ4IEQ==
X-Google-Smtp-Source: APXvYqyH9knR104jag6LxdCTMdYd0zBHt0+kcHYiweHGOkpP8q2RPmHnaRYDHv8WYlbuo799tINJUQ==
X-Received: by 2002:adf:efd2:: with SMTP id i18mr17700363wrp.145.1562613162740;
        Mon, 08 Jul 2019 12:12:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g8sm355988wme.20.2019.07.08.12.12.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:12:42 -0700 (PDT)
Message-ID: <5d2395aa.1c69fb81.39844.207b@mx.google.com>
Date:   Mon, 08 Jul 2019 12:12:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.1.16-96-gadc3bfb5810c
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
Subject: Re: [PATCH 5.1 00/96] 5.1.17-stable review
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

stable-rc/linux-5.1.y boot: 108 boots: 3 failed, 105 passed (v5.1.16-96-gad=
c3bfb5810c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.16-96-gadc3bfb5810c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.16-96-gadc3bfb5810c/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.16-96-gadc3bfb5810c
Git Commit: adc3bfb5810c7d89758b29f1736fc927757ea64f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 15 builds out of 209

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-bananapi: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab

---
For more info write to <info@kernelci.org>
