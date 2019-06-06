Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D1436C43
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 08:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725267AbfFFGak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 02:30:40 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55516 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbfFFGak (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 02:30:40 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tomeu)
        with ESMTPSA id 01F11263955
Subject: Re: CKI hackfest @Plumbers invite
To:     kernelci@groups.io, vkabatov@redhat.com,
        automated-testing@yoctoproject.org, info@kernelci.org,
        Tim.Bird@sony.com, khilamn@baylibre.org,
        syzkaller@googlegroups.com, lkp@lists.01.org,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>
Cc:     Eliska Slobodova <eslobodo@redhat.com>,
        CKI Project <cki-project@redhat.com>
References: <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com>
From:   Tomeu Vizoso <tomeu.vizoso@collabora.com>
Message-ID: <1e8552db-8e7e-100a-2b2d-e2d41cd0c9be@collabora.com>
Date:   Thu, 6 Jun 2019 08:30:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1667759567.21267950.1558450452057.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/21/19 4:54 PM, Veronika Kabatova wrote:
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

Hi Veronika, I would like to be there.

Cheers,

Tomeu

> Feel free to contact us if you have any questions,
> Veronika
> CKI Project
> 
> 
> -----------------------------------------------------------
> Here is an early agenda we put together:
> - Introductions
> - Common place for upstream results, result publishing in general
>    - The discussion on the mailing list is going strong so we might be able to
>      substitute this session for a different one in case everything is solved by
>      September.
> - Test result interpretation and bug detection
>    - How to autodetect infrastructure failures, regressions/new bugs and test
>      bugs? How to handle continuous failures due to known bugs in both tests and
>      kernel? What's your solution? Can people always trust the results they
>      receive?
> - Getting results to developers/maintainers
>    - Aimed at kernel developers and maintainers, share your feedback and
>      expectations.
>    - How much data should be sent in the initial communication vs. a click away
>      in a dashboard? Do you want incremental emails with new results as they come
>      in?
>    - What about adding checks to tested patches in Patchwork when patch series
>      are being tested?
>    - Providing enough data/script to reproduce the failure. What if special HW
>      is needed?
> - Onboarding new kernel trees to test
>    - Aimed at kernel developers and maintainers.
>    - Which trees are most prone to bring in new problems? Which are the most
>      critical ones? Do you want them to be tested? Which tests do you feel are
>      most beneficial for specific trees or in general?
> - Security when testing untrusted patches
>    - How do we merge, compile, and test patches that have untrusted code in them
>      and have not yet been reviewed? How do we avoid abuse of systems,
>      information theft, or other damage?
>    - Check out the original patch that sparked the discussion at
>      https://patchwork.ozlabs.org/patch/862123/
> - Avoiding effort duplication
>    - Food for thought by GregKH
>    - X different CI systems running ${TEST} on latest stable kernel on x86_64
>      might look useless on the first look but is it? AMD/Intel CPUs, different
>      network cards, different graphic drivers, compilers, kernel configuration...
>      How do we distribute the workload to avoid doing the same thing all over
>      again while still running in enough different environments to get the most
>      coverage?
> - Common hardware pools
>    - Is this something people are interested in? Would be helpful especially for
>      HW that's hard to access, eg. ppc64le or s390x systems. Companies could also
>      sing up to share their HW for testing to ensure kernel works with their
>      products.
> 
> -=-=-=-=-=-=-=-=-=-=-=-
> Groups.io Links: You receive all messages sent to this group.
> 
> View/Reply Online (#404): https://groups.io/g/kernelci/message/404
> Mute This Topic: https://groups.io/mt/31697554/925689
> Group Owner: kernelci+owner@groups.io
> Unsubscribe: https://groups.io/g/kernelci/unsub  [tomeu.vizoso@collabora.com]
> -=-=-=-=-=-=-=-=-=-=-=-
> 
