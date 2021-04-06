Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46640355D0B
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 22:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347245AbhDFUoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 16:44:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55196 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347212AbhDFUoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 16:44:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617741837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9gAUBSas1c2zynPZGsm5lpmI/COC2SlQ+0LwpbtGnEY=;
        b=UGNajZKAOC5jW0A7vvOsN1FNUSuKF+iS4WtGV99902Q0m1CIE8rTRs4NpAhmsiQEz64LaF
        nEm9ClsfmpEHcA9zhcfWaIHw0DbY6pJlRX9usGNXwkeNxqN+2kY6cUBMVYQhchp8Bz3ilb
        GA/rLvyC7Gw4c1UOCn4Eyr83SvogTbs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-rvUZEAE4OUiLxD9wMa5ySw-1; Tue, 06 Apr 2021 16:43:55 -0400
X-MC-Unique: rvUZEAE4OUiLxD9wMa5ySw-1
Received: by mail-ej1-f71.google.com with SMTP id o11so2296833ejx.23
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 13:43:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9gAUBSas1c2zynPZGsm5lpmI/COC2SlQ+0LwpbtGnEY=;
        b=du6KtjAR81a5eAEiIq07bRLSqn4YkZApN6RQaJebbIYzWR7ytJHd0p1tVJeFzPElow
         THZBIb1ZUAuxAPWOib2m2dDOa3LmOZl0I0BupbYyBVpAhs7dj60qqGLPQZIRVuiRewGG
         oAJQK4pNEOMlDSGy3DVdwKMHNOcTxq2gsaOQ2i00LvTWeAmeGlcFyYH5/VsJ32vaWaSo
         F8oczziDdfO7ScD2CDQkLzB4P675evnHLAXfHcKzeQvw7uBGE78tRZCgmMSqxdC1kFUf
         1wxF28/Wm+K315PmebbC/1ZjeY5uRMrZQ84k4ouNVw+q2QZ1xBqR124YsOv9rlPdT2UM
         8ZbQ==
X-Gm-Message-State: AOAM530uHeW+8QCgpQ6VBVnsWH9bbESYYn2V12Ln+lQb+Ioqh2XjeGHP
        5oBqbC3sPv8unQd4cZopK8uMRU9uf6AhmxqJ6Te8MiJdWQOCmU6ti6/Y81npLTT7tjLa2+S/R36
        ZQFvUFL8BoMVU8OXy
X-Received: by 2002:a17:906:5203:: with SMTP id g3mr35123521ejm.95.1617741834519;
        Tue, 06 Apr 2021 13:43:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxB8CQ5zi2U8KCqc/sM5wQa7uXbbaNHIZF+GVJ7SPEwuoOJKAUWSWazNJSLH7SJOhDH8dQOSA==
X-Received: by 2002:a17:906:5203:: with SMTP id g3mr35123507ejm.95.1617741834348;
        Tue, 06 Apr 2021 13:43:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s12sm9340838edx.18.2021.04.06.13.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 13:43:53 -0700 (PDT)
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085034.229578703@linuxfoundation.org>
 <98478382-23f8-57af-dc17-23c7d9899b9a@redhat.com> <YGxm+WISdIqfwqXD@sashalap>
 <fd2030f3-55ba-6088-733b-ac6a551e2170@redhat.com> <YGyiDC2iP4CmWgUJ@sashalap>
 <81059969-e146-6ed3-01b6-341cbcf1b3ae@redhat.com> <YGy6EVb+JeNu7EOs@sashalap>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.10 096/126] KVM: x86/mmu: Use atomic ops to set SPTEs in
 TDP MMU map
Message-ID: <b2b05936-f545-9272-714b-845d54fa78eb@redhat.com>
Date:   Tue, 6 Apr 2021 22:43:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGy6EVb+JeNu7EOs@sashalap>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/04/21 21:44, Sasha Levin wrote:
> On Tue, Apr 06, 2021 at 08:28:27PM +0200, Paolo Bonzini wrote:
>> If a patch doesn't (more or less trivially) apply, the maintainer 
>> should take action.  Distro maintainers can also jump in and post the 
>> backport to subsystem mailing lists.  If the stable kernel loses a 
>> patch because a maintainer doesn't have the time to do a backport, 
>> it's not the end of the world.
> 
> This quickly went from a "world class" to "fuck it".

Known bugs are better than unknown bugs.  If something is reported on 
4.19 and the stable@ backports were only done up to 5.4 because the 
backport was a bit more messy, it's okay.  If a user comes up with a 
weird bug that I've never seen and that it's caused by a botched 
backport, it's much worse.

In this specific case we're talking of 5.10; but in many cases users of 
really old kernels, let's say 4.4-4.9 at this point, won't care about 
having *all* bugfixes.  Some newer (and thus more buggy) features may be 
so distant from the mainline in those kernels, or so immature, that no 
one will consider them while staying on such an old kernel.

Again, kernel necrophilia pays my bills, so I have some experience there. :)

> It's understandable that maintainers don't have all the time in the
> world for this, but are you really asking not to backport fixes to
> stable trees because you don't have the time for it and don't want
> anyone else to do it instead?

If a bug is serious I *will* do the backport; I literally did this 
specific backport on the first working day after the failure report. 
But not all bugs are created equal and neither are all stable@-worthy 
bugs.  I try to use the "Fixes" tag correctly, but sometimes a bug that 
*technically* is 10-years-old may not be worthwhile or even possible to 
fix even in 5.4.

That said... one thing that would be really, really awesome would be a 
website where you navigate a Linux checkout and for each directory you 
can choose to get a list of stable patches that were Cc-ed to stable@ 
and failed to apply.  A pipedream maybe, but also a great internship 
project. :)

Paolo

> Maybe consider designating someone who knows the subsystem well and does
> have time for this?

