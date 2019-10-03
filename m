Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A04A4CB281
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 01:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbfJCXvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 19:51:37 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46435 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfJCXvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 19:51:36 -0400
Received: by mail-pf1-f194.google.com with SMTP id q5so2704338pfg.13
        for <stable@vger.kernel.org>; Thu, 03 Oct 2019 16:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=SM0jbJ92pewaO2UyUMQGBudBI+n7lpF8N9PzdJ80Ddw=;
        b=pPjHIsHxI5U6qsDZ98f27ZX0jQhbAVXW4OmhAl4I75g7dVFAVlqNRyMe2Klv/pjH/5
         Eebo39ovpjedvBzVIH1EXWF5ADHAGDLwFWnulDD4UnbFLWrpCmXMZbrz5yJVocXENIaD
         PKI4c8gFYSy+aDQfCxxtfDvd8goG5gMUlTftarPohCJndwfvLBu+md+gjd+aD0F/Wsz4
         fiS1l2rv6DziNkAQQiqZ66g5J3QMJdbN9Aw4idY6lCd/Hi2SxTm6OHLd+PE6LdtIaM+A
         pGtZ1e/GhPkSK9HWx8Fb46xUnJ1Ftl/LqyiVgBvIlTubzICX/f8hV1RDjzCuqpRgnR+S
         8H4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SM0jbJ92pewaO2UyUMQGBudBI+n7lpF8N9PzdJ80Ddw=;
        b=umbRUQ/w2XExOhh3mWA6EVzfw2BnMWZNM11DzIR84ttv0IP6pDcIt9MCUNJoBtmKxe
         1qkpufbHE2Tn5vxDgcTt0Jtw9925LjPKJeboTwwUVgSIX+rCFYfuLGCLFt6qLQmwOgMQ
         UobcYTbx/ZeGCHXA/Uv3pvxwg4pYtAszkm/uiWHr7dT8EX2WjH0IEc5NCsBORHBe1/eY
         A/Uv0qw8Nof5J28PN07MthEJXNUVNbHPMu66xxm/0IbKs5vRnX9rUDCbDHcqbQWcnDDa
         zx2HAsBU7y4H7zjQilga20y5BLXJOYV6Sb+9J8OznbxI/sP6BnIuzHLY07Xt8j1ScyIf
         48IQ==
X-Gm-Message-State: APjAAAULg+8wbsOpnlZ+lJ732nMSrfmci0+bkYMHsNQoZEUCdL8oRt2Z
        v1SKY7zr05BIx3lCBrupeGybNg==
X-Google-Smtp-Source: APXvYqwS+Kwy84pyUOoYC9yXYxngxdEt1wEwq/m4oP/itFien8ixsHy3bhJH7Qz1NFMB3aHSJ+OOmg==
X-Received: by 2002:a17:90a:8001:: with SMTP id b1mr13278880pjn.10.1570146695643;
        Thu, 03 Oct 2019 16:51:35 -0700 (PDT)
Received: from localhost ([2601:602:9200:a1a5:6c63:e3e5:f440:92c9])
        by smtp.gmail.com with ESMTPSA id w2sm3738261pfn.57.2019.10.03.16.51.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Oct 2019 16:51:35 -0700 (PDT)
From:   Kevin Hilman <khilman@baylibre.com>
To:     "kernelci.org bot" <bot@kernelci.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/313] 5.2.19-stable review
In-Reply-To: <5d967daa.1c69fb81.174c7.399f@mx.google.com>
References: <20191003154533.590915454@linuxfoundation.org> <5d967daa.1c69fb81.174c7.399f@mx.google.com>
Date:   Thu, 03 Oct 2019 16:51:34 -0700
Message-ID: <7htv8pgzg9.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"kernelci.org bot" <bot@kernelci.org> writes:

> stable-rc/linux-5.2.y boot: 136 boots: 1 failed, 126 passed with 9 offline (v5.2.18-314-g2c8369f13ff8)
>
> Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux-5.2.y/kernel/v5.2.18-314-g2c8369f13ff8/
> Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y/kernel/v5.2.18-314-g2c8369f13ff8/
>
> Tree: stable-rc
> Branch: linux-5.2.y
> Git Describe: v5.2.18-314-g2c8369f13ff8
> Git Commit: 2c8369f13ff8c1375690964c79ffdc0e41ab4f97
> Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Tested: 80 unique boards, 27 SoC families, 16 builds out of 209

TL;DR; all is well.

> Boot Failure Detected:
>
> arm64:
>     defconfig:
>         gcc-8:
>             rk3399-firefly: 1 failed lab

There's a known issue on this board I've been trying to debug with the
mediatek maintainers, and we're not sure yet if it's a kernel issue or
a hardware issue on my board, but for now, nothing to worry about for
stable.

Kevin

