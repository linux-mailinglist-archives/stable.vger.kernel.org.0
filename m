Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BA13003D5
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 14:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbhAVNKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 08:10:11 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:57503 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727047AbhAVNEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 08:04:55 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id DB7103BA;
        Fri, 22 Jan 2021 08:03:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 22 Jan 2021 08:03:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=k
        zk5CkVPDV2z5ANLM8vZ51aMVOkQ1/iQCg3WWm0XRpI=; b=EIVRnu/P3l8XjfUVm
        H2fU/D0jtlKFt3+hQgD+aFvlaqCPT/hnEambIXcAasw4SU6Tga0gz8KuP5zZi3N3
        ZLlpaKn+L7zEJgP9sXjxJneAFYWCJWe5/UMf/fImn6i/GkTfy3JJ6B6zjdI562Rr
        BgrmPcAxBjZedqyPTNH7lk0csARp8hjtaIyqy/0fDTkSj3l0Kl5Qf8gQtnKlzwho
        xE+r/r5ekWzynpcVdFydsS+r/2i/VXF5X9U/qe1tmYjNFiwVcSNSuZjuNwhPrMRa
        X/gqj4UPT767AvtQ88fJ5kDfvzSHbyu+InUBj5W4J0O4Qw0KrBg6gS5K0Gi4KsZ/
        R02yw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=kzk5CkVPDV2z5ANLM8vZ51aMVOkQ1/iQCg3WWm0XR
        pI=; b=EMN4zhKaBmhHVlOtCgVbKjEON+KFiJlEpuSsH2Vi/rF2MHtysYIIOzJKX
        Qr9tCEPNxhQNXK612hspvT9A70JLwUbTp5+qb6gYCPIN3TTFGmaDflpFoqf/RUY5
        5rm/KNOXRuHG81wFrKvmv4VpnoPJ0XIL6vB18Z5JJP83Ik25FkHiRqO671du4/na
        R6nLFJc1vgn7Vkw57ZXtj0n8SO8da6dmNr8OwhZAeltEaUi4GoQH8lZPFLD6/GCn
        qTYM16Ycv4zbWP5gSbsr27D8YPQlSjvzq1KUgXbVuhNd/2XcUoEc+pc4qpO2fLmO
        5vOXRgLJSYMvZhrl5REY56jz0QvPw==
X-ME-Sender: <xms:LM0KYO2l4yC7lM0ix8kfNDef1ts-eeHScBLP0KximdvLhBKLHg8yVQ>
    <xme:LM0KYBGwckzDAiel0IuVqD6TVsvqJ_2Ggw19N47-Rvzl-Z0hkV7MmlZmz2V15GrtD
    sWtxpozW83L2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeigdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevtdeile
    euteeggefgueefhfevgfdttefgtefgtddvgeejheeiuddvtdekffehffenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:LM0KYG6VEJxl8FJz3XXnk3kpWMuGMOyZYZWeAfDHF7bjBTUNA9ng4A>
    <xmx:LM0KYP3fm8PcujZQZ2G62oxX04nclV6muer8yqa1UmGPZUHBf802_A>
    <xmx:LM0KYBFxG3RPTW1pS5sUACXqSOtoW8YtC4H2RAZd7NurBKmjgQllYw>
    <xmx:Lc0KYI1gnGg6K7ghxCQ32cKGADVgIn2QAqQgSXO4mvuLM--Z7UDLDQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CCE15108005C;
        Fri, 22 Jan 2021 08:03:39 -0500 (EST)
Date:   Fri, 22 Jan 2021 14:03:36 +0100
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?=A0Tan?= Zhongjun <hbut_tan@163.com>
Cc:     tanzhongjun@yulong.com,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Tobias Markus <tobias@markus-regensburg.de>,
        David Howells <dhowells@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        =?iso-8859-1?Q?Jo=E3o?= Fonseca <jpedrofonseca@ua.pt>,
        Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] X.509: Fix crash caused by NULL pointer
Message-ID: <YArNKPD+3R7mx2gA@kroah.com>
References: <20210122121917.1414-1-hbut_tan@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210122121917.1414-1-hbut_tan@163.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 08:19:15PM +0800,  Tan Zhongjun wrote:
> From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> On the following call path, `sig->pkey_algo` is not assigned
> in asymmetric_key_verify_signature(), which causes runtime
> crash in public_key_verify_signature().
> 
>   keyctl_pkey_verify
>     asymmetric_key_verify_signature
>       verify_signature
>         public_key_verify_signature
> 
> This patch simply check this situation and fixes the crash
> caused by NULL pointer.
> 
> Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate verification")
> Reported-by: Tobias Markus <tobias@markus-regensburg.de>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-and-tested-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Tested-by: João Fonseca <jpedrofonseca@ua.pt>
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: george.tan <tanzhongjun@yulong.com>
> ---
>  crypto/asymmetric_keys/public_key.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Why send this to us again?  Is it needed somewhere we have not already
applied it to?

thanks,

greg k-h
