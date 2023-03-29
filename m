Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3736CD6D5
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 11:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjC2JsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 05:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbjC2JsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 05:48:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92265130;
        Wed, 29 Mar 2023 02:48:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B67D61C2F;
        Wed, 29 Mar 2023 09:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D167C433D2;
        Wed, 29 Mar 2023 09:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680083286;
        bh=sXc5FZIHU0K4YTmbrsdUejURuFcQA0VXDC4zDcbi9OY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BMAS1G8/85Qg49oU3vTUCmov0LO8KKonunrOKcGBRIZdUCRZTtJwL0GXX+L12Caxu
         V0UeFKBsArRLxh1R+BxVp/jn6mCOmXsdQTEgqOqjqreJBHWI8neRf4TJa7ecDlmLfn
         K3+3qXzPd+Bfhtl0RYHFjFb8Nh6UT4VIkekl0vBozrK2ZNkHBUISv2n6FWvfbHhnPO
         FvMgWTkyMAnq3sTcaRaF8y6GJwSIqwDk+EhHY6w3FDvHH+dxNdxfxGOYZ1k2BDgAKL
         IUTofTT5cQ9jVI6CydF2Cp1X56clD9x3T2iESMKMbjbZ89y2W+SISOdTYy8C9pSyCc
         lkgmLTXsOeY2Q==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1phSPl-00007C-U2; Wed, 29 Mar 2023 11:48:21 +0200
Date:   Wed, 29 Mar 2023 11:48:21 +0200
From:   Johan Hovold <johan@kernel.org>
To:     =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     linux-usb@vger.kernel.org, Andrew Green <askgreen@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: option: add Quectel RM500U-CN modem
Message-ID: <ZCQJZdRwl6osMrPi@hovoldconsulting.com>
References: <20230328184131.206490-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230328184131.206490-1-bjorn@mork.no>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 08:41:31PM +0200, Bjørn Mork wrote:
> This modem supports several modes with a class network function
> and a number of serial functions, all using ff/00/00
> 
> The device ID is the same in all modes.

> Reported-by: Andrew Green <askgreen@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Bjørn Mork <bjorn@mork.no>

Thanks, Bjørn. Now applied.

Johan
