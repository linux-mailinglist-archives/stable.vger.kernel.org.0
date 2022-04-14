Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2543500BAB
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 12:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiDNK7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 06:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiDNK7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 06:59:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3875A75E4B
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 03:56:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5BF8B82925
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C92C385A1;
        Thu, 14 Apr 2022 10:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649933800;
        bh=W+NwO+qV3gs4IMjMvMuUni8JYSZTmEpgYEePWKT3vB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i+QjQ8OBtuux1Y0YCcMJGdz4JrUCj+dMB/TsDsFQspz61W9EKja8Y1TSSVVrfDQJu
         lSN9uEu1ZbJU35tLU0PLFcJu1pQbCXUMnBTIoz9IQHY/7o8EKKLwwbsONfrBYZ6Zmr
         1FTPyEg+hff7If8KdJF/kquRv7UUFGYh5qwkaIKA=
Date:   Thu, 14 Apr 2022 12:56:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Fix issues caused by lack of x86 LPI support
Message-ID: <Ylf95jt6GSjbJeO+@kroah.com>
References: <BL1PR12MB515758FA1BFA7C94812B88A3E2ED9@BL1PR12MB5157.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB515758FA1BFA7C94812B88A3E2ED9@BL1PR12MB5157.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 10:09:30PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> There are a variety of x86 systems that advertise LPI support and as part of negotiation with firmware they don't end up using C-states
> in certain circumstances.  This leads to higher runtime power consumption and also failure to enter s2idle. 
> 
> In mainline there have been changes to block that behavior.  Can you please backport these two commits from mainline?
> commit 01f6c7338ce267959975da65d86ba34f44d54220 ("cpuidle: PSCI: Move the `has_lpi` check to the beginning of the function")
> commit eb087f305919ee8169ad65665610313e74260463 ("ACPI: processor idle: Check for architectural support for LPI")
> 
> This should go to 5.15.y and later stable kernels.

Queued for 5.4 and newer kernels.  If you want this backported to older
ones, please provide a working set of patches.

thanks,

greg k-h
