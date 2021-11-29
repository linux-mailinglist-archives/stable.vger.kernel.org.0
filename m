Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF54460F96
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 08:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240786AbhK2Hwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 02:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240866AbhK2Huy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 02:50:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DF4C061574;
        Sun, 28 Nov 2021 23:47:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F220B80D77;
        Mon, 29 Nov 2021 07:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D011C004E1;
        Mon, 29 Nov 2021 07:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638172054;
        bh=KtAb67LnalHmYppYJg4a+4Vsjh86YMhiNv+w58SdATU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xMAsrXZhSbEiNDC8TVQP2x7jnQWqmAnWuLMErBeYo5q4wgFQIcl5skdtTOgCyQIRV
         KhNrDfqCdAzo6PS6wvEszhFmMgmfg9+A0fWeM3OzFN+V+zFnlzFJDozaU7njVaC2Bv
         nl7FE+ZivpNMQwqmRHO35hNlvMpiT46+Qy2tvoCc=
Date:   Mon, 29 Nov 2021 08:47:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Marcel Holtmann <marcel@holtmann.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Daniel Winkler <danielwinkler@google.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sonnysasaka@chromium.org" <sonnysasaka@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] Bluetooth: add quirk disabling LE Read Transmit
 Power
Message-ID: <YaSFk4uY9bs8kEI3@kroah.com>
References: <52DEDC31-EEB2-4F39-905F-D5E3F2BBD6C0@live.com>
 <8919a36b-e485-500a-2722-529ffa0d2598@leemhuis.info>
 <20211117124717.12352-1-redecorating@protonmail.com>
 <F8D12EA8-4B37-4887-998E-DC0EBE60E730@holtmann.org>
 <40550C00-4EE5-480F-AFD4-A2ACA01F9DBB@live.com>
 <332a19f1-30f0-7058-ac18-c21cf78759bb@leemhuis.info>
 <D9375D91-1062-4265-9DE9-C7CF2B705F3F@live.com>
 <BC534C52-7FCF-4238-8933-C5706F494A11@live.com>
 <YaSCJg+Xkyx8w2M1@kroah.com>
 <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <287DE71A-2BF2-402D-98C8-24A9AEEE55CB@live.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 07:42:39AM +0000, Aditya Garg wrote:
> From: Aditya Garg <gargaditya08@live.com>
> 
> Some devices have a bug causing them to not work if they query LE tx power on startup. Thus we add a 
> quirk in order to not query it and default min/max tx power values to HCI_TX_POWER_INVALID.
> 
> v2: Wrap the changeling at 72 columns, correct email and remove tested by.

These lines are not wrapped at 72 columns :(

Also the changes line goes below the --- line, as documented in the
kernel documentation on how to submit a patch.

thanks,

greg k-h
