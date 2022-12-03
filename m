Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82A4641715
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 14:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiLCNlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 08:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiLCNkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 08:40:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5231FF99
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 05:40:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85878601BE
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 13:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65125C433D6;
        Sat,  3 Dec 2022 13:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670074840;
        bh=ZgNo6K48ent+7WIJXpGtpE9L+IhExHLNcKInXoGayVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JlXUG0x1qBRpIjPEWuKp9HvgjNxRJXezNTp91b9ushSK4kej3yVElMCTqiR03FkYo
         9G3DADu0CS1d56141Bp/NkAEN0Y8SjQe/34xGhfMkpC5/O95/EN8Dba3s1UuGGTjjL
         v9VmRGSTOhAGyiiadzAfz7Rpjy5KQk1I44GCtJwU=
Date:   Sat, 3 Dec 2022 14:40:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>, andres@anarazel.de,
        Alexei Starovoitov <ast@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, quentin@isovalent.com,
        Jiri Olsa <jolsa@kernel.org>, benh@debian.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: Stable backport request: tools and binutils'
 init_disassemble_info
Message-ID: <Y4tR1VlS+LNvcS0P@kroah.com>
References: <CAEUSe7-vBpHrbEy+eQrNZ_LTeqHpn2eQEr3C7cmfNYjK1YL4Ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7-vBpHrbEy+eQrNZ_LTeqHpn2eQEr3C7cmfNYjK1YL4Ww@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 09:04:02PM -0600, Daniel Díaz wrote:
> Hello!
> 
> Would the stable maintainers please consider backporting the following
> series of patches?:
> https://lore.kernel.org/lkml/20220801013834.156015-1-andres@anarazel.de/
> 
> Branches where this is needed are:
> * 5.4
> * 5.10
> * 5.15
> 
> Branch 6.0.y is fine, as this series is present there.

What exactly are the git commit ids that you are needing here?  And in
what order?

And have you tested them on the older kernels to verify that they work
properly?

thanks,

greg k-h
