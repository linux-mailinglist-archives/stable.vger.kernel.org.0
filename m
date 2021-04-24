Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F5A36A1A9
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 16:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbhDXOo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Apr 2021 10:44:29 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46047 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229630AbhDXOo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Apr 2021 10:44:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6938E5C00D9;
        Sat, 24 Apr 2021 10:43:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 24 Apr 2021 10:43:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=2ZOfQhPJ+uxZJ5RC6Fp4DFPdIwM
        NdnjI00W7BuBOvhY=; b=q2rhkY/1dpcs6KVp70ra4MSSQ9UOliYIj25vws7jA1X
        z9Nm0iLUErzCrSOyDjTO9NzBhHpthDDhvSrAhtcJE0Hfl6MrMZAlvlBDyAZJu7IQ
        K90abSilsO4DuOxNryh1kRQV7SXiy6o5WJlQPVcIBJnb8DsKfZyYv1eXQS3zgAr6
        lQw67NFUgeMz/zbCNvvJpuPCdioNwXfgKZUGvTi57rYcWEnfHHAWPhNs8WEpkNe9
        cDiwrRCVgsXVxx9obQ0/SsNdfFCenziwhIRXU4Jhx2HroeMfy8q8vxL5sPYAMvfk
        qeypaRODNcfHeyIXNzPPFGF4KncyLbae2/bbnBqvdeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2ZOfQh
        PJ+uxZJ5RC6Fp4DFPdIwMNdnjI00W7BuBOvhY=; b=pgl0XA+Ts45SFG93UGp0K1
        jszlUkS2jfx6Y9uxKdKDqrSSDESFmv1paP+YeVe7gsSCq1YlXTrkIbtV929rmF5u
        //MjGPXeSsduIbc0IWPtFbB7AcXUEAskSnPb+93GR8cJRfdeLqySTd8S6Wcisc7c
        AK1UGrK0b3hYbKAR3hcSgfnQFQfgdept9PukSlzF6Uyjrh/hS6pPHPRWm812ZTm5
        Rlznql1XrVGc+DnD9H2UnQjMQ7AxqJRl0Jt83rgxpeNJtQOqRI42zHuKktoMShpl
        iF1iT2eIoTGB2UAslKB2DwW2H2i1yfvAr6qLq8ic4q9CHwEmShD1ecoMuUu/3eLA
        ==
X-ME-Sender: <xms:pi6EYGj9wNHr2cyKlX2kPN8kFDCfaIBZZShpQ_zSD8gE0d4QBGpeWQ>
    <xme:pi6EYHBxrcZCAQById3N_kzMI-DiKPzqH6TaYpnIos-NBZAweOtWpUTz3H8xGNTAf
    Oy_n4MxwHPHBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:pi6EYOFEZBY4aB_X5tzafPZfpIn6idXEOBMiH4J28Z_-u1cWiRXIuA>
    <xmx:pi6EYPTl4oA5u37XEWIwlodkyvJUdYIJfttKOE1X0-n-pSgikclkpg>
    <xmx:pi6EYDzlaIzVtEDH3aHl3kB-OVBBX6SpEUvCu-RXk7bcWLbkyAoJQg>
    <xmx:pi6EYEtixLogvlAGI2jafdFfrz3VTsjawkPCblyGWCCR7Noz6bF7Eg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EB8C9108005B;
        Sat, 24 Apr 2021 10:43:49 -0400 (EDT)
Date:   Sat, 24 Apr 2021 16:43:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Jianxiong Gao <jxgao@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5.10 0/8] preserve DMA offsets when using swiotlb
Message-ID: <YIQupJuzbdgif6WA@kroah.com>
References: <20210405210230.1707074-1-jxgao@google.com>
 <YG2q6Tm58tWRBtmK@kroah.com>
 <CAMGD6P1OEhOXfFV5JpPfTjWPhjjr8KCGTEhVzB74zpnmdLb4sw@mail.gmail.com>
 <YILkSsR4ejv5CraF@kroah.com>
 <CAMGD6P2gUpUuX5cdPi1Q0nqRFmsBPctUR+hBt+DnPK+H4jHiiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMGD6P2gUpUuX5cdPi1Q0nqRFmsBPctUR+hBt+DnPK+H4jHiiQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 23, 2021 at 10:28:32AM -0700, Jianxiong Gao wrote:
> > How?  Anything that installed 5.10 when it was released never had this
> > working, they had to move to 5.12 to get that to work.
> 
> I wasn't clear. The bug is not specific to SEV virtualization. We
> simply encountered it while working on SEV virtualization. This is a
> pre-existing bug.
> 
> Briefly, the NVMe spec expects a page offset to be retained from the
> memory address space to the IO address space.
> 
> Before these patches, the SWIOTLB truncates any page offset.
> 
> Thus, all NVMe + SWIOTLB systems are broken due to this bug without
> these patches.

Ok, and what prevents you from adding this new feature do your "custom"
kernel, or to use 5.12 instead?

This is a new feature that Linux has never supported, and these patches
are not "trivial" at all.  I also do not see the maintainer of the
subsystem agreeing that these are needed to be backported, which is not
a good sign.

So I recommend just using a newer kernel version, that way all will be
good and no need to backport anything.  What is preventing you from
doing that today?

thanks,

greg k-h
