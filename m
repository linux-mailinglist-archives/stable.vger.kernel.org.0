Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080BE365E6
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 22:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfFEUrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 16:47:02 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34718 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFEUrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 16:47:02 -0400
Received: by mail-io1-f65.google.com with SMTP id k8so84804iot.1
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 13:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3pjeUYVjfw69zThxe60OAfxMh/Iwew9J9nTiZEKrvC4=;
        b=A6ZLaCKvlsObiDPdmd5DMoPLA2sP8Mep+cxDU9CtY1lVp1yee1m3Pv70cZ4Ujpcfye
         ENAmzKQLCSMZyvrl8W9Nshtz5srMFX7/YMcVughDWDMc4S8uEEgFg2KVy+xR/G9RG5LH
         +WkepgWVAdlPmJDPgS8KwRgQ2cBDs3Wy2BoOUkwwFQjYbMzb8ACE6+OEw7biV5rSgRcZ
         zoukKe7Wltv6hPtqVT3p9jgPiOJ8JXKBaR4h1GVk8+aWbzo+1IKL3bWEKhgMEneEe45H
         ioaebU68KS61i1Ftt6jKT4HyeSO0gLhzW1hKc+w748aqBPe4a6mXO3p686DcKbM7oQkN
         1Qdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=3pjeUYVjfw69zThxe60OAfxMh/Iwew9J9nTiZEKrvC4=;
        b=dhga49NHHtPhGHUIk0PI5ITNDXQja8YBj8Dx7MnI/qzH2mhcf4FJQKAM0zspswGjYE
         xkqKRFpxA9xWh6erintOHn05wJGWeYmJeg6MxHBMbCpCOsBWYszn8TEBkRd3l+C07DZj
         jYJuSeNksWCNmU36KXanVS9tQ/7a3ycMBD6IYuP1JsxsOaU5VStJ5ziAGWyod0sSenUL
         SSJsNZPSxbcpyFE8u5xKzKW2EVL5ZyCXoD7dvqnWdNZgCxmZwdUYQoiA27LpLWVgWaxu
         bxvaZpBQYFQ+jHKfiqhbWFCjGKi230VupQlC4cWhQfku5++m5ROUCQ88MPCc47dl+2gd
         TBdA==
X-Gm-Message-State: APjAAAXGM6yr/tMdEJw148v8H/LAKBUyX79eS3V0Z2mnGE+eQt4NbOZ3
        6JiX4xV/FRpooMohr5uZd0bYjQ==
X-Google-Smtp-Source: APXvYqyB3H61cJbQKFRHrEaK0gimYJ722ZUgaEPe2wFuCj2S3w7AvHx4+m6nW9CU0itI5FHf7qfG2Q==
X-Received: by 2002:a5d:8f9a:: with SMTP id l26mr26967144iol.22.1559767620647;
        Wed, 05 Jun 2019 13:47:00 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id l14sm196548iol.44.2019.06.05.13.46.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 13:46:59 -0700 (PDT)
Date:   Wed, 5 Jun 2019 15:46:59 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     automated-testing@yoctoproject.org, info@kernelci.org,
        Tim.Bird@sony.com, khilamn@baylibre.org,
        syzkaller@googlegroups.com, lkp@lists.01.org,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Eliska Slobodova <eslobodo@redhat.com>,
        CKI Project <cki-project@redhat.com>
Subject: Re: CKI hackfest @Plumbers invite
Message-ID: <20190605204659.npyf7wnmsdlr2bff@xps.therub.org>
Mail-Followup-To: Veronika Kabatova <vkabatov@redhat.com>,
        automated-testing@yoctoproject.org, info@kernelci.org,
        Tim.Bird@sony.com, khilamn@baylibre.org, syzkaller@googlegroups.com,
        lkp@lists.01.org, stable@vger.kernel.org,
        Laura Abbott <labbott@redhat.com>,
        Eliska Slobodova <eslobodo@redhat.com>,
        CKI Project <cki-project@redhat.com>
References: <1204558561.21265703.1558449611621.JavaMail.zimbra@redhat.com>
 <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 10:54:12AM -0400, Veronika Kabatova wrote:
> Hi,
> 
> as some of you have heard, CKI Project is planning hackfest CI meetings after
> Plumbers conference this year (Sept. 12-13). We would like to invite everyone
> who has interest in CI for kernel to come and join us.
> 
> The early agenda with summary is at the end of the email. If you think there's
> something important missing let us know! Also let us know in case you'd want to
> lead any of the sessions, we'd be happy to delegate out some work :)
> 
> 
> Please send us an email as soon as you decide to come and feel free to invite
> other people who should be present. We are not planning to cap the attendance
> right now but need to solve the logistics based on the interest. The event is
> free to attend, no additional registration except letting us know is needed.
> 
> Feel free to contact us if you have any questions,
> Veronika
> CKI Project

Hi Veronika! Thanks for organizing this. I plan to attend, and I'm happy
to help out.

With regard to the agenda, I've been following the '[Ksummit-discuss]
[MAINTAINERS SUMMIT] Squashing bugs!'[1] thread with interest, as it
relates especially to 'Getting results to developers/maintainers'. This,
along with result aggregation, are important areas to focus.

Dan

[1] https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2019-May/006389.html

> 
> 
> -----------------------------------------------------------
> Here is an early agenda we put together:
> - Introductions
> - Common place for upstream results, result publishing in general
>   - The discussion on the mailing list is going strong so we might be able to
>     substitute this session for a different one in case everything is solved by
>     September.
> - Test result interpretation and bug detection
>   - How to autodetect infrastructure failures, regressions/new bugs and test
>     bugs? How to handle continuous failures due to known bugs in both tests and
>     kernel? What's your solution? Can people always trust the results they
>     receive?
> - Getting results to developers/maintainers
>   - Aimed at kernel developers and maintainers, share your feedback and
>     expectations.
>   - How much data should be sent in the initial communication vs. a click away
>     in a dashboard? Do you want incremental emails with new results as they come
>     in?
>   - What about adding checks to tested patches in Patchwork when patch series
>     are being tested?
>   - Providing enough data/script to reproduce the failure. What if special HW
>     is needed?
> - Onboarding new kernel trees to test
>   - Aimed at kernel developers and maintainers.
>   - Which trees are most prone to bring in new problems? Which are the most
>     critical ones? Do you want them to be tested? Which tests do you feel are
>     most beneficial for specific trees or in general?
> - Security when testing untrusted patches
>   - How do we merge, compile, and test patches that have untrusted code in them
>     and have not yet been reviewed? How do we avoid abuse of systems,
>     information theft, or other damage?
>   - Check out the original patch that sparked the discussion at
>     https://patchwork.ozlabs.org/patch/862123/
> - Avoiding effort duplication
>   - Food for thought by GregKH
>   - X different CI systems running ${TEST} on latest stable kernel on x86_64
>     might look useless on the first look but is it? AMD/Intel CPUs, different
>     network cards, different graphic drivers, compilers, kernel configuration...
>     How do we distribute the workload to avoid doing the same thing all over
>     again while still running in enough different environments to get the most
>     coverage?
> - Common hardware pools
>   - Is this something people are interested in? Would be helpful especially for
>     HW that's hard to access, eg. ppc64le or s390x systems. Companies could also
>     sing up to share their HW for testing to ensure kernel works with their
>     products.

-- 
Linaro - Kernel Validation
