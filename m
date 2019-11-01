Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22BBEBF1F
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 09:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729975AbfKAISw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 04:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730034AbfKAISw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Nov 2019 04:18:52 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97A57208CB;
        Fri,  1 Nov 2019 08:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572596331;
        bh=asDV6Jv1udhmik0e8GZTrjcA/yFx7JhC9wDqE8hzT70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b3CsOsJdMkvq6qeN1p59MyBCxmyX0D0b/qMH6c5Pz9fzq6h4CcINli1OQkhDlsdh5
         luTAwW+m0fpol3FT82WIKGB7WL+b8LUdvv7dbGuqMjZIPhAyZappaTj0zzQmoIZm8w
         3JQFIyY0q5MG756MvxPTdnXrAz7FaPMbifegpqac=
Date:   Fri, 1 Nov 2019 04:07:45 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3.16 47/47] KVM: x86/vPMU: refine kvm_pmu err msg when
 event creation failed
Message-ID: <20191101080745.GT1554@sasha-vm>
References: <lsq.1572026582.631294584@decadent.org.uk>
 <220d8f2c1b299d2e71fdcf50b98286aae5b0c6f2.camel@perches.com>
 <05be6a70382f1990a2ba6aba9ac75dac0c55f7fb.camel@decadent.org.uk>
 <3078d0a186cca2dfae741908ffff41f1bdb30eae.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3078d0a186cca2dfae741908ffff41f1bdb30eae.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 31, 2019 at 03:53:23PM -0700, Joe Perches wrote:
>On Thu, 2019-10-31 at 22:14 +0000, Ben Hutchings wrote:
>> On Fri, 2019-10-25 at 12:05 -0700, Joe Perches wrote:
>> > On Fri, 2019-10-25 at 19:03 +0100, Ben Hutchings wrote:
>> > > 3.16.76-rc1 review patch.  If anyone has any objections, please let me know.
>> >
>> > This seems more like an enhancement than a bug fix.
>> >
>> > Is this really the type of patch that is appropriate
>> > for stable?
>>
>> Apparently so:
>>
>> v4.14.135: eba797dbf352 KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
>> v4.19.61: ba27a25df6df KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
>> v4.4.187: 505c011f9f53 KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
>> v4.9.187: 3984eae04473 KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
>> v5.1.20: edadec197fbf KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
>> v5.2.3: 9f062aef7356 KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed
>
>I think not, but hey, maybe you and Greg do.
>
>Porting enhancements, even trivial ones, imo is
>not a great thing for stable branches.
>
>My perspective is that only bug fixes should be
>applied to stable branches.

Usability issues are just as bad as code bugs. Our human interface is at
least as important as the functionality of our code.

-- 
Thanks,
Sasha
