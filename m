Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C4858F98F
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 10:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiHKIwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 04:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbiHKIwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 04:52:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE73915F6
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 01:52:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1107261595
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 08:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1BAC433C1;
        Thu, 11 Aug 2022 08:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660207941;
        bh=wHQytY2p+uD1oPDxzh+jEoOgmBWqziHIaxBJoLnv720=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bHQEt8obuoud8gb3gQc7yMG7YHYD7ewrAxm32syao6BEl6uN7DKi7ll2IO4m9Sewz
         zMiYcLOq3/TBuTzCd6w8+lDppiQHBjyS7EoRyVLpf/j9IT9MCeywSavIbcWLiuIFaG
         QKk8pGFWxA5pf6cWS6tBSDh0umESNZaJtqzwRjgs=
Date:   Thu, 11 Aug 2022 10:52:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Linjun Bao <meljbao@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] igc: Remove _I_PHY_ID checking for i225 devices
Message-ID: <YvTDQr7MuhnQYP/9@kroah.com>
References: <5d499487-2503-f1bd-586c-57ac755e1f41@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d499487-2503-f1bd-586c-57ac755e1f41@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 04:39:51PM +0800, Linjun Bao wrote:
> commit 7c496de538ee ("igc: Remove _I_PHY_ID checking") upstream,
> backported to stable kernel 5.4 to support i225 Ethernet adapters.
> 
> Signed-off-by: Linjun Bao <meljbao@gmail.com>

What happened to the original commit message and signed off by lines,
and why not cc: everyone involved in the original commit also?

thanks,

greg k-h
