Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B9B6DC4C8
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 11:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjDJJCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 05:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjDJJCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 05:02:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63BE30D0
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 02:02:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DAE66103A
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 09:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83289C4339C;
        Mon, 10 Apr 2023 09:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681117332;
        bh=Zj8s/oSM/FbabyJ/pTM5S2A3M09UXxPCLZ4CMzrVlbQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wJqEwMyotYD70CKjovdsDZQjOHAQ9X3uGjlMvobMJ4M9JaM+4ajPu3fq5u3JH41Rk
         lvC3TuQIeuiAfy+Y/rH7sdzhdywcumFH/tKp2cU2EdDCOKBuKVwzHUP8Z6Xe+vlCUm
         yNcUx0g7z6Y1WCCiPpMinKa0GWMb/iHh6qsEJ8OI=
Date:   Mon, 10 Apr 2023 11:02:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Acid Bong <acidbong@tilde.cafe>
Cc:     stable@vger.kernel.org
Subject: Re: No updates in rolling branches
Message-ID: <2023041042-irritate-oat-26e0@gregkh>
References: <D5189C7F-B690-4296-A005-A2C0A1EC85F9@tilde.cafe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D5189C7F-B690-4296-A005-A2C0A1EC85F9@tilde.cafe>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 10, 2023 at 11:36:41AM +0300, Acid Bong wrote:
> Hi there, hello,
> 
> I've noticed that the recent (at the moment) releases 6.2.10 and
> 6.1.23 weren't merged into linux-rolling-stable and linux-rolling-lts
> respectively. Is there something wrong with them that they require the
> delay?

Sorry about that, I just forgot to push them out.  They should now be
there (might take a bit for the backend mirrors to sync.)

thanks,

greg k-h
