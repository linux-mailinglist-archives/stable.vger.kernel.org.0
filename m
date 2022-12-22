Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E7C653BF6
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 07:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiLVGCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 01:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiLVGCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 01:02:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D90A11A1F;
        Wed, 21 Dec 2022 22:02:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA279B81BE5;
        Thu, 22 Dec 2022 06:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECA3C433EF;
        Thu, 22 Dec 2022 06:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671688967;
        bh=QCHeWI4MnQJP8gQWw8/q2WL8k04wCBoAA/xJCgvSvjA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d+DKXZCveXnS9PbpxHTdgO12VikhRSUaT7Zl7CSGPNuKSBT0Zd1lztUG80mX2U9Ad
         yZaY0r5hswR2zXSLrRWmvPFFILubOnMHH+ie/c+uR1Unrg/zX1EqLTSnCJ9z+nk5Ul
         hjiglV2Eb77h3IPD2MvoOdKz6e5ZmkT4SlyRlhIA=
Date:   Thu, 22 Dec 2022 07:02:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ferry Toth <ftoth@exalondelft.nl>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Ferry Toth <fntoth@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/1] Revert "usb: ulpi: defer ulpi_register on
 ulpi_read_id timeout"
Message-ID: <Y6PzBAcx921ogdO/@kroah.com>
References: <20221221201805.19436-1-ftoth@exalondelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221201805.19436-1-ftoth@exalondelft.nl>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 09:18:05PM +0100, Ferry Toth wrote:
> This reverts commit 8a7b31d545d3a15f0e6f5984ae16f0ca4fd76aac.
> 
> This patch results in some qemu test failures, specifically xilinx-zynq-a9
> machine and zynq-zc702 as well as zynq-zed devicetree files, when trying
> to boot from USB drive.
> 
> Fixes: 8a7b31d545d3 ("usb: ulpi: defer ulpi_register on ulpi_read_id timeout")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Cc: stable@vger.kernel.org
> Link: https://lkml.org/lkml/2022/12/20/803

We have no control over lkml.org at all, please always use
lore.kernel.org instead.  Can you fix this up to use that?

thanks,

greg k-h
