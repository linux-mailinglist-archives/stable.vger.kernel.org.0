Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030C759E4D6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 16:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242313AbiHWOEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 10:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243561AbiHWOEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 10:04:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A22E24A8CD;
        Tue, 23 Aug 2022 04:13:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7277615B0;
        Tue, 23 Aug 2022 11:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988BDC433C1;
        Tue, 23 Aug 2022 11:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661253163;
        bh=6G6zq8I7nAi0kVG+KT4vj6LQ2QT6M4kSZqG+LDbqc/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u2Ia3oDu2UIgk86wMyHje6XBt89O/vMEp94XTWCt/KzcbD2Kuk78FIaJjZAg7+vNY
         DV8tZT/8cGpa53+8LYy9ax7z+tDMJ2wi9nqQQTmOqnwDB/yVkqGJIWgZzC+k1NOgrr
         AWEDUpP4LgMf1rC1p4k6O125EE8iXYOsjyFRW2hw=
Date:   Tue, 23 Aug 2022 13:12:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: Re: [PATCH 4.19 026/287] selftests/bpf: Fix "dubious pointer
 arithmetic" test
Message-ID: <YwS2JxS4vmKuBy5r@kroah.com>
References: <20220823080100.268827165@linuxfoundation.org>
 <20220823080101.156298170@linuxfoundation.org>
 <YwSksjAucU2zwo0y@myrica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwSksjAucU2zwo0y@myrica>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 10:58:10AM +0100, Jean-Philippe Brucker wrote:
> Hi,
> 
> On Tue, Aug 23, 2022 at 10:23:15AM +0200, Greg Kroah-Hartman wrote:
> > From: Ovidiu Panait <ovidiu.panait@windriver.com>
> > 
> > From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > 
> > commit 3615bdf6d9b19db12b1589861609b4f1c6a8d303 upstream.
> 
> This shouldn't be backported to 4.19, because it adjusts the selftest due
> to commit b02709587ea3 ("bpf: Fix propagation of 32-bit signed bounds from
> 64-bit bounds."), which wasn't backported further than 5.9.
> 
> See [1] for the report about these BPF backports to v5.4, which we are
> still trying to unravel. Given how painful building the BPF tests used to
> be even on 5.4, I'd rather not do the same on 4.19!
> 
> [1] https://lore.kernel.org/lkml/CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com/

Thanks for letting me know, I've now dropped this from the 4.19-rc
queue.

Ovidiu, please work on fixing this up in a way that everyone can agree
on.

thanks,

greg k-h
