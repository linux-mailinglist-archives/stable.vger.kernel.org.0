Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C50053ED8A
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 20:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiFFSHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 14:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiFFSHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 14:07:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B971A839;
        Mon,  6 Jun 2022 11:07:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA5A6B81A79;
        Mon,  6 Jun 2022 18:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF02C385A9;
        Mon,  6 Jun 2022 18:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654538844;
        bh=V609pr5ev5J8Nn+gPyV2nr6oXqVNR3OZd3l5qsfLjQY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lUTvNDvIFOnfkIQ3e1q/+5WTf8s4WIFngS69Ef4XUBsPyOln+reY8V6r3dAS/d69G
         vUi/5BsTQsMejz6tR5d2+2qW/1YIWIUo8F0pBYtr3QFyFrR+ZFKkK4yB4SHhqfL004
         n6ln+FqKxRoiQWvYvFwQs57uNbVF4e9tywBid6DY=
Date:   Mon, 6 Jun 2022 20:07:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jan Kara <jack@suse.cz>
Cc:     stable@vger.kernel.org, linux-block@vger.kernel.org,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/6] bfq: cgroup fixes for 5.10 stable
Message-ID: <Yp5CWVgVsZ59m21g@kroah.com>
References: <20220606174118.10992-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606174118.10992-1-jack@suse.cz>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 07:56:35PM +0200, Jan Kara wrote:
> Hello,
> 
> In this series are BFQ upstream fixes that didn't apply to 5.10 stable tree
> cleanly and needed some massaging before they apply. The result did pass
> some cgroup testing with bfq and the backport is based on the one we have
> in our SLES kernel so I'm reasonably confident things are fine.

Now queued up, thanks for the backports!

greg k-h
