Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8375D59FF57
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 18:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239254AbiHXQUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 12:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239555AbiHXQU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 12:20:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEBE558FF;
        Wed, 24 Aug 2022 09:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D2E3B825A4;
        Wed, 24 Aug 2022 16:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAD6C433C1;
        Wed, 24 Aug 2022 16:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661358024;
        bh=bd5Ai7gyV3dh6KUli/6kO2E3a9PeCam1mN3CjAw1CiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R6VypjWzakqTzUG5kNIyxNgICq9VgEKkXEQrDwe/VZ75GbX0OLRIrcfjrwmW+ZK2k
         MwxRcvCQjt5W1BRDJqF23neebKRZU9WMRlnKOu3Bg/HQUVvpLBkfGXQaF+dOpLyUMK
         Qggczk1zGqQty/Wc5BR8cyji7GY2zv/qiBkGoDtY=
Date:   Wed, 24 Aug 2022 18:20:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: Re: [PATCH 4.19 025/287] selftests/bpf: Fix test_align verifier log
 patterns
Message-ID: <YwZPxdeZt/dtleeZ@kroah.com>
References: <20220823080100.268827165@linuxfoundation.org>
 <20220823080101.125479106@linuxfoundation.org>
 <YwZOQv/dqReP8XfU@myrica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwZOQv/dqReP8XfU@myrica>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 05:13:54PM +0100, Jean-Philippe Brucker wrote:
> Hi,
> 
> On Tue, Aug 23, 2022 at 10:23:14AM +0200, Greg Kroah-Hartman wrote:
> > From: Ovidiu Panait <ovidiu.panait@windriver.com>
> > 
> > From: Stanislav Fomichev <sdf@google.com>
> > 
> > commit 5366d2269139ba8eb6a906d73a0819947e3e4e0a upstream.
> > 
> > Commit 294f2fc6da27 ("bpf: Verifer, adjust_scalar_min_max_vals to always
> > call update_reg_bounds()") changed the way verifier logs some of its state,
> > adjust the test_align accordingly. Where possible, I tried to not copy-paste
> > the entire log line and resorted to dropping the last closing brace instead.
> > 
> > Fixes: 294f2fc6da27 ("bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()")
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Link: https://lore.kernel.org/bpf/20200515194904.229296-1-sdf@google.com
> > [OP: adjust for 4.19 selftests]
> > Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I believe this one shouldn't be applied as-is either, only partially. See
> https://lore.kernel.org/stable/20220824144327.277365-1-jean-philippe@linaro.org/

Now dropped, thanks

greg k-h
