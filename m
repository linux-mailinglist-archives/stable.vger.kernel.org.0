Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C90380670
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 11:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhENJp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 05:45:28 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54389 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230059AbhENJp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 05:45:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id CB3255C0182;
        Fri, 14 May 2021 05:44:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 14 May 2021 05:44:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nakato.io; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding:content-type; s=fm1; bh=
        9i4NUL/YeDArFkP1t4LXD0ajcgqjLMEAiieLzS+3mpg=; b=Fu8ZLZflJ8gxXjqc
        pTs63whQpIL5TfPZgdovE41yoW9FWCxIbRgLhyEHtTudwATCEDWIpRKoQjHsNrur
        E6r4oPtebHSNophrbQYPyLMAwFYg6NZdoIrrB8cBlUswDsbE8FixQqTeK6YsO7Ge
        2pgVxsz+PMqTTadhLBL2o5R+QAIDakbVmwb9d2c20FVCEmYQCFSnKm5T2o5+a8hL
        e1tx2R3X+FbbCf5GDYFDP+714ODwh/90Cj10TmB23b7M8WOr9+FXRBG7TK3lo6Sf
        8tndYgKZ4lm8Kt/KWAWJFTa9RTiJTd27rf8ndeehGggwTjNgyzPC1b4Z3Y7lQ5uJ
        R8Syrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=9i4NUL/YeDArFkP1t4LXD0ajcgqjLMEAiieLzS+3m
        pg=; b=VMW+xoy6vQ9tzysdguUpgE6RP60HVvWpMGQWT0Tedc4TjC3uqfjg/Kmd9
        A1RvRravFiIl62l4vp0ONOW7AjTgZjLq+U/PcLoqRP5UVEvGU12+vYfxf2eH6Xoh
        k7eD7rwn2UevT6ShFr0Q0q9THxWHl9ZK+FlmmkYOI5o7/a9g3/5t0Amgom/JNLu+
        zIorVavP9Ir8BpyN/A0CF4HpmuRDM4IvX05reXnzLAHRM7ExtMf/JmcEs8Bk/JjO
        LZDpXhoM9H9tBR0afU0GZ4zTjftzymmMFp+i/387n3EAtXdEicpwxHdCEOt9cmdl
        GR8OB8S8QiACIR+yjoePrbk56NjnA==
X-ME-Sender: <xms:b0aeYNJIkeaPBga9_LwaSJgwQyY1Cs1D8_6ZIyhcNJiC2xy9f8AorQ>
    <xme:b0aeYJLJ1jjYa_1JQsxnIbUU65rFHYpVhmBVaSE-yh81T_OywxWxnE16U1AYS9P4v
    91p4jXIJBNnu2BVFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehhedgudegjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkjghfggfgtgesthfuredttddtvdenucfhrhhomhepufgrtghh
    ihcumfhinhhguceonhgrkhgrthhosehnrghkrghtohdrihhoqeenucggtffrrghtthgvrh
    hnpeegvdfgtdfhueevjedvgeeugfeghffggffhieevhfejkedvfeevudduiefgfefhieen
    ucffohhmrghinhepmhhithdrvgguuhenucfkphepvddvtddrvdegtddrkedtrdeitdenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehnrghkrght
    ohesnhgrkhgrthhordhioh
X-ME-Proxy: <xmx:b0aeYFtXhZKzatpOcZAYox89hyeX17bxeThG-vQlFjxomu8ogmN8DA>
    <xmx:b0aeYOZfCeZFEDPNEIysVsltf2WUQJBCEmSgHPyHlDK0QIT0oRiQqg>
    <xmx:b0aeYEY9cnY0BD_I7cGHwttdY_J9Df5BMUzoIvmqbbrMOV-4dEeWxw>
    <xmx:cEaeYJOGChidYlUIdDVqcXii1gSuSYrit0K0WZTIay-BPXulve5nVQ>
Received: from yuki.localnet (unknown [220.240.80.60])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 14 May 2021 05:44:12 -0400 (EDT)
From:   Sachi King <nakato@nakato.io>
To:     'Maximilian Luz' <luzmaximilian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        David Laight <David.Laight@aculab.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
Date:   Sat, 15 May 2021 05:41:07 +1000
Message-ID: <3034083.sOBWI1P7ec@yuki>
In-Reply-To: <e43d9a823c9e44bab0cdbf32a000c373@AcuMS.aculab.com>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com> <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com> <e43d9a823c9e44bab0cdbf32a000c373@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thursday, May 13, 2021 8:36:27 PM AEST David Laight wrote:
> > -----Original Message-----
> > From: Maximilian Luz <luzmaximilian@gmail.com>
> > Sent: 13 May 2021 11:12
> > To: David Laight <David.Laight@ACULAB.COM>; Thomas Gleixner
> > <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Borislav Petkov
> > <bp@alien8.de>
> > Cc: H. Peter Anvin <hpa@zytor.com>; Sachi King <nakato@nakato.io>;
> > x86@kernel.org; linux-kernel@vger.kernel.org; stable@vger.kernel.org
> > Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
> > 
> > On 5/13/21 10:10 AM, David Laight wrote:
> > 
> > > From: Maximilian Luz
> > > 
> > >> Sent: 12 May 2021 22:05
> > >>
> > >>
> > >>
> > >> The legacy PIC on the AMD variant of the Microsoft Surface Laptop 4
> > >> has
> > >> some problems on boot. For some reason it consistently does not
> > >> respond
> > >> on the first try, requiring a couple more tries before it finally
> > >> responds.
> > >
> > >
> > >
> > > That seems very strange, something else must be going on that causes the
> > > grief.
> > > The 8259 will be built into to the one of the cpu support
> > > chips.
> > > I can't imagine that requires anything special.
> > 
> > 
> > Right, it's definitely strange. Both Sachi (I imagine) and I don't know
> > much about these devices, so we're open for suggestions.
> 
> 
> I found a copy of the datasheet (I don't seem to have the black book):
> 
> https://pdos.csail.mit.edu/6.828/2010/readings/hardware/8259A.pdf
> 
> The PC hardware has two 8259 in cascade mode.
> (Cascaded using an interrupt that wasn't really using in the original
> 8088 PC which only had one 8259.)
> 
> I wonder if the bios has actually initialised is properly.
> Some initialisation writes have to be done to set everything up.

I suspect by the displayed behaviour you are correct and that it has
not.  I'm struggling to figure out who to talk to to see that is
something that can be fixed in the firmware.

> It is also worth noting that the probe code is spectacularly crap.
> It writes 0xff and then checks that 0xff is read back.
> Almost anything (including a failed PCIe read to the ISA bridge)
> will return 0xff and make the test pass.

I was under the impression that it wrote 0xfb, and 0xff would be
considered a failure.

> It's about 35 years since I last wrote the code to initialise an 8259.
> The memory cells are foggy.

I'm not sure the i8259 is needed on the device, as the interrupts
appear to function on the device if I bypass the nr_legacy_irqs() check
while the legacy_pic is set to the null_legacy_pic.

The null_legacy_pic however specifies having 0 irqs, and the io_apic
does not allow us to set the pin attributes unless the pin we are
attempting to set is less than nr_legacy_irqs.

The IOAPIC seems to take responsibility for the 0-15 interrupts on this
specific hardware, should we maybe be ignoring the i8259 and looking
into allowing interrupts 0-15 to be setup even when the legacy_pic is
not available?

Cheers,
Sachi


