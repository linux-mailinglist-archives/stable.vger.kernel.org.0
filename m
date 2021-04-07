Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EEC35663A
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346904AbhDGIPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346787AbhDGIPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 04:15:40 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A0DC06174A;
        Wed,  7 Apr 2021 01:15:30 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id z1so19191480ybf.6;
        Wed, 07 Apr 2021 01:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e3srcGijwVkdGEDyqrMyzk7H5PiTF+15Bkn4ScMbDp0=;
        b=qQdAp7spxgdOft+aBnedQrBRcz6SaeeZBvvEwazNbxrGZSyWr7UmgGG6k3NV0hSyES
         velHFNv5blS+FV32GYBwDCloZf1HpY6V7FyH7eddT1LLBJahJ+r9EstI1Qt3Qq3+YnX4
         rJ97GXRW3AnPpFG65ntOYRXN3c/Vmh9QvuQO6nrWKJZNMOYKS04YnxNpWfjzmM6h+Ozy
         qj/ePXEQMZx7BNaNmVnN/J7AUxdtnz5tfRQiLfGIm5/TIhvf4AsLfYm2PgDBMARuoh6T
         CPTLgfV4e/UIYkZ/yh6VL/W4JzTimwX6n9cOYhIIkz0hrdtgNGOfpBO+LgZGA4rgFV1m
         PgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e3srcGijwVkdGEDyqrMyzk7H5PiTF+15Bkn4ScMbDp0=;
        b=pxv4g6WFEz7uj8VvL3SSPpitc/BA5SswkC9gvfYqRWOYoAEkBuewcqcVy5PL1EF69J
         47dn3JXbqfhOKoVBlESS92X6JTjsLM7eHqTsvXQitT3fDHQIQCAEPKw15stBUrg0ONCW
         fKLuIvvtcrv+BL0VJ2CrcfLPMyXLZ+UVUBYCRhlpunVxfbYMlof8NEuZIfm6+TN3XsKN
         6r4Nx5xXO+MyRrOCGKsIPkI8i8ebIbNh/KTD/bP5Y+QJgXyt6hG9cutiAyQX2LJMAX1z
         /y5y/KzMqrl1eq1eWHkVY1ClXhlbY0Wr2dLeNST7cixDpMqDgHijzm6Ofdw3g9tRr69f
         iudg==
X-Gm-Message-State: AOAM530htd6x0pDpasA68gEcfYaYueyAdJYH236Q5chladUqPGcn1Tyq
        hAU6vTiI+JHsjjo/rYfFx5nhQ5x/2TG/xD7/p9Q=
X-Google-Smtp-Source: ABdhPJxStqW4VQy0A9S4AORqrp2wZPPzZQ51dcczazywBItXEsFf4TaaOcz+LCiXPyJGNBL/H/OI6A3b67NkN22OQsE=
X-Received: by 2002:a25:68c5:: with SMTP id d188mr2897497ybc.127.1617783329786;
 Wed, 07 Apr 2021 01:15:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210405085031.040238881@linuxfoundation.org>
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 7 Apr 2021 09:14:54 +0100
Message-ID: <CADVatmM=LxvGX8BdASA38pLrJ=use8aeVvn+oQFEgUxKbrX+ow@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/126] 5.10.28-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Apr 5, 2021 at 10:09 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.28 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.

Booted on my test laptop. No regression.

Tested-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>


-- 
Regards
Sudip
