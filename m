Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5A41FB1B8
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 15:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgFPNJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 09:09:23 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41857 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727966AbgFPNJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 09:09:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id A99AD5C00CC;
        Tue, 16 Jun 2020 09:09:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 16 Jun 2020 09:09:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=SGfS1oaev7CuM0/Rjg3cna9aAU2
        +Gh4jA5IxO+dqbd0=; b=KNzXg1bnm5XXjiT3D+m/E0XkfBMst2TsOrq3/TUAhAR
        rKFYttqkjfc0MJWJKe/IYXVMoBndpkBiiZJg4Rp260TFqq8Sn9SvbatkwGwkNjxO
        iR7X+B+iNrsBoPbxxoClaVAv6Mi6Y3YljrRIevLTXvgGl+96m70L9XOq1wiPT+t6
        RkEVJpxO66yFR0prVIIUOkNRKPDzlG/dYAAHe4s9rki41VS2maFUkCAVwrU/BtiD
        KlfHtfvMGEQth0aq0MgkhgvJUtLct057BlqKDnL335qZ3rHec7EzZSq42y31uN7y
        xlb5mfDgfqnagv+8BneGWc/axn4+k9YDVQZQ1yLCnyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SGfS1o
        aev7CuM0/Rjg3cna9aAU2+Gh4jA5IxO+dqbd0=; b=n7Fqq2KcdOiDdcT/Bi/UY9
        5chrTvarjUYBeuhLai1gNdhIa2hNSTIwlIPt0A7/y2/EJDWcjvIbwyomSFniR4EN
        OhwYAnuJuYCA5bjBQ6ndWsp0+uRQ2Eekf5RUmyGWT1kRoD6hZV+alELq3p9RKAlk
        /YQ862Ai50h6HTk4abVdoVJh3qDnYFszQGxf1TAD1n7E+y2/9p84+Jy7kYCCTm8i
        RlVlX/BlfxbdxReJ8Nf3wg3skejcXovspCqEZTDzCguwjFPKglSAd4Ao0dlfF2Z3
        K8c4sFBmwvP3jDVOmlCisiCTncFYGZgreJCueNyP6i7IM92G3WLf/aP75vJLl+Rw
        ==
X-ME-Sender: <xms:gcToXn09GKQw-NIZ2wCmqaIgU5eKLEHWGsrwh-aJv4D-2VXhyEKHMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejtddgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:gcToXmGYwgI9HxBvHeQdJTg228-r5tyGPOCEvEpwQDiFMOVv00EX4g>
    <xmx:gcToXn5fjpCjfcj5jXE3JYUr8oCldu2SuAXEnJVvaBF1xVzawsDwDQ>
    <xmx:gcToXs1IdQfLec52LuYGjlTc8DQxAsXa4kEmxOqI6ybQSCbZeVv_sQ>
    <xmx:gcToXlOuLEcjcdicS6L7t2pAPWHA8ftxZcpqoDVQS2t-fDJMFQR0BQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B2F9328005A;
        Tue, 16 Jun 2020 09:09:20 -0400 (EDT)
Date:   Tue, 16 Jun 2020 15:09:16 +0200
From:   Greg KH <greg@kroah.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org, kernel-team@android.com,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH stable-5.7] KVM: arm64: Synchronize sysreg state on
 injecting an AArch32 exception
Message-ID: <20200616130916.GB3932158@kroah.com>
References: <20200616125200.2024340-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616125200.2024340-1-maz@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 01:52:00PM +0100, Marc Zyngier wrote:
> commit 0370964dd3ff7d3d406f292cb443a927952cbd05 upstream
> 
> On a VHE system, the EL1 state is left in the CPU most of the time,
> and only syncronized back to memory when vcpu_put() is called (most
> of the time on preemption).
> 
> Which means that when injecting an exception, we'd better have a way
> to either:
> (1) write directly to the EL1 sysregs
> (2) synchronize the state back to memory, and do the changes there
> 
> For an AArch64, we already do (1), so we are safe. Unfortunately,
> doing the same thing for AArch32 would be pretty invasive. Instead,
> we can easily implement (2) by calling the put/load architectural
> backends, and keep preemption disabled. We can then reload the
> state back into EL1.
> 
> Cc: stable@vger.kernel.org
> Reported-by: James Morse <james.morse@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/arm/aarch32.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)

Thanks for this, and the other backport.  Queued up.

greg k-h
