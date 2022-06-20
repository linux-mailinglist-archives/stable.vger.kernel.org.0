Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C431355158A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 12:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236474AbiFTKNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 06:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240631AbiFTKNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 06:13:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDC813D14
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 03:13:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BF54B80E35
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 10:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E0AC3411B;
        Mon, 20 Jun 2022 10:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655719984;
        bh=ZLZvduMLusmyQLInBdTuLUvgan9AY4ww++5w4T6/Bso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mrt7C8XrMflpr1x7ptIXAVh5Rc/g5/q0B5lshfaDmJYuVhCklXQNjgjCxnuscPSPx
         gGLW+H3b9HNtbcijEO2pnRe8tmvTDL2tb53Bfh0cR1zwocXRU2NZEUuuKt6Sah5UsQ
         6OGRFC9dx+fZzhbp0up1srB1tOnabeQIddvsvrsc=
Date:   Mon, 20 Jun 2022 12:13:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: patch request for 5.18-stable to fix gcc-12 build
Message-ID: <YrBILWzY4ziMl7xE@kroah.com>
References: <YqxguwkPJhyvKbRk@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqxguwkPJhyvKbRk@debian>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 17, 2022 at 12:08:43PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> v5.18.y riscv builds fails with gcc-12. Can I please request to add the
> following to the queue:
> 
> f0be87c42cbd ("gcc-12: disable '-Warray-bounds' universally for now")
> 49beadbd47c2 ("gcc-12: disable '-Wdangling-pointer' warning for now")
> 7e415282b41b ("virtio-pci: Remove wrong address verification in vp_del_vqs()")
> 
> This is only for the config that fdsdk is using, I will start a full
> allmodconfig to check if anything else is needed.

Now queued up, thanks.

I don't think 5.18 will build with gcc-12 for x86-64 yet either, I'm
sticking with gcc-11 for my builds at the moment...

thanks,

greg k-h
