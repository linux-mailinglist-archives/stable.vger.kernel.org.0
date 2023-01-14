Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99ED66A9C4
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 07:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjANG5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 01:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjANG5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 01:57:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D0C4ECC
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 22:56:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2A6960B51
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 06:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D378BC433EF;
        Sat, 14 Jan 2023 06:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673679416;
        bh=tZH5+7ljPefS8hBdYpJxPsf2KyAm+uGZidjIkwVg2cM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qbGRUgrfMhm/PmfWOAWCxY40qyw8jcLu9KbT/cDIEBqcIK49sFyxZuyqnoMhmssDO
         rcYNv+nP4nVq9WYeZgkzbzg1jlxSBkm338HtFChZMwyeS+QUCcrKqxPZEgmnv8Mnj6
         SFq3M+OyoSqHaWCad/M/BTx12eC+r1ZBfwva2dJo=
Date:   Sat, 14 Jan 2023 07:56:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matthew Fahner <mdfahner@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Second Monitor Issue on Kernel 6.1.5
Message-ID: <Y8JSMlMgnggwOYl0@kroah.com>
References: <CADsncqR2mTUArTv2HhRnsfmQx5iNgUZo=JVgkUcZT7MtjxEoYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADsncqR2mTUArTv2HhRnsfmQx5iNgUZo=JVgkUcZT7MtjxEoYw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 13, 2023 at 11:58:47PM -0500, Matthew Fahner wrote:
> Hello,
> 
> I'm running Ubuntu 20.10 and experienced a regression when trying
> kernel 6.1.5 that was not present in previous kernels such as 6.0.19
> or 6.0.9
> 
> I have two monitors attached using DisplayPort MST (daisy chaining the
> displays).
> 
> Normally, this works without issue and both monitors are detected and
> display properly.
> 
> With kernel 6.1.5, the second monitor (the monitor that's not directly
> connected to the computer) was detected but would not display.  I
> didn't spend much time troubleshooting the issue and instead reverted
> to 6.0.19 where it again worked without issue.  The first monitor
> worked without issue.
> 
> Let me know what steps I can take to help identify the root cause.

Can you use 'git bisect' to track down the offending commit?

thanks,

greg k-h
