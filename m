Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423B54FBF5B
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 16:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245412AbiDKOlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 10:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347345AbiDKOlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 10:41:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB805E82
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 07:39:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45E416144A
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 14:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E78DC385A4;
        Mon, 11 Apr 2022 14:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649687942;
        bh=6Gn5/wZr/quEKLMB6w8cQRSmQWASBcEyrLpv8bwXScA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GGSaMI0SsexHyt/bjDM+64Oum/LvjyaUdJapkb84tY4YQocy1e171Iq0Q45k3VHlX
         564BlwGYd1uCMTy/kIhm15/mDbfH3X0QMTQt2VaBjYViOk1f+Rr8rGZlp456NEZrhh
         cBmpjoWAh/574fRmijZkVc4f3lokt3JF7T3KeAVw=
Date:   Mon, 11 Apr 2022 16:39:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Peter Xu <peterx@redhat.com>
Cc:     aarcange@redhat.com, akpm@linux-foundation.org, apopple@nvidia.com,
        david@redhat.com, hughd@google.com, jhubbard@nvidia.com,
        kirill@shutemov.name, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm: don't skip swap entry even if
 zap_details specified" failed to apply to 5.15-stable tree
Message-ID: <YlQ9hKONImbjtrnw@kroah.com>
References: <1648817504102234@kroah.com>
 <Yk31709QxFzKHPta@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yk31709QxFzKHPta@xz-m1.local>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 06, 2022 at 04:19:59PM -0400, Peter Xu wrote:
> 

> >From 11fad3a3088d5059cc6b12314c679ba1547a7224 Mon Sep 17 00:00:00 2001
> From: Peter Xu <peterx@redhat.com>
> Date: Tue, 22 Mar 2022 14:42:15 -0700
> Subject: [PATCH] mm: don't skip swap entry even if zap_details specified
> 
> NOTE: this is cherry-picked from 5abfd71d936a8aefd9f9ccd299dea7a164a5d455
> but backported explicitly to stable branch.
> 

All now queued up, thanks.

greg k-h
