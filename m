Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC37257F9CD
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 09:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiGYHAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 03:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiGYHAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 03:00:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CD6A46A;
        Mon, 25 Jul 2022 00:00:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61584610A7;
        Mon, 25 Jul 2022 07:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DF1C341C6;
        Mon, 25 Jul 2022 07:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658732440;
        bh=PU/uIPIuT+1JDGrwewxldEjg0C1KjctDuSqs0gZtTDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kw4hbPrz2g6Htu4tGQOtrQGNyXTYbvOkPF4UaqNJiQZuAXWBmrm6MQEKNq6Ty5z5U
         oU3uJPO3An296oEQqQHv8W1aRSfCm9WHsX7R1TtThhOcgOn6bcBVrSYjHcSC/+knBA
         8U2IjXrZa61LhxyYIW+lovvpex2nKICIEhX1o34c=
Date:   Mon, 25 Jul 2022 09:00:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Max Staudt <max@enpas.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH AUTOSEL 5.18 28/54] tty: Add N_CAN327 line discipline ID
 for ELM327 based CAN driver
Message-ID: <Yt4/lVCvm/GHuGWj@kroah.com>
References: <20220720011031.1023305-1-sashal@kernel.org>
 <20220720011031.1023305-28-sashal@kernel.org>
 <544401cc-97ad-c9b6-16e0-ea74d2695fd4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544401cc-97ad-c9b6-16e0-ea74d2695fd4@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 25, 2022 at 07:35:13AM +0200, Jiri Slaby wrote:
> On 20. 07. 22, 3:10, Sasha Levin wrote:
> > From: Max Staudt <max@enpas.org>
> > 
> > [ Upstream commit ec5ad331680c96ef3dd30dc297b206988023b9e1 ]
> > 
> > The actual driver will be added via the CAN tree.
> 
> Hmm, it's a new driver (ldisc). Should it really go to stable?

You are right, no, this shouldn't go to stable kernels, it doesn't
affect them at all.

Sasha, can you drop this from all autosel queues?

thanks,

greg k-h
