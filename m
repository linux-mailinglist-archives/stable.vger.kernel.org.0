Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CD76321B1
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiKUMQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiKUMQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:16:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB5B29802
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:16:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ACB76114A
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 12:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B12C43144;
        Mon, 21 Nov 2022 12:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669032984;
        bh=g4hxLkaOuahe5hUbWnuSvTa2AKnnHU2REW1Cnh9gHgg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bgkdk9etm4bZUuKlD4Nr9HA1Y7Q1n8381a4/lew/XyZgTpVzsUMmY+hGDpWmItVNg
         YIeupnuUCpgtgS56y+zHTcd9gEfHzRF+ez8kDkYe9PEIxzqf3nsveU472tdLuDUN6i
         VB6uSHSrYwZx0TkyWN7bbp98I8qbDd/JYbsbKgqQ=
Date:   Mon, 21 Nov 2022 13:16:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     jthoughton@google.com, akpm@linux-foundation.org,
        axelrasmussen@google.com, linmiaohe@huawei.com,
        naoya.horiguchi@nec.com, shy828301@gmail.com,
        songmuchun@bytedance.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] hugetlbfs: don't delete error page from
 pagecache" failed to apply to 6.0-stable tree
Message-ID: <Y3tsFTUw9NpdYA4h@kroah.com>
References: <166842203040114@kroah.com>
 <Y3f8spPtwzNCFyte@monkey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3f8spPtwzNCFyte@monkey>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 18, 2022 at 01:44:18PM -0800, Mike Kravetz wrote:
> On 11/14/22 11:33, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 6.0-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Below is backport for 6.0-stable.  Only minor conflicts in code that is being
> removed by this patch.  Tested with simple program to access hugetlb pagecache
> page after poisoning.
> 
> >From 5dcd97ae1a0848c1b9a1ec5f4ab623b1ab478892 Mon Sep 17 00:00:00 2001
> From: James Houghton <jthoughton@google.com>
> Date: Tue, 18 Oct 2022 20:01:25 +0000
> Subject: [PATCH] hugetlbfs: don't delete error page from pagecache

Looks like Sasha already picked this up, thanks.

greg k-h
