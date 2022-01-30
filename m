Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6274A34E2
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 08:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240797AbiA3H2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 02:28:05 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:52789 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240201AbiA3H2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 02:28:04 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 731FF32006F5;
        Sun, 30 Jan 2022 02:28:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 30 Jan 2022 02:28:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=ZkvE8zuYCRxTssqfQ3SZXFzQbD/Ja7rH9StXHY
        qgdxs=; b=MHlia3rgA1fabfvYepNGEMJpgq3nM8afY7jxDt9uNPCX/oCUQlrlLX
        YF9vTLMKcQ0Y0/sIlobtGBz5kRpyXDX+IEY5S6gIV82+UH8X4YVK1CoavalrATti
        9bNW9IQJqXTCTZ1rSC1rDVe3c5QghjKiq1yp4ZOvrHe2yb1S9KNtGU+oWUEpvZRW
        1ptNNuEe4ALCPTwXfPlLq2tSyYh2lhZPH9cwyn2iyMYr4nCeEaGoH9z0YJXgjjH/
        lA74S24yDdRrCcYflNJ4I7sj4Fy1w0f27Z/xkYP+0mhHeUfyhg7uHpkP6ImwkxMB
        n7cyzXjxAR3SMeUUkYP9tJn/JpD7AHAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZkvE8zuYCRxTssqfQ
        3SZXFzQbD/Ja7rH9StXHYqgdxs=; b=lUfbJbNI5PJT3kvwaHjtLC+YPfpNq3CWU
        JsyjkLUlF+x9gJIr3Va31h5FO+gfyS0ULjWQ3s3ibqoa6jiV8Op3CCIK6qyiohBc
        b5YTAtXTHW2yGrOvExvDMNp0+v9WecNGrdfTRiU6bnAG5tp5GY8k9qczRzmAmd94
        BpJvt52RvAvvTp+dyirH0141d/hRSxrF/9O229XBIJi28HpXbBxEJLqqwxQmhvwJ
        01V1zf+dB+OYSh3HFmM5wu8hjOzJiq+MiYj6lOd9vve0knCSbQaWlDx8puylJyPZ
        JnHyQsMOWKZUkxcO8UwAB1ohWDAqoEsAGTNUKtQgAcY+zNSpJCUfg==
X-ME-Sender: <xms:Aj72YQd5TyXIkEv14qONBxTHqhhIZSh_H8ZujDlDmbm_uFQu7AtshA>
    <xme:Aj72YSPu_DU9bn9ogKecHSuvBvsB1sHfcJojRHcQPdVwmoAP8l8y2s6QeVLRYaI8r
    EXZQsfrU1iwmg>
X-ME-Received: <xmr:Aj72YRgvSRRMumGuIBh0uJ8K0Rj_ysDUNHlZIVHmmHd1xwaYfW2XMr092sM410ktd7Af6t8BN_a6cFerQe7YZBVUYfkDH0lg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfeekgdeklecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Aj72YV8JfOJBWQC6we-0XVCZLqLse8m5Z_XWyXWwqTXJlvM_Q6SMYA>
    <xmx:Aj72YcsbEyHRTiy5bgk0KHIsR1C1V6kI_ha2YhnhizyKwg5-I6nLXg>
    <xmx:Aj72YcHTJWr9K3Q2XilgCn2vLCCrQBqnGdk9gC-zD4_tlb9e51Baaw>
    <xmx:Az72YeLyh72JRIPIEvy4eg-6U5-cbcsc28NN2pr9NG22vGObCrVfFQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Jan 2022 02:28:02 -0500 (EST)
Date:   Sun, 30 Jan 2022 08:28:11 +0100
From:   Greg KH <greg@kroah.com>
To:     Felipe Contreras <felipe.contreras@gmail.com>
Cc:     Linux stable <stable@vger.kernel.org>,
        Linux wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 5.16.3 with mt7921e
Message-ID: <YfY+C9hiX2V7LnT6@kroah.com>
References: <CAMP44s2vAmfHU+h5bSp5FJvks7T+b_tpdU1U4pBvK9jFF6C=eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2vAmfHU+h5bSp5FJvks7T+b_tpdU1U4pBvK9jFF6C=eQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 01:05:50PM -0600, Felipe Contreras wrote:
> Hello,
> 
> I've always had trouble with this driver in my Asus Zephyrus laptop,
> but I was able to use it eventually, that's until 5.16.3 landed.
> 
> This version completely broke it. I'm unable to bring the interface
> up, no matter what I try.
> 
> Before, sometimes I was able to make the chip work by suspending the
> laptop, but in 5.16.3 the machine doesn't wake up (which is probably
> another issue).
> 
> Reverting back to 5.16.2 makes it work.
> 
> Let me know if you need more information, or if you would like me to
> bisect the issue.

Using 'git bisect' would be best, so we know what commit exactly causes
the problems.

thanks,

greg k-h
