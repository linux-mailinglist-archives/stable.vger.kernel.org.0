Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D97D55748F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 09:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiFWHzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 03:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiFWHzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 03:55:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F7A47043;
        Thu, 23 Jun 2022 00:55:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 236BD61B01;
        Thu, 23 Jun 2022 07:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17098C3411B;
        Thu, 23 Jun 2022 07:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655970913;
        bh=fPqGc0qej9i/SABjSJ2TQXIOK2RVumdkJZyalDrgWKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OgQGfNAJAOEXzVEnmeHeyarQXal8i0fWYk1GGoQVXJiQTvyUYRl68bDNBUeaPuv/1
         Xa25yZ0lXuxMDg+Ax2hIJnoDxhnewmMVCMWisK/y4Vb5JWiI8xIHvzCcKdCskFwG3Z
         mw261Uo253JkkQNH+1ayttRqAlxSac6O2UZXlxP0=
Date:   Thu, 23 Jun 2022 09:55:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     xu xin <cgel.zte@gmail.com>
Cc:     anton@tuxera.com, linux-ntfs-dev@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        xu.xin16@zte.com.cn, linux-fsdevel@vger.kernel.org
Subject: Re: Bug report: ntfs_read_block may crash system
Message-ID: <YrQcXg89eO0Y/pgZ@kroah.com>
References: <20220623033635.973929-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623033635.973929-1-xu.xin16@zte.com.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 03:36:35AM +0000, xu xin wrote:
> >From Zeal Robot <zealci@zte.com.cn>
> 
> Hi! Zeal Robot found a potential risky bug about NTFS under the help of syzkaller.
> This will cause OS crash when CONFIG_NTFS_FS is set and panic_on_oops is on.

Do you have a proposed fix for this as you can easily reproduce this?

And it looks like you need root permisions for this, right?

thanks,

greg k-h
