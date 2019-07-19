Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945646E9D4
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 19:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbfGSRH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 13:07:29 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51907 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727910AbfGSRH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 13:07:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8BCEE20260;
        Fri, 19 Jul 2019 13:07:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 19 Jul 2019 13:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=voc5jZSIL6rQ+zweBeKShoLkmze
        3Sqp2FVDibCqmjPg=; b=Lg8hgsfR4JFRxkyChmqT9xFsSpoTY5g1i9coInH8dUa
        mSeXhvEccaI13lLI+5c0UnmSPa2jG8G+yiH0ifh7DK7uxTidpdmlasAe0AEqwcd2
        2Ik9zCXnkqdKBl49tV5yAcSxVX1wB55cXFT7jOFm5oM/W20jXPW07/oSmc5UfZUm
        WbqDFE0wSACXaoaPLHl9iyNCfRqlDB7n6CgxMsBd4qboUjAc6/vhx93p/temL5ti
        4pL7j8E9ZhmBeTUfRU6kW4kpRlEtWbhhkCJ7rrqMyEjHfqhvQYG10dgJ9y9gWeFt
        jlEmmOIhYYlWIW5d3P3HDdCGhRIGhlkhnbGURpQ3LdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=voc5jZ
        SIL6rQ+zweBeKShoLkmze3Sqp2FVDibCqmjPg=; b=BFqyXR/Tc/D+nJrtAzSCQy
        BSxa+E4QkJjag4QIzZ1m8r87xhPz5mt8fI/uL1/ltyh+HDtGi9lofC9WAV+zTpd3
        wctvkQEJHS05JEUwTz6lCksVkQiCDdnBDJvY1cStLbiIL8n0oyUJiGn6jIYJVPzX
        T0PMkD6PlfDiOlK26RWdEPCt+VnT/Xv2f911dwwezt9/i9u/f7fsQHl+tj7Pe1ll
        hnhd3CtrM6+wvLJLjcIjeZMjKTLKX1nAr2hgCFvJEmxIuPT1HQHyrSCSgUVOxDgE
        dZzDGnHfSPHff0QJs5Cxk6wPLYKjZDHBtnkJTV2dcXf5LrcFMbgl/VxHyFDVOuWg
        ==
X-ME-Sender: <xms:zfgxXacwMYW87aM2cmjMuX_pcST6upMZmRDuZVtzK9JF4n_hMzyTsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrieejgdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekgedrvdeguddrudelle
    drleehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:zfgxXedzW6CVsli4jlHM5INkPBarmTWmdO-wlbSoYEkgIol_uPWVCw>
    <xmx:zfgxXQ9_Ljnuv4r24niTq7D_c157F73Url5AysZKf87Y_MfCmnXJAQ>
    <xmx:zfgxXeOyZo2xsxEIbBQyJo-NBuBKG4qFsNdTlSX393iwH75zi3vSkQ>
    <xmx:zfgxXdtDjRvM7_eo07U5VLoRy9z47zdlV6qeKVDr2oWsejB134bGoA>
Received: from localhost (unknown [84.241.199.95])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7297B380084;
        Fri, 19 Jul 2019 13:07:24 -0400 (EDT)
Date:   Fri, 19 Jul 2019 19:07:18 +0200
From:   Greg KH <greg@kroah.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Floppy ioctl range clamping fixes
Message-ID: <20190719170718.GA32664@kroah.com>
References: <CAHk-=wg+aNdzECivhrKrBr8CzEuMuhPg40DcH=jgmNSD+Ns_Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg+aNdzECivhrKrBr8CzEuMuhPg40DcH=jgmNSD+Ns_Fw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 09:29:06PM -0700, Linus Torvalds wrote:
> Hmm. I just realized when I saw Sasha's autoselect patches flying by
> that the floppy ioctl fixes didn't get marked for stable, but they
> probably should be.
> 
> There's four commits:
> 
>   da99466ac243 floppy: fix out-of-bounds read in copy_buffer
>   9b04609b7840 floppy: fix invalid pointer dereference in drive_name
>   5635f897ed83 floppy: fix out-of-bounds read in next_valid_format
>   f3554aeb9912 floppy: fix div-by-zero in setup_format_params
> 
> that look like stable material - even if I sincerely hope that the
> floppy driver isn't critical for anybody.
> 
> I leave it to the stable people to decide if they care. I don't think
> the hardware matters any more, but I could imagine that people still
> use it for some virtual images and have a floppy device inside a VM
> for that reason.

Thanks for the reminder, I'll queue these up for the next round of
stable releases after the next ones go out in a day or so.

greg k-h
