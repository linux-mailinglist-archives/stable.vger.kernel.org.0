Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCF066452E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 16:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjAJPpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 10:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbjAJPpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 10:45:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B93F479E6
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 07:45:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29CBA61796
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 15:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7DFC433EF;
        Tue, 10 Jan 2023 15:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673365505;
        bh=MWpwwf6Jttv7s070d5vpzRjU72w4+t41Vf+MhbjwcwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G8rxIFlX/RpmavEmyibOjyCiHE8zZQCrO0gM/0tGLFPIhUhKvSqS3fFpuTwOYfpKC
         lGavCvWqrqRExgkdJJGf2CHqgQNMIaGIs5ulo0+9MpVZ64KseOs0LYQIFuMMhnVq8n
         CCfpZrBV2/Qd0Nz/Khrzl5iYXAmyxZZeIFqPaXJk=
Date:   Tue, 10 Jan 2023 16:45:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.15.y] Revert "ACPI: PM: Add support for upcoming AMD
 uPEP HID AMDI007"
Message-ID: <Y72H/NkTtrjws0aB@kroah.com>
References: <20230105201050.20602-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105201050.20602-1-mario.limonciello@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 05, 2023 at 02:10:50PM -0600, Mario Limonciello wrote:
> A number of AMD based Rembrandt laptops are not working properly in
> suspend/resume.  This has been root caused to be from the BIOS
> implementation not populating code for the AMD GUID in uPEP, but
> instead only the Microsoft one.
> 
> In later kernels this has been fixed by using the Microsoft GUID
> instead.

Now queued up, thanks.

greg k-h
