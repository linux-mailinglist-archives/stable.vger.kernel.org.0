Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04008FF58
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 11:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfHPJqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 05:46:55 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47935 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726839AbfHPJqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 05:46:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 99FC82203C;
        Fri, 16 Aug 2019 05:46:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 16 Aug 2019 05:46:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Yi/P7M9ZGl8GciWb9jfjcefebii
        e1qSi09xunq4kNOQ=; b=O+I9Z4rDdP5kPqEhUa7DLzVj0954lLQtF5OPE/YNEzn
        cYZxT66bdZg7mBHktQSOflivQRdSjgWM3EgJvugfPFaz1qDeMuoAql28QqRmQQQU
        C3/rlLHC83GdJm7sBAEdX7n0CFOkhtX2ylijnSIF3QWgAkfDPbh4Q//aJMlZXCUa
        1j9ARwpro0vOTdXTIkG890n8ghiK6SI4jo91WTWJE3dzu0fl88BK5QGsefDsY9Ol
        iL0K6XAH6gxDkvvSLNcfIRG9Z5cdx2qroQjJEl6DDFF3zQcr8hM9iwr46Vuhs0Wq
        tVMKb6Tc+K3SGG5TuY4Ydk8xOjCIO9/1KEq87vqF4Mw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Yi/P7M
        9ZGl8GciWb9jfjcefebiie1qSi09xunq4kNOQ=; b=BUftaoesVFmddgHODB0Lca
        oHBWnl2ZbU0yzkOU0kIczQP1ZxspfgG6uch9nY43gT7lbDWLKufUDD2L8WElZZfl
        3tH6AonbhHbQrcV4XfFUiwDB7ckdBkpg7BcClS+wRe245bRGLrvUdKY2sMrCZf3M
        zMbIWKBx4YBPuNGTMKTlEDqhaeH4KfdEHx8pX1CIoCVNcXI02bqo2XVG4OQOM9TV
        EELUehz1q4YPLIFR3Y6gtnin9DgjViZppE7+sm0kiRx69ccHMYfnNa2JyGUF8uho
        M+SRyOaW6Nj6Z+waHfoVcDSalWcWrtQzIbN0mzBlfG40Ts68XO3e5GWWUOvjda6g
        ==
X-ME-Sender: <xms:jXtWXYANu-WLlYgc4AnnOtG35IW0HcgZ6P5UgAZRZrSdEzUZ_ydgEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeffedgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujggfsehttd
    ertddtredvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:jXtWXchGMlA0RGOh24K804s_FnztNjf77MIy_Ko_LdJNUjGCDIGtBg>
    <xmx:jXtWXf6HmrO0zOv2fUvGaldn4Il5WGl0tj1p4gzQSHndhkpNi2GeHg>
    <xmx:jXtWXW83BhO4k1gOv0pUgmXNXyPtALFYkTckEibL22tGSeLl1MDd1w>
    <xmx:jXtWXReaVTV0W3_elit6Juf8A6-6DdhvYtpHlxI86Yt05mVVdx6bwQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B626D380083;
        Fri, 16 Aug 2019 05:46:52 -0400 (EDT)
Date:   Fri, 16 Aug 2019 11:46:50 +0200
From:   Greg KH <greg@kroah.com>
To:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     stable@vger.kernel.org, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH RESEND] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Message-ID: <20190816094650.GA10743@kroah.com>
References: <1565086396-44714-1-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565086396-44714-1-git-send-email-suganath-prabu.subramani@broadcom.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 06:13:16AM -0400, Suganath Prabu wrote:
> From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> 
> Although SAS3 & SAS3.5 IT HBA controllers support
> 64-bit DMA addressing, as per hardware design,
> if DMA able range contains all 64-bits set (0xFFFFFFFF-FFFFFFFF) then
> it results in a firmware fault.
> 
> e.g. SGE's start address is 0xFFFFFFFF-FFFF000 and
> data length is 0x1000 bytes. when HBA tries to DMA the data
> at 0xFFFFFFFF-FFFFFFFF location then HBA will
> fault the firmware.
> 
> Fix:
> Driver will set 63-bit DMA mask to ensure the above address
> will not be used.
> 
> Cc: <stable@vger.kernel.org> # 4.4.186, # 4.9.186 # 4.14.136
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
> RESEND: Resending this patch to include 4.14.136 stable kernel.
> 
> This Patch is for stable kernels 4.4.186, 4.9.186 and 4.14.136.
> Original patch is applied to 5.3/scsi-fixes.
> commit ID:  df9a606184bfdb5ae3ca9d226184e9489f5c24f7

Now queued up, thanks.

greg k-h
