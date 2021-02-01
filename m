Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3488E30AB36
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhBAP0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:26:24 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36825 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231263AbhBAPZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:25:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 4A042AAE;
        Mon,  1 Feb 2021 10:24:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Feb 2021 10:24:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=vnY68hAQGVux9HZpu5FKpgw08ur
        WMrsPppLlYGCF9q0=; b=XQEOVQZtkHY5zoLsMie1U7R3Lx/DUMEdUb8lz/ktH/Z
        qaaKF8E80JtZSaTSahnNP7lSYwVr+P2xYWOxpwiq6vZCpdFyb0NW0qPOWkzzefWY
        iMpa/Y2MhPiTJIv3GsXLR4csNRH7y4Vgp3Sspyh7VaHW0AmHCeK0Vk/WZp81D0Jq
        fnGjJQnDEcLBFDHiIYvriJuNGJSPtG7UyFAS0BWo3uFVeW0rwb0uv2sUkgVjkNfg
        ocZaWpIP91vG4C3Rsk1q3qUpk1cd9oxOdLfRCAgNUr3qFP8m8gm7HbSmu5PQ7FeM
        BfM2fpKasTMgsAPYIV48Oagczn0r4uZTnpjlN/iHonw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=vnY68h
        AQGVux9HZpu5FKpgw08urWMrsPppLlYGCF9q0=; b=gU5UH943ul2tQUm0tLKq8l
        TsRsyeEFp+eP6cLBAsi4G0m0FWPhq+b6RYUiTFVquEKtg1aJZ58imedw08HlTOmF
        ZTXkhF+QG6TJvkZCkyRC6p/cD3Q78MDg0/pIfxTh2L4SwjF9XrKzKZHN00CEAd0c
        gD2uvzzGzQrbvUeU8ei2igFLu51sW1w3vBy3WnELg1epKXpqZwv1tRjnt++LJ5GT
        /ONEj1BVFUnCRfz8t6x4d1TIARnD2qj9GnUODvFNaANBmw46G8F1XIp7ELbFqrSI
        bqRCA7SvUn7hyOHnYrXPkaMvt5QCP9Ap1SxL8aK8oA4qUBRnRW0SVyP5SF4q9DKg
        ==
X-ME-Sender: <xms:Rx0YYK3YJDY5SRZCZAaUzP2vtg7u0kVKucLnK7LAbqVzFaTVgAurWQ>
    <xme:Rx0YYNHLzTWktaseEk90ue3mj_UWvdjLvGE_vpi_S4lToY_ZM2AgfvDx8rmUNxVZo
    TnKivHI0Kc7GA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:Rx0YYC7myeftqGvCsrCuL_QG9cy3MpzPlfuZXaMhrJvsObYWjeH1mQ>
    <xmx:Rx0YYL3BD3EZPs2OVfm84o_7yy0BQa3nI-zbQNl4BfSXPZG47JZSAw>
    <xmx:Rx0YYNEPRQiV-tFyD5ZcOgPWRS6OZl63qSQC80pyLYL-sK3BWAXdHw>
    <xmx:Rx0YYMxHF3XLdcZRVQ4ufszFs_vUgPasT335Tk-IVLj6qHCTbq4NRQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67EF624005E;
        Mon,  1 Feb 2021 10:24:55 -0500 (EST)
Date:   Mon, 1 Feb 2021 16:24:52 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/12] Futex back-port from v4.9
Message-ID: <YBgdRJxWt8Y1Oog2@kroah.com>
References: <20210201151214.2193508-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201151214.2193508-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 01, 2021 at 03:12:02PM +0000, Lee Jones wrote:
> Ref: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/pending/futex_issues.txt
> 
> This set required 1 additional patch dragged back from v4.14 to avoid build errors.
> 

Many thanks for these, now all queued up!

greg k-h
