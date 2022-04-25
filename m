Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670CC50E4B7
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 17:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbiDYPvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 11:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbiDYPvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 11:51:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C458A114817
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 08:48:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 606EA60F3A
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 15:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535DAC385A7;
        Mon, 25 Apr 2022 15:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650901712;
        bh=+aBKAvZQcmG9y/cUJyE9/YT8g7/VVlOeVKzYTZZ/uu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qLtZP1dCEtdxx7TFGIQzj1vJhosJ1di9k2SMHAP6rALMbBwaGzLT3ynkEwkeKlsHl
         9cYyMiAjjBULhG9pf3PvTGE/4aAYP8mL9nhNt45p6iKvlTp46rHoyfRJUdrmqO6bGZ
         EU2vJKIHmPRKLtEuS5UJQr0aO9Ypb/gYZ4eV1uBw=
Date:   Mon, 25 Apr 2022 17:48:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     asml.silence@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: fix leaks on IOPOLL and
 CQE_SKIP" failed to apply to 5.17-stable tree
Message-ID: <YmbCzl9RQA9YixAp@kroah.com>
References: <1650891057139245@kroah.com>
 <5be49cde-7c90-3be4-7c3c-f9bf8694f9ab@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5be49cde-7c90-3be4-7c3c-f9bf8694f9ab@kernel.dk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 25, 2022 at 08:28:05AM -0600, Jens Axboe wrote:
> On 4/25/22 6:50 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.17-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here's one for 5.17.

Now queued up, thanks!

greg k-h
