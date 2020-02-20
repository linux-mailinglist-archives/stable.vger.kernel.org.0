Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE6F7165D58
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 13:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgBTMOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 07:14:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgBTMOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 07:14:16 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 069D4207FD;
        Thu, 20 Feb 2020 12:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582200856;
        bh=Zjn5vPJa1+ZSrq3LmZGwrG8jCKUGlHXl2cUKL5ftucw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QVbFfY9gfs2JICDrlBlzKA6/V00uQlaW/7+LdIY2z0gJoixIsY19h7G0NdLTMVk4Y
         CSU6kf5/LbVylGEp7LjGmcrpX3yZXnWeemMLc/0FUxqkTTgNjicX94CBM7dlMbrkoM
         wii0AoVymaZD/XB6jsFmE2Dz9J3uvPcZkeiTLytI=
Date:   Thu, 20 Feb 2020 07:14:14 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     gregkh@linuxfoundation.org, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: VMX: Add non-canonical check on
 writes to RTIT address" failed to apply to 4.19-stable tree
Message-ID: <20200220121414.GA1734@sasha-vm>
References: <15812515183712@kroah.com>
 <20200209201223.GZ3584@sasha-vm>
 <fc00f38ef8db90d982dad4de41e97918b565d321.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fc00f38ef8db90d982dad4de41e97918b565d321.camel@codethink.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 20, 2020 at 09:16:51AM +0000, Ben Hutchings wrote:
>On Sun, 2020-02-09 at 15:12 -0500, Sasha Levin wrote:
>> On Sun, Feb 09, 2020 at 01:31:58PM +0100, gregkh@linuxfoundation.org wrote:
>> > The patch below does not apply to the 4.19-stable tree.
>> > If someone wants it applied there, or to any other stable or longterm
>> > tree, then please email the backport, including the original git commit
>> > id to <stable@vger.kernel.org>.
>> >
>> > thanks,
>> >
>> > greg k-h
>> >
>> > ------------------ original commit in Linus's tree ------------------
>> >
>> > From fe6ed369fca98e99df55c932b85782a5687526b5 Mon Sep 17 00:00:00 2001
>> > From: Sean Christopherson <sean.j.christopherson@intel.com>
>> > Date: Tue, 10 Dec 2019 15:24:32 -0800
>> > Subject: [PATCH] KVM: VMX: Add non-canonical check on writes to RTIT address
>> > MSRs
>> >
>> > Reject writes to RTIT address MSRs if the data being written is a
>> > non-canonical address as the MSRs are subject to canonical checks, e.g.
>> > KVM will trigger an unchecked #GP when loading the values to hardware
>> > during pt_guest_enter().
>> >
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>
>> File/code movement. Cleaned up and queued for 4.19-4.4.
>
>I don't know what happened here, but you've ended up adding the
>entirety of arch/x86/kvm/vmx/vmx.c on all those branches rather than
>applying the change to the right file.

Ugh, sorry. I think that I got confused here by 'git cherry-pick'
creating the file when it doesn't exist and it doesn't find the right
file renames.

-- 
Thanks,
Sasha
