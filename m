Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F0BB89C6
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 05:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406996AbfITDjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 23:39:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37788 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406849AbfITDjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 23:39:44 -0400
Received: by mail-wr1-f65.google.com with SMTP id i1so5226280wro.4
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 20:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=JxSuNDRTNY122iXEX/hS5NZ0dE0XPc1tRWWP3rVxMFQ=;
        b=TULAlVgOkMBZa6p6ebSb9bn9970VoYjSKiMpsaa9psHxV1gQYpAuRDw70Bf/vdFRTy
         dj2vkAdKVgB2/NQCHEHGv+6PpuBufmbhfyezXaOOjDYoWaLyEZiTciNLveA9f6oBtMQm
         BbGwNzz5R92Z13ZvjJT03AphD/jtCMrykwR4Uz8NrZvONOqYHpSHbq+VEPgBmRH9paAc
         Fic1Gl3fw2C5GRdFnjf+eRve/AWJd9D4u+Vu6Wg352bs0miON+M2N6Ag/LxAcadjziJ2
         NI1jB55e/Z9UJTIN/NUw4Db/ToDwGouLvryZrtusXRpINi8G+bmBJWeH4G6zletWBEJD
         E70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=JxSuNDRTNY122iXEX/hS5NZ0dE0XPc1tRWWP3rVxMFQ=;
        b=g1UgJRkP8n6+OeM1QpXB2fq65Sf/k80mEDtPmJnuQsL1fap7sZC2v5/VUlLuftYLHR
         NouijPXw2WCuUJ/2Jqme+pUlAv4GhEpedAWkAf57awYln+LpFMVMOoE+gJJqJsxva7ns
         WHwL/ub5zv0F6i6OMjnfPTqquaJ+BFZYxZAQJku07W+rC2LjxVG/7DMCVz29UFFtwuvB
         e/hJZfeY0yD9XHp78/p220eM/VuHNW67tyeWK9zmv9hrU6T3fWnb1kPY0Hnp9nqV4dFX
         I+Xj8O6BpUoREIG4gp5wCISXmo4N54ezv6oQ409uFOEMy0uCCP+i2iPmjBJ8yI6TsqGK
         RdFQ==
X-Gm-Message-State: APjAAAXb3GCS7FYW7YJodhgZI/LPgRwtGrcR+4KoYO9teLPwEE9dW3WD
        iDKC14rH9Pl2ErDIUAY2cu1WbQ==
X-Google-Smtp-Source: APXvYqx3EVaK3oUApeuL4FbXfrEbDggdlBAH5Ts5904WnBKQZYM+r0Yc7JEfJ5SDiynvuuUb71dbjQ==
X-Received: by 2002:a5d:4ac5:: with SMTP id y5mr10070148wrs.179.1568950781058;
        Thu, 19 Sep 2019 20:39:41 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y19sm521634wmi.13.2019.09.19.20.39.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 20:39:40 -0700 (PDT)
Message-ID: <5d8449fc.1c69fb81.6658a.1dd2@mx.google.com>
Date:   Thu, 19 Sep 2019 20:39:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.74-80-g42a609acc1b2
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/79] 4.19.75-stable review
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

stable-rc/linux-4.19.y boot: 68 boots: 0 failed, 68 passed (v4.19.74-80-g42=
a609acc1b2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.74-80-g42a609acc1b2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.74-80-g42a609acc1b2/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.74-80-g42a609acc1b2
Git Commit: 42a609acc1b2b5a744dd9ad3d3eb6a71906e4bcc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 38 unique boards, 16 SoC families, 12 builds out of 206

---
For more info write to <info@kernelci.org>
