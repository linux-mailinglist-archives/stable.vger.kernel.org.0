Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC501161BA1
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgBQTcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:32:11 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51955 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727089AbgBQTcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:32:11 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8A08821B62;
        Mon, 17 Feb 2020 14:32:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:32:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=p
        B5/h6QtXnWjwhO6h1rG1lFeayi1FVcb46TRWMnQw1s=; b=JOJENwiBbOwXG+Guw
        549z4ycmgVKfPaW0N7V3hgBN1ZXeNf+evPx05Sy7tjkBqUeXSp291h2vwi/Bca8q
        +PtFZCVFth0uImf2ehTIdHYYnrfw45dHkb20n0rXUxU+R8LDbrxvAtPtaUvgrVtb
        3kVhAuDfX7ZnduiKZDrfQ/sjAcUb7ihCSf01YCZEfvwX9BxGb7JOXqjqRRAKNQp9
        Zpu3VjbIP0+1BW1Hb/pQWS4GYVWMQvSddbm7pV4i4orz16OTlDVTf8aiLCjKw6u0
        YMl/ETypzlHgE3qPEiUH/mxNQ+cDEl/yVyCPKrqyfI3T/s8aX1a+ewhoujoHbr2H
        ORbFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=pB5/h6QtXnWjwhO6h1rG1lFeayi1FVcb46TRWMnQw
        1s=; b=FYNmL+qUzbx2rh0eKMj2i9XNPA1RjYR1ocC19toOvSkipmV06PG6j5joh
        lwFApgOHEKYEyAUZlQauadpLlZmddF6J+VEAgusBy1S3DivatqXwcG9FqXLomo/T
        BZyXHOvP+ncEiNsjYkHLsJaTV5+JCF1TLxWnd+RWVlGQ4MGC6sYErFmxmVeqA7P8
        DR+WC6jk+X3NFiW7mJs6zengKLTtvYMTxVtPt1mTjvggxw4VEbZnF/kP2K5DB84l
        a3n6Pfvp3gibHN8kf/pdfqXs9k205IqysYwNxSh26UF5+USHj3+DdnUn6eA8lSKj
        1I8mggcZStv1pOuadSvjw7pzWBGmQ==
X-ME-Sender: <xms:OepKXtMxwYCx90EKCe0POZbdJZYpCye-Vn4bXlX32SnI_f1uFswg6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpeehqdhrtgegqd
    duhedvqdhgsgejfegvsggrvdgrkeeijegvrdhithenucfkphepkeefrdekiedrkeelrddu
    tdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepgh
    hrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:OepKXq3SXLszq6YQevLf3U_TmsvYMcn3k-DvfXA-W4660zHMvmKhng>
    <xmx:OepKXkHid8xzOarf8R59RdPNfrKeq2eMv-xXQNNA0mgJ435jPkES-A>
    <xmx:OepKXn7JJySpPuzn16mYFv73HROVU1wUHS0u5GacQO8JoD1bFxMgRw>
    <xmx:OupKXoXx2w8321Utv-Q5nDwa-p85rL72QdMv4V1CvHccbmGVi5yOxA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9E334328005A;
        Mon, 17 Feb 2020 14:32:09 -0500 (EST)
Date:   Mon, 17 Feb 2020 20:32:07 +0100
From:   Greg KH <greg@kroah.com>
To:     Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
Cc:     stable@vger.kernel.org, Gang He <GHe@suse.com>
Subject: Re: ocfs2 fix for 5.4 LTS
Message-ID: <20200217193207.GA1724751@kroah.com>
References: <20200217192155.GE18366@valentin-vidic.from.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200217192155.GE18366@valentin-vidic.from.hr>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 08:21:55PM +0100, Valentin Vidić wrote:
> Hi,
> 
> Please include the following patch in the 5.4 LTS kernel:
> 
> commit b73eba2a867e10b9b4477738677341f3307c07bb
> Author: Gang He <GHe@suse.com>
> Date:   Sat Jan 4 13:00:22 2020 -0800
> 
>     ocfs2: fix the crash due to call ocfs2_get_dlm_debug once less
> 
> because ocfs2 module crashes the system starting with commit
> v5.2-5650-ge581595ea29c up to the fix in v5.5-rc4-152-gb73eba2a867e.

It's already in the 5.4.9 kernel release, does that not work properly
for you?

thanks,

greg k-h
