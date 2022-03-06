Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9003C4CEA91
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 11:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiCFKsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 05:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiCFKso (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 05:48:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED82C1705E
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 02:47:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 721C6B80CA9
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 10:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915B1C340EC;
        Sun,  6 Mar 2022 10:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646563670;
        bh=LIYLFzhTjiFakI9sMTdQprv0CpuPuOvewCBrVJeEMHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1N+P2o56QnwX1XSbN+jUkLyIvz/grOr8XvzNMFawkMgDhJ8BWtvhVfUftZq3VgNkx
         GDZ1uPsAZyZTt9QBWDA0Ts7kKq7LrySFDwXiZG4b/6O/ZiIzEW5elwDClwymtjW+H2
         A6GCiPdIgPd1uIAer0kNFGfEmlwJknxvyObpdDDI=
Date:   Sun, 6 Mar 2022 11:47:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     akpm@linux-foundation.org, cgel.zte@gmail.com,
        kirill@shutemov.name, mike.kravetz@oracle.com,
        songliubraving@fb.com, torvalds@linux-foundation.org,
        wang.yong12@zte.com.cn, willy@infradead.org,
        yang.yang29@zte.com.cn, zealci@zte.com.cn, yongw.pur@gmail.com,
        stable@vger.kernel.org
Subject: Re: Patch "memfd: fix F_SEAL_WRITE after shmem huge page allocated"
 has been added to the 5.4-stable tree
Message-ID: <YiSRUwgyRot6f2io@kroah.com>
References: <1646512773164108@kroah.com>
 <d169b785-1486-7c3d-7843-e2c23870a048@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d169b785-1486-7c3d-7843-e2c23870a048@google.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 06, 2022 at 01:09:16AM -0800, Hugh Dickins wrote:
> On Sat, 5 Mar 2022, gregkh@linuxfoundation.org wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     memfd: fix F_SEAL_WRITE after shmem huge page allocated
> > 
> > to the 5.4-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch
> > and it can be found in the queue-5.4 subdirectory.
> 
> Thank you for adding that patch to 5.16, 5.15, 5.10 and 5.4:
> please accept the substitute patch below for 4.14 and 4.9 - thanks.
> A different patch for 4.19 has been sent separately.

All now queued up, thanks for the backports!

greg k-h
