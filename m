Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763B9600B2F
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 11:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiJQJnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 05:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJQJnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 05:43:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2109A1D0F9
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 02:43:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B20D760FD6
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 09:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBCDC433D6;
        Mon, 17 Oct 2022 09:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665999800;
        bh=PdYaOroIvhajksSyvVorhhaUoSvC1dqD5uc3zb6f/Ms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z6rnpEmi42aKjOKLEW611INtbTvZJz1w7tsdsPtBrrFW2Xt08zNNVIczpQfA2bT49
         wP2T9kUHHfad549i9APLRLsH4eJZuihV7LWZU3xPn5T2eV1MROzwgCPuTcyVm64alM
         2Phe06X9770BjZKBH/Dk8h6dR0h/ZhGrGPXzrRhI=
Date:   Mon, 17 Oct 2022 11:44:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-5.15 0/5] io_uring backports
Message-ID: <Y00j5+EKGVf34QFc@kroah.com>
References: <cover.1665954636.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1665954636.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 16, 2022 at 10:42:53PM +0100, Pavel Begunkov wrote:
> io_uring backports for stable 5.15

Now queued up, thanks.

greg k-h
