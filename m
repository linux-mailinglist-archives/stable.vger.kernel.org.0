Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01168768ED
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbfGZNsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:48:05 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:46059 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388036AbfGZNsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 09:48:04 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9DA8E5B5;
        Fri, 26 Jul 2019 09:48:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 26 Jul 2019 09:48:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=EwBpIkjhCHtc6Po0QEhUGVxUPV9
        vvyQZliRF9TyzIsw=; b=TuZpe1Nk0q/BOxdUgTXVqKmed6/8769jGxywKgLJ7Ok
        aKoIHR7vG+pP09vplXewjZXdn44bfCuodsSZm7w+BB6xkHJsxijVQDxWbIFZguNd
        WUAMuIadKIae+ziCON8pz4Kw34mcIUQCjgReYu5OGcGmz2oO9G5X/w8s3oTkWXbL
        brufs+Qtr7/v0JU6u7EQKZcgWujewbF/y/vcSlsWtsTg4E7EPKvfr3QcbYU5YYVC
        RFBKDn2tPzO/6LQzHt1mdGH0Yl0ViNyTy9wASG9CcvOF0v9tfOo/vd4rxGUaO2iF
        n9WMU77YbyDPDdBKan1UcJ3+klT4gDG+xaixVaYDzkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EwBpIk
        jhCHtc6Po0QEhUGVxUPV9vvyQZliRF9TyzIsw=; b=pSlIkRnRajFAAKrhMWR0nF
        ciGnPNIcILZ/TwwalAjPGFPxCget17THr/UOL2MvXxPkf09ovVO/rtjaU75ZB3/D
        W/w++jTgRZdCmk4iMLmY1s4LOHfMfGm1Q677Pt+Zj8HLw2bHgjlHKGTUg6KVgnxl
        //vhKI8qE3dCEZMpI+cqB3iIsBjCUWlMnQRX+C63tzZFPqAvC0B17ALmEoVDKqK5
        lE3kwD1Zs2WA4jaVVFX2wErQTNFYstng3breWrR293AkIsLwD9YxPdSBiOCiJLdd
        wNnfLb0FbLa7GPREuTh60Om4QBEQGMImlyaGNR6kkp4gLr8MzQcPoV+MWn9q6tXA
        ==
X-ME-Sender: <xms:kgQ7XUzzqfCSn_myxjMq4PC-VB9hFVqwZEkMYNjjWQQ3dfWEtz6pkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeggdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:kgQ7XbozBuhl0-RHB9XXsPFLlKVCqQkfG9THTamB2ZQ15-8tOORpyA>
    <xmx:kgQ7XRk1nIlbiZe0Sq-KrILzoq9b-dFwSrPD_HJUR5BRRZGLMMjnQg>
    <xmx:kgQ7XUCB_8YJ6eOFctKG6ApUxSt8QH57q3JiJIqsDFY8fBDb3jgHbg>
    <xmx:kwQ7XW3d_regz52ZsMOFHmxRgATolIEq4VYi6RqKmBux6kfh_gBBbQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7A03C380086;
        Fri, 26 Jul 2019 09:48:02 -0400 (EDT)
Date:   Fri, 26 Jul 2019 15:48:00 +0200
From:   Greg KH <greg@kroah.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     stable@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH stable-4.19 0/2] KVM: nVMX: guest reset fixes
Message-ID: <20190726134800.GA23085@kroah.com>
References: <20190725104645.30642-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725104645.30642-1-vkuznets@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 12:46:43PM +0200, Vitaly Kuznetsov wrote:
> Few patches were recently marked for stable@ but commits are not
> backportable as-is and require a few tweaks. Here is 4.19 stable backport.
> 
> Jan Kiszka (1):
>   KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested
> 
> Paolo Bonzini (1):
>   KVM: nVMX: do not use dangling shadow VMCS after guest reset
> 
>  arch/x86/kvm/vmx.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

All now applied, thanks!

greg k-h
