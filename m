Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1478067DE80
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 08:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbjA0H2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 02:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjA0H2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 02:28:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6AECC31;
        Thu, 26 Jan 2023 23:28:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAF57619E2;
        Fri, 27 Jan 2023 07:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6C0C433EF;
        Fri, 27 Jan 2023 07:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674804490;
        bh=41nvTCSFJJ2bFpXnW7eFEO4smfuDDSvMknN6qj5+8fQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pkoB9AEfbxqTGBhPImDfcmMF5VHRqGrh84KZRLtvG64eDgo+Vgcg53YnUIbHSXawQ
         nsyl8Nmi/BhAw7YN5lc5H/RCQSpY3UAPIGA5A1SnQB6d2CwoC+P3AY6lnD2h5Y3MYu
         CGmqs06Ytbo+YBihz75nH4xzTnsGHvaZKFo/0Q+E=
Date:   Fri, 27 Jan 2023 08:28:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Tom Saeger <tom.saeger@oracle.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 5.4 fix build id for arm64 with CONFIG_MODVERSIONS 0/6]
Message-ID: <Y9N9B5e7HZhFN7nl@kroah.com>
References: <cover.1674588616.git.tom.saeger@oracle.com>
 <Y9MyFyifBDCrwMuq@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9MyFyifBDCrwMuq@sashalap>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 26, 2023 at 09:08:23PM -0500, Sasha Levin wrote:
> On Tue, Jan 24, 2023 at 02:14:17PM -0700, Tom Saeger wrote:
> > Build ID on arm64 is broken if CONFIG_MODVERSIONS=y
> > on 5.4, 5.10, and 5.15
> > 
> > Discussed:
> > https://lore.kernel.org/all/3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com/
> > https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/
> 
> Queued up, hopefully it makes it this time :) Thanks!

Dropped from the 5.4 queue as it is not in any newer kernel tree yet,
sorry.  We can't have a fix that is in only 5.4 but not in a newer
release, that would mean it would be a regression if someone moves to a
newer release.

Tom, please submit patches for _all_ branches, and we will be glad to
consider them, not just for one old one.

thanks,

greg k-h
