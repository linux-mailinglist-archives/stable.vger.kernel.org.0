Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74766613129
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiJaHXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJaHXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:23:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8A9256;
        Mon, 31 Oct 2022 00:23:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B408B810B2;
        Mon, 31 Oct 2022 07:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D9FC433D6;
        Mon, 31 Oct 2022 07:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667201019;
        bh=Io6zd5E1x1tJ/A9M6wscatLJ3A4vcR7XMXt55LhYVlM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rxgrY6l/YrO7UgwPm7uvOk1I0IqGWoWy8vQIiIZi+nKCmQAtC3eoqTg6LzFy8hDS/
         L7t+Up37mXudXsWdX754npknNRx52BSV1gk5OQzmU+EhYBPsinXNpCnIblFjbb3fmF
         XEitYEI81AgR4/bWn11D7ZU99wB56rj0oIRvhhGA=
Date:   Mon, 31 Oct 2022 08:24:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Sasha Levin <sashal@kernel.org>,
        Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>,
        "M. Vefa Bicakci" <m.v.b@runbox.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/3] xen/gntdev: Accommodate VMA splitting
Message-ID: <Y194M/6GboCwWiZX@kroah.com>
References: <20221030071243.1580-1-demi@invisiblethingslab.com>
 <20221030071243.1580-4-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221030071243.1580-4-demi@invisiblethingslab.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 30, 2022 at 03:12:43AM -0400, Demi Marie Obenour wrote:
> From: "M. Vefa Bicakci" <m.v.b@runbox.com>
> 
> Prior to this commit, the gntdev driver code did not handle the
> following scenario correctly with paravirtualized (PV) Xen domains:

This is already in 5.10.152, do we need to add it again?

thanks,

greg k-h
