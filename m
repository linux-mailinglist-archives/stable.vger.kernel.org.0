Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFA4509CEF
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358094AbiDUJ7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 05:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiDUJ7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 05:59:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464C721250
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 02:56:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F33D8B82398
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 09:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31649C385A1;
        Thu, 21 Apr 2022 09:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650535013;
        bh=9r6uQgFJ4qYCnDvoqBVqTNJm/agRBUe8nOMPfZXV0O8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LxU6v0KODD9VLHiM43PZwckZv9EJT+7WyAThKUJvCQyBBsVSM1EGnXzoDfLOuE6YE
         Jh1yOU1lZOb1GXN9FgntlI/siCa97r4m7TjM8Ycu4uHi/ZyDil+FpZIn/NnyJfWa7z
         urgqK/joapKqZjtCDPskLYVSVWz8E+gfoO83i+OM=
Date:   Thu, 21 Apr 2022 11:56:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     snitzer@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4.19] Re: FAILED: patch "[PATCH] dm integrity: fix
 memory corruption when tag_size is less" failed to apply to 4.19-stable tree
Message-ID: <YmEqY3llf0yK1D3N@kroah.com>
References: <1650273565139113@kroah.com>
 <alpine.LRH.2.02.2204190455520.8323@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2204190455520.8323@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 19, 2022 at 05:00:56AM -0400, Mikulas Patocka wrote:
> Hi
> 
> Here I'm sending a backport of the patch 
> 08c1af8f1c13bbf210f1760132f4df24d0ed46d6 for the kernel 4.19.

Now queued up, thanks.

greg k-h
