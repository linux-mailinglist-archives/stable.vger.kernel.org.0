Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47EBF1058CB
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 18:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfKURuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 12:50:05 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35893 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbfKURuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 12:50:05 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9736822716;
        Thu, 21 Nov 2019 12:50:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 21 Nov 2019 12:50:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=oM+Oc5aGWuWFWH/DjEDqWU7Hek4
        C7Ywv02tmN1aTL3Y=; b=CUm18/XmeQ6ZZFjaGCSIbl7OSqF4duemGsTqJCd0haq
        1SN2MZBbBrOTs5WblThP7IrW+V7ea16csRsYlNVp87u/67z2hzRj4/f4OTGj1o3E
        RBEq70i2Sp41a7LgXiw31vAzkyaJEWJnDjx4MLyNufzV2exRPpbw44cfYjCOX9ql
        r//58H2rbM91uOtuZUDCl46WnzBAaQsVaqHF+VjGZhOBlLD8xqfrbrIqj4PCYnJt
        FuHKD1vXKuA9plehxT0znIw8rr+YBIEPJIoBskGOc6F0Mm0gOoz974SZNy3nLANE
        7dwUA7uZ5/17w9lCYAprO7ry7cNzQIxCdoo5VUBGWxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oM+Oc5
        aGWuWFWH/DjEDqWU7Hek4C7Ywv02tmN1aTL3Y=; b=x9FHoPLw1RDiJmuqBcYvUU
        oGZ6zbH3ChSk4wxg1xn5ElkqzPxiDDf5s3ZY8hsl3TI4JG5DPbtdsJkhs5f6PLKS
        AHylHneUbvxDpW40m9VKcx+oBiwY+h9PTj5kFAcX6jkMb49DWYvyxv8a0MIiyWgw
        AjIbAzRptS6zjCzX6qBw+etFACNjineS8k9MRxiE103ZUZ0we9mbjLGqdWU+IhU7
        uSPLE9OydQ++JyeEsd4YWIWN9QT0G20BeWsKrHVho5AZlmlTWMJ9M1HrllNy2wq+
        pIWljhT7hhMPXF/59xpePIslgFjc+sG+0X1sMNtmK/+AZwWZzBSdcQja8koQ4+/A
        ==
X-ME-Sender: <xms:TM7WXRlkNHJeUHKfTYlUp9FqTzCGvGJRlcWIoeNkO5rccl1mjEG9oQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudehvddguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepvddujedrieekrdegle
    drjedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:TM7WXf3FfzZaI19Lho07iLZtVO5_lKcEXjJYKGSEGe2sOKXGyRiRoA>
    <xmx:TM7WXRh3CXzj7dPzOEmqydKxbe_IYSzFK1A5sexaa67z-0VcjKNn8w>
    <xmx:TM7WXcpewjbTSSdED9av_SJr2TuaaKba8ufH4t122HylOJ_WT0qpKg>
    <xmx:TM7WXZpePT4UDA4mMfRPQ_yWc0-hdjIgX3D4JfkSPzVTd9SkxBsrnA>
Received: from localhost (unknown [217.68.49.72])
        by mail.messagingengine.com (Postfix) with ESMTPA id 780A080066;
        Thu, 21 Nov 2019 12:50:03 -0500 (EST)
Date:   Thu, 21 Nov 2019 18:50:01 +0100
From:   Greg KH <greg@kroah.com>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH for 4.4.y, 4.9.y, 4.14.y, 4.19.y] net: cdc_ncm:
 Signedness bug in cdc_ncm_set_dgram_size()
Message-ID: <20191121175001.GA766491@kroah.com>
References: <20191120030710.5169-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120030710.5169-1-nobuhiro1.iwamatsu@toshiba.co.jp>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 20, 2019 at 12:07:10PM +0900, Nobuhiro Iwamatsu wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> commit a56dcc6b455830776899ce3686735f1172e12243 upstream.
> 
> This code is supposed to test for negative error codes and partial
> reads, but because sizeof() is size_t (unsigned) type then negative
> error codes are type promoted to high positive values and the condition
> doesn't work as expected.
> 
> Fixes: 332f989a3b00 ("CDC-NCM: handle incomplete transfer of MTU")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/net/usb/cdc_ncm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Now queud up, thanks!

greg k-h
