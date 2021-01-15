Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447162F75F7
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 10:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbhAOJye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 04:54:34 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35373 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728652AbhAOJyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 04:54:33 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 248035C009A;
        Fri, 15 Jan 2021 04:53:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 15 Jan 2021 04:53:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=9
        ApFtZeNhaKGGoE4bR9kvaOataMHh2fPzoy6WypX358=; b=RenCvY00FAVPBeiR2
        mYj29+sZkB+YhuY5IMR3wbBX3hvk0BIgr/iuPpBG69bAnUkGk8tV186SXcPFRnV2
        qC/MdPW7sMRPSzb1BpnDxENq7B8pOvigcbpr0USPVDey42aNmez1NVVK8ory2aem
        meJocRqJcuOzse8J21jjuEW+/mSiP2QE0u4p3zW0mLeI7SnEZcfvNf+CVhFqlrx5
        OEmCpWYKu2NDZmDxlwy0FJGONgeSWJpy0ZRz5WHTYO/jw9YzecufFK0e23kuIsi3
        LvU9NH8vKwxFCvauGg1VMkIGJCewkjVaz2ziSTzVsSULRUKvlXF7QwVNhuy06aMZ
        mqSvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=9ApFtZeNhaKGGoE4bR9kvaOataMHh2fPzoy6WypX3
        58=; b=MYCmXYD2JABINfsT6qMFcCupv1AyIFcbUSNaDYjHCRmwVXWcox7UAUieQ
        2p3sAWI5VgwOWxYxkVol2BL2uPe+72VwqjGX3AH2x9pTrPuEMjL0fl1YuTH9qUZu
        0nWFvEe5Z/GpDLmi/61Sv/8IBHDBifl72r876wjqq+hW82VsdxYT74o8NqfeGirH
        lLHEemtwgViQOjj/FJuILocARFwyHpwqBVHCOnS7za6lOWeD2nnGYdgJtt+KCoO9
        SWgQRD7r25gcJQAyyAETs+SV7coCJqSzGM31FcUBthqS4FUxcp4OURUX4eB/Z+D6
        TrSbfxxXkYsTJQDzR3xdRHOEDTDpg==
X-ME-Sender: <xms:K2YBYIMacxxpDDZ4PCCT9ryEf9wt5_nTUuk0GuFM4Bt4bse9ySUJ0A>
    <xme:K2YBYO8XjtmXk49PJpdX7A5SceCRxrTV6_A4YD9JvAmRLtCA4nVmy-iQvOnulQnuj
    GkBPNSM8-TfpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugddufeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:K2YBYPRCtZSEQ0_ElKDHFXsBG7dVEn-wzthJQqVwSzLor0N-TadG8w>
    <xmx:K2YBYAsmKMH_S6xfI6bo5Rh8PrCiGUCQ4sezTn2Yd7CzYoazLsp3PA>
    <xmx:K2YBYAfZrSiQlWZCtqmv6NiORFmY3jKYdA_BIfuQpQFnXsMYWwTGag>
    <xmx:LGYBYKq5faIePnMnp9YOSSgOkNvRubZnUOYQzoDeakxa8HmE4_ymtA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB7E924005A;
        Fri, 15 Jan 2021 04:53:47 -0500 (EST)
Date:   Fri, 15 Jan 2021 10:53:46 +0100
From:   Greg KH <greg@kroah.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Request backport of ionic driver patch for 5.10 stable
Message-ID: <YAFmKvI+fSSGzusE@kroah.com>
References: <3ebd98b2-e680-13c4-2e42-0a6ebafc243b@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ebd98b2-e680-13c4-2e42-0a6ebafc243b@pensando.io>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 01:27:03PM -0800, Shannon Nelson wrote:
> Please apply upstream commit 8f56bc4dc101 ("ionic: start queues before
> announcing link up") to 5.10.
> 
> When initially discussed, the implied race condition was still theoretical. 
> Since then, a case has been found to generate the race issue and cause a
> failure to bring up the netdev interface by having the device in a bond and
> the bond driver trying to bring up the device on the netif_carrier_on()
> notification but before the queues have been started.
> 
> This should be applied to 5.10 stable.

Now queued up, thanks.

greg k-h
