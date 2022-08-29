Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9075A4470
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 10:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiH2ICZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 04:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiH2ICB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 04:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D0250708
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 01:02:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1BE960909
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 08:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D281CC433C1;
        Mon, 29 Aug 2022 08:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661760119;
        bh=wXyxJeUstHLkbiUNgs0A1uVGaDUbOaYwj7LtnkDwQmE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jd3Vx8AXZZsNrNltWW4NatDQGwZD+Nm+o3aegAc91T1PWZ1SpNCZhqnZtm0ta7gCy
         L8tt3JY2pvGn2/+gWGhNv9YWRCpuoK4mLy+mDjuvDD1mNKOxeDs02CZ3G7hMCHBgyq
         o8Ki38ZcPEExhOpckroqSsx7wafEIQMlfHxozF8k=
Date:   Mon, 29 Aug 2022 10:01:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable <stable@vger.kernel.org>,
        "song@kernel.org" <song@kernel.org>
Subject: Re: 5.19 and 5.15 stable patches
Message-ID: <YwxydO2CuQOuUp/m@kroah.com>
References: <a603cfc5-9ba5-20c3-3fec-2c4eec4350f7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a603cfc5-9ba5-20c3-3fec-2c4eec4350f7@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 25, 2022 at 10:21:38AM -0600, Jens Axboe wrote:
> Hi,
> 
> Backport of fix that went into 6.0-rc1 for 5.19-stable and
> 5.15-stable. Please apply, thanks!

Now queued up, thanks.

greg k-h
