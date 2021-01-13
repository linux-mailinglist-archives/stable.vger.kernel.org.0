Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E792F469A
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 09:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbhAMIga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 03:36:30 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44535 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbhAMIg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 03:36:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id DC04E5C04B6;
        Wed, 13 Jan 2021 03:35:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 13 Jan 2021 03:35:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=QFrd8/Cm4EwX8Y7araktIbSjoBl
        mXGo8qHRYothcUyU=; b=Kc5lJDiYtkhMTO7ecGVPIhoQYr5AUQEoty0oA+U8XVN
        b7XttLCYOcLbaJMf6RPAljjcuVDRSqxPgmukEK2zvWtPKKy3LxevMkLGtUjqTbiD
        nRYh02JKFktwEm2CxlTtu2gJTb4ZXQb9jmU0gwFtxH4JPBQX3E809PBrSn5n+x+b
        ML0n9ctNnAk4BVSdLyHrb/RrvAvMtG1wyz80aPqH0IfJegZFU370ysrYPfuW0vSo
        QhrzCAbzbgvWcz9XwVtDjn4ydVjRkZQZu51lbGhBvQRZbRzb3+DF/5p/sq+WRYdE
        kO7bHfQyv0eJ55S3rvZQTW5Q5F4nz5JiECbUkm8mHDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=QFrd8/
        Cm4EwX8Y7araktIbSjoBlmXGo8qHRYothcUyU=; b=SwWlAa8LMivcmJGLD1cwjv
        suhdxuYwhuXHJlAy1GSEdpl1uXcy4ShehvrNaPVmfwwEmewzJmZWVIw+e4Mumxva
        3B8pGLaRYornUZzuT51RlsLaG2QHVBfLouoON2+znNxLS3dK4KJKa5GyAzvSeLJX
        FZg9lB2KtXRgCy3kICY0BHybOpNP8+tXo80cAskFthG04zUPt44bZ6fjkT2PyAQA
        Hme38ep5tBjjhquaq6JIqQu/OYqPE7ArIPBKeRYG0b17i/X2F53dLS8U7JDBwHkJ
        S1rf7ZEUUua5CNXojfWMZ3+cSL3GAtWu6xb50jFee2wY5eBGokkerk79hA6U9dNg
        ==
X-ME-Sender: <xms:3rD-X-jOkVkIr1Z8xi4W4VDOddYVNHMN9rqHZGADCmz0RAmWFi4S5A>
    <xme:3rD-X_Ckz1goHfYtkRKTtEtBY7ZDfFUEae5dk5GCG_l0pF3E_vEK0M-23AAC45y3n
    oqyV-P_FlyDyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedukedrtddugdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:3rD-X2EyOYM4ypF6A0E-P-iczXKe12dJlYUZGkcbngr0p1ZQXWD-Qw>
    <xmx:3rD-X3QF7RaRXjw_e71eNiLII30xN58X-s-jW-ZYsNtwkUPrqt0q4A>
    <xmx:3rD-X7xOBZEbS2vFukfL6_cx9sdEUVuQRMqRjbWxEJG-2f29EuL_eA>
    <xmx:3rD-X2q8w4IWXomhGhLsnJUarPV878703cMpdfSWn9OIosD0ZwvFwA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 356DD1080059;
        Wed, 13 Jan 2021 03:35:42 -0500 (EST)
Date:   Wed, 13 Jan 2021 09:35:40 +0100
From:   Greg KH <greg@kroah.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-mm@kvack.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/6] libnvdimm/namespace: Fix visibility of namespace
 resource attribute
Message-ID: <X/6w3MKvKChR3cn4@kroah.com>
References: <161052331545.1805594.2356512831689786960.stgit@dwillia2-desk3.amr.corp.intel.com>
 <161052334995.1805594.12054873528154362921.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161052334995.1805594.12054873528154362921.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 11:35:50PM -0800, Dan Williams wrote:
> Legacy pmem namespaces lost support for the "resource" attribute when
> the code was cleaned up to put the permission visibility in the
> declaration. Restore this by listing 'resource' in the default
> attributes.
> 
> A new ndctl regression test for pfn_to_online_page() corner cases builds
> on this fix.
> 
> Fixes: bfd2e9140656 ("libnvdimm: Simplify root read-only definition for the 'resource' attribute")
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/nvdimm/namespace_devs.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
