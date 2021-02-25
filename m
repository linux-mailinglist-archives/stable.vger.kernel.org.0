Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A650324C02
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 09:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbhBYIZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 03:25:35 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:51345 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232601AbhBYIZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 03:25:35 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 86E25B44;
        Thu, 25 Feb 2021 03:24:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 25 Feb 2021 03:24:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=wXEDrAdq/2Bz8KWMJ7CdWUXR0wg
        xU8y44p1T6R4IsHo=; b=YFyPZ9JgFepZTF+6ZwASlAeEAYTI6XuE5eQmEEGgKsO
        x2Dzs0or/ff7cg/Pfow96UMWVKLlgLPp6yP0fYMA4BOQnOClnSeI52tPZ93oTp3T
        RCSNTPznTS51hhkbaqxvdu8JUWlAzffcy0+yLRJbSTRaCE00FxqXvpvBVyCx+CvB
        V8Fl9dk2OBIFg+SOuRPD9IzSnbbvEDgcZ9DgJMbULTBZ68pn8Fjo65riGRl3Q+2b
        PFIzvhZG4vPOBLLvLda2MC67XXbeuoz+In81Z8V1TAtNCTY1oib4Q6C33VD/dRy2
        vY16erXT+ey3FaVNPSW7getzdAKjWjuwLCBLEAe8qeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wXEDrA
        dq/2Bz8KWMJ7CdWUXR0wgxU8y44p1T6R4IsHo=; b=X7A/D+zseLHRaZaZ8l/jyY
        SZhD6xsNREqilMHsDAoW+Pm+E3AYkEFeITpjs+Uu0rX32gRrCF8ihbA6HkloJp73
        WOGQ2dMoTDiiZkZIefHwW/NlXjuSbmL+V1bR9gutLVd3XSb2FLbQFeX2W5YQE0g+
        mhJtatAOvk1K6dQFK3Xja2CRnhDLy6nL4Pqc+yU5YzaMDz9zuKDA6oQbbIchw52r
        JJoxkIuq8LGwW9z6W/GpBEzVSEobvCxZluZalJoxNVKckicUWi2HbkeUa+QsFrtb
        x/SStJGsnddMO9K8IE9EyZkzbZZ1EEO2oni91MmT8jE+YnIqaDWXEtNfY69dKszA
        ==
X-ME-Sender: <xms:0V43YJxipjEC9YMc1TEYYLziTrGH9muDNeiT_dTRzWjSC5BHKZu-yw>
    <xme:0V43YJOltTjuA1uUHwNPdHE2tAHP9MKnmgqJtrooRs4C29nv18TBop1K4JWaxRvLq
    Ww23be5mYyVpw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeekgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0V43YAOHwhbQQVG6aJ9aD8vcqr-T2IlMxSoVCUTXQRYCMPebTkPQzw>
    <xmx:0V43YDQbj0gS7AYMYfNor5rtJXVvonv4wCsxgpPD-r2fLvrQAgkBCw>
    <xmx:0V43YKBWTrLDt5Trb2ivIbQi4iVvF_EgwOyhfEinbKCZuMNk2SOW4w>
    <xmx:0V43YMbCJD7mWvXapxdFgNMDFPB3sK9gqz7jvVO7UyL3M8f2VUhkXQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A505C1080054;
        Thu, 25 Feb 2021 03:24:48 -0500 (EST)
Date:   Thu, 25 Feb 2021 09:24:46 +0100
From:   Greg KH <greg@kroah.com>
To:     Rolf Eike Beer <eb@emlix.com>
Cc:     stable@vger.kernel.org
Subject: Re: [5.4 / 4.19] backport of
 2cea4a7a1885bd0c765089afc14f7ff0eb77864e and
 fe968c41ac4f4ec9ffe3c4cf16b72285f5e9674f
Message-ID: <YDdeznA0PVBAKUTT@kroah.com>
References: <2934400.eNZDa4x5nO@devpool47>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2934400.eNZDa4x5nO@devpool47>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 02:51:36PM +0100, Rolf Eike Beer wrote:
> Hi,
> 
> the attached patches are the backport of these 2 patches for tools/Makefile 
> that allows building when OpenSSL is not at the default location. They apply 
> cleanly to both to 5.4.99 and 4.19.176. Backports for older stable kernels 
> will follow.

Now queued up, thanks.

greg k-h
