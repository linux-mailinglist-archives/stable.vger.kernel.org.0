Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BD46D4566
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbjDCNNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjDCNNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:13:36 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62E611657
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 06:13:28 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 0286D5C0105;
        Mon,  3 Apr 2023 09:13:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 03 Apr 2023 09:13:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1680527607; x=1680614007; bh=FY
        xGIRE0QsDjyp5idANmE2+8TX+qGOhOSJqzd12286A=; b=YhK1fKcWE4Toz2nGVU
        PFgEgNB3yDlon7p4a+IjU2wK9KV+pN2bcGJBDTUqlJzg7ltnHoCzaB12YI5kALJq
        5b/qKPiaCV09lViNtTw0PGyeo0D5tGydv4i/pOSXEGyUOpET1u9EUCLq1UdR6m6J
        8+8cFgOqBLx3H19x4vCOQwxAzhwQh/a9VAudksuiRFysag1z63YyObCYm2zVbCRD
        EeTX0yFKcxbHj7Dz5RPeDMNIad0X6tG6rDxagIhqRovlj31HuydiT2eAr/D6V8aE
        fRzOTxlGwdD4ITKjDddZnv+CvBkE950OpUaBYfAjfulfxXuh+xA2261sI/7XG3y0
        iuZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680527607; x=1680614007; bh=FYxGIRE0QsDjy
        p5idANmE2+8TX+qGOhOSJqzd12286A=; b=P4Mo7cX8hfZvUcY7FKftvG6AWhRWb
        c4MCfotwiscD3BvOD5TSEzLFXFY7kv0/LiEkXd8kWkO9svEiJ1AdLO0K5vTSxRFw
        Ki2x/IL6VHv6baG/Yz4iH5A0KvrLWo3mcyozhwP4Spdnts7Gm4JmtmBhNwe6I/7M
        LNBFIp3mace6ff/ovXFSI9fBg2KC8F0HVur6f3QMD6u4glCZDiaTQzCOpnu5O3hE
        unpsLsZtT1obzOaZZARdUvBxuXOXqoh9pVT/4aFoK10uFWokCxmIvqOR1U4d5qzf
        Xpt+D4A5UTPqxMF9CMtIgqqJLDzpL7pGLSqY3Mj4ArE1J38WvYGbSObJg==
X-ME-Sender: <xms:99AqZDdOEZj0Zjf8UEw7A0blhGoEk9wrOMFm3eQOjtxlbJNEsIRR8A>
    <xme:99AqZJPTTWCCf0DN92IZ_cqfLZz_8o7PFXdfP1nnU8qVCYpMGIXtOOAgQ2x_KESVD
    VegZ0uoEMTdWQ>
X-ME-Received: <xmr:99AqZMh_HWpVYHh73APOOwTtFgv4kesm00IQo2a6qbe-cmxOi5DV24zP9p7aUmVFnsBxvXjaEO_w-WaHnlP5-YGUrh8pl0zgjp2PCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeijedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:99AqZE-EoDDR6upzpJ7g4x3uk6_KipKNvvZlPnxajizfpeAGs9LWyg>
    <xmx:99AqZPsTT6JKhUEvkE6bgKwWy7MfdCtDNj7o8MO3qeyhDn_R92agEg>
    <xmx:99AqZDGg6b2wWajBDbcdAm4XWE-n6NPSuEwv6rLonoFXinwZZHUqxQ>
    <xmx:99AqZI6FrI7fBohZMVDBU8ICQF_fuCpojccOpDTdC0MrSGSUewV7Xw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Apr 2023 09:13:27 -0400 (EDT)
Date:   Mon, 3 Apr 2023 15:13:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.10.y] zonefs: Fix error message in
 zonefs_file_dio_append()
Message-ID: <2023040317-starter-coeditor-d7c8@gregkh>
References: <16800036329137@kroah.com>
 <20230329102542.1757470-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329102542.1757470-1-damien.lemoal@opensource.wdc.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 29, 2023 at 07:25:42PM +0900, Damien Le Moal wrote:
> commit 88b170088ad2c3e27086fe35769aa49f8a512564 upstream.
> 
> Since the expected write location in a sequential file is always at the
> end of the file (append write), when an invalid write append location is
> detected in zonefs_file_dio_append(), print the invalid written location
> instead of the expected write location.
> 
> Fixes: a608da3bd730 ("zonefs: Detect append writes at invalid locations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> ---
>  fs/zonefs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 66a089a62c39..b9522eee1257 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -789,7 +789,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
>  		if (bio->bi_iter.bi_sector != wpsector) {
>  			zonefs_warn(inode->i_sb,
>  				"Corrupted write pointer %llu for zone at %llu\n",
> -				wpsector, zi->i_zsector);
> +				bio->bi_iter.bi_sector, zi->i_zsector);
>  			ret = -EIO;
>  		}
>  	}
> -- 
> 2.39.2
> 

All now queued up, thanks.

greg k-h
