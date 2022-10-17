Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE85600AFA
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 11:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiJQJgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 05:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiJQJgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 05:36:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C751054A
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 02:36:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2C34B8110A
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 09:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA1CC433D6;
        Mon, 17 Oct 2022 09:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665999391;
        bh=Zo+O8oihRHkb/5k7MwIjSulHGInlUoqFJ1cJATFXPoQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iGTsqkrZ+uTFlRIhzp3cVVVpy/a/S9gaAe1Sw/tzD4KEXU9BwGTPsYBPr72nhqHGM
         x7EC8kouYMFx6feDGhGPQifc/Idl/tfCECykE7K1URA4cmJpdY5piuL6q7jedJWBHd
         uIfTa/Gdk7+CuxAcFkC2R+Ia24RqsU10MPm1BZJA=
Date:   Mon, 17 Oct 2022 11:37:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-5.15 0/5] io_uring backports
Message-ID: <Y00iTiwiIGaIoGhm@kroah.com>
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

How about 5.19?

If you wait a week or so, 5.19 will be end-of-life, so maybe we can just
not worry about it :)

thanks,

greg k-h
