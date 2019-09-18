Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8601B66EF
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 17:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfIRPUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 11:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfIRPUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 11:20:48 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ED7721907;
        Wed, 18 Sep 2019 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568820048;
        bh=3aLYvdE+34rtwhZUbphrzRj9DwPp9/Pn2+viAXCPVjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l6RpybC3Ta/Bs/8FqrVs/SFQGrRAhnj6n20ADappmPVwye0wHsM+0aUpwgtO97rGa
         mc/sZZEatPYv3ot2rg01M9Xaf8Pfy2TuuQlAbCq1fbZAFfEkEXJIKw1E/HWaBHLOaZ
         1Le4EmBT8uOpiSHBaPsTCL53ioD73yqTv8ttszO4=
Date:   Wed, 18 Sep 2019 16:20:43 +0100
From:   Will Deacon <will@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kernellwp@gmail.com, gregkh@linuxfoundation.org,
        Matt Delco <delco@chromium.org>, stable@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: coalesced_mmio: add bounds checking
Message-ID: <20190918152042.de4gxtaf3ddfyhyt@willie-the-truck>
References: <1568815302-21319-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568815302-21319-1-git-send-email-pbonzini@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 04:01:42PM +0200, Paolo Bonzini wrote:
> From: Matt Delco <delco@chromium.org>
> 
> The first/last indexes are typically shared with a user app.
> The app can change the 'last' index that the kernel uses
> to store the next result.  This change sanity checks the index
> before using it for writing to a potentially arbitrary address.
> 
> This fixes CVE-2019-14821.
> 
> Cc: stable@vger.kernel.org
> Fixes: 5f94c1741bdc ("KVM: Add coalesced MMIO support (common part)")
> Signed-off-by: Matt Delco <delco@chromium.org>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reported-by: syzbot+983c866c3dd6efa3662a@syzkaller.appspotmail.com
> [Use READ_ONCE. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/coalesced_mmio.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
