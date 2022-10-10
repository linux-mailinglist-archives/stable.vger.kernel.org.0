Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6B65F9860
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 08:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiJJGbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 02:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiJJGbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 02:31:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613E35601B
        for <stable@vger.kernel.org>; Sun,  9 Oct 2022 23:31:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F348D60CF6
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 06:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1695CC433D6;
        Mon, 10 Oct 2022 06:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665383465;
        bh=1gAEZbm/nYV26pwT88wNQjXozio6d8FtYqC7faTT4e4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xtvlpuFKBfcePfsDodFg8By0QFWlTPPxCsrkdJb8Lq9n724rLLcHMHm5Hj198A+AE
         GASDbAtdn4tU43xK0TBEIYCy21AmDUVZBNB0Ekdyej8KkvU2k4L+cpzqom+msM8Kdf
         ykG4XYKjnoDhLBAUaX4/TiOEdStkknwALLnlvg3Y=
Date:   Mon, 10 Oct 2022 08:31:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Fix IRQ storm on ASUS UM325UAZ
Message-ID: <Y0O8VPrLS3qt/MlC@kroah.com>
References: <MN0PR12MB610115BC9826AB2E3449D064E2209@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB610115BC9826AB2E3449D064E2209@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 05:12:20AM +0000, Limonciello, Mario wrote:
> [AMD Official Use Only - General]
> 
> Hi,
> 
> ASUS UM325UAZ encounters an IRQ storm at runtime due to a BIOS error by the vendor that they programmed a floating pin as an interrupt source. It's avoided by a workaround to gpiolib-acpi to detect this situation.
> 
> Can you please backport these commits to 5.19.y and 6.0.y:
> 
> 6b6af7bd5718 ("gpiolib: acpi: Add support to ignore programming an interrupt")
> 0ea76c401f92 ("gpiolib: acpi: Add a quirk for Asus UM325UAZ")

Now queued up, thanks.

greg k-h
