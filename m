Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DEB255F8
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 18:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728961AbfEUQrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 12:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729018AbfEUQrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 12:47:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 852C82173E;
        Tue, 21 May 2019 16:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558457227;
        bh=VCJa3i5w4CEBP7yNVDObKsU8P1zdKv+ZIEn4qE1XgR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yp0RVt7Mcb0wiblPJ1Dj5DS9v15MjkqQ2vED5GQp2K9gsADLE+hue9rwHgiZ7jgh6
         095FDa5sVep5s7MFQUqhl+epWkTw6malnmJli1I+6vK7PlwYyYttfGFEIXI6bmTRPO
         6VkVfTsivWHK5Q4ZYJo9U0O4/83DMKpYJ3Duxe84=
Date:   Tue, 21 May 2019 18:47:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     automated-testing@yoctoproject.org, info@kernelci.org,
        Tim.Bird@sony.com, khilamn@baylibre.org,
        syzkaller@googlegroups.com, lkp@lists.01.org,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Eliska Slobodova <eslobodo@redhat.com>,
        CKI Project <cki-project@redhat.com>
Subject: Re: CKI hackfest @Plumbers invite
Message-ID: <20190521164704.GB8787@kroah.com>
References: <1204558561.21265703.1558449611621.JavaMail.zimbra@redhat.com>
 <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
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

So I guess I'm going to be there?

Ok, fair enough, I'll be present, looks good :)

thanks,

greg k-h
