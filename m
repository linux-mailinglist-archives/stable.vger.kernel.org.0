Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2544F133C
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 12:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358402AbiDDKnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 06:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357901AbiDDKmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 06:42:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17123CA77
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 03:40:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C76961522
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 10:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852F4C2BBE4;
        Mon,  4 Apr 2022 10:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649068854;
        bh=bTopu5GtksV4E5G3vNInnScQjphu9JzzbvxJiaUszKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R0wDHfjs8oD/QUNn60sjPgb82hd0R9tlOm3+EWj+gKDjQ1puref6gI5al/ODbZ3Ue
         wH/8PdpINOZWS/9QRjFzl7IlxjRRgHvAU/vs0otFQ6CcNheQgxfrC05mowPua6s6+Y
         r9v1CZyvSx0bydiwg7FMM23TWMxWSQgQ2PhMpWYw=
Date:   Mon, 4 Apr 2022 12:40:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, boqun.feng@gmail.com,
        dyoung@redhat.com, josh@joshtriplett.org, paulmck@kernel.org,
        peterz@infradead.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vgoyal@redhat.com
Subject: Re: FAILED: patch "[PATCH] proc/vmcore: fix possible deadlock on
 concurrent mmap and" failed to apply to 5.16-stable tree
Message-ID: <YkrLNL47V+dhPFF+@kroah.com>
References: <164889941824213@kroah.com>
 <5a220426-6b83-6a0e-5af0-ee4c76e72c79@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a220426-6b83-6a0e-5af0-ee4c76e72c79@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 12:17:47PM +0200, David Hildenbrand wrote:
> On 02.04.22 13:36, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.16-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> 
> I don't think we need that particular patch in -stable. The deadlock
> shouldn't really happen in practice (concurrent addition/removal of a
> callback doesn't really happen in a kdump anvironment). Thanks.

Ok, I'll go drop it from 5.17-stable, thanks.

greg k-h
