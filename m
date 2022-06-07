Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF3953FA5A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240421AbiFGJwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240292AbiFGJv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:51:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518CDED7A1
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 02:50:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73430B81E7F
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 09:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D2CC34115;
        Tue,  7 Jun 2022 09:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654595390;
        bh=Wxwm/w8YSCrw5v1of8lXbfQY8YAKblNCXLJZwfs0pw4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0CLhL1dYituCGAASivpcqqrLSoBb1+zTjXy5i7pIFEm9uItEP6JdkvPv/hDEMV7uy
         GasheogqbdugkGwP71ciAtHpGqBfiapkGjBSdfLPCPXbywFQb3h1aN5nyjfq4ijkOL
         MudSsb8weCSmwbo4PI8rLX+EaqV/CMP6Owqh/IwE=
Date:   Tue, 7 Jun 2022 11:49:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: [PATCH stable 5.10 5.15 5.17 5.18] arm64: Initialize jump labels
 before setup_machine_fdt()
Message-ID: <Yp8fOOdQdSFC3beA@kroah.com>
References: <20220604062503.396762-1-Jason@zx2c4.com>
 <Yp2kn+lzTL7RTaoD@kroah.com>
 <CAHmME9pPvdAS1fqDpaDVq6T9=cch2M_UhRJwNEBntG-dYfhU0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pPvdAS1fqDpaDVq6T9=cch2M_UhRJwNEBntG-dYfhU0g@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 10:56:21AM +0200, Jason A. Donenfeld wrote:
> You can actually drop this in favor of
> https://lore.kernel.org/stable/20220607084005.666059-1-Jason@zx2c4.com/
> rather than playing whack-a-mole by architectures that may have been
> broken by it.

So I need to drop this as well?  Or is it ok to keep for now now that I
have queued up the other commit?

confused,

greg k-h
