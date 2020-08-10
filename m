Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935112406B3
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 15:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgHJNjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 09:39:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38973 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726569AbgHJNjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 09:39:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id BC1CE5C00CB;
        Mon, 10 Aug 2020 09:39:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 10 Aug 2020 09:39:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ZhnjRGAeCHne7uifxiQGpe/FnFE
        ts4/XW5+zaLnq0GM=; b=VZxGuHIqZ53gH4vxAv9D8kS7Y1Wkpk8/UpEKX2/Jd4R
        0jNMxmfEidh5lDaOHwsg8aTHlxE9630Ds6UFEAzROuBiMzJfyzxik/jgxEWeXSbl
        AOVIDCensKMEOBpvJlZoMRncCL8w6RFRpf/PzWFbcjpLP44mrnZrkWJ4VuZACXW3
        JCAcm9waJnSGJ4Z9gENb4in6qoHShz8tcNnixrwaa5FqfA7knqIT3zSwZU8lfN78
        +3EKgq47lv/kDmTZr0XDBp1Wj+2HfnCqY8nx4Tvh9OqUzy+lixoaOKW/3kn2NuMt
        ADnjn/jxM0YNK4F9+bH5TjNfLhVexA1f9PPQ1+8M8MQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZhnjRG
        AeCHne7uifxiQGpe/FnFEts4/XW5+zaLnq0GM=; b=Ww39GGaupB6eegXScjEkWI
        wc7fxiIX0bB7UmNngS4yNBd9xNBr8pNKXBHv2vfY5vOq9DzkJG9mh5b5pgZ3+Jge
        Cmq6aahpWHjQP2IjqG57W91DHOIiBSI9JGkJW5IjFAdX7wjaKSOK7d9SekAb3UMC
        JdLTgkbfKsh6AGwP/ak/h+i0LD2fSURSfRD+jJzOLo/L1MkyGPDvM2065zojVsi3
        yUYAMXW5gyCiyeWnDgXSi3FDSF+5Kf0u2pgTkQ06PNnpd34vPAy6t69U+6Tu00wU
        eMSjPhmV6tFVs1F8t5T9x6Dd31m1dL6JHcIIIxpp0xvjx5J3feM8epb322NZ6xQw
        ==
X-ME-Sender: <xms:CE4xX2STEyw-vcazPigCYVVsVzxdBxA5_sRzDMoyHVLcP01sNvJnOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkeekgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:CE4xX7y15zoPHuTNw-n5ulKV4T28ysCmG9wkWikWStb-N0ESXqgN1g>
    <xmx:CE4xXz2hn8qvfUO4IQiCvIFFxfA802T1GHpt9kntk1YWBz8A-C0x6A>
    <xmx:CE4xXyDh838Ip0dsY_ubIwB0PxuBTyrvkKw5TsExmeKDdHiV--7ElQ>
    <xmx:CE4xX3bwOXyS-XTZDso5t8QOeVPbycsxldtHfZx_mSBjoxho_ud3Nw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F170630600B1;
        Mon, 10 Aug 2020 09:39:19 -0400 (EDT)
Date:   Mon, 10 Aug 2020 15:39:31 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-security-module@vger.kernel.org,
        syzbot+e6416dabb497a650da40@syzkaller.appspotmail.com,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 4.19/4.14/4.9/4.4] Smack: fix use-after-free in
 smk_write_relabel_self()
Message-ID: <20200810133931.GB3491228@kroah.com>
References: <20200807161324.1690303-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807161324.1690303-1-ebiggers@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 07, 2020 at 09:13:24AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit beb4ee6770a89646659e6a2178538d2b13e2654e upstream.
> 
> smk_write_relabel_self() frees memory from the task's credentials with
> no locking, which can easily cause a use-after-free because multiple
> tasks can share the same credentials structure.
> 
> Fix this by using prepare_creds() and commit_creds() to correctly modify
> the task's credentials.
> 
> Reproducer for "BUG: KASAN: use-after-free in smk_write_relabel_self":
> 
> 	#include <fcntl.h>
> 	#include <pthread.h>
> 	#include <unistd.h>
> 
> 	static void *thrproc(void *arg)
> 	{
> 		int fd = open("/sys/fs/smackfs/relabel-self", O_WRONLY);
> 		for (;;) write(fd, "foo", 3);
> 	}
> 
> 	int main()
> 	{
> 		pthread_t t;
> 		pthread_create(&t, NULL, thrproc, NULL);
> 		thrproc(NULL);
> 	}
> 
> Reported-by: syzbot+e6416dabb497a650da40@syzkaller.appspotmail.com
> Fixes: 38416e53936e ("Smack: limited capability for changing process label")
> Cc: <stable@vger.kernel.org> # v4.4+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> ---
>  security/smack/smackfs.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Thanks for the backport, now queued up.

greg k-h
