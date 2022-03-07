Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EB64CFE48
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 13:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241415AbiCGM0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 07:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbiCGM0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 07:26:17 -0500
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 177848023B;
        Mon,  7 Mar 2022 04:25:22 -0800 (PST)
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1nRCQS-00072o-04; Mon, 07 Mar 2022 13:25:20 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id DBA8FC1280; Mon,  7 Mar 2022 13:21:42 +0100 (CET)
Date:   Mon, 7 Mar 2022 13:21:42 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     YunQiang Su <yunqiang.su@cipunited.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        od@opendingux.net, stable@vger.kernel.org
Subject: Re: [PATCH] mips: Always permit to build u-boot images
Message-ID: <20220307122142.GE14422@alpha.franken.de>
References: <20220306151648.39599-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220306151648.39599-1-paul@crapouillou.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_PERMERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 06, 2022 at 03:16:48PM +0000, Paul Cercueil wrote:
> The platforms where the kernel should be loaded above 0x8000.0000 do not
> support loading u-boot images, that doesn't mean that we shouldn't be
> able to generate them.
> 
> Additionally, since commit 79876cc1d7b8 ("MIPS: new Kconfig option
> ZBOOT_LOAD_ADDRESS"), the $(zload-y) variable was no longer hardcoded,
> which made it impossible to use the uzImage.bin target.
> 
> Fixes: 79876cc1d7b8 ("MIPS: new Kconfig option ZBOOT_LOAD_ADDRESS")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  arch/mips/Makefile | 4 ----
>  1 file changed, 4 deletions(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
