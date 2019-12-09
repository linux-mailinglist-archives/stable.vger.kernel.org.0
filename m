Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B70D61167E0
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 09:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfLIIAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 03:00:13 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54613 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727044AbfLIIAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 03:00:13 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 95F14229F5;
        Mon,  9 Dec 2019 03:00:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 09 Dec 2019 03:00:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=/eDV+idsS1SByF2QiCV4iltEjbZ
        C4QfDo8rN0jT3bl8=; b=jtJyXEssx2Xg74ffNqm9BNn076mJQpPiierMTi4ftfo
        UUxNUfgdbLwwgSI/3kchZDrtGWoZnQ/DVzCFZ9CVY0lpm24/y9k5W+JrGQabYL1v
        zF7+op9h2YraKCm5XrUm0N2BIrC37GvTYzEKeSC4tZwAxxlsX9BrmaZw+AlAYIJL
        XBgrF991llqigIyCAkXDjsDVlPvsFIQolD38nXCj7ZWNfWSSdPMPIGGoTYKYut4S
        KcQu2RhCGsW+AQ5DRoZHBZbFMZqYUG5EQhFta/dxn1QoxFs46b4XIiLfgcYb1rY2
        XQgZXAucs2h18BmoiVmko6k+2bPSYitlKL7ykPG3tWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/eDV+i
        dsS1SByF2QiCV4iltEjbZC4QfDo8rN0jT3bl8=; b=dFfzdlfVnTJJEfAZzU4HLG
        S/hnTXddCN7U5hXEz9hq471t7kj/GPFF8lmFrQ//pLezwN23B8wcmvIGZXD/dOVo
        s9a18Y25JYUmGxcuLT8Pa/L+fSb70gnN9/X3y/E5E6k7Qpf5mv5oYOyhojjatL5G
        Xt7x5wit75EfSAFINWB6zCVF/ZmpTVmnJK7lHDWAXx88rjV8rH9wDDFqcZAcLCcI
        rMSWtTK44wqfZLuFhEyAIacCjuwVTdn/GXsgxKJjBk8xC7CDdbi3Z9MIrYCMU0sq
        e0uagrPujEH/f2Gpt2kJiNXsTYXV33I0opyJ4bLsz0opiFViM8j3x5f2kcD7x2jQ
        ==
X-ME-Sender: <xms:DP_tXcjRSfK3G_tcRktdfzF_ngfNfKbi5DOgBcv9ZcnozKrnpobxKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudekledgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:DP_tXe8iFDrD_SFUORuQfbRRY6VIFnokNW2yo5cccdny16us1erUsQ>
    <xmx:DP_tXabDdCZ5_N70qruZe9VEAqgLmxB4CnTy_2ULZb21zFhvboxOMQ>
    <xmx:DP_tXTwIqVaf_3ZCxzQ9ZqfobS8veDkxzuEFzgIWdXFKjjwTcBbvxg>
    <xmx:DP_tXbFRWXmagBM4bsJU7F8EM-PBrmAn4SfNYKBEII5f1zMNLtrqGQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2F708005B;
        Mon,  9 Dec 2019 03:00:11 -0500 (EST)
Date:   Mon, 9 Dec 2019 09:00:10 +0100
From:   Greg KH <greg@kroah.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [EXT] Patch "scsi: qedi: Allocate IRQs based on msix_cnt" has
 been added to the 4.19-stable tree
Message-ID: <20191209080010.GC691602@kroah.com>
References: <20191206211757.E90A320659@mail.kernel.org>
 <CH2PR18MB31604EB0E41782F8ED27A493AF580@CH2PR18MB3160.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR18MB31604EB0E41782F8ED27A493AF580@CH2PR18MB3160.namprd18.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 09, 2019 at 05:12:28AM +0000, Nilesh Javali wrote:
> Hi,
> 
> Please do not add this patch to stable kernel, as there is another upstream commit which reverts this patch,
> 
> 13b99d3 Revert "scsi: qedi: Allocate IRQs based on msix_cnt"

Now dropped, thanks.

greg k-h
