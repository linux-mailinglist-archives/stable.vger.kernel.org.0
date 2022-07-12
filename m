Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6F85711CA
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 07:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiGLFWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 01:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGLFWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 01:22:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BEF631202;
        Mon, 11 Jul 2022 22:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E8DBB815FE;
        Tue, 12 Jul 2022 05:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CC1C3411E;
        Tue, 12 Jul 2022 05:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657603329;
        bh=Ww6j3/fF3QEpTsea7pwWzO3LkmRF5R0kzGRxKJYVJtI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w/TAhh8VqpazmioA6fuBOJodMT5MJjAYGIP4b6fm8saRFfCQhVzWP1mOFQFkmRzIw
         FfPC+3MpHHb71xK/NCxep6TJNHkQkajW8JngjoTuMwIWzxlajCugTbyssb+yYugANC
         X/EmyLVDu0OQeI4hYMsNS5CLOtnktYybmH6vd6xI=
Date:   Tue, 12 Jul 2022 07:22:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     sixpack13 <sixpack13@online.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
Message-ID: <Ys0E/Fhe0eZ5UBWt@kroah.com>
References: <0506af84-fedf-d431-3cd3-811c559d3776@online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0506af84-fedf-d431-3cd3-811c559d3776@online.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 11:27:22PM +0200, sixpack13 wrote:
> hallo Greg
> 
> 5.18.11-rc1
> 
> compiles, boots and runs here on x86_64
> (Intel i5-11400, Fedora 36)
> 
> Thanks
> 
> Tested-by: sixpack13@online.de
> 

Thanks for testing, but for obvious reasons, I need a valid name for the
kernel changelog if you want your Tested-by: to be added there :)
