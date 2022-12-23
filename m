Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08B1655386
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 19:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiLWSO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 13:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiLWSO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 13:14:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC651AF2B;
        Fri, 23 Dec 2022 10:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 827A7B820F7;
        Fri, 23 Dec 2022 18:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBC3C433D2;
        Fri, 23 Dec 2022 18:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671819293;
        bh=sW1IN7usQNWZ2oySw61xB8gHkdOeHHdj1T8IZ8sXP/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xgmn3UGO4B7SSAs2iNgVPYojkUKnikgcT1UhRnef0/fJS4+MJ08kqiFjX1BV1us6V
         aTvaGKhH6VxWIeZtoYRkyKH6mIH+VDcZfNK2gS5xak9/wyfnawPcYdkkRjy3kXm/SR
         bfAW0Tk/u51Fm/27bVQiNsni73Acxz4CUDzsn8cM=
Date:   Fri, 23 Dec 2022 10:14:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, nadav.amit@gmail.com,
        ives@codesandbox.io, hughd@google.com, apopple@nvidia.com,
        aarcange@redhat.com
Subject: Re: +
 mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
 added to mm-hotfixes-unstable branch
Message-Id: <20221223101452.509adca88617f69fc7fd1f13@linux-foundation.org>
In-Reply-To: <b7489609-d9e3-a052-5f29-b948a3e4584e@redhat.com>
References: <20221210004423.94D4FC433D2@smtp.kernel.org>
        <b7489609-d9e3-a052-5f29-b948a3e4584e@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 23 Dec 2022 11:02:40 +0100 David Hildenbrand <david@redhat.com> wrote:

> On 10.12.22 01:44, Andrew Morton wrote:
> > 
> > The patch titled
> >       Subject: mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA
> > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> >       mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
> > 
> > This patch will shortly appear at
> >       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
> 
> Andrew, what happened to this fix? I think I'm too blind to spot it 
> upstream, in one of your trees or in -next ...

Seems that I fat-fingered it.  Thanks for noticing.
