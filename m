Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D38E5185E6
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 15:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiECNv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 09:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236485AbiECNv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 09:51:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21582BDD;
        Tue,  3 May 2022 06:47:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EEA161770;
        Tue,  3 May 2022 13:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFAAC385AF;
        Tue,  3 May 2022 13:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651585674;
        bh=JGdCpt4agMTF12I9zAqh5aW+Y9xr4o2tFqbIR1FL72s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eTt4oQBTssE5Ck34ze918/gqMPmKYMbLtRPnRk/ViFDRgFDmYNoU3vQ53s7tovsNb
         96MU95rBbgWe/yxYFFjdAWy9eu4Yb4ee91KdSmSaVcMUt2qkmIVEbAM4QNOGHzmRZS
         tfQY4f9UGXgdUIDTWGyHFxVaYgSoWfMXyjLkZu6E=
Date:   Tue, 3 May 2022 15:47:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [Rebased for 5.4] mm, hugetlb: allow for "high"
 userspace addresses
Message-ID: <YnEyiYh/NIFJG16V@kroah.com>
References: <9367809ff3091ff451f9ab6fc029cef553c758fa.1651581958.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9367809ff3091ff451f9ab6fc029cef553c758fa.1651581958.git.christophe.leroy@csgroup.eu>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 03, 2022 at 02:47:11PM +0200, Christophe Leroy wrote:
> This is backport for linux 5.4
> 
> commit 5f24d5a579d1eace79d505b148808a850b417d4c upstream.

Now queued up, thanks.

greg k-h
