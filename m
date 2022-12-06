Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47543644324
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 13:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbiLFMab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 07:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiLFMaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 07:30:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B6928E2C
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 04:30:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C28FB80D69
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 12:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8BCC433D6;
        Tue,  6 Dec 2022 12:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670329827;
        bh=rq/qVCxln7rB9L2wP2aLeDFVGlk15M7p1/r/mtRoSZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T6/Do6issPbILpO5m+Siqb0mYlwty4uHkwyNMxCuSsYFJcPeWQIFrT4MYUfPaGFds
         4YuBpPA33JEM5MgJRC2q8mO8Q+jzQdTarJrQbIA9mJJHth4J7PAA3mIwfTGTpuIFuD
         h69xXbQqVUUUI3e/48laLt4O9ey6x2NvHNDnwGEA=
Date:   Tue, 6 Dec 2022 13:30:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 4.14 0/2] x86/speculation: Regression fixes
Message-ID: <Y4814LXcj2DmI4gB@kroah.com>
References: <Y45sM5Dg6Y6YQIBZ@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y45sM5Dg6Y6YQIBZ@decadent.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 11:09:55PM +0100, Ben Hutchings wrote:
> Fix two regressions introudced by recent speculation mitigations
> on the 4.14 branch:
> 
> - Crash on older 32-bit processors
> - Build warning from objtool
> 
> Ben.
> 
> Ben Hutchings (1):
>   Revert "x86/speculation: Change FILL_RETURN_BUFFER to work with
>     objtool"
> 
> Peter Zijlstra (1):
>   x86/nospec: Fix i386 RSB stuffing
> 
>  arch/x86/include/asm/nospec-branch.h | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 


Now queued up, thanks.

greg k-h
