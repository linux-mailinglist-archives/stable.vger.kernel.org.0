Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752AF67F6B5
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 10:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbjA1JaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 04:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjA1JaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 04:30:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771A61E1FE
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 01:29:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C8CBB80122
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 09:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8804CC433EF;
        Sat, 28 Jan 2023 09:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674898196;
        bh=43W7geYhwV2zkOs9rYNV0AQdkTBoHgyf27E2OqeN3Rs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tRxgVDCNFwC+QidFif8YAfxBSoognlaRg5QHWYI4K3RpirbHgYNhpvf+UaAvMZonL
         P2Z5S+TxqQqrd9C31wMh8ZvlY0QW4hWgzTDQYsic8PeEXv0ME5FSAI2fnEGStSoT8E
         RlYu5ODMOrkcBv24e1OR4yglxsK47Mpb33xTC1og=
Date:   Sat, 28 Jan 2023 10:29:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: i2c: mv64xxx: Add atomic_xfer method to driver
Message-ID: <Y9Tq9mn7FckDe5da@kroah.com>
References: <CAA5qM4B-4_9dpb=O_+ttGsOpP=N-aMrBpb+KZ7RJCOxxR+CoFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA5qM4B-4_9dpb=O_+ttGsOpP=N-aMrBpb+KZ7RJCOxxR+CoFA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 27, 2023 at 10:52:47PM -0800, Tong Zhang wrote:
> Hi Folks,
> I am getting the following dmesg during shutdown on a stable kernel
> (5.15.90) on a sunxi-a20 board.
> 
> Please consider cherry-pick the following commits to fix the issue in
> stable kernel
> 
> 09b343038e34 ("i2c: mv64xxx: Remove shutdown method from driver")
> 544a8d75f3d6 ("i2c: mv64xxx: Add atomic_xfer method to driver")

Now queued up, thanks.

greg k-h
