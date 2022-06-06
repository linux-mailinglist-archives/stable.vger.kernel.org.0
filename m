Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90EE253ECC2
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiFFRMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 13:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiFFRL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 13:11:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9452937BDB
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 10:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41CF3B81A96
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 17:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F32AC34115;
        Mon,  6 Jun 2022 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654534817;
        bh=s0+Y9xu15Jh9BNwYPJGtH9Rw0y+ZqS75bv6viPalsec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pOzFEYFbZe8icvcZw0zniA0R5VfUrMOtQQdsjXFsalA7xLQ+ajz4Af/QNbyTEV+f0
         bT/PPPFfN7lUUIUkE2lkkYmmLO3JsjAHreqE8cak34jCEbAVkbsq8jf1Dt975jCa/8
         zcvrNdPF7/5o0ZSb8vffGQzHcwA5CPExjxgfUZlk=
Date:   Mon, 6 Jun 2022 19:00:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Elder <elder@linaro.org>
Cc:     stable@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH 0/2] net: ipa: v5.18.2 backport to fix page free
Message-ID: <Yp4yn+Wkdb8abteG@kroah.com>
References: <20220606141548.724917-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606141548.724917-1-elder@linaro.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 09:15:46AM -0500, Alex Elder wrote:
> This series back-ports two bug fixes that landed very late in v5.18
> cycle and didn't make it to the final release.  They're present in
> v5.19-rc1, but don't cherry-pick cleanly onto v5.18.2.
> 
> 					-Alex
> 
> Alex Elder (2):
>   net: ipa: fix page free in ipa_endpoint_trans_release()
>   net: ipa: fix page free in ipa_endpoint_replenish_one()
> 
>  drivers/net/ipa/ipa_endpoint.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> -- 
> 2.32.0
> 

All now queued up, thanks,

greg k-h
