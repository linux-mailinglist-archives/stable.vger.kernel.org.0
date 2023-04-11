Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7788B6DDCCB
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjDKNuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjDKNuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20BF5241
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:49:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 952C061CD6
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB720C433EF;
        Tue, 11 Apr 2023 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681220987;
        bh=HtY0WFwv0ODoBOwLn5Gc4bcZE+//CbuAk48sniVzrEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oeoiT0tnh+Z5d753Yr5b8ym2o8WQGX4tP6RBs6O0PUl0ueE862OF6HJ5F9gffzcQs
         0dGUDelANHxq+0ZT4lPIMVMCEBXYbod0FZ5oJuz+/Md2gFZkecp16EhsTRG1moU74E
         3g1jSMqdKjflVQF2xWv3SvkiqyOKB3pAQcs/LwCM=
Date:   Tue, 11 Apr 2023 15:49:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Khazhy Kumykov <khazhy@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: blk-throttle hierarchical throttling fix
Message-ID: <2023041138-footgear-citadel-0cef@gregkh>
References: <CACGdZYJ97rBX5JO-605WT50uEYefF4MW5HLq30cHz6QskqKPPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGdZYJ97rBX5JO-605WT50uEYefF4MW5HLq30cHz6QskqKPPg@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 06, 2023 at 10:34:56PM -0700, Khazhy Kumykov wrote:
> Please take 84aca0a7e039 ("blk-throttle: Fix that bps of child could
> exceed bps limited in parent") for stable 6.1
> 
> Cherry pick claims that the patch applies cleanly to previous trees.
> Don't believe it. This fixes a regression introduced in 5.18 abouts

Now queued up, thanks.

greg k-h
