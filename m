Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBEF10010
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 21:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfD3TGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 15:06:25 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37821 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbfD3TGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 15:06:22 -0400
Received: by mail-wm1-f68.google.com with SMTP id y5so4997779wma.2
        for <stable@vger.kernel.org>; Tue, 30 Apr 2019 12:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=KOC8am+a2nOdN4WYbe81JkusFOlmT/wzWfYRV8sMIdI=;
        b=dA77n0o4NI7x0ELsgdO84aeigRfoPwJWFy/n3ps5vN073G36EzZ2IeYl+A6sMoFipO
         Fsc+S9P8Gs+L0lV4r8pwSINtqa7v7nRJd8L8/YBKWhLyZT88ibGqymtZK8E9llzoBLJ6
         uX8M1FLKLse1nkwI1Jb6XiA+5mic+TR1b23auVFTo7YIRAukm8+GuLo8y1PkaTHFcZVS
         jHJ2dEhmBNHp+a2F/4n+IdPlVeq1Qd4QnUeaETle04u+pufWKrV2qV4v5+QNLmmkhBlN
         i/m9RQXk+oC6MnApOb3SwbJo5/d5Z4tP53j7sYoT02prd+VpF9Uo04jsh7b10DqtvLvF
         J+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=KOC8am+a2nOdN4WYbe81JkusFOlmT/wzWfYRV8sMIdI=;
        b=ac+2s1jFH8q4ysZ1NwsVMOUWHG6Mo9+hv6pcEQGQ7EF/ZvHi6wJv/4z0KjZvKNeNXd
         nDyZvUzarosHerCn8x0+m6rcdQFxxMRbP7bN4+lSeCpPindPrzvRmvmnLoVD+gNHzw4e
         4IcZWhHoAyQQ8ktESYMPbM84Z/xF6fK3ZlM6+bgSg+2km6tw89DSyw3ZHZRRXhVDIN9M
         OJUq9KjRVs4OlUaEZEByQYANDjN6YZJv3flEhygpB6S8S/Z+SkJGX2oGPH6/w+s+ge+i
         rbcO3wF3spZw+5ram59w96mzdEBlN9xav8UYc45Wv/nyNh/L3fyqnHD0+iBcdvYEHiCu
         2tbw==
X-Gm-Message-State: APjAAAVbiVnzdrVZnq/YTKtdUiRmRuWT3FRgIOemkhUEQJyrKTr2Cfgb
        AXIcM6CuXbqNoDHTgIwxbXeQYQ==
X-Google-Smtp-Source: APXvYqwia6Lw063G9SsVeUFKAAF2IsKPay8Vla9rRHmKjKeNMQ18PPPNQRAxPSeU0Ws+QemR94OAPg==
X-Received: by 2002:a1c:a753:: with SMTP id q80mr4207784wme.120.1556651179630;
        Tue, 30 Apr 2019 12:06:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b11sm6088605wmh.29.2019.04.30.12.06.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 12:06:19 -0700 (PDT)
Message-ID: <5cc89cab.1c69fb81.4a233.21d9@mx.google.com>
Date:   Tue, 30 Apr 2019 12:06:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.114-54-gdb44a158d937
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/53] 4.14.115-stable review
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

stable-rc/linux-4.14.y boot: 117 boots: 2 failed, 114 passed with 1 untried=
/unknown (v4.14.114-54-gdb44a158d937)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.114-54-gdb44a158d937/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.114-54-gdb44a158d937/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.114-54-gdb44a158d937
Git Commit: db44a158d937ed88d91fa55f1df54c11490a5b57
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 66 unique boards, 24 SoC families, 14 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-7:
          stih410-b2120:
              lab-baylibre-seattle: new failure (last pass: v4.14.114-44-g8=
da3ae647284)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-7:
            stih410-b2120: 1 failed lab

arm64:
    defconfig:
        gcc-7:
            rk3399-firefly: 1 failed lab

---
For more info write to <info@kernelci.org>
