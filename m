Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FBA43FF07
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 17:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhJ2PIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 11:08:18 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:50121 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229684AbhJ2PIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 11:08:18 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 6BB953201C50;
        Fri, 29 Oct 2021 11:05:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 29 Oct 2021 11:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=OlSOxjUfkMixE/PGTV0ch9+9FPY
        sgRVDpDn3i+VXvBk=; b=CPhocKsyDRbqZCo1GOTFo5RL8501ytknt4g0n2JMIhO
        ybJ5dOkdKXn2eF4hH0WFqg5PakvVeXFVRmvxt1Tmjd4j2Kmi5frvCuaZ+IFYKz5t
        L/BtzDwEbs7lMtwyyGFABkvPnhrifAc3ftb3wXqZz2o/cng9jCOs6rZbP14WunPV
        MFQjfz7/lBeRW1EStgs8m4T/ouMSyRtdVqX+mt4g7cMuy4LfvbGmXlbW5KDxkiRw
        Uv4lZajUXO+JP6Wccx5SDzx/SkqI/UQtlQqHHN7yVx/3iUWU4oWlZffxCDUysne8
        zS3oGPok4cqAvQcPEt99HdK4hCOBwYLG7vR6GH1fGAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OlSOxj
        UfkMixE/PGTV0ch9+9FPYsgRVDpDn3i+VXvBk=; b=oLf+OtkDtIvAWUFQKG5vsX
        tuRvC79EA97LW4v7HIiGKd8KzL6mTzbqT6nMzDcutqDRhVfc+8B6vq00OMI0O0R9
        2nFyJnVEVF57CUzT7S5WwZenW/cULZK9hlfl6lj9X2FDs5sGjq1vAe3tWmjrBC+X
        nsyKhiUAZkUYPP+p8f9MojHTRY4KN1oWEm6tjLFLEYEjrEoO33cnB1hPSXiRRjFg
        U4eQfmhT9rxHeEJt35f3du+sBcW8fDhbcS5eCkJBL3Ubfc45JDiRKEExirMCfqJ3
        5NgfM+o7ms8dIHvrJkgHfpQGba3JJ/Ups4+y8cdnVRg6R6sf4gEsNjwtKeIErR2Q
        ==
X-ME-Sender: <xms:zA18YY8Caj5e4DYIH9ccoIwFJ8ZjpFVaStpNi3cT6d05HthdUW7j0Q>
    <xme:zA18YQutOXdAXH8Ab4kZbEQqg40lRZ23Z0zBm2AxnqeJKKBT8P8vqEl0hJMFo9Fbf
    c3QGxqTqkKtAg>
X-ME-Received: <xmr:zA18YeDnipyLZwztBBiqQqXZPh0by769uVBmg_kyckqjMv25EhxEyGnj_5-54fcSKxK-2oFha8yZglArEUz9EdRcqIdein3n>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdeghedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:zA18YYdm27rAza8WgCPaKSbKU4S3dbiZuUHPcdk9b2qf3IFpDTJuJA>
    <xmx:zA18YdO1P4B3PE518lJD6SoH23UfLKcSET8QEl_N4ztQCrEJdvyDiw>
    <xmx:zA18YSmZ5vFCawv497uPMH1ha1Esg7nFSpWgQltQCP3dK_CFHU0T6g>
    <xmx:zA18YWaKbitNeo8GdqvanvJvUxdD_H41qVH9epndpfOPmrKKEa283Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 Oct 2021 11:05:47 -0400 (EDT)
Date:   Fri, 29 Oct 2021 17:05:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.14 0/1] ipv4: backport fix for CVE-2021-20322
Message-ID: <YXwNyZOk6uPb/Mpl@kroah.com>
References: <20211029145418.1888144-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029145418.1888144-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 29, 2021 at 05:54:17PM +0300, Ovidiu Panait wrote:
> The following commits are needed to fix CVE-2021-20322:
> ipv4:
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6457378fe796815c973f631a1904e147d6ee33b1
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=67d6d681e15b578c1725bad8ad079e05d1c48a8e
> 
> ipv6:
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4785305c05b25a242e5314cc821f54ade4c18810
> [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a00df2caffed3883c341d5685f830434312e4a43
> 
> * Commit [2] is already present in 4.14 stable.
> * Commits [3] and [4] are not needed in 4.14, as there is no exception hash
>   table implementation for ipv6 (it was introduced in 4.15 by commit
>   35732d01fe31 ("ipv6: introduce a hash table to store dst cache")).
> * Therefore, backport only commit [1] with minor context adjustments.
> 
> Eric Dumazet (1):
>   ipv4: use siphash instead of Jenkins in fnhe_hashfun()
> 
>  net/ipv4/route.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 

Queued up, thanks!

greg k-h
