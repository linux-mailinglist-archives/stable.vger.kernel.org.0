Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752A61FB216
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 15:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgFPN21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 09:28:27 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34317 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgFPN20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 09:28:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 83E615C0032;
        Tue, 16 Jun 2020 09:28:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 16 Jun 2020 09:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=0Vdk2TFdVFqKWkxxxasM2+0H5lq
        SzO3bJJWDJtYmjmk=; b=d8HQ/sGHx2JDwLtqDMjN4erUPLvZr+xqFwZc5Azjw0e
        Md1lWuqkwEudLKjsOSnfCsqlbLwQRzFr5MzKbDJIGijfW9VL82GoUSDrcFEPdA1j
        HgaVtSdpn+NpmsjOHta6QVPXd+A6xx4NMlTlw/AmcTa/JyZqWof8KdD8v3R22O7t
        W/czueWSBetLxnhHVfQdiKA49RCcH+EK40MV8lf6eA32kCBc1lJGkTsu5yz8vQ8d
        U11ayJWmFmiQ8Nmrojr0I7GF3Osadf0TRNdlu78Q5dGhbE9Y1viXaBhE2DyQaw8n
        pqhXKbXgJWFEdSDPR5+jqsXUp0HpSpWIuO4IHTEp58g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0Vdk2T
        FdVFqKWkxxxasM2+0H5lqSzO3bJJWDJtYmjmk=; b=d/X8KyIPgUl9bzBmmD89O/
        FoYh2/DlyH2xuY5Fx/NG6YafsHGihRlqur+vszqS7dGkYwNjeQrQWcNuV8M8kvac
        jTVV/0Kab8NXsfGzZrbhbp/YURS3gyJrKIRha/uTa40kTF5c/plTeDTQk9Elgjqu
        zAoLbtZQ0PLu4JKFCQR315Sxc//Eb6VaopLuurvRdZb3MYgWMuP3xvvqOoXEPxkr
        e8MLPTRQjadfF/MYQROoKfeb4/+bxx3s5Wy12eIBB34I6DFn/7gbp57J9kYLj4rV
        7ih7/qO2XGkaPHEb6nxo3ImQo9eWPMN02NH3alkw0KqbMyhboJq4A5fK76oYMgKA
        ==
X-ME-Sender: <xms:-cjoXnBkavGM-L4_qr3lnaNq_nh2gUeMc_WBtqJSKvKTVadopjhBsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejtddgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:-cjoXth_v18wB_6XfqVDOfVTvnz2YLgHf-RIyJiMqDlwZYY-dnduAQ>
    <xmx:-cjoXinX5fMmMwMfFqR96Ie5FhOqOQpYFGEIAacprcI1aj4HnkNVfw>
    <xmx:-cjoXpze2oQ25va57wvmxfO5CApNiNOngkvLSmh2mGdxFzrH-5wuVQ>
    <xmx:-cjoXl5Qfenjq2w6NR6Z-WT_l_YosBPd6z7AjWhSZLi19QLjb34H0w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ECB243061CCB;
        Tue, 16 Jun 2020 09:28:24 -0400 (EDT)
Date:   Tue, 16 Jun 2020 15:28:20 +0200
From:   Greg KH <greg@kroah.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org, kernel-team@android.com,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH stable-5.7] KVM: arm64: Synchronize sysreg state on
 injecting an AArch32 exception
Message-ID: <20200616132820.GB4019625@kroah.com>
References: <20200616125200.2024340-1-maz@kernel.org>
 <20200616130916.GB3932158@kroah.com>
 <4380fcb75d3c486919dd6fe65ce9a6c1@kernel.org>
 <c8941df9ac547d845c8f248b139908bf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8941df9ac547d845c8f248b139908bf@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 02:21:11PM +0100, Marc Zyngier wrote:
> On 2020-06-16 14:19, Marc Zyngier wrote:
> > Hi Greg,
> > 
> > On 2020-06-16 14:09, Greg KH wrote:
> > > On Tue, Jun 16, 2020 at 01:52:00PM +0100, Marc Zyngier wrote:
> > > > commit 0370964dd3ff7d3d406f292cb443a927952cbd05 upstream
> > > > 
> > > > On a VHE system, the EL1 state is left in the CPU most of the time,
> > > > and only syncronized back to memory when vcpu_put() is called (most
> > > > of the time on preemption).
> > > > 
> > > > Which means that when injecting an exception, we'd better have a way
> > > > to either:
> > > > (1) write directly to the EL1 sysregs
> > > > (2) synchronize the state back to memory, and do the changes there
> > > > 
> > > > For an AArch64, we already do (1), so we are safe. Unfortunately,
> > > > doing the same thing for AArch32 would be pretty invasive. Instead,
> > > > we can easily implement (2) by calling the put/load architectural
> > > > backends, and keep preemption disabled. We can then reload the
> > > > state back into EL1.
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Reported-by: James Morse <james.morse@arm.com>
> > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > ---
> > > >  virt/kvm/arm/aarch32.c | 28 ++++++++++++++++++++++++++++
> > > >  1 file changed, 28 insertions(+)
> > > 
> > > Thanks for this, and the other backport.  Queued up.
> > 
> > You seem to have queued the same patches for 5.4 and 5.6.
> 
> Huh, and 4.19 as well. Gahh...

Oops, sorry, my fault.

I'll go drop them now, thanks.

greg k-h
