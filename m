Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08ACC600B33
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 11:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiJQJok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 05:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiJQJoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 05:44:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BC1F5B2
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 02:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D194B811CC
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 09:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E60C433D6;
        Mon, 17 Oct 2022 09:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665999874;
        bh=xpUJxBFVDhYQnNa7JrkTdPKvmcGYHQ5nHhEXeKsYAgA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MOJIiMFGTdjhF2/md1UYJmz6mLvue2AeVMDRwro2x1XH1v7ht706TNdHXdUdL/6Fp
         ngaf+iK63XepzkeMxKRLHGnCTJUpld8jxIXPBuXOfx7wd1/CvQWBjc8A8N8vjATyfV
         sF4opgHdPX+vuinuciGwCCmvFr/XWEGKL6alg2bE=
Date:   Mon, 17 Oct 2022 11:45:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-5.10 0/2] io_uring backports
Message-ID: <Y00kMcJdulRrYBNq@kroah.com>
References: <cover.1665959215.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1665959215.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 16, 2022 at 11:31:24PM +0100, Pavel Begunkov wrote:
> io_uring backports for stable 5.10
> 
> Pavel Begunkov (2):
>   io_uring: correct pinned_vm accounting
>   io_uring/af_unix: defer registered files gc to io_uring release
> 

Now queued up, thanks.

greg k-h
