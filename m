Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B434B692A
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 11:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbiBOKYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 05:24:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236507AbiBOKYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 05:24:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A88422BD7;
        Tue, 15 Feb 2022 02:24:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94E1E61344;
        Tue, 15 Feb 2022 10:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EB0C340EB;
        Tue, 15 Feb 2022 10:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644920658;
        bh=JUNXB18jg+7Kzp9Sc52Qxzmd5Nzo54fh6gGG/K88CgI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xRMp56rc4ABAGn/apSFOxlR0WC/QrRGKmgxMaocZNitP+JCznu5Ayiqja3QbvCJPW
         vGB88P1dZjS8/jZapXt0bXbEZSpZKVaKnO5L2zNhECouXMe3SK4ABqcznuS93ozG4O
         R61RbFp9I4HMD/vmSJM5qQFeap3XgY5VvgJTshRc=
Date:   Tue, 15 Feb 2022 11:24:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tomas Winkler <tomas.winkler@intel.com>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        Vitaly Lubart <vitaly.lubart@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [char-misc 1/4] mei: me: disable driver on the ign firmware
Message-ID: <Ygt/Th1UeOkWpwlD@kroah.com>
References: <20220215080438.264876-1-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215080438.264876-1-tomas.winkler@intel.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 10:04:35AM +0200, Tomas Winkler wrote:
> From: Alexander Usyskin <alexander.usyskin@intel.com>
> 
> Add a quirk to disable MEI interface on Intel PCH Ignition (IGN)
> as the IGN firmware doesn't support the protocol.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/hw-me-regs.h |  1 +
>  drivers/misc/mei/hw-me.c      | 23 ++++++++++++-----------
>  2 files changed, 13 insertions(+), 11 deletions(-)

I see 2 different copies of this patch/email:
	https://lore.kernel.org/all/20220215075748.264195-1-tomas.winkler@intel.com/
	https://lore.kernel.org/all/20220215080438.264876-1-tomas.winkler@intel.com/

which one is right?

confused,

greg k-h
