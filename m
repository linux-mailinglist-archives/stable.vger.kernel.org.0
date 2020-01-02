Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820CB12E16E
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 02:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgABBL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 20:11:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgABBL6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 20:11:58 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63D1D208C3;
        Thu,  2 Jan 2020 01:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577927517;
        bh=c6uvGuxIkZWQP6pf0O1zj+m1D68g9hbagQ6DzAMQypY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lp1mFnFfjYSWll3xP51wZPEpHbn1lWRSor7cZpc7osD05RWFUHRecZZjMdCeP31aY
         2hbU6QOHiGoLnyxkIJBtjh+nnTNB+SR8GLMA5BJtVK40LSW2nnasK6EuqnFSbYRGhE
         sSrOLQYRX5Wv9eau9wHRB97qi1R8BTkfrZZeXe48=
Date:   Wed, 1 Jan 2020 20:11:56 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     jmattson@google.com, ebiggers@kernel.org, jacobhxu@google.com,
        pbonzini@redhat.com, pshier@google.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] kvm: x86: Host feature SSBD doesn't imply
 guest feature" failed to apply to 4.19-stable tree
Message-ID: <20200102011156.GE16372@sasha-vm>
References: <1577634666179186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1577634666179186@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 04:51:06PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 396d2e878f92ec108e4293f1c77ea3bc90b414ff Mon Sep 17 00:00:00 2001
>From: Jim Mattson <jmattson@google.com>
>Date: Fri, 13 Dec 2019 16:15:15 -0800
>Subject: [PATCH] kvm: x86: Host feature SSBD doesn't imply guest feature
> SPEC_CTRL_SSBD
>
>The host reports support for the synthetic feature X86_FEATURE_SSBD
>when any of the three following hardware features are set:
>  CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31]
>  CPUID.80000008H:EBX.AMD_SSBD[bit 24]
>  CPUID.80000008H:EBX.VIRT_SSBD[bit 25]
>
>Either of the first two hardware features implies the existence of the
>IA32_SPEC_CTRL MSR, but CPUID.80000008H:EBX.VIRT_SSBD[bit 25] does
>not. Therefore, CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31] should only be
>set in the guest if CPUID.(EAX=7,ECX=0):EDX.SSBD[bit 31] or
>CPUID.80000008H:EBX.AMD_SSBD[bit 24] is set on the host.
>
>Fixes: 0c54914d0c52a ("KVM: x86: use Intel speculation bugs and features as derived in generic x86 code")
>Signed-off-by: Jim Mattson <jmattson@google.com>
>Reviewed-by: Jacob Xu <jacobhxu@google.com>
>Reviewed-by: Peter Shier <pshier@google.com>
>Cc: Paolo Bonzini <pbonzini@redhat.com>
>Cc: stable@vger.kernel.org
>Reported-by: Eric Biggers <ebiggers@kernel.org>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I don't think that this is needed on 4.19 and older, but it would be
nice if someone would ack.

-- 
Thanks,
Sasha
