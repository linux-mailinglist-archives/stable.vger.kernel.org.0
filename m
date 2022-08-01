Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9343D58662B
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 10:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiHAITW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 04:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiHAITN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 04:19:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E2A3AB1F
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 01:19:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0478AB80D1A
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 08:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04238C433C1;
        Mon,  1 Aug 2022 08:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659341949;
        bh=wqq6+xF98unq+2hn+EotpqnE3nfJuw+In3NjyuC7Nrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a/hnx072Qk7C+4ZNCvN44SO6S0T2dEDSAOyjHl0RLNZ6i7iAPAeU8BuB37LXhDw8u
         CNnczv6N3oLXDFbmTKSBQvL9e9FbxabuETynrXsySxiIIjW0gVmXK57Zux4ssTKy/j
         mPOhkbpnt6i9f8Ig3LZ2SIKe+wgp3kVO5UpEUJSI=
Date:   Mon, 1 Aug 2022 10:19:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org,
        david@redhat.com, linmiaohe@huawei.com, liushixin2@huawei.com,
        mike.kravetz@oracle.com, osalvador@suse.de, shy828301@gmail.com,
        songmuchun@bytedance.com, naoya.horiguchi@nec.com
Subject: Re: FAILED: patch "[PATCH] mm/hugetlb: separate path for hwpoison
 entry in" failed to apply to 5.18-stable tree
Message-ID: <YueMeT1huXybhx+1@kroah.com>
References: <165919533798118@kroah.com>
 <20220801062937.GA192992@ik1-406-35019.vs.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801062937.GA192992@ik1-406-35019.vs.sakura.ne.jp>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 03:29:37PM +0900, Naoya Horiguchi wrote:
> On Sat, Jul 30, 2022 at 05:35:37PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.18-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> 
> Hello,
> 
> I updated the patch for 5.18-stable, could you apply this?

I can, but are you sure you need/want this for 5.18-stable?

I ask because of this line in the changelog text:

> Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive")

Which only showed up in 5.19-rc1 and is not backported anywhere.

So why did you have:

> Cc: <stable@vger.kernel.org>	[5.18]

In the changelog if the commit this fixes is not in 5.18?

confused,

greg k-h
