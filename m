Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7B6601110
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 16:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiJQOYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 10:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiJQOYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 10:24:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0A365643
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 07:24:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94406B816C8
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 14:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DB7C433D6;
        Mon, 17 Oct 2022 14:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666016648;
        bh=/vkQ3udMznSQNis67SMvrgVm/uuJYGLFb782EGASBLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LGYlOiM57DOTZdF4yqTs8apL91gX364lVq2Z2Yi/fFHp0XSiArFC71GPgYaTXYPUP
         1ZMiXHaP791aIeq1ecs004xrrsKoEiiOom9kQ7fAC2R1IVMKXEnHQdM4Mj7RahTaLQ
         vzZ3ykkYwUnK2xbsw/zNFLywbDuB1lj6Php8kmtU=
Date:   Mon, 17 Oct 2022 16:24:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-5.15 0/5] io_uring backports
Message-ID: <Y01lhVsTzD5lbh8p@kroah.com>
References: <cover.1665954636.git.asml.silence@gmail.com>
 <Y00iTiwiIGaIoGhm@kroah.com>
 <3b067018-3b79-9be4-455d-e48ae91afee8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b067018-3b79-9be4-455d-e48ae91afee8@gmail.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 02:08:57PM +0100, Pavel Begunkov wrote:
> On 10/17/22 10:37, Greg KH wrote:
> > On Sun, Oct 16, 2022 at 10:42:53PM +0100, Pavel Begunkov wrote:
> > > io_uring backports for stable 5.15
> > 
> > How about 5.19?
> 
> Looks there were no conflicts for 5.19 and you applied them
> yesterday.

Ah, you are right, sorry about that, too many patches floating around
right now...

greg k-h
