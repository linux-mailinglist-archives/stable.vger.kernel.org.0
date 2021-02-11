Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAC4318D42
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 15:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhBKOWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 09:22:54 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:60409 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231419AbhBKOU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 09:20:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 42C435802B1;
        Thu, 11 Feb 2021 09:19:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Feb 2021 09:19:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=YMJRaCtkHieJBNb9J1X6VVrVX9S
        eNyMMz47nMnLDBZI=; b=PJWwH4P4Q8iRZEOV2XlknWmhpZcihU+j4UlXaqjyAvY
        W5TdYVXX23xV8SyIAoyCI5eFRTOW4f8QQnacTyKCeoLIT1K/H+5GenyDyTk15Eu3
        WCy6GjPjZoXiAmty4ItIbDa7fHbIdrAGkKtKlt+Ck8/mF5/uJkiUxDT77zTjiH08
        Twg/23JUwvj4H3oWHOmCAANZK9VKBAxXybYTqW8Fd8ugr0gzsizM1sw2iqB6YhkT
        crzxxry9MKTP6KuT+QJEKsoO4OsoQNNHi8xv9AE4FMObRTrslfRhnvd3bOxy7dc0
        kqeYl4zKRc1UXyKoEvgvc3Sq8PXEnbHnx2NclW/5CLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YMJRaC
        tkHieJBNb9J1X6VVrVX9SeNyMMz47nMnLDBZI=; b=oMtVOlVIdcdP/e2AxD5k0k
        bEbSOPsM0/CfVrwjMnNNJB6JYtKDYbhXZHPvZuZuOyUFxkpL7F+4kxXhsgeT9YmW
        YjQWq+CbEe32i2umHb3FmM5BfLada4H05UtstV21f5f5em4URWIDNudNl7mjjOo6
        NNgzQJ1qi13fvib8eMjXEBT9hSWaiy326FgnSOVyyIDBoOayzu7FqI53YCv02d6n
        XJZN3lDXF39LK5tWBNpdAEvYiHKkFl7Cq4Rc9qUjbsD90iihyT/3XyqHh1aAuufl
        EM57AN0gNNPM4jTTUuP3dndyZWJQEa354D+KF6rHIcdxe0mW3BsNhxqurCo483pg
        ==
X-ME-Sender: <xms:-jwlYNLOJbxVGbGn-a3MyUFGKhVD2zFJpT2WRbAQcAwkCKYt1Jm0oA>
    <xme:-jwlYJLXdyGPQ-iZvrH53sXR2YIUDrXsBXp-Dn_SvVWNjwN7aJVFizbHuMfqmZgVK
    H39ZOol6-EidQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheelgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:-jwlYFtNrDl9PNr2TyGpMJ1UJTW5dLrBP74PoU8mHR9uMEvp7YWD5g>
    <xmx:-jwlYOYdpNpERSS9ZrPNLL0dgKllhqdNaUTveJChnKXOxKts6gwN4A>
    <xmx:-jwlYEYjCcuoksBu_6SU0-D4WlfnR5rUGpHwb2SyJPMrPSaBHxV4Dg>
    <xmx:-zwlYBQTt2unJiwmRBw-xWoU1qMFx4c2KI2zeyF23cD8HU_KNgEokw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DF9F61080067;
        Thu, 11 Feb 2021 09:19:37 -0500 (EST)
Date:   Thu, 11 Feb 2021 15:19:36 +0100
From:   Greg KH <greg@kroah.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for 5.4] Fix unsynchronized access to sev members through
 svm_register_enc_region
Message-ID: <YCU8+Piht0VZzrzx@kroah.com>
References: <20210208164855.772287-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208164855.772287-1-pgonda@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 08:48:55AM -0800, Peter Gonda wrote:
> commit 19a23da53932bc8011220bd8c410cb76012de004 upstream.
> 
> Grab kvm->lock before pinning memory when registering an encrypted
> region; sev_pin_memory() relies on kvm->lock being held to ensure
> correctness when checking and updating the number of pinned pages.
> 
> Add a lockdep assertion to help prevent future regressions.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: 1e80fdc09d12 ("KVM: SVM: Pin guest memory when SEV is active")
> Signed-off-by: Peter Gonda <pgonda@google.com>
> 
> V2
>  - Fix up patch description
>  - Correct file paths svm.c -> sev.c
>  - Add unlock of kvm->lock on sev_pin_memory error
> 
> V1
>  - https://lore.kernel.org/kvm/20210126185431.1824530-1-pgonda@google.com/
> 
> Message-Id: <20210127161524.2832400-1-pgonda@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)a

Both backports now queued up, thanks.

greg k-h
