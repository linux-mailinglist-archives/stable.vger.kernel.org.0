Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 897DD557C9
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 21:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfFYTaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 15:30:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727709AbfFYTaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 15:30:23 -0400
Received: from localhost (unknown [167.220.24.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6C6220883;
        Tue, 25 Jun 2019 19:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561491022;
        bh=1B1lXkMUpm+QSfDLbuQelPWey4SBFgw4l2TH/2xtg/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HPYkDvlGax0DeaALBAsSiY/k7au/Bh69swvfXkylveZH9Xgh+hsfdPO2flwHNNZ51
         dE28i2D1Iau9pDaVvh6nZsK/Sou8liAQf3bRR066z1ZdVPqgt83PKkw4vzDCV+0IQz
         Jksj5xwhu1myLlshbcKRIno8XFXzPAJP737zo7a0=
Date:   Tue, 25 Jun 2019 15:30:20 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jiri Palecek <jpalecek@web.de>
Cc:     stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Allocate PAE root array when using SVM's
 32-bit NPT
Message-ID: <20190625193020.GA7898@sasha-vm>
References: <1561321670157164@kroah.com>
 <87mui6djuj.fsf@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87mui6djuj.fsf@debian>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 12:45:24PM +0200, Jiri Palecek wrote:
>Original commit id b6b80c78 ported to stable/linux-4.19.y.
>
>SVM's Nested Page Tables (NPT) reuses x86 paging for the host-controlled
>page walk.  For 32-bit KVM, this means PAE paging is used even when TDP
>is enabled, i.e. the PAE root array needs to be allocated.
>
>Fixes: ee6268ba3a68 ("KVM: x86: Skip pae_root shadow allocation if tdp enabled")
>Cc: stable@vger.kernel.org
>Reported-by: Jiri Palecek <jpalecek@web.de>
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Could you add your signed-off-by please?

--
Thanks,
Sasha
