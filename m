Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28902696C59
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 19:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbjBNSHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 13:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbjBNSHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 13:07:05 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1822ED7A;
        Tue, 14 Feb 2023 10:07:02 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 79EA05C0154;
        Tue, 14 Feb 2023 13:07:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 14 Feb 2023 13:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1676398020; x=1676484420; bh=2vEumOitJz
        p7mZeo1LyjVeDNF3glQyrVaaSOFva2+jo=; b=bFVpBUrR4iEbsG5houHxYRNTCu
        jmCOo7eZjnUgh8m0vrHwfxjK33uxIeie8FWg8pWmd8iMhrtU3czvG6rVxCJrQA3N
        +LZC9PeqjlGbTC0uF0yyD+jdxOWpC5gZKL10JJ5GzTAxT6xd3uo9qFem89/vK5aR
        hcf+v8BtfInn+DMtlHbTwfPilPF0/pkpLX7/2+HOyV9mM3rbfZct95jx2f+hPHWo
        SYe+mcDa3fm8MYLeDkpXtZx91iK6bdgV7PpCGJkLPJwTmWJ+bh10IxPZsBm8Uhob
        f/j6rDm3W59kkFXu2GckxPNnA3mzWNRHAKoAB+1mQ92KTW5+SA2e5D124/AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676398020; x=1676484420; bh=2vEumOitJzp7mZeo1LyjVeDNF3gl
        QyrVaaSOFva2+jo=; b=iac1zJ7mZan6Y03ZbbcPHZh0C15vYgllxFOYxRFGKPvN
        6lLcAl1uOxsJLBjcM4AcqGkG0m/0ERFve11tyS8tbUMXQZazUt9SYPZaUFlaUDZ9
        1y1PMUtQ7sjNpI9n/RBEyT0yLM24w00aRwmsSqQC2UWtAKQB0m/neuD3ZAxBoyI3
        v4kwQiF8f/Yf2JtAJtzH2nBtG+anV2OAGjGEI4ayhWghhcDCBNWXZ+kPVTzEInO5
        dk8xJQB6NYlAkxqXPzIc41RM5nDHfzVBnuw7tLBc0gw+/UwCBYgGKt4Lv5FY1bHI
        RKtWxjvIWk8mcflPpVesDmL6SmgKsY9z9t1ndWKI8g==
X-ME-Sender: <xms:xM3rY4tQhTZs5gbxt56m7DBJb-zJi35Uev-MtpoktAsh6vLTGumkkA>
    <xme:xM3rY1dJOg85g7VjSgPQqTSd_coZCcMwasHSp24fe8Q2yulZ-vldG2mW7hvkXX184
    t6fAOaMGKoVTw>
X-ME-Received: <xmr:xM3rYzy8Sd_lO1mlEfJ07L0vYpG80MQSFWcUD_ECVu0b9cS_xrLV-kCL1Za1Hl-YY3qkNFbNuf4uMPQ0KhDi56XovHL8UrSYSgTdfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeifedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:xM3rY7N5tiVbS4pdhfOTudq-jnlRa5UiCWh5YzeSaham3bpxDLhDiQ>
    <xmx:xM3rY49nUKeu5uT6_tBpUUccHZ8Lm_2UHKvf2lDPDjdKv7E--VHDsg>
    <xmx:xM3rYzUuAXV-7nZA62dnGpNWZ5uk4qEpNAy_apzSQZNm2fqP3wOVtg>
    <xmx:xM3rY8QrEEjqEC9r_4_3puj3emhNA-zgfx0YROy7hgmgR-wW5sAI7w>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Feb 2023 13:06:59 -0500 (EST)
Date:   Tue, 14 Feb 2023 19:06:51 +0100
From:   Greg KH <greg@kroah.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, thomas.lendacky@amd.com
Subject: Re: [PATCH for-5.15 0/3] Cross-Thread Return Address Predictions
 vulnerability
Message-ID: <Y+vNu+vaxPFN8Sy7@kroah.com>
References: <20230214170956.1297309-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214170956.1297309-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 12:09:53PM -0500, Paolo Bonzini wrote:
> Certain AMD processors are vulnerable to a cross-thread return address
> predictions bug. When running in SMT mode and one of the sibling threads
> transitions out of C0 state, the other thread gets access to twice as many
> entries in the RSB, but unfortunately the predictions of the now-halted
> logical processor are not purged.  Therefore, the executing processor
> could speculatively execute from locations that the now-halted processor
> had trained the RSB on.
> 
> The Spectre v2 mitigations cover the Linux kernel, as it fills the RSB
> when context switching to the idle thread. However, KVM allows a VMM to
> prevent exiting guest mode when transitioning out of C0 using the
> KVM_CAP_X86_DISABLE_EXITS capability can be used by a VMM to change this
> behavior. To mitigate the cross-thread return address predictions bug,
> a VMM must not be allowed to override the default behavior to intercept
> C0 transitions.
> 
> These patches introduce a KVM module parameter that, if set, will prevent
> the user from disabling the HLT, MWAIT and CSTATE exits.
> 
> The patches apply to the 5.15 stable tree, and Greg has already received
> them through a git bundle.  The difference is only in context, but it is
> too much for "git cherry-pick" so here they are.

Thanks for these, all now queued up.

greg k-h
