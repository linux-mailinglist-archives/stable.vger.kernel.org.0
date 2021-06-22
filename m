Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7CE3B010A
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 12:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhFVKPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 06:15:09 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:57793 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229612AbhFVKPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 06:15:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 947F35806DB;
        Tue, 22 Jun 2021 06:12:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 22 Jun 2021 06:12:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=pQtzM1DqFDdfzJczHbE0hVR7RaJ
        +DVrWztT+rRlCQh0=; b=YzHFOu2SxOl0BCAJy9jZozNGYJZ0wrl8O0jKdRapOvb
        KT3zjqk39Ymny9tI2CDMukLxeWkDtCcJqlcRTDTcGeVr1BSngaJEwCeB29nwpxIC
        yGuzvksRqr0yzcXk35nit/65T9VWhdDkdASeL+gspkvJoOa6IkWzb40RSGLhikK7
        cO5YO0QbXXFKMRMoclll2kG4sTAULr//wrD2F6Th0zXocozQvADZ2jovNQa4BXVk
        m+nqZsVW90AS0H/oQI7qp8imm8YsSQ5zQrYIAMBVVwqzhTPNlcMN1kWbYcS2tqjL
        brQMvFwlX5th0/UT/qk/DRK03E7eMJNbNmlvmYN2SEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pQtzM1
        DqFDdfzJczHbE0hVR7RaJ+DVrWztT+rRlCQh0=; b=kSixDL1BIp5Sj4eeF2VUnQ
        kBTRdHv/l7Tu8RpL7Iqpqx5KgWdTiwPDLn5ZL13eAcB8MSZM4hHOZK5Na2NznlMA
        ltIkJJBx9A+WfDXKf1lVmTB+srpRzXKohgvHwcbWlvPe43qpQ188z7AEqqIQM81t
        lUM9TMGCmV/2ZlTRG4TRENfR8ReQyw6f0oaGr1y/zMQ+UHfw8JU8ADnkBIZklXEK
        NPDw0W86KqXbPjjhegPy9PtcO/lyW6PDF/QpMSg4kqVKSOVikaxni8EeLRYXiQQy
        e9bkpsywCyK7kLZfk/l+G7Qu3EFzZQlQRNb2Ju0MnI4/F9v2/RMNvhmDqUUzBIyw
        ==
X-ME-Sender: <xms:o7fRYF9ER84jHh9dc4M2AdgOWkI5mpNHtYoOOZFhQmbmSr8e95JLPw>
    <xme:o7fRYJuST43UsMPDZVu_5hq4j9yctBQoI7LvtaLHMHavgxmYmid9Y06usOpdqZsAH
    ES12dpb-95OpQ>
X-ME-Received: <xmr:o7fRYDAG3TDlhxa2D3P6GsQ9Mnh0MB36PwX7ueFhIzNg5wxax4g02GziyMsssL4ZUHlBI_Tcdzo8HmKQC-PlKjNVXObEav4O>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeguddgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:o7fRYJcuzvoovWDL6bc60vHDp4WeROXkdflgDg6-_bT7yvAC9wKm5A>
    <xmx:o7fRYKNEHSnydVn3U9lte28arUeY5sAZY2R7W7hXlTNQ_DAg6CSxAQ>
    <xmx:o7fRYLlHS-7r-gU2R4e9-lWQGj-I27RvvTaDuU-ACHTdTYhLMSuKEQ>
    <xmx:pLfRYFHcJbBityTSwpugTLvpSTYFxnaxP4aJQRh5us2HCDkM5jTOmA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Jun 2021 06:12:50 -0400 (EDT)
Date:   Tue, 22 Jun 2021 12:12:46 +0200
From:   Greg KH <greg@kroah.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Mauro Carvalho Chehab' <mchehab+huawei@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "mauro.chehab@huawei.com" <mauro.chehab@huawei.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] media: uvc: don't do DMA on stack
Message-ID: <YNG3niUwqeFfltxO@kroah.com>
References: <6832dffafd54a6a95b287c4a1ef30250d6b9237a.1624282817.git.mchehab+huawei@kernel.org>
 <d33c39aa824044ad8cacc93234f1e1cd@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d33c39aa824044ad8cacc93234f1e1cd@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 22, 2021 at 08:07:12AM +0000, David Laight wrote:
> From: Mauro Carvalho Chehab
> > Sent: 21 June 2021 14:40
> > 
> > As warned by smatch:
> > 	drivers/media/usb/uvc/uvc_v4l2.c:911 uvc_ioctl_g_input() error: doing dma on the stack (&i)
> > 	drivers/media/usb/uvc/uvc_v4l2.c:943 uvc_ioctl_s_input() error: doing dma on the stack (&i)
> > 
> > those two functions call uvc_query_ctrl passing a pointer to
> > a data at the DMA stack. those are used to send URBs via
> > usb_control_msg(). Using DMA stack is not supported and should
> > not work anymore on modern Linux versions.
> > 
> > So, use a kmalloc'ed buffer.
> ...
> > +	buf = kmalloc(1, GFP_KERNEL);
> > +	if (!buf)
> > +		return -ENOMEM;
> > +
> >  	ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, chain->selector->id,
> >  			     chain->dev->intfnum,  UVC_SU_INPUT_SELECT_CONTROL,
> > -			     &i, 1);
> > +			     buf, 1);
> 
> Thought...
> 
> Is kmalloc(1, GFP_KERNEL) guaranteed to return a pointer into
> a cache line that will not be accessed by any other code?
> 
> (This is slightly weaker than requiring a cache-line aligned
> pointer - but very similar.)
> 
> Without that guarantee you can't use the returned buffer for
> read dma unless the memory accesses are coherent.

For USB buffers, that should be fine, we have been doing this for
decades now...

thanks,

greg k-h
