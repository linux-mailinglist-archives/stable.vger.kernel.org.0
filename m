Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6636777AD
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 10:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjAWJrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 04:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbjAWJrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 04:47:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2BB21956
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 01:47:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0358D60DF1
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 09:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12987C433D2;
        Mon, 23 Jan 2023 09:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674467233;
        bh=PWosGTuVEirPX/3jKZmj/D1rkOvobYtsi9fq5D6+aGs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sDs75bh69pd2i5I3toJ8fm6gtLqinkAzYJEOsZPAgFFg9VI0SzFoA4D23ef1fjfdQ
         ghzs0ueiSS1L0tV72MnXZ0qCUq/9UjI5RqkbEhQMhQUKMVNDxXkgH8EOkLd/rIiarM
         FTNapufc6qbI4pDLbtmj4W+NwfgOLDcsma4vhWF4=
Date:   Mon, 23 Jan 2023 10:47:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     akpm@linux-foundation.org, david@redhat.com, jannh@google.com,
        shy828301@gmail.com, songliubraving@fb.com, stable@vger.kernel.org,
        zokeefe@google.com
Subject: Re: FAILED: patch "[PATCH] mm/khugepaged: fix
 collapse_pte_mapped_thp() to allow" failed to apply to 5.15-stable tree
Message-ID: <Y85Xl3zQ8HR941Tr@kroah.com>
References: <1674296977196124@kroah.com>
 <c6665dff-d48a-7dac-c845-fe41cb67b31@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6665dff-d48a-7dac-c845-fe41cb67b31@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 12:31:52AM -0800, Hugh Dickins wrote:
> On Sat, 21 Jan 2023, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Thanks Greg: the backport below is suitable for 5.15-stable and
> 5.10-stable and 5.4-stable.

Now queued up, thanks!

greg k-h
