Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB1530D09C
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 02:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbhBCBFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 20:05:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhBCBFs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 20:05:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EA6564F50;
        Wed,  3 Feb 2021 01:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612314307;
        bh=bIDmI39SbvxywPKQvKWpiiXDWwvHe9jBvk1F6iVP8oY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=egAjbNvxrrcA5o6tlQgVqkkRJVZ/ixpjM8aNqywORp99it74OZX6f/P/yY1qk4MLn
         bJrARjSMJrhE7tgrxXZ6FIUTkm79w/PV1BZaXx9/TBMq43MraIwgRjy0GH3DBbVLzl
         NDNPY8WHU5DjeVTQnZ8L7OUjH5mARsQLuuRZ20ky5sw6xoulyylvhgZ4uZEbHHlyZx
         i94xCwpteORA2rxy+b9ZotIrQr1A3IGmYat7yFb2dDQCJA6A8vH4s/uk2olB5ZNNfY
         1R7Pmz6stVaJ86brV4UR2/JeHlAZ72T/04Rj0Is2zvHzQ9fD60WHDjNhXL88LXw8qL
         5GZV7M7VZ06BA==
Date:   Tue, 2 Feb 2021 20:05:06 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Quentin Perret <qperret@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.10 066/142] KVM: Documentation: Fix spec for
 KVM_CAP_ENABLE_CAP_VM
Message-ID: <20210203010506.GU4035784@sasha-vm>
References: <20210202132957.692094111@linuxfoundation.org>
 <20210202133000.449940320@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210202133000.449940320@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 02:37:09PM +0100, Greg Kroah-Hartman wrote:
>From: Quentin Perret <qperret@google.com>
>
>commit a10f373ad3c760dd40b41e2f69a800ee7b8da15e upstream.
>
>The documentation classifies KVM_ENABLE_CAP with KVM_CAP_ENABLE_CAP_VM
>as a vcpu ioctl, which is incorrect. Fix it by specifying it as a VM
>ioctl.
>
>Fixes: e5d83c74a580 ("kvm: make KVM_CAP_ENABLE_CAP_VM architecture agnostic")
>Signed-off-by: Quentin Perret <qperret@google.com>
>Message-Id: <20210108165349.747359-1-qperret@google.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>---
> Documentation/virt/kvm/api.rst |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>--- a/Documentation/virt/kvm/api.rst
>+++ b/Documentation/virt/kvm/api.rst
>@@ -1319,7 +1319,7 @@ documentation when it pops into existenc
>
> :Capability: KVM_CAP_ENABLE_CAP_VM
> :Architectures: all
>-:Type: vcpu ioctl
>+:Type: vm ioctl
> :Parameters: struct kvm_enable_cap (in)
> :Returns: 0 on success; -1 on error

Um, how did this patch made it in?

-- 
Thanks,
Sasha
