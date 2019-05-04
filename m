Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD8C513BCD
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 20:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfEDSqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 14:46:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32996 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfEDSqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 14:46:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id e28so11967284wra.0
        for <stable@vger.kernel.org>; Sat, 04 May 2019 11:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=KPACyaSmM7SH7Z/mR6C52rw+ki7LFPR7iQQVajdcVW4=;
        b=yWHI46OT1kwRnI4WAy+/jjFu1FxtQdf8bMQjbVOKwlTGqXeMyuL6069vsuA87ThNsk
         wmh5ORb8WoKhnRQ0u/wj4HAZ+RSqcqoGuu1zmfslTR6NJ78x76a9/FYQ+Vsngo93wtgZ
         DM7hK47ElTjmSWDJfZuhk/h/apShTNQTLTUn8zqz3zjHWBayOySy02Q9O0cMa1VYgfGC
         DFW1qrQnxw0PhAG2O+XvGFnCAz+/kj9UycGL8v9gVcpNj3Hqp9ptEBqV1KsUPTGN8C7w
         2nbbtItzObh4MkK0lB5JQLsuLGqPOEFXS8mAITHPrPnZ1E+chkDqKXYSzw4I6+FGX/Ml
         pJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=KPACyaSmM7SH7Z/mR6C52rw+ki7LFPR7iQQVajdcVW4=;
        b=Y1aWT2j8O58uD1hENhdSEq26XVVqTDOEQbdHm3gJhL1wHbSo8jgcBkd8PSOoLOKc7f
         61Ob466rIFdgFojJcDjEGV+mMcyTYuXZxBMkFytu1nw4CpIM5xAHZIxj9s0fPcsZUzft
         mzTqN4iztEeNyjJuiftZvWPWic74+BFsmwBeVzit/XFfJZ0U9tXSCCXr1yDxf/UCkAd5
         t2cOjargS8o4vt7ET9pXqBQbyYmFZcDljr3afYq09App1W8zdJ6XhRiUCHbvFFK5oR7f
         HZxAfvGhDW6cP3Ww6V3DULuxa/wvIBzrCDHA6YiRZQAOVqM28UZKzOa9qDnlbG59hiFf
         +gMw==
X-Gm-Message-State: APjAAAXCnOL4D/yRHuq/DJbrHmxZtaa5u3tbeRYUKJeUt3iUBDkgwtcj
        0WsRRLHxaLScEeCSmguN04LHdA==
X-Google-Smtp-Source: APXvYqzGD991jjuijsE+yDY3NLCeLH8x2fimp3tghKTxdYpnpUZrjzRmSW9yq3PwDbHanga5nBG3aw==
X-Received: by 2002:a5d:6b07:: with SMTP id v7mr3563090wrw.311.1556995601156;
        Sat, 04 May 2019 11:46:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id d3sm10344624wmf.46.2019.05.04.11.46.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 11:46:40 -0700 (PDT)
Message-ID: <5ccdde10.1c69fb81.7061b.99ef@mx.google.com>
Date:   Sat, 04 May 2019 11:46:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.39-24-gb0d6421bd855
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190504102451.512405835@linuxfoundation.org>
References: <20190504102451.512405835@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/23] 4.19.40-stable review
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

stable-rc/linux-4.19.y boot: 128 boots: 0 failed, 123 passed with 4 offline=
, 1 untried/unknown (v4.19.39-24-gb0d6421bd855)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.39-24-gb0d6421bd855/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.39-24-gb0d6421bd855/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.39-24-gb0d6421bd855
Git Commit: b0d6421bd85515e878edcf33121a818666df7749
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 24 SoC families, 14 builds out of 206

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-7
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-7
            exynos5800-peach-pi: 1 offline lab
            stih410-b2120: 1 offline lab

---
For more info write to <info@kernelci.org>
