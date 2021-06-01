Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3E6396D80
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 08:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhFAGmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 02:42:10 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42217 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232989AbhFAGmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 02:42:09 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id B34D35C01D1;
        Tue,  1 Jun 2021 02:40:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 01 Jun 2021 02:40:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=3SQOCHYhmE94iQdRM9MpOC8T+Wk
        EoGFN1ZAYs1lz2Hg=; b=ke+mnos+qObHP3IMmuDePnVN/19K0iJ4gfrgKnNqG9q
        SsBg7I70n4szd7I52b/aRhzECWKaE9KyuRIgFSFoZ4pjuCw1lNc1/rHIqnQs6R/1
        V2mAXszTYQ8DRRc22nqYFIkXD9C8qzhYYLzG3gK8EIkI3TpBXzJc7lLbXIc9wEAq
        H6ifVCvUKwybVoRFRbBbu/cmYquiG1iQSBWzvUVQoZIccrbQaUG9kLfRDQf4fBtC
        rgJKKO+jwO5OXRQVLl4O2eODU9PiVxmCfq2NjIyWO1A0ccBouW35uCE2mZ5iofJo
        LduYU9SKh+hIX6KAXKxZCX/aOWys7cvKxcDvg+1TsVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3SQOCH
        YhmE94iQdRM9MpOC8T+WkEoGFN1ZAYs1lz2Hg=; b=PWJhTQhkX+n53BwWrCW+sH
        W5T/gGznEmAwJGJzCHaZTOLWwM1o8gx0iU+GoHrxMQYcvWaQgABAalwvExex7md5
        NIpya6JkXi0661F95owWro5TTz1TaoTG8mkZr9clVKx5GNSo3lAxwRsCXL7cyNAa
        NbYUXg/8X0k3kp1KnuxOlXozYpymi2FPaw7CUUkvttUqagbVxizNHX185rELM/N1
        y8IXrYVMH3d+QloQ0BM2ihgWTRle6cVkHLSRxkNt6oh3ZkBwcqyl+VCai5bPOULH
        TDUNNZO1GG1fyV6AbO20hqvnm4ZtbRNKdVSLhuh4d5kEBnPr5ZydxQuR8yv9HlZQ
        ==
X-ME-Sender: <xms:XNa1YDfErpxWTL9D6EcNB6e36QOtjeBKlkAO10mZhJGHVBhbdbUurQ>
    <xme:XNa1YJMRXZdizEklSiA7LLjR6aX9L1aFDq9ASkkKG5SjGlCiC-wB437fkZSjGd88T
    nZ13Dl06yy7Mw>
X-ME-Received: <xmr:XNa1YMjlTrU4BNgCgEouuNSJ5ay17OcvIlmhgXbyooEJXHKWLbMuvLewoZdV6ugUjgPlmKEjEjRIe2WQw8w_rW30ayML08Sv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdelgedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:XNa1YE_yTJ6_Q0t2kfA35EB9y-MXtXfamvUQXlR012c4ttZzsy-Cgg>
    <xmx:XNa1YPvpjaeDvJkeH1Jjtlu16mEBjWPclZleid-CeC6XAVhj9fkCkg>
    <xmx:XNa1YDG-7rUB5fDvHNpvHTcGAMeaCTBWXvUHFHuiUyG1OAUomDKtRg>
    <xmx:XNa1YFDQIv3VnQK2eTpMurmMmsqDSOmKhYYuwBM9Ssw5FK1lj0kSrA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Jun 2021 02:40:28 -0400 (EDT)
Date:   Tue, 1 Jun 2021 08:40:25 +0200
From:   Greg KH <greg@kroah.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v3 | stable v5.10 0/3] x86/kvm: fixes for hibernation
Message-ID: <YLXWWWG7Ut7p3SPE@kroah.com>
References: <20210531140526.42932-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531140526.42932-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 04:05:23PM +0200, Krzysztof Kozlowski wrote:
> Hi,
> 
> This is version 2 of a backport for v5.10.
> 
> Changes since v2:
> 1. Rebased v3 of v5.4 version, I kept numbering to be consistent.
> 2. The context in patch 1/3 had to be adjusted.

I also need a 5.12.y version of this series before I can apply these to
older kernel releases.

thanks,

greg k-h
