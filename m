Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EBA59142D
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 18:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239118AbiHLQpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 12:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239381AbiHLQpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 12:45:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5153FB07C4
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 09:45:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E29CD615ED
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 16:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F307DC433D6;
        Fri, 12 Aug 2022 16:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660322707;
        bh=zsmkO76RyZjhQRVXG3TJT130ejBIMArLNF1Qr3m1Ip0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GNWe49lW9Ia/PTvzXZIUD6DFcB7B8mOvV2TN3V5wkE9CH9HPpC7wxsI3kuXocq9Sn
         apjcRP+Y+iOxAgAa73mWD7CO9o361/drG57ESLaL4psSo5yn3OIE2qAFzjsdTNKniU
         dkf47R7GxU4pFdCAUy4lyRxzfUJYZyDMpEcRpN88=
Date:   Fri, 12 Aug 2022 18:45:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH 5.10 0/1] Backport support for tracing capacity constants
Message-ID: <YvaDkDyy2eohvkmx@kroah.com>
References: <1660255683-1889-1-git-send-email-khoroshilov@ispras.ru>
 <YvZzwc7x+0QzTPlH@kroah.com>
 <97dd7ee5-e81b-30d3-b38b-ba39159af823@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97dd7ee5-e81b-30d3-b38b-ba39159af823@ispras.ru>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 12, 2022 at 07:01:55PM +0300, Alexey Khoroshilov wrote:
> On 12.08.2022 18:37, Greg Kroah-Hartman wrote:
> > On Fri, Aug 12, 2022 at 01:08:02AM +0300, Alexey Khoroshilov wrote:
> >> Syzkaller reports a number of "BUG: MAX_LOCKDEP_CHAINS too low!" warnings
> >> on 5.10 branch and it means that the fuzz testing is terminated prematurely.
> >> Since upstream patch that allows to increase limits is applied cleanly
> >> and our testing demonstrated that it works well, we suggest to backport
> >> it to the 5.10 branch.
> > 
> > What about all of the newer kernels branches, it is needed in 5.15.y,
> > 5.18.y and 5.19.y, right?  What's so special about 5.10.y?
> 
> 
> The commit was introduced in 5.13, so it is already there.
> 
> By the way, I messed up upstream commit id in my message, sorry about that.
> 
> The correct one:
> 5dc33592e95534dc8455ce3e9baaaf3dae0fff82

Ah, that makes more sense, the id you gave me was not in a released
kernel yet...
