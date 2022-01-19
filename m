Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5F2493DC0
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 16:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347537AbiASP4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 10:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237164AbiASPz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 10:55:59 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36CEC061574;
        Wed, 19 Jan 2022 07:55:59 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id l7-20020a4a2707000000b002dde197c749so853806oof.10;
        Wed, 19 Jan 2022 07:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aSGUAl3gocAm+DLJ0aQCnbcEeJnsi/wUpekX13IHCuo=;
        b=fOyNg4qcUt37pe7laWsmJ8fvNB0XmoDH2Mnynw/z/yiAIkeF9QGVcvVKHDh0CATJts
         zO5iGRvLbyoJTlKkDb0qC2HqFADSFpf2c9tngfm67w5NUC+9WHmTuDLyY9dIx8JI4wcj
         R6V/jy2GJKkgOyQEtcdR+lbPAtOh+jdCFpVnqTgid5j6cALrz+Fmd3raXSkpA5gqUmRi
         YFTuf9Cqd09aQyjvX8yccM1BLzP0Q1K+iBxPbBxNraBAlC09a+0+FFxIrVxaKWZ5mFWF
         X07qRou0GjQ94bld8IDC3F5eFMPKCi3qP3lXFhRlWhwfAAV2Y2/UaHJWBAnmFKo76Oij
         DpbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aSGUAl3gocAm+DLJ0aQCnbcEeJnsi/wUpekX13IHCuo=;
        b=z3WYPaMZgMQLK7DLVDe7CybDbiqdIy7x7jDkRcDK+lc/KzXtUEsF1SGf8KzJ0batM3
         aS43hAAz1BxiY2ZCdm3b3h1cxDNqfbPyCNDO6UG2ksKQFLy8HdXKkrPHstiCXbhgUw6a
         5+SzxG8Sk8ugMzGJ/QR7Mnv5y7h1DQ4pqHhNOyUfhsoJztSRggPitpTRxWAtsLxrcbT0
         33BGNI5jjRYNoORLBY2+H39C7uGKe3I1LMZUZDLTC6bj2kqx9vefxBV0889LGCnS1e6V
         rcr7QVnTRJkPPKtVk6bFfxlMDJoYF4J0ZNYyp+5d5LxnOH1Sa0ZFkrgptv2JB7Ks2uMv
         43fA==
X-Gm-Message-State: AOAM532nYg75ZgtyUZqEfOZ1h2fp0w7CmDjs9PQ/+tLsLAcqjnbC/t1B
        dG1ZA1RfqPIWPmTZ96dS1Xw=
X-Google-Smtp-Source: ABdhPJwVX9iXytkWG/lvP0m/HVAdUHyAlz8jdPDfjrDOPS01ehS+jf00fWaTpgkNwzul7ep+I3Zeng==
X-Received: by 2002:a4a:3851:: with SMTP id o17mr22448953oof.6.1642607759105;
        Wed, 19 Jan 2022 07:55:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t14sm8853466oth.81.2022.01.19.07.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 07:55:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        NeilBrown <neilb@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
References: <20220118160452.384322748@linuxfoundation.org>
 <CA+G9fYvJaFVKu24oFuR1wGFRe4N2A=yxH6ksx61bunfR9Y3Ejw@mail.gmail.com>
 <CAHk-=whJjHXGeVnVPmC8t_+Rie5N1tarrzsttECEh5efbXYUuA@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.16 00/28] 5.16.2-rc1 review
Message-ID: <45b72e1b-d98b-ba4e-fc08-ab7b122d69ef@roeck-us.net>
Date:   Wed, 19 Jan 2022 07:55:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whJjHXGeVnVPmC8t_+Rie5N1tarrzsttECEh5efbXYUuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/18/22 11:53 PM, Linus Torvalds wrote:
> On Wed, Jan 19, 2022 at 9:30 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
>>
>> Inconsistent kallsyms data
> 
> This tends to be a "odd build environment" problem, and very very
> random. Triggered by very particular compiler versions and just some
> odd code modement details.
> 

It happens once in a while depending on the compiler version and
on how symbols are arranged, and new compiler specific symbols showing up.
I had submitted a patch a while ago that kept retrying a few more times
before giving up (that was rejected). We carry a patch in ChromeOS kernels
which tells us what the offending symbols are in case we see the problem
in our builds.

> I'd suggest doing a completely clean build and disabling ccache, and
> seeing if that makes it go away.
> 

My experience is that once it starts, it will show up randomly and become
more and more prevalent over time until almost all builds fail. powerpc
seems to be affected a lot by this problem, but we have also seen it
on x86. When that happens, someone has to go in and figure out the
offending symbol(s) and add it or them to some exception list.

Guenter
