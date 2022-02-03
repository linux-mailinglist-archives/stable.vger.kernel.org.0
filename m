Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5353D4A86E9
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 15:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349256AbiBCOri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 09:47:38 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59559 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351539AbiBCOrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 09:47:36 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7963C5C00F8;
        Thu,  3 Feb 2022 09:47:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 03 Feb 2022 09:47:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=8RilFMFgcYZizxfInLg37PRVQ+ik9YYAaT2RHv
        RrSyk=; b=IqD/cGGypnGuVnRz6DR0VCIu+ZpHbFNsxK7oNZVL9MpvU389T7OsDX
        Wi6cRgcy3o0Xoimw+0glR8evt9bParPCZiw2loLdAkAWLv14gyic+IRAIu9+uxHm
        m+ppQxYiLEt/l8iElYX30k5i1XJJD/y55qSnJ+IXqcUcbCgsy2quThnZou31hwyh
        l//GRrvvNTEps+WFNpMuT7Ru9HQr514fbPYW//occnwru+vYQLZ6YmlydCb3sceS
        H8/Xzr9tPljzjF4CC7Hu4iSFwsnBcJvM+KI95i7cxLgTeCb3aMmMoGCeOpdWXRB6
        crVwT8DkzR6aSFAD+L4qto6hDHEN+AGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8RilFMFgcYZizxfIn
        Lg37PRVQ+ik9YYAaT2RHvRrSyk=; b=P8KMSyn+LvPwKLqov8sR1178VDQN7wqtU
        cqDE/GU9Br/k9JrIEtN9C+HasR6Ij4HcPOxI5YP42SfOOGnTPAFtaI01ROEtDwNU
        ODKW/2cPkeqU/VReDCv1bP2SFt5qhnIIvRCVCOAbtUKbYjr4qnXd9Ucz5H+Ho/Ns
        XBnVOJ3cMc6iqnc8Tgp8F2e5d0YquAFnE6wZD1gU+V6lbw5xTx/Eky8dwX6IMgOD
        JaAO1Q5k1HC5g3Ja0CrtuTBqR/sLn/X+yvqx2HlAQNchYSbePweWa4oIVR4trGwU
        8trvnZFoi+PsOMMZNS1A8QyO59Pq+v7ILJC1aDwNqbn1I5FklcAYA==
X-ME-Sender: <xms:B-v7Ycwfo_21WJdw44wTEbtkfzl_7d677G-hP1IGFXYH1sBt-KcwSg>
    <xme:B-v7YQTuCw0lLClgzHi2YbgulUUBVXqt60ktkm0KVSPaFKovrkk8_f2YkeRPMN3qS
    X1UcGZI6R6kbA>
X-ME-Received: <xmr:B-v7YeVH_CCMGatDzgexHQcfhoRT4av28VHol8iztRgHEzkRBzZnMzq4aIS4F0sDxUbrYuhkTe9mXSV5PhO5HfYFGx0Phzwy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrgeejgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:B-v7YajGAdYY4oioHUW2ESLEy0gBAPCyH9mCU64YM--BRwBH4z4gdg>
    <xmx:B-v7YeBJYMZGGNgSnx9DHO5BGAlz6AqBMM5Nlmh3TwLjQA_8ug3xMg>
    <xmx:B-v7YbJQxdSKccsNxSpWyvGakMPq4oUUGkAjvGOcBbMDcSrYmLwvMQ>
    <xmx:B-v7YR9CzvSAaC22dqjZskD72QHrWN-ILj-zNIGS7ZmC4ffrgry4UA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Feb 2022 09:47:34 -0500 (EST)
Date:   Thu, 3 Feb 2022 15:47:32 +0100
From:   Greg KH <greg@kroah.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     stable@vger.kernel.org, pablo@netfilter.org
Subject: Re: 4.19.y stable request: nat soft lockup fix
Message-ID: <YfvrBLwOOo5d/ZvX@kroah.com>
References: <Yfqb6BKXBqrkMkBa@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yfqb6BKXBqrkMkBa@strlen.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 02, 2022 at 03:57:44PM +0100, Florian Westphal wrote:
> Sasha, Greg,
> 
> Could you queue following two commits for 4.19.y tree?
> 
> 6ed5943f8735e2b778d92ea4d9805c0a1d89bc2b
> netfilter: nat: remove l4 protocol port rovers
> 
> a504b703bb1da526a01593da0e4be2af9d9f5fa8
> netfilter: nat: limit port clash resolution attempts
> 
> This resolves softlockup when most of the ephemeral ports
> are in use.
> 
> Its also needed on older kernels but unfortunately they
> won't apply as-is. We will try to get modified backports
> for older releases and forward them to stable@ later.

Now queued up, thanks.

greg k-h
