Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B7753AF3D
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 00:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiFAWl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 18:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiFAWlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 18:41:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E535587;
        Wed,  1 Jun 2022 15:41:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F173260DE2;
        Wed,  1 Jun 2022 22:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10362C385A5;
        Wed,  1 Jun 2022 22:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654123311;
        bh=QwWLpPJ9neDi37D1ATJmr1+Z3EM9nNEqg5aF3oDCC6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SdbS/jchk5ImeWGxslo55JaImnucDr/WcytfYvQ50IcylVwO4LZt0mBpV0A/MmAa+
         WZX296PpYncM363u9MZnqH9FK8DYKjgkTNSOKU/fddNeB+rBGHifuJo5nedreLXWa4
         /P4xqZ2gtm6uanXLVV70TaIaWXEqDbMxHn0XaEvTvdIzSWxNeqPWrneeaY9NizgGPE
         HgXSxzDguWNEpnWMAYCnysn7ocbCOs/RiLWBB/f4fJnAalFOR/ONch2SVbAavGz4wU
         l/kCMOZBPgAZkgHKCbYaiURye8SDYUaqnEXoUOpk/va2VYFHXdaih4QZDNS5Umf/5h
         2yHPUX/VFO06g==
Date:   Wed, 1 Jun 2022 15:41:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     torvalds@linux-foundation.org, stable@vger.kernel.org,
        Stephen Brennan <stephen.s.brennan@oracle.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] assoc_array: Fix BUG_ON during garbage collect
Message-ID: <YpfrLUknlmcvwNzY@sol.localdomain>
References: <165295023086.3361286.8662079860706628540.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165295023086.3361286.8662079860706628540.stgit@warthog.procyon.org.uk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 19, 2022 at 09:50:30AM +0100, David Howells wrote:
> diff --git a/lib/assoc_array.c b/lib/assoc_array.c
> index 079c72e26493..ca0b4f360c1a 100644
> --- a/lib/assoc_array.c
> +++ b/lib/assoc_array.c

Where are the tests for this file?

- Eric
