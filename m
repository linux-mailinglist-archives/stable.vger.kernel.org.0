Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42596591CB0
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 23:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240774AbiHMVZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 17:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240771AbiHMVZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 17:25:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5719817E32;
        Sat, 13 Aug 2022 14:25:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB5FB60DC5;
        Sat, 13 Aug 2022 21:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101C9C433D7;
        Sat, 13 Aug 2022 21:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660425952;
        bh=ieLBB0CToj04idhUAL0HeVnNTzGxcgV0W3kZ7dOUqek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C6mRbV/zTmvSNROs4a9UtF8iD9tEAogqaFCGvssg6A8dhYvySvnuXYLMfNzv7TY1F
         qmDp/CqwCE1xn5IUe71J/jq8bbSDjnPiqoTMmWs8w4nD4r8WTCVLeb4gWFY3LisnCu
         BODthP4yNYbEHuC+nbhzNRUiPgaTtAmFbwQWHsuU=
Date:   Sat, 13 Aug 2022 14:25:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        john.p.donnelly@oracle.com, david@redhat.com, bhe@redhat.com,
        mhocko@suse.com
Subject: Re: + dma-pool-do-not-complain-if-dma-pool-is-not-allocated.patch
 added to mm-hotfixes-unstable branch
Message-Id: <20220813142551.4b2c7d99b52f8a99b95e75e2@linux-foundation.org>
In-Reply-To: <20220813063329.GB10523@lst.de>
References: <20220810013308.5E23AC433C1@smtp.kernel.org>
        <20220813063329.GB10523@lst.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 13 Aug 2022 08:33:29 +0200 Christoph Hellwig <hch@lst.de> wrote:

> I noticed this is still in -mm.  As state before any change to
> kernel/dma/pool.c should go through the dma-mapping tree, AND this
> patch is not correct.  Please drop it.

I hang onto such a patch until seeing confirmation that it (or an
alternative) has been merged elsewhere.  So it doesn't get lost.

I'll assume (without such confirmation) that this issue will be
addressed via the dma-mapping tree.

