Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E37CF16B4E
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 21:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfEGT1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 15:27:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36458 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfEGT1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 15:27:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id o4so23900305wra.3
        for <stable@vger.kernel.org>; Tue, 07 May 2019 12:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=Snv7TyoiGAcKNv0tuFYq8gStYoAzEsMX1pXAbixEywg=;
        b=ahJR6LhOZaw/AKX3XQShai5q5fKGZgezH1HRW7PZg3qTUvHODj7PancgoKDpf4eYPB
         8D+Uk08/K8w+BrDtXi6T4G9b09r8Kbu9s8wTJj7MIAxUlmRL1EBFpjHqsd5JNvRfafOz
         kHsorRt2Xb8o/9e3re4j+yL86uYXjqwuzOrloBvDdpS43qYZ4RKQBhoCnqOH8Qzf8Jc+
         fndMpElNwdLnxC/P69a+zezMCKhmIhVhsyn82/kBAQ9juGgU9CImIvSJSRkmEPEoVc/q
         rPe0w9yF6gSoj5g5W0sc1z4UeOiWTzVADhhK4NDDjn/AZaEsh4rYXWW6vx8lBy2Nc9ED
         xMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=Snv7TyoiGAcKNv0tuFYq8gStYoAzEsMX1pXAbixEywg=;
        b=kviF24ZN89nqrq31zHq48rSTIYtgo/YxM20cM6+xWkDVjEB0LRVwfuOplE3ne+vexy
         ELk/buH0o+3lbNjmJ0hqt63zwMfimA5bt928Qgw0OcaT9KRzWQHzDwSIrnaQKfa/Ih5+
         ZCkYHkEijA6PyjRqogbi2XhMgmezPPJ1qN/rGeY2L5Y0PnU5uJXfoj/W2jqvm1umA45q
         /Aeug4y5ARIBDDP67DGeF1P/aa2TGIUFzT2xaJEq6sEJdKvEFg55RORDpi4s8kxXbkdo
         lsJz5SDRARr0m25SR/Xvcx/9kbxTB3GSI2Rh5AqByzFP40TVlWGDkdN3RabueDYx+yKB
         dkeQ==
X-Gm-Message-State: APjAAAV7jfpLZ4J4ntPOh6utu8BInTZDz9pJ6sk60fkH7QSKuxQn7NwR
        m5Hb4U2fRw8+l7GY+M8V7Z2tsA==
X-Google-Smtp-Source: APXvYqwZvey4kdE6QfjZ1FMDGUpTasFbSeF/gxEF+fQQVuag6wSWUDqY0OMwS8/kJ0hMrFB3Ovu46g==
X-Received: by 2002:a05:6000:3:: with SMTP id h3mr23305782wrx.314.1557257221363;
        Tue, 07 May 2019 12:27:01 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id m25sm14465583wmi.45.2019.05.07.12.27.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 12:27:00 -0700 (PDT)
Message-ID: <5cd1dc04.1c69fb81.7a4ca.ab0f@mx.google.com>
Date:   Tue, 07 May 2019 12:27:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.40-100-gf897c76a347c
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/99] 4.19.41-stable review
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

stable-rc/linux-4.19.y boot: 54 boots: 0 failed, 53 passed with 1 untried/u=
nknown (v4.19.40-100-gf897c76a347c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.40-100-gf897c76a347c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.40-100-gf897c76a347c/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.40-100-gf897c76a347c
Git Commit: f897c76a347c330cca7fc03afaa64164eda545f7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 24 unique boards, 11 SoC families, 10 builds out of 206

---
For more info write to <info@kernelci.org>
