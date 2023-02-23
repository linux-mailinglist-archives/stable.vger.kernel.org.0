Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31906A0475
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjBWJHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbjBWJHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:07:14 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D169848E38;
        Thu, 23 Feb 2023 01:07:12 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 835E65C011B;
        Thu, 23 Feb 2023 04:07:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 23 Feb 2023 04:07:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1677143230; x=1677229630; bh=SlVfI1SWS9
        Y9mAoOlL1DgHom0T2b0UsGN6oj+8Qk3tw=; b=LohVrk+XhC9T3KQKLiRhC93SSN
        QAHm3KubWcAV4ILHy13r8Xy++QRQImr/VMeU8quz05stfigL3om8CrgH0LlAYYHp
        pR7V8krmjn6ThaFCImZNoWlFuZSXb/VVHXq1GVbm9CgTqVqxNmQjynNkzrVycvmG
        QR74rLaHCNZBhhZymObWtDPJggD9IXNfDzZ4b+ePZGewmBYL58hFWzQm9fx0tlV/
        DVtfLQJ+hKnJ8/ThsD+G8x8sa5GRSPvcJ6CH6wOqAHS98AeNn6+JbM4SGpiIcxqn
        m+i5D/cGfLZeKYTaEeVTFj/LiBxZblXDt0be6L4bfJxwHBSKRZcDkHWkMBSg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677143230; x=1677229630; bh=SlVfI1SWS9Y9mAoOlL1DgHom0T2b
        0UsGN6oj+8Qk3tw=; b=oRwhlMhbufKMqAkr4BMofP+qUyGKRguKNjhrHD/sQgUh
        Ja3wvw9yK6NW2lT1KaAtzPYVzwIc7B/Sa0bv1ig39ECa0da+gKIfoG5MNFDr1dsP
        dVBBjlq898NXy2+eJJeQB+LNKTuNYWFo1zr+em8Mvc4doZVbUzupB6MhPeo1pFct
        B9/tcyGKgzrkILfLZiK3TZQzDfi08BIGltEvJVn1e+DqMrqVVS9cKE6KAtuAvHnX
        IR+fU86UUce7haoph36NRgtdmI9y+Slc87r8dLxVjRCEjpKdBtHHQA89RnI/6P33
        IWkiImBAq6fG2zA84FUjVWw0vxj3QBzXwL0s1TLmUg==
X-ME-Sender: <xms:viz3Yz2m1jn7N-IzAh2fB4WFJ6Be8Br4Nmp3Fd1ThbdGUrnP_1LHyA>
    <xme:viz3YyGy8eduZUTDoLWjGDbJPQWaoqRllhmGzXjTL66qHpOSYMmqDFaGacnDlON6U
    u0DuTedha_TFA>
X-ME-Received: <xmr:viz3Yz7WvrPPiSlnzO3RPOj2Gbl8Q96x5MnX1qCc9Xo61u5i6tjjR5aGuAoVKNTlfYuQ8YqHxOuDEI-UeMoziQpYwzrVCspl7ad8gw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudektddguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeghe
    euhefgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhm
    rghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:viz3Y41YyIZ1lOgyQ2AkviRg2_FQDIww94J38mfkuDrKup24n4E8UA>
    <xmx:viz3Y2EmHIdE23Y7luZGLhmvGKZmTyK-nImBfVNaqwdep7HGZPWeWA>
    <xmx:viz3Y58ZytGAXg-lSD2wSiOVuqcw7GG7L6x4F2WlKno5tICUHZf40Q>
    <xmx:viz3Y-8SzdoUeT50BEPLbyjnkvrHE1AFPcpXsx3gnrz5byHBZMnJ8w>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Feb 2023 04:07:09 -0500 (EST)
Date:   Thu, 23 Feb 2023 10:07:07 +0100
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Cc:     stable@vger.kernel.org, pbonzini@redhat.com, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 6.1/5.15/5.10/5.4 1/1] KVM: VMX: Execute IBPB on emulated
 VM-exit when guest has IBRS
Message-ID: <Y/csu6ScK0XqhIPL@kroah.com>
References: <20230222100625.1409958-1-ovidiu.panait@eng.windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222100625.1409958-1-ovidiu.panait@eng.windriver.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 22, 2023 at 12:06:25PM +0200, Ovidiu Panait wrote:
> From: Jim Mattson <jmattson@google.com>
> 
> commit 2e7eab81425ad6c875f2ed47c0ce01e78afc38a5 upstream.
> 
> According to Intel's document on Indirect Branch Restricted
> Speculation, "Enabling IBRS does not prevent software from controlling
> the predicted targets of indirect branches of unrelated software
> executed later at the same predictor mode (for example, between two
> different user applications, or two different virtual machines). Such
> isolation can be ensured through use of the Indirect Branch Predictor
> Barrier (IBPB) command." This applies to both basic and enhanced IBRS.
> 
> Since L1 and L2 VMs share hardware predictor modes (guest-user and
> guest-kernel), hardware IBRS is not sufficient to virtualize
> IBRS. (The way that basic IBRS is implemented on pre-eIBRS parts,
> hardware IBRS is actually sufficient in practice, even though it isn't
> sufficient architecturally.)
> 
> For virtual CPUs that support IBRS, add an indirect branch prediction
> barrier on emulated VM-exit, to ensure that the predicted targets of
> indirect branches executed in L1 cannot be controlled by software that
> was executed in L2.
> 
> Since we typically don't intercept guest writes to IA32_SPEC_CTRL,
> perform the IBPB at emulated VM-exit regardless of the current
> IA32_SPEC_CTRL.IBRS value, even though the IBPB could technically be
> deferred until L1 sets IA32_SPEC_CTRL.IBRS, if IA32_SPEC_CTRL.IBRS is
> clear at emulated VM-exit.
> 
> This is CVE-2022-2196.
> 
> Fixes: 5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02")
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Link: https://lore.kernel.org/r/20221019213620.1953281-3-jmattson@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@eng.windriver.com>
> ---

This was already added to the queues, thanks.

greg k-h
