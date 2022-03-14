Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4173C4D7E5F
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 10:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbiCNJXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 05:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiCNJXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 05:23:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6BD433A1
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 02:22:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A6B560916
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 09:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCF4C340E9;
        Mon, 14 Mar 2022 09:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647249762;
        bh=VBxcQ4n67RtNfWUrqRVKLiR1QbwBFoY8IcUTLTHBfbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dbpNs2S0zeq7rCE0XcHpvC6L4Gsxf0R79Y1buLNkxSHMti9Ds0WjvuqUbmpqaM3e9
         mZ8BG9TxXHVWZNUcGbkF0GVExCzPzUM7SKRtAl2hF1tUR9Ze+gWEMuFrGWtQ/nlFo1
         EHeUNaJpZuATDrOol1TvHhcFziVlHb+P4njaPmjc=
Date:   Mon, 14 Mar 2022 10:22:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "palmer@rivosinc.com" <palmer@rivosinc.com>
Subject: Re: FAILED: patch "[PATCH] riscv: dts: k210: fix broken IRQs on
 hart1" failed to apply to 5.15-stable tree
Message-ID: <Yi8JXkm75GQrA5Td@kroah.com>
References: <16465109854128@kroah.com>
 <YiXwp6Yx7bmRaAin@x1-carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiXwp6Yx7bmRaAin@x1-carbon>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 07, 2022 at 11:46:49AM +0000, Niklas Cassel wrote:
> On Sat, Mar 05, 2022 at 09:09:45PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hello Stable (Greg),
> 
> Original commit in Linus tree:
> 74583f1b92cb3bbba1a3741cea237545c56f506c
> 
> Attaching a patch that will apply for 5.15 and 5.16.

Now queued up, thanks.

greg k-h
