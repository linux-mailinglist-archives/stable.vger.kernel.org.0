Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9961226E6
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 09:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfLQIpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 03:45:30 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:44907 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfLQIp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 03:45:29 -0500
Received: by mail-lj1-f169.google.com with SMTP id u71so2176492lje.11
        for <stable@vger.kernel.org>; Tue, 17 Dec 2019 00:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LykOI4XNhK/sQW2UChERBgIdICJXupMlzh8i1Tv8Stc=;
        b=b3iCn4RURmQj6PPCPhzYYxZRsDz1FINgsVgCHcL4IGU8cc59LPnJ82s0rjDI7mp3d2
         PqxDXvgAxljXnh3r5aRXndS9EKY1PJ60dcCTMfwaqHr5qc9IIGOTovgzE0hIsKwVXZaK
         aYyNvZ01tQTEmSJZbxbz4iNg+MPmbz3uCugLOtsiERcmm986j5azGio0MJMmmm69081f
         +/kisIo7Nd94sXCW2U80WkVFYulCdge+9FDOw35eYQgEi6dOLoOXNXckAqzuDs5KjwNq
         c0riNSIP7h37/usMqH0ZqxQ8KqzX+Lx8nwkqy7TpZV0B0g70CVPQU67SmdpXZRHtww9i
         gfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LykOI4XNhK/sQW2UChERBgIdICJXupMlzh8i1Tv8Stc=;
        b=Ye1S9FXCNAFyZok+GlVycf4YdEtDKffc0RCTRBxazdfdseNFm3stbTxcXv5CtpGm7b
         5BiXi1ZxT4YfF5ZZhd6Kd8G6f6KVegJggLuK4GhNNVuyP45dYyXRz5+aGVK8qN/0vuko
         DAl7A5pJbvoZSb9WiOzNtyav/D+n7Snw75d00mSyCEi5qU3sH9BrJfOdMG5jpaGToC2V
         REVAOkgHSoVXfGHuf6GHqmBQcUA53Ontzn4v7fFx02OsBtH8+Co+r+HuEbSsk+z2Jzi9
         D+y5zWjPcy3ZbVPEEJJHbLTFNHm/AyAU//rAPJM+N375aKkLjK/D/u6UjIxFTF3aZqzR
         STdw==
X-Gm-Message-State: APjAAAVixntVMWxJFzynfv2nYSKABTvuTvyHlMMyVZeCA7728cPb+Kp9
        t+TqA7wANR11ZB+efAOkg9pyAMa6f/Zj7x1+5qDuz/bu5+A=
X-Google-Smtp-Source: APXvYqym0PivuPM62o0QLwn+0VSnXSGoVVToM7YTyjq2gl+Aps3zWsb1+UqirctTEnH8eEld8pGvuMs/RMRLJILLoCU=
X-Received: by 2002:a2e:868c:: with SMTP id l12mr2137258lji.194.1576572327686;
 Tue, 17 Dec 2019 00:45:27 -0800 (PST)
MIME-Version: 1.0
References: <20191216174848.701533383@linuxfoundation.org> <CA+G9fYta8SH1EhzTSLshp1xx=MqmbSKPM2oXdV1qMSx=o2Tqsw@mail.gmail.com>
 <20191217075322.GE2474507@kroah.com>
In-Reply-To: <20191217075322.GE2474507@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 Dec 2019 14:15:16 +0530
Message-ID: <CA+G9fYupS7hBtYPauO3A_QM-NQTPgxrOSLF=vu=dfHfdeG01Eg@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/267] 4.14.159-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        william.kucharski@oracle.com, bepvte@gmail.com, rppt@linux.ibm.com,
        Jan Kara <jack@suse.cz>, rientjes@google.com,
        dan.j.williams@intel.com, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 >   ltp-fs-tests:
> >     * proc01
>
> What does all of this mean?
>
> Can you bisect to find the offending patch?

Here is the offending patch,

Michal Hocko <mhocko@suse.com>
    mm, thp, proc: report THP eligibility for each vma

FYI,
Reverted this patch and re-validated ltp-fs-tests proc01 and now
getting PASS on arm.

- Naresh
