Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6674935EA
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 08:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352306AbiASHz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 02:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352405AbiASHxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 02:53:44 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EC5C061756
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 23:53:44 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id q25so7290080edb.2
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 23:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h+4TAAW0oCGxfeZjzEbwErifa+6E3JL+Snfdxuo9hi4=;
        b=VphISyBLHqMdbjiWr2Zai00b4bFXug+8mUgSJxbfpZQoTAGgs2rCN2UNKbJD2vXt6i
         GbOkmqHLi5vXN621pAU3O1Ao0bKq9j/ukvtcqner6W2s0X1EaCJuZ1aCZNCFt6lFO7Ig
         tH+1kqNjJqFLVH0/8uHItRZFdFBLAZZJMq+2o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h+4TAAW0oCGxfeZjzEbwErifa+6E3JL+Snfdxuo9hi4=;
        b=l5Wiy+qrfLo0Jeg/CIj+9yfevozi/I/woOtMRXg1y6/O3yTOaFUDmp9xZBI71ey6R8
         /6q4S4sa04mBVsIWrkWzpMW+Jv+wXMyxHMRay6DAJW65cWNtU1yR0vdCsjeI+MxHVOJC
         PkB5EA3H5IAmyhgFQmuaZg72S3j1FXsJVrhtJsxcLIenLMCdoN/kaQ9GeOMzj9vMmwOe
         RqjwuDl+TRFFhbzyVKzH6sT6MTg3/LK0Dhk9xMrk82LH36n0nvMS6zb3Dh39ju9lDarR
         J4jF8SS83nTwwJuflLZ7lVVnPqpZu/zRrvPNvwClsIxNuUOEvaYYn/miacG776Mh3QwX
         sIBQ==
X-Gm-Message-State: AOAM5306W8Lot71aetoMz5WEXmWyEgV8OAGccrlmQ2SJd0d2FbLJTLAh
        BftBr353dO3tmC7BEkfIHil8a/KDnUfZsYaP
X-Google-Smtp-Source: ABdhPJyk/ixoiwem3BSOmLdL26p6EOCkiG0syZ85Qm/dOTn8pXP0M6/nwh4FXIUpnXkxPIQnri7eCQ==
X-Received: by 2002:a17:906:3094:: with SMTP id 20mr19505479ejv.72.1642578822987;
        Tue, 18 Jan 2022 23:53:42 -0800 (PST)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com. [209.85.128.44])
        by smtp.gmail.com with ESMTPSA id bj1sm3634288ejb.141.2022.01.18.23.53.40
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 23:53:40 -0800 (PST)
Received: by mail-wm1-f44.google.com with SMTP id ay14-20020a05600c1e0e00b0034d7bef1b5dso5612234wmb.3
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 23:53:40 -0800 (PST)
X-Received: by 2002:adf:c74e:: with SMTP id b14mr27546389wrh.97.1642578820207;
 Tue, 18 Jan 2022 23:53:40 -0800 (PST)
MIME-Version: 1.0
References: <20220118160452.384322748@linuxfoundation.org> <CA+G9fYvJaFVKu24oFuR1wGFRe4N2A=yxH6ksx61bunfR9Y3Ejw@mail.gmail.com>
In-Reply-To: <CA+G9fYvJaFVKu24oFuR1wGFRe4N2A=yxH6ksx61bunfR9Y3Ejw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 19 Jan 2022 09:53:24 +0200
X-Gmail-Original-Message-ID: <CAHk-=whJjHXGeVnVPmC8t_+Rie5N1tarrzsttECEh5efbXYUuA@mail.gmail.com>
Message-ID: <CAHk-=whJjHXGeVnVPmC8t_+Rie5N1tarrzsttECEh5efbXYUuA@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/28] 5.16.2-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        NeilBrown <neilb@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 19, 2022 at 9:30 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> Inconsistent kallsyms data

This tends to be a "odd build environment" problem, and very very
random. Triggered by very particular compiler versions and just some
odd code modement details.

I'd suggest doing a completely clean build and disabling ccache, and
seeing if that makes it go away.

              Linus
