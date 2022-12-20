Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD74651AE6
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 07:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiLTGqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 01:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiLTGqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 01:46:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9593CD49;
        Mon, 19 Dec 2022 22:46:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDFD160010;
        Tue, 20 Dec 2022 06:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0A0C433D2;
        Tue, 20 Dec 2022 06:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671518807;
        bh=MynLP3RLBuHiL+yyA+BF3KU3mSMlz5/5TBt7lgAgEuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FWS/CFEKkXqViGSdAlBUFy8m9M+8teUCVVGx68ZguMZnR53ZDGLZWaS0Qdn7AU9fo
         LpZdgTiC50aJZdAXh0KLl1Sswml7Kett5LquMolGT0eUpFyT2ChILIRa7wUblVVVAe
         OYEUh5wWbZ7xWE+jCQ5KrYAykb/Dn0ESbfj2wDRQ=
Date:   Tue, 20 Dec 2022 07:46:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Allen Webb <allenwebb@google.com>
Cc:     "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v9 02/10] rockchip-mailbox: Fix typo
Message-ID: <Y6FaUynXTrYD6OYT@kroah.com>
References: <20221219191855.2010466-1-allenwebb@google.com>
 <20221219204619.2205248-1-allenwebb@google.com>
 <20221219204619.2205248-3-allenwebb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219204619.2205248-3-allenwebb@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 02:46:10PM -0600, Allen Webb wrote:
> A one character difference in the name supplied to MODULE_DEVICE_TABLE
> breaks a future patch set, so fix the typo.
> 
> Cc: stable@vger.kernel.org
> Fixes: f70ed3b5dc8b ("mailbox: rockchip: Add Rockchip mailbox driver")

How has this been an issue since the 4.6 kernel and no one has noticed
it?  Can this code not be built as a module?  If not, then please
explain this.

thanks,

greg k-h
