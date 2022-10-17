Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732A8600B00
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 11:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiJQJhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 05:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiJQJhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 05:37:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890905AC67
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 02:36:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7459FB811B1
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 09:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A79C433D6;
        Mon, 17 Oct 2022 09:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665999403;
        bh=IamE8ZiRQ9eh4lHMGr48KC05BdMOeWg6ioV80NnF5WI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bo3qaZ4UvFdw2FCXI/bAO4qtJI3M1wp/KqZeaDG/I6tthuiKDFMDT363RX8oef45d
         sF2eSbCaOdgWVkV4fEBdvm2mseDvSai4te9bUox1U5RWYUL5zY3XglJGYm3b4vL+VB
         vaqGdAR/13UAmSq3C4cP32wO3WDd94qlQFiZn9xY=
Date:   Mon, 17 Oct 2022 11:37:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-6.0 0/6] io_uring 6.0 backports
Message-ID: <Y00iWh0TdxNnZztU@kroah.com>
References: <cover.1665951939.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1665951939.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 16, 2022 at 09:33:24PM +0100, Pavel Begunkov wrote:
> io_uring patches that has failed to be applied today with their
> dependencies.

Now queued up, thanks.

greg k-h
