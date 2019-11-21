Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB0E105CBA
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 23:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKUWhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 17:37:41 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40347 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbfKUWhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 17:37:41 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D7BE922C7A;
        Thu, 21 Nov 2019 17:37:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 21 Nov 2019 17:37:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=hal4X0n3HWrSNl8EikRGFxkks21
        oOIJec8CstnXW8c8=; b=GTH5lR8JyUrnQGs2kxhpvqvIXbPZeqoOryHuH5Tve0d
        +a7STiCNAOH0pnQ0lhtlRSYHzLAf/UKZ9QExPWQ6gIjWVfmzokkJrdv6JXy3ExIh
        wC2QwxNIGCkxZcrObn5C6xjrkjWc78Wl3U7YxTNVtQxQMMU47ISI8VlwmMrZVyPh
        RfZ7eIYixbM5QscQ1omigOCW0aPydG50PBTCPMC4O4679kFNhwpCMbvseUUwps2/
        m0/bzrctu6FKb6IZto5kcD8WwoWJ8X/XafVYRt8sFPjO1d1d/+f/KjswybNaILFS
        Rfwu0E9zgq3c20kIKzAU7gXMkn210ZMEiyOPTRQyj6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hal4X0
        n3HWrSNl8EikRGFxkks21oOIJec8CstnXW8c8=; b=VktoD1Jc3bN8qSBMXH9323
        4SJwwjsr3cOD/A5nDpfkV+g0LPKCBolQjRa9XBBjRUIp07XPBKOkMCany6xFfNWf
        JW/FixILJq/yiB1BHO3375+Mjb29mv53WnLmemM7Avduqu5cyak8IuJjWR4HxP/N
        cWdO1aOh5RA/x1hzbSDnaXSZ3rG6N3pPJtmFyyKMOP4BO5/5A3l3VVMenQ+i/nm5
        ZXBh9YLz38LsrFR10CQ0YOCA8H4Fqvr7beCSuMj10nFNI14GDSEBLzaJC/pqPbaC
        hAvGa0qmmux9gl65DZI6GiA+ysFSFeKx5RXL0vCbfGpQ5PlnVax+B3A3J2ailVPw
        ==
X-ME-Sender: <xms:tBHXXX1ytvCiv3G8bSz5fTVZfz022AkExi05Ybjsd5LPN_Q2I-hdwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudehfecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcumffj
    uceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvghlrdhorh
    hgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:tBHXXSIWDIXC9raxKurFE1qOiPpaGrnKwgKz6juH2o4nF7vnUci14Q>
    <xmx:tBHXXd2y_vvpKafkgoRn_Q0gMNTfdvytIU6nm19Yn-DtXkj7Fvyzvw>
    <xmx:tBHXXdzDMqCB6gMjXmEtHxE6eAdSqACHQ2j1sHN6W3NcnKHAGn2wKw>
    <xmx:tBHXXbh6j4VgbT0Rbma1SSh_vSnxvSVHC3EUPO6VUAULpCSs1XAgIA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2929F306005F;
        Thu, 21 Nov 2019 17:37:40 -0500 (EST)
Date:   Thu, 21 Nov 2019 23:37:38 +0100
From:   Greg KH <greg@kroah.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Wang YanQing <udknight@gmail.com>, stable@vger.kernel.org,
        stephen@networkplumber.org, ast@kernel.org, songliubraving@fb.com,
        yhs@fb.com, itugrok@yahoo.com, bpf@vger.kernel.org
Subject: Re: [PATCH] bpf, x32: Fix bug for BPF_JMP | {BPF_JSGT, BPF_JSLE,
 BPF_JSLT, BPF_JSGE}
Message-ID: <20191121223738.GA1170586@kroah.com>
References: <20191121074336.GA15326@udknight>
 <be634e7c-98f4-cd7d-6967-485dc0bd2ebc@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be634e7c-98f4-cd7d-6967-485dc0bd2ebc@iogearbox.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 21, 2019 at 10:43:28AM +0100, Daniel Borkmann wrote:
> On 11/21/19 8:43 AM, Wang YanQing wrote:
> > commit 711aef1bbf88212a21f7103e88f397b47a528805 upstream.
> > 
> > The current method to compare 64-bit numbers for conditional jump is:
> > 
> > 1) Compare the high 32-bit first.
> > 
> > 2) If the high 32-bit isn't the same, then goto step 4.
> > 
> > 3) Compare the low 32-bit.
> > 
> > 4) Check the desired condition.
> > 
> > This method is right for unsigned comparison, but it is buggy for signed
> > comparison, because it does signed comparison for low 32-bit too.
> > 
> > There is only one sign bit in 64-bit number, that is the MSB in the 64-bit
> > number, it is wrong to treat low 32-bit as signed number and do the signed
> > comparison for it.
> > 
> > This patch fixes the bug.
> > 
> > Note:
> > The original commit adds a testcase in selftests/bpf for such bug, this
> > backport patch doesn't include the testcase, because the testcase needs
> > another upstream commit.
> > 
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=205469
> > Reported-by: Tony Ambardar <itugrok@yahoo.com>
> > Cc: Tony Ambardar <itugrok@yahoo.com>
> > Cc: stable@vger.kernel.org #v4.19
> > Signed-off-by: Wang YanQing <udknight@gmail.com>
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> 
> Thanks a lot for backporting & testing, Wang, much appreciated! Greg, if you get a
> chance, please queue this & the other stable requests from Wang up.

All now queued up, thanks.

greg k-h
