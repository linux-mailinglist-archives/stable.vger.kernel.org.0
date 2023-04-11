Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3806DDD79
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 16:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjDKORP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 10:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjDKORN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 10:17:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C4A525B
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 07:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED8BE6185C
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 14:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F8DC433D2;
        Tue, 11 Apr 2023 14:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681222591;
        bh=UijI6JTMeVHaWhdVMBMKOQ1zr7BB5Gw8phzqH/wody8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SU9LwCD4UBr1kBKU6KL78GlV7CLAlYctAgncyq4aXvr9sf2HAJMuyu/+oDJ+TbKhI
         P+oOYeMeNz4mE72QuAtyi6EYqcslseDFO/dGkMTnDMHmrm9e5jQfq5zwmEzIQI0YhN
         jQnFQOPiUX97EtFSa+nRZRWkEYvZBR99iLdK03E4=
Date:   Tue, 11 Apr 2023 16:16:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Bo <yyyeer.bo@gmail.com>
Cc:     stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH 1/6] virtiofs: clean up error handling in
 virtio_fs_get_tree()
Message-ID: <2023041147-mooing-uncut-9b7f@gregkh>
References: <20230411032111.1213-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411032111.1213-1-yb203166@antfin.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 11:21:06AM +0800, Yang Bo wrote:
> From: Miklos Szeredi <mszeredi@redhat.com>
> 
> commit 833c5a42e28beeefa1f9bd476a63fe8050c1e8ca upstream.
> 
> [backport for 5.10.y]
> 
> Avoid duplicating error cleanup.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)

When forwarding patches on, you have to also sign off on them as per our
documentation.

Please fix up and resend if you still think these are needed in the
5.10.y tree, AND explain why they are needed in a 0/X email.

thanks,

greg k-h
