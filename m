Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BAE69BADE
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 17:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjBRQJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 11:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjBRQIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 11:08:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E26F15CBC
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 08:08:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C48DF60A4C
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 16:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF43C433D2;
        Sat, 18 Feb 2023 16:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676736528;
        bh=0MPdbHVfZ+S+cFrdFSF8Wj08gz6rY2HE1u5ZZvg2eDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H4t6/+PAhA0ogVtZUlfiPsNcX08Mk08SK5m+P+M7URKLZJMCtCKwiJWLlKiBh/meZ
         zhKLxbLuiPCjCmtW2XOLva8M2K0vdIbjzI7g7lxUqJU8wgR1FBqZb4gK5AFh4AvOxE
         fECuHJyjQG9G+GWv53Q8SIqlAFuNvRy7ce5cSfyM=
Date:   Sat, 18 Feb 2023 17:08:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     qian@ddn.com, akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mm/filemap: fix page end in
 filemap_get_read_batch" failed to apply to 5.15-stable tree
Message-ID: <Y/D4DbnbCCRRyHDt@kroah.com>
References: <167670736248208@kroah.com>
 <Y/D2LZICIG7x+FOw@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/D2LZICIG7x+FOw@casper.infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 18, 2023 at 04:00:45PM +0000, Matthew Wilcox wrote:
> On Sat, Feb 18, 2023 at 09:02:42AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here's a patch for 5.15-stable, generated against v5.15.94

Now queued up, thanks.

greg k-h
