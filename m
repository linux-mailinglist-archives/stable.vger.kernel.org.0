Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0686A4FD623
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377593AbiDLHuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359421AbiDLHnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:43:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4892CE21
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 00:23:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09196616B2
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 07:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F58C385A1;
        Tue, 12 Apr 2022 07:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748191;
        bh=+07LADLXCXaWRvzXsQPjhqDq9THJbpkYSMhdmLyrw7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jix4a/r8oMKaXtyzz6/DeHIQn1uy2qOrwQMafg4Oceb0N6bTSHLj9+hHdFtetY9np
         bdIOx3KE7rGU1sjsWC2FKw3ivW0r37Kek4J4LqxLxNsCFGGT7syFfu8MQslru6ASTF
         2fEoyZK23vJw2Nz5QpIFteSY5i87nOLDKiGRBZvU=
Date:   Tue, 12 Apr 2022 09:12:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xu Jia <xujia39@huawei.com>
Cc:     stable@vger.kernel.org, duoming@zju.edu.cn, linma@zju.edu.cn,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH 5.10 1/2] hamradio: defer 6pack kfree after
 unregister_netdev
Message-ID: <YlUmU+YrN69AQ37K@kroah.com>
References: <1649745544-19915-1-git-send-email-xujia39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1649745544-19915-1-git-send-email-xujia39@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 02:39:03PM +0800, Xu Jia wrote:
> From: Lin Ma <linma@zju.edu.cn>
> 
> commit 0b9111922b1f399aba6ed1e1b8f2079c3da1aed8 upstream.

Don't these two also need to go into 5.15.y?  You do not want someone
upgrading to a newer kernel and having a regression.

thanks,

greg k-h
