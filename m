Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F3C4A363D
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 13:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354779AbiA3M2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 07:28:37 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42067 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354778AbiA3M2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 07:28:37 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4DF925C00D3;
        Sun, 30 Jan 2022 07:28:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 Jan 2022 07:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=CqNgAQVZzOtSZopuwwTwr1nRliYIINiQLlJfuP
        6jJh4=; b=n3Tu2W7tZChUun+B1RLi9dStLLdAsEIelsKGUjkPFT2qHmhP6vu0/g
        Oy/t6JMyeRnNUNRzsWtsM//DgRF+A6/4U4D+zNBako8eAS+yhM/LVjqtH/XsJ637
        KYpCwa3derEfqo7cIenPnxxiy7XNmGvWuzZsDm9NJR/HRBTNTO1DCmL2v7eg2/mp
        LtKYH+HfG4tUOEI0r49r4SS0UunG0MUqmz7O5oU4MdkFxM3a8GN012+3tyxEalF7
        VmFjfpJGz/yjqpHFe76D+s6gw/O8K7pXorh3/v+9BW0JzT78QdW2lhAFzXLhEn9R
        UcLFXGJd9psfikI5qpHbH7tR0i0sDzOA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=CqNgAQVZzOtSZopuw
        wTwr1nRliYIINiQLlJfuP6jJh4=; b=MVKeUz4aBFTFwEvZuSauHMreHRnKHH+Sz
        lK2s2BYgsAGmKvap1dL20k2zEA8+q6gPLiXGuc7bkM7+ATkkERvEfay18EH4n5nR
        RC33V6r7cZdo4FjWurFEADhRK2o8OdbZm9JwbbGgfReOEbzfQmbn7B6G2HctiKVj
        JtQzsrsLyhVRknqQTBEjErTidplCCxwDpFeRaJfJsB4oqnWafUN/QZ0jLhKBf1Pe
        bzSy3Bh/j4hPHk1a9mOXB/qrguSOwQJr4EmvNUX+DFqNd8bAtcHh6nFwZ3LcFy57
        AwlsIaan11j4XQif18/JpQC1Ri6IbczvbHUwLJOYCp2OZai9mZeyQ==
X-ME-Sender: <xms:dIT2YYTEuvPaqXIatpE12hLfsmY0qlYuFGuV4iP0k9kSq7HBfdbS4w>
    <xme:dIT2YVxgunxULaGyAuO3R2bHXQ2H-A9SP6qPADRto4f7xvlJDJgALH6ctgk8ShDhU
    LXeD1_K7k4dtg>
X-ME-Received: <xmr:dIT2YV0HHiIL1H_g8RGUsn0B7saxQpsxiXoeGg6bZuyvzicwX7SAHbHpBpNk2az3BO_d4JSeh1YwSr87RdFM66UzR4CdkiX->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfeelgdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:dIT2YcAcBjZ7jy3Q_aJm0i5SpEZQPMBhokwAoMiATcTz0XolVYKcaw>
    <xmx:dIT2YRiCsrsO7jsT_CfofukA6R9P5bXhOcqvRd3jdysdaJMgDwaGuw>
    <xmx:dIT2YYqQ6YqRCFRCpAmaNARo5INhN05fxsTtLEgoam8I4wXYmm5AIQ>
    <xmx:dIT2YRdoFboBnpsp6nJa3EokIgMLhqd--1JfkzwV5sLXMKqtO7GSfQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Jan 2022 07:28:35 -0500 (EST)
Date:   Sun, 30 Jan 2022 13:28:33 +0100
From:   Greg KH <greg@kroah.com>
To:     Felipe Contreras <felipe.contreras@gmail.com>
Cc:     Linux stable <stable@vger.kernel.org>,
        Linux wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 5.16.3 with mt7921e
Message-ID: <YfaEcWXg2lGYBSR5@kroah.com>
References: <CAMP44s2vAmfHU+h5bSp5FJvks7T+b_tpdU1U4pBvK9jFF6C=eQ@mail.gmail.com>
 <YfY+C9hiX2V7LnT6@kroah.com>
 <CAMP44s0b93nO9uVYB3_p_c=cq8BR3WCtnQA=7jJxyAxYC6rxNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s0b93nO9uVYB3_p_c=cq8BR3WCtnQA=7jJxyAxYC6rxNQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 30, 2022 at 02:07:32AM -0600, Felipe Contreras wrote:
> On Sun, Jan 30, 2022 at 1:28 AM Greg KH <greg@kroah.com> wrote:
> >
> > On Sat, Jan 29, 2022 at 01:05:50PM -0600, Felipe Contreras wrote:
> > > Hello,
> > >
> > > I've always had trouble with this driver in my Asus Zephyrus laptop,
> > > but I was able to use it eventually, that's until 5.16.3 landed.
> > >
> > > This version completely broke it. I'm unable to bring the interface
> > > up, no matter what I try.
> > >
> > > Before, sometimes I was able to make the chip work by suspending the
> > > laptop, but in 5.16.3 the machine doesn't wake up (which is probably
> > > another issue).
> > >
> > > Reverting back to 5.16.2 makes it work.
> > >
> > > Let me know if you need more information, or if you would like me to
> > > bisect the issue.
> >
> > Using 'git bisect' would be best, so we know what commit exactly causes
> > the problems.
> 
> I know, but it has been a while since I've created a decent config
> file to build a kernel.
> 
> Either way, I pushed forward and the commit is a38b94c43943.
> 
> Upstream commit 547224024579 introduced a regression that was fixed by
> the next commit 680a2ead741a, but the second commit was never merged
> to stable.
> 
> I've sent the second commit to fix the regression.

Wonderful, thanks for figuring this out and sending the fix.

greg k-h
