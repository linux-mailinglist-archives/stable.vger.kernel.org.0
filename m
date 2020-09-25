Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18175277FAB
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 06:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgIYEyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 00:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbgIYEyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 00:54:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF77321D7A;
        Fri, 25 Sep 2020 04:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601009678;
        bh=h7FyJwa0j7bb050Q3boEyo/OC0K0iQoDqaVnBjWhwb0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lBSJt+Wd4aZELMIXz5Ev3oyhWbFQWFTHiR8hT3rkVqEkWtvjyv6nDvgXErjKpeGhO
         sX1tCweOVdCAZDDjk0fpgE5Vvy5PfyWS2mSL71zrwqIKDkj8xI7kE4y3RkDP6qVs8s
         m6YYPsegrR7QlhjwHfzpuY3BmAo2KaEEnnG8uZBw=
Date:   Fri, 25 Sep 2020 06:54:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cfir Cohen <cfir@google.com>
Cc:     "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Lendacky Thomas <thomas.lendacky@amd.com>,
        Singh Brijesh <brijesh.singh@amd.com>,
        Grimm Jon <Jon.Grimm@amd.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Mark SEV launch secret pages as dirty.
Message-ID: <20200925045434.GA602062@kroah.com>
References: <20200807012303.3769170-1-cfir@google.com>
 <20200925020011.1159247-1-cfir@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925020011.1159247-1-cfir@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 24, 2020 at 07:00:11PM -0700, Cfir Cohen wrote:
> The LAUNCH_SECRET command performs encryption of the
> launch secret memory contents. Mark pinned pages as
> dirty, before unpinning them.
> This matches the logic in sev_launch_update_data().
> 
> Fixes: 9c5e0afaf157 ("KVM: SVM: Add support for SEV LAUNCH_SECRET command")
> Signed-off-by: Cfir Cohen <cfir@google.com>
> ---
> Changelog since v2:
>  - Added 'Fixes' tag, updated comments.
> Changelog since v1:
>  - Updated commit message.
> 
>  arch/x86/kvm/svm/sev.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
