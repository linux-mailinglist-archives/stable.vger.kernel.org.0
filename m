Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4820156C59
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 21:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgBIUMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 15:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:40252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727404AbgBIUMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 15:12:25 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C400720733;
        Sun,  9 Feb 2020 20:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581279145;
        bh=m26k8m+ecfnPqHnSfIs+nHX659/W1Z/s1YAdtHu1VSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bNImmCf4XOWqAKMm1RfIqoXUorKUDcXygSclTaVN4Q7RprLI59T79F3HMkr35YhMa
         /aIo2XK88QJU/X0D/7G0VyyREgGEAIDTOqSSwbSbhsMovb4QSWjFo1M5TyeyEYAXbF
         kdnASSVb5tJGF7AdpjHlM9w8U+mjf0dD7Ta+3RqE=
Date:   Sun, 9 Feb 2020 15:12:23 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: VMX: Add non-canonical check on
 writes to RTIT address" failed to apply to 4.19-stable tree
Message-ID: <20200209201223.GZ3584@sasha-vm>
References: <15812515183712@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15812515183712@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 01:31:58PM +0100, gregkh@linuxfoundation.org wrote:
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
>From fe6ed369fca98e99df55c932b85782a5687526b5 Mon Sep 17 00:00:00 2001
>From: Sean Christopherson <sean.j.christopherson@intel.com>
>Date: Tue, 10 Dec 2019 15:24:32 -0800
>Subject: [PATCH] KVM: VMX: Add non-canonical check on writes to RTIT address
> MSRs
>
>Reject writes to RTIT address MSRs if the data being written is a
>non-canonical address as the MSRs are subject to canonical checks, e.g.
>KVM will trigger an unchecked #GP when loading the values to hardware
>during pt_guest_enter().
>
>Cc: stable@vger.kernel.org
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

File/code movement. Cleaned up and queued for 4.19-4.4.

-- 
Thanks,
Sasha
