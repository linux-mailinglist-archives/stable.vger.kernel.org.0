Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4101195A8
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 01:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfEIX1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 19:27:16 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55057 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfEIX1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 19:27:15 -0400
Received: by mail-wm1-f67.google.com with SMTP id b203so5245522wmb.4
        for <stable@vger.kernel.org>; Thu, 09 May 2019 16:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=RnvY7geH+A4N8B10Z1RbPFf3s1ZPigUFVWpv/Xpazjs=;
        b=KZXV+ZmebZiHyksi89Co3Ncpgpll079vA+GPTDcX0c3sNhE7P/fo4EdX4iO1u0r0mZ
         COOreq3YGTcJLoYVnHX/+3Xvs7DTecqEiFLlFMaY7yEKZIyzuSAyvs5K7i6EE4gH01uV
         91H5X2EdBsyu5VtMNtV/YFwARMQ2cqT6CCKNQ9uJF3pXIwS9U9Wwp7JUEcC7vUJKXjx8
         DJGfxDLwnLy3krjt0OtCkXQjTudjHgYu0+rFwPcdGGjxmknBOkYH5WlQC+K/eg0wdlkK
         Scx4Nsm9ATFL0UUBB4FxUQW+qPRPW5ZrN+J/aj2IFQK8R3u5FLkqXNxWqPNEvFu2zskn
         aljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=RnvY7geH+A4N8B10Z1RbPFf3s1ZPigUFVWpv/Xpazjs=;
        b=cLP9of5GQHLuf79Fq743zXocwZ9yc9rBKrurYl9wDiktcWSMLrdf061YT5WOsR1BDu
         qGbLdZgkQTgWeTzjj+jMHyDfWjW+zc5OQzQUvGPRXRjM/giPpUXraIlqxvK2d2VrAil1
         PIPsVYkJs9qBEoKU+PIcAe4usH0+9xXyhtdixC88AWWKKaShZkWBAF8mVPB87uQ2FK8M
         /XH+fZj6rFKV1ssg26HXlotYqWGEszuuI1bbKo/CUsrAgOyad794hbIw1n14tWO4pTjP
         e2Y7XNCWEMQohD1wzr1bYwZfyNHqJWIKzOhwIqxEeeV3pl7lWXH3EwrzuSpmE4uJp46q
         6uQg==
X-Gm-Message-State: APjAAAUjaJMIP9RGNWmj6iRIAajT86rrGhnSDC7y4AGsXR/brq7PnhLy
        xYcQVpj7nZFy74/YmsmLJ6OEZWZiv/2xgA==
X-Google-Smtp-Source: APXvYqxLLfrFCfz3i3u9lf6pJBwCTjAtwmx1g16ijs4SqlmlwcGtWHQfTSP6cXuPpLXD8ZRGHn/UEw==
X-Received: by 2002:a1c:a406:: with SMTP id n6mr4581605wme.126.1557444433385;
        Thu, 09 May 2019 16:27:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f7sm2215872wmb.28.2019.05.09.16.27.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 16:27:12 -0700 (PDT)
Message-ID: <5cd4b750.1c69fb81.c7a5d.a8bc@mx.google.com>
Date:   Thu, 09 May 2019 16:27:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.117-43-gfd7dbc6d8090
In-Reply-To: <20190509181252.616018683@linuxfoundation.org>
References: <20190509181252.616018683@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/42] 4.14.118-stable review
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



Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.117-43-gfd7dbc6d8090/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.117-43-gfd7dbc6d8090/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.117-43-gfd7dbc6d8090
Git Commit: fd7dbc6d8090b210573e19d5a50f7772ec4b1977
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 25 SoC families, 15 builds out of 201

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            rk3399-firefly: 1 failed lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

arm:
    davinci_all_defconfig:
        da850-lcdk:
            lab-baylibre: PASS (gcc-8)
            lab-baylibre-seattle: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
