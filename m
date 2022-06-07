Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDD053FAD0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 12:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239921AbiFGKFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 06:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbiFGKFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 06:05:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1649EACD7
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 03:05:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D48461307
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 10:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85B6C385A5;
        Tue,  7 Jun 2022 10:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654596345;
        bh=dF3rbKrc9YsKUsIduNGJUeBiYvvxODqFefwlXGwwXq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aU3bNItidGCVIa2Ib39yZZaRa6RdYiE6nQX3BUfkxHvCWDPOjMI7D/K7K2qqnU4rb
         0RJ4UuXxXe9vMTVeCgnUioDXe7VG9w6hnzRdm9q3orv+DwpCkqDAtecblZr3H9Xxg5
         tzv7sfpXvgqwHKIN8ykl/Ydc2XiJBillILh9J+2w=
Date:   Tue, 7 Jun 2022 12:05:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: [PATCH stable 5.10 5.15 5.17 5.18] arm64: Initialize jump labels
 before setup_machine_fdt()
Message-ID: <Yp8i9DH57dRGfTNf@kroah.com>
References: <20220604062503.396762-1-Jason@zx2c4.com>
 <Yp2kn+lzTL7RTaoD@kroah.com>
 <CAHmME9pPvdAS1fqDpaDVq6T9=cch2M_UhRJwNEBntG-dYfhU0g@mail.gmail.com>
 <Yp8fOOdQdSFC3beA@kroah.com>
 <CAHmME9pkWz_DBww8YOTzKtbxbjRgNkjDTRfxy2Hr-pur0dVA0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pkWz_DBww8YOTzKtbxbjRgNkjDTRfxy2Hr-pur0dVA0A@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 11:51:23AM +0200, Jason A. Donenfeld wrote:
> On Tue, Jun 7, 2022 at 11:49 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jun 07, 2022 at 10:56:21AM +0200, Jason A. Donenfeld wrote:
> > > You can actually drop this in favor of
> > > https://lore.kernel.org/stable/20220607084005.666059-1-Jason@zx2c4.com/
> > > rather than playing whack-a-mole by architectures that may have been
> > > broken by it.
> >
> > So I need to drop this as well?  Or is it ok to keep for now now that I
> > have queued up the other commit?
> 
> The other commit ("Revert "random: use static branch for
> crng_ready()"") fixes this problem on all architectures. This commit
> fixes the problem on arm64. There's probably no harm in keeping this
> commit, if you want it, but it's also no longer necessary, because
> "Revert "random: use static branch for crng_ready()"" addresses the
> issue more comprehensively.

I'll just leave this as-is for now, that's simpler.

thanks,

greg k-h
