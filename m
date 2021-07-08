Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636133C192A
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 20:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhGHS26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 14:28:58 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51083 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhGHS24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 14:28:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3A7F15C0089;
        Thu,  8 Jul 2021 14:26:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 08 Jul 2021 14:26:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=S8D7Qs+0Wjm5NbLoskwvXCI0Dkl
        Ik3rjjWxxDQC51s0=; b=TclItcmYjlWSCc9AKLRKvu9UYUecM2rOmmUCtyUjzt2
        kZ11VoaH9xtMxUzGaal2gRusHGuOn0jtzNEFX/lO5BTRbGLv0hajKVDa5FxtkA99
        L7R02vXdKfU84WHLP5xV1S/BJA9PQ06vGWnN8CzIIo4gSooFmz5N/uL79KYEzQoi
        cY4ikzdDH18Tv6QCpUh1bol4/iESj03UGmi0VtwYN3jBXTLTAbZcMdKXSBtPykRO
        hmQeUk3g93tFpvl9A0xb3P5s5PI/ioqSdgVM0vbBUMmr4qAv+O1sBTBERVIRADDo
        +IDQYMqg3IXFF5No9/1m0Af3xuS72LEA21fhVDHSr7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=S8D7Qs
        +0Wjm5NbLoskwvXCI0DklIk3rjjWxxDQC51s0=; b=aMe7Agm2mwpAn7919/uNUV
        7uSBqgNHjWTBQyiOzKp+BCtifWW5MLQ+1ngWyiNvtgP5pGo9HHveLf1KKjEAlMzr
        XUfqYV5RrvB6rdVoJJLHlGjGCYMGocfYBDuG+s9dD+EnAHpLg8Ih4Z2geUIBAX3/
        7NpIgnoQ1Wt35gmVA19JeXbJNQ70OBaBNgPMcNIDGph2pAMRPEhRQKbyxyAMhZ6T
        WTpX6ITPfNEac3TwZWQvEXXrNJC/78PxtZde4JhwmmLjrYKyk29lVWSnImGVp8No
        blfPkx0h/roy1JH2ouSCBI15gKoWXw+O9FqWjaSOhJ+lP6tFkfcwqL8pDTFq5NPA
        ==
X-ME-Sender: <xms:RUPnYGI_ryA6KiBa1o7GbWyHNHPkUp9fXq7Eg5TuQqDtf8WkdOuDZA>
    <xme:RUPnYOIk3g-4bw62A3FijZhU-JngJ928jCl74wkOxuxXUADXCgVihy1LrxkGbprdr
    sBDMxG4lZ0X4g>
X-ME-Received: <xmr:RUPnYGsYcUon6rkPHBvDvs7OQ_4HtsJFLO2iPxxPGc_bzNcsof_C_t1VcQLmPH-TB2jp04CiCU4GNpe5ClHj2nIPUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrtdeggdduvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:RUPnYLbznt9Sdj5e02v06EGmh8ym8EzU9PyvjYLeec4ME9IV5KVtKA>
    <xmx:RUPnYNYMr8Gpj9lltIDOtfjDnt6dPt5Wd2jrU87_Uec_VBfW0QXSRQ>
    <xmx:RUPnYHBXP6f8MektxkbQhnZi4s_6xOYokSjfzYZHCkiFHt8mT780Sg>
    <xmx:RkPnYLPxEjF9LrbgmbBtxvDkFVtuFbrtTE4hAYMkbbO0weox_t_V7A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jul 2021 14:26:13 -0400 (EDT)
Date:   Thu, 8 Jul 2021 20:26:11 +0200
From:   Greg KH <greg@kroah.com>
To:     Alper Gun <alpergun@google.com>
Cc:     stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.4] KVM: SVM: Call SEV Guest Decommission if ASID
 binding fails
Message-ID: <YOdDQwf/qY21W5uR@kroah.com>
References: <20210628211054.61528-1-alpergun@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628211054.61528-1-alpergun@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 09:10:54PM +0000, Alper Gun wrote:
> commit 934002cd660b035b926438244b4294e647507e13 upstream.
> 
> Send SEV_CMD_DECOMMISSION command to PSP firmware if ASID binding
> fails. If a failure happens after  a successful LAUNCH_START command,
> a decommission command should be executed. Otherwise, guest context
> will be unfreed inside the AMD SP. After the firmware will not have
> memory to allocate more SEV guest context, LAUNCH_START command will
> begin to fail with SEV_RET_RESOURCE_LIMIT error.
> 
> The existing code calls decommission inside sev_unbind_asid, but it is
> not called if a failure happens before guest activation succeeds. If
> sev_bind_asid fails, decommission is never called. PSP firmware has a
> limit for the number of guests. If sev_asid_binding fails many times,
> PSP firmware will not have resources to create another guest context.
> 
> Cc: stable@vger.kernel.org
> Fixes: 59414c989220 ("KVM: SVM: Add support for KVM_SEV_LAUNCH_START command")
> Reported-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: Alper Gun <alpergun@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <20210610174604.2554090-1-alpergun@google.com>
> ---
>  arch/x86/kvm/svm.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)

Now queued up, thanks.

greg k-h
