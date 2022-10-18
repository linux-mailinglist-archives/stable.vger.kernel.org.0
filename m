Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE3D602473
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 08:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJRGf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 02:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJRGfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 02:35:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E06161137;
        Mon, 17 Oct 2022 23:35:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAB0561459;
        Tue, 18 Oct 2022 06:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA900C433C1;
        Tue, 18 Oct 2022 06:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666074921;
        bh=IzR7O/C88Ow9pRaZW143sjTCZ5leIUyYS50jtSz5lBw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T+5aCvhoZ6XOTeavDPWbYcRmXnYXooRCn/2N8wGzJAAQmsSs8qbTtoz9HB45n9ne/
         sEbXYEMdUi2IQBupm9NNwVQtO42glaU9uRNuJYXD8BbUU9rgrxifJ0adtjpzWNQxlN
         W7NsrbMRxjz4T6Yq6AkLCjlfvcGjMjaJu1F3YiVA=
Date:   Tue, 18 Oct 2022 08:35:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-fscrypt@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Please don't backport "fscrypt: stop using keyrings subsystem
 for fscrypt_master_key" to stable until it's ready
Message-ID: <Y05JJZScBd5mZs6m@kroah.com>
References: <Y032gHb9LHSYtVBH@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y032gHb9LHSYtVBH@sol.localdomain>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 05:42:40PM -0700, Eric Biggers wrote:
> Hi Sasha,
> 
> Please stop backporting my commits to stable without asking, especially without
> Cc'ing to any mailing list that is archived on lore.kernel.org.
> 
> "fscrypt: stop using keyrings subsystem for fscrypt_master_key" is a big change,
> and there's already a fix for it pending
> (https://lore.kernel.org/r/20221011213838.209879-1-ebiggers@kernel.org).  I've
> been planning on doing the backports myself once the change has had a bit more
> time to soak, which is why I intentionally didn't add Cc stable.
> 
> It appears you also backported several other commits just to get it apply
> cleanly to 5.10, so please drop those too for now.

All now dropped from the queues, thanks.

greg k-h
