Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53785F5882
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 18:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiJEQoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 12:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJEQn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 12:43:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B614356D7;
        Wed,  5 Oct 2022 09:43:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB868B81E7D;
        Wed,  5 Oct 2022 16:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342F6C433D7;
        Wed,  5 Oct 2022 16:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664988235;
        bh=q8ACQxJEoyAOc9bbxtVu03Z1z4MDQDcp50LasV7H1cE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=icBEjQhcTKbpjt21HpYcv1oQDW0XnNegHg+vxk0Gpmm65gQSmJnFi5UJxeKOccRhu
         DdDIsNIV2pjmp9dIIf5ZYZ4zuFikO6kZmjiFKo+kz28cUUbBgyoo8IlCZgIjPPcLOi
         I1d68g77CJ6cIgcODRe31oN46dnwpOEgXAnF1Acw=
Date:   Wed, 5 Oct 2022 18:43:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     stable@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Danilo Cezar Zanella <danilo.zanella@iag.usp.br>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ARM: fix function graph tracer and unwinder dependencies
Message-ID: <Yz20SWLFNVgXTv2M@kroah.com>
References: <CAAxUTH4zpibkhOS+NPzcYsXFqx1bJfSU19gdt0eCAOrpWAkinA@mail.gmail.com>
 <YyTXIUjq9tmFPTDi@linutronix.de>
 <CAAxUTH4xawCFpnwpRkcaZ5fdzMEbZZmPOyVDoqdMrPrf+G64dg@mail.gmail.com>
 <YzLZIX+Pi6lyIr1f@linutronix.de>
 <Yz1DtlYj+W7jfJLK@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yz1DtlYj+W7jfJLK@linutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 05, 2022 at 10:43:34AM +0200, Sebastian Andrzej Siewior wrote:
> Danilo Cezar Zanella reported broken function graph tracer in the v4.19
> tree. This was caused by the backport of commit
>    f9b58e8c7d031 ("ARM: 8800/1: use choice for kernel unwinders")
> 
> which ended in the v4.19-stable tree as of v4.19.222.
> It is also part of v4.14-stable since v4.14.259.
> It is also part of v4.9-stable since v4.9.299.
> 

Now queued up, thanks.

greg k-h
