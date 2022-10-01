Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E375F1A6A
	for <lists+stable@lfdr.de>; Sat,  1 Oct 2022 09:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiJAHAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Oct 2022 03:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJAHAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Oct 2022 03:00:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD5D491E1
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 23:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B205560302
        for <stable@vger.kernel.org>; Sat,  1 Oct 2022 06:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13EDC433D6;
        Sat,  1 Oct 2022 06:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664607598;
        bh=bCy3uIYTLhssW57XNkDd23rcctvLgLSlA2Al3pIZ3yw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PFVVQKL8eso+yxoHmq6JL9j4cOxYLntEu35Tqr+cNI8Snoqgf7nUYPCBff9qcfO6o
         /wwXUFONMKENVHZlYQ+GEMgixXSoZ1NDt54tMdSEkNQTEy5IWa1fjxgtPSdbMTttx1
         NH6esYPBckVGo1orWLYmm0bBBBqCZWL2v93UDjUQ=
Date:   Sat, 1 Oct 2022 09:00:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] provide arch_test_bit_acquire for architectures that
 define test_bit
Message-ID: <YzfljcUzxBDy20U2@kroah.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2209301136380.23900@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2209301136380.23900@file01.intranet.prod.int.rdu2.redhat.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 30, 2022 at 11:36:52AM -0400, Mikulas Patocka wrote:
> This is backport of the upstream patch d6ffe6067a54972564552ea45d320fb98db1ac5e
> for the stable branch 4.9
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

What happened to the original changelog information and the original
signed-off-by information?

Please keep that when backporting changes.  Fix that up for all of these
when you resend.

thanks,

greg k-h
