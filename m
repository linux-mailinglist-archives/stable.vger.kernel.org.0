Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537EE261FB8
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 22:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbgIHUGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 16:06:07 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40169 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730190AbgIHPVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:21:45 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id EC9715C017E;
        Tue,  8 Sep 2020 09:16:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 09:16:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=8nA9uni+DU6nOuFgzPyBrRidn5R
        o+1G0prIuYfsfiHY=; b=J49OGvZiA1v+8MAqcmrGWvMrMNm16jTbWezHL9xX1Lb
        OUrl4wIGgB7I1aJTNwc2NM8LSUtWHoTSRF5vITje2vwJE+jIak1pNnFaHW3EiPFi
        nmGaIWUMt8xABX7xTDOlN+fYikb7IZkrqUg2SSDoXG7UZYRn9qFLJEAk0sfJ8jOL
        mwubU1sw8TOuhkyF/laRi1Y187YFWgL/i0ad1HdLt82OqrYjDzfgNpM3KgOaoEFW
        G3s6L21bXu8Dw5zKSubK8/VLArSkd0GPpFn1yY3YNItKXlooFCIpdTErFJlN80aO
        u0PfhKvAUoA2py6GAMLS8XfSPMGg0SLhSnHu4Mn2okg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8nA9un
        i+DU6nOuFgzPyBrRidn5Ro+1G0prIuYfsfiHY=; b=uvT3lZy0dmGC3mFLj27Z1c
        w4mSG6D84R6vx/a5YlyozkJmGL1mh8c3Q45ABvjCi7nzWm5o7NQkRCyvw2JL6TJB
        EcUsIdEi8f10CYF1Q9/4MHXyUd9QIk6j+tb77cmU06vbw5krIyll0stbxy7fwzjn
        sSiZy4jmkW1UZhpUxPqAyhfEFpjFC6bSC54jvh1z/2x9MXbLS4vq5L6GS+UYvin3
        mQfr1RMXYjU5gsTRFPLDloy8UglfvGssTvb7Wa3y0QKmwdlhn5zOouLlMb00GFr3
        YUEdbtUX0MSvLlmuxCbtyKWo4X5vv2qbiXM7TCJ9I2f7zKSJMSR9SNorLYtVVmWQ
        ==
X-ME-Sender: <xms:QYRXXw5hurkx43fGwegzeeqbqFJPKtSZHANvfCyaCH1XsfX3lm-4dA>
    <xme:QYRXXx4DbGwO4TkY80iBHR9CZ-t3nSRLGOIvW8ILDNZydhflxtGsdRzm8zO7h72sf
    i7gLwoqHXHf6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:QYRXX_ef0g9AOqStt6voWFvBmGEjh4thpZ4p16zDQlWseLLs3PBE3w>
    <xmx:QYRXX1Jy_eaH5-pXYyTRd3KM6coyxkmV8H-BRM-NsMu8wRNRtt16QA>
    <xmx:QYRXX0Ide8qrQhWi_i05lCpfV2-oHeBB5O_1G9iheEkCIGVyrc1Gkg>
    <xmx:QYRXX7XQX4ZQr7o6c62e4T0fpnobpsxeMlx42jrbj5PSMoBbpm9wuA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 458B8306467E;
        Tue,  8 Sep 2020 09:16:49 -0400 (EDT)
Date:   Tue, 8 Sep 2020 15:17:02 +0200
From:   Greg KH <greg@kroah.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH stable v4.9 0/4] KVM: arm64: Fix AT instruction handling
Message-ID: <20200908131702.GB3173498@kroah.com>
References: <20200904112900.230831-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904112900.230831-1-andre.przywara@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 04, 2020 at 12:28:56PM +0100, Andre Przywara wrote:
> In some architectural corner cases, AT instructions can generate an
> exception, which KVM is not really ready to handle properly.
> Teach the code to handle this situation gracefully.
> 
> This is a backport of the respective upstream patches to v4.9(.235).
> James prepared and tested these already, but we were lacking the upstream
> commit IDs so far.
> I am sending this on his behalf, since he is off this week.
> 
> The original patches contained stable tags, but with a prerequisite
> patch in v5.3. Patch 2/4 is a backport of this one (removing ARMv8.2 RAS
> barriers, which are not supported in v4.9), patches 1/4 and 3/4
> needed some massaging to apply and work on 4.9.

This, and the 4.14 series, now queued up, thanks.

greg k-h
