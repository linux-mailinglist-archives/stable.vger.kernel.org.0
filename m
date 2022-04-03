Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A6A4F0804
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 08:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343550AbiDCGNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 02:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbiDCGNd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 02:13:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDCF32ED5;
        Sat,  2 Apr 2022 23:11:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AA5460F97;
        Sun,  3 Apr 2022 06:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23073C340F2;
        Sun,  3 Apr 2022 06:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648966298;
        bh=bbXDL4GB7kLAC/hRB7DsA0hmmhkYEOh/ZIYICBlOU38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KKfn+TojwJX1SzUWmmq3gFPSFYNShOuJ7DCtid/aPdmGwhq5KIsDD3davcDPTJLhv
         Ok1RtpH976/nlmd7LeXgRycmUmlfFERFWlpSJDoMuMlx13aYOFeGKRkrwsHCvZtXeD
         ENgmZ/ezRg1aMPVj9SIvBZdHR+XUgTz4ubW0u+/o=
Date:   Sun, 3 Apr 2022 08:11:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        rdunlap@infradead.org, Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: Patch "virtio_blk: eliminate anonymous module_init &
 module_exit" has been added to the 5.17-stable tree
Message-ID: <Ykk6l6wBuEO4N7lJ@kroah.com>
References: <20220402130329.2055072-1-sashal@kernel.org>
 <20220402161936-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220402161936-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 02, 2022 at 04:20:59PM -0400, Michael S. Tsirkin wrote:
> On Sat, Apr 02, 2022 at 09:03:29AM -0400, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >     virtio_blk: eliminate anonymous module_init & module_exit
> > 
> > to the 5.17-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      virtio_blk-eliminate-anonymous-module_init-module_ex.patch
> > and it can be found in the queue-5.17 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> 
> I don't see how this patch qualifies for stable.
> Yes it's probably harmless but you never know
> what kind of script might be parsing e.g. System.map
> and changing that in the middle of stable seems
> like a bad idea to me.

I don't think that's a good reason to reject it, but I do think it
doesn't fit with "fixes a bug" requirements.  I'll drop this, and the
other module_init patches from the stable queue now.

thanks,

greg k-h
