Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D19F33E8E
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 07:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfFDFsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 01:48:14 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:45249 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726488AbfFDFsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 01:48:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 5BA42543;
        Tue,  4 Jun 2019 01:48:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 01:48:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=T
        CaT+Fn47+ujhoKgN9BqRZfA99WODN1m/1NIm/vdRH8=; b=oaHBm6XDYjYnIR1+T
        tDP6lz3rPXXNul0GO6vfZa9L/L0jmBs0+qYGxIQnA08yiWcMtzGgEJlXssupUOWk
        IXiXTc7PRBQRY8LN2/u5T9nI1Gc58f2Y+HocDeVesocNpudlktWBKYFqrc8DWBYQ
        5T8byHPpvDvi0U/aqtts5/dEkHgnDE6uwCEI8NtaEUsa7dzTm8LdHXXccCSo5DJd
        DcpcQZug2TO0gunHcVwPYJBuXCyAEerKpju7cSNY+oK7yNc4D5DLNb/9D9OUB9Lq
        FvPKvahrP7eOBp/EexPhywS/N8HhKe1+bohaYPKCBirPf/w19szbXlsmREwh9Nik
        wyn9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=TCaT+Fn47+ujhoKgN9BqRZfA99WODN1m/1NIm/vdR
        H8=; b=GZ1FyG62s1xexwpPe4FC5Q62hK982P/nBwXKoBo/2LnNCaW3a8jrInxUP
        ARtfThVhX0ddEKj/QQTMSwRy92rmVXFTbqKE7t82LRu10VAo7CZXphwOTw+DW8Rd
        Ff6DUipkbo5YI4EQOUfzQcWI4d535crAFOp8aLrTINByquHyunwRESbSU+2uFB6k
        cgSLpRmIDnk+c5uygok/Yf8oWKKuoDv/JTrXuiKjQr4PaI9BFWtBeHsGJu3b/aWO
        UgINRDDsf1Kww2ql/jndm+FpH1YxGFGlisyuif+OBKgGDDSxBc5DuVD4lSuucuys
        kJBI0TTvpvIIHNOT32o5xgvUhsrBg==
X-ME-Sender: <xms:HAb2XMsLzrEelzR63i577txk3SZsU_gm9jfFAIzxFlhZnlgiWT3SXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefkedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggugfgjfgesthekredttderudenucfhrhhomhepifhr
    vghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:HAb2XAXj2CYIhrQEuc_j1ZO71smNpFuZQ4e9xT5nHdm84L8BfVNDcw>
    <xmx:HAb2XEuofA8-jEtRCO9VuEgl94sirJxZOAau1IFOA77Jler4B0Hw5A>
    <xmx:HAb2XMUTPjTTGlW_7E7ii5Po8Npe5gmYXiMjtJ5BclMC_k7seX4Qnw>
    <xmx:HAb2XBl0QRT00X7fZZLlii9NBeVFVwtCGUThSxW0JzJGa7G6Zrt6Aw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CEBED380083;
        Tue,  4 Jun 2019 01:48:11 -0400 (EDT)
Date:   Tue, 4 Jun 2019 07:48:09 +0200
From:   Greg KH <greg@kroah.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Prarit Bhargava <prarit@redhat.com>,
        xen-devel@lists.xenproject.org, stable <stable@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [stable] xen/pciback: Don't disable PCI_COMMAND on PCI device
 reset.
Message-ID: <20190604054809.GA16504@kroah.com>
References: <1559229415.24330.2.camel@codethink.co.uk>
 <0e6ebb5c-ff43-6d65-bcba-6ac5e60aa472@oracle.com>
 <20190603080036.GF7814@kroah.com>
 <1559563359.24330.8.camel@codethink.co.uk>
 <d3358f62-3e53-4468-782c-7b4466d34c0a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3358f62-3e53-4468-782c-7b4466d34c0a@suse.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 03:10:55PM +0200, Juergen Gross wrote:
> On 03/06/2019 14:02, Ben Hutchings wrote:
> > On Mon, 2019-06-03 at 10:00 +0200, Greg KH wrote:
> >> On Thu, May 30, 2019 at 07:02:34PM -0700, Konrad Rzeszutek Wilk wrote:
> >>> On 5/30/19 8:16 AM, Ben Hutchings wrote:
> >>>> I'm looking at CVE-2015-8553 which is fixed by:
> >>>>
> >>>> commit 7681f31ec9cdacab4fd10570be924f2cef6669ba
> >>>> Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >>>> Date:   Wed Feb 13 18:21:31 2019 -0500
> >>>>
> >>>>      xen/pciback: Don't disable PCI_COMMAND on PCI device reset.
> >>>>
> >>>> I'm aware that this change is incompatible with qemu < 2.5, but that's
> >>>> now quite old.  Do you think it makes sense to apply this change to
> >>>> some stable branches?
> >>>>
> >>>> Ben.
> >>>>
> >>>
> >>> Hey Ben,
> >>>
> >>> <shrugs> My opinion is to drop it, but if Juergen thinks it makes sense to
> >>> backport I am not going to argue.
> >>
> >> Ok, I've queued this up now, thanks.
> > 
> > Juergen said:
> > 
> >> I'm with Konrad here.
> > 
> > so unless I'm very confused this should *not* be applied to stable
> > branches.
> 
> "should not" is a little bit hard. I didn't opt for adding it, but I
> don't object to add it either (like Konrad :-) ).

Ok, I've added it as it does fix a CVE, and if I don't, I'll get odd
emails 6 months from now asking why I didn't include it...

thanks,

greg k-h
