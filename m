Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5F4500BB0
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 12:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiDNK7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 06:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242085AbiDNK7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 06:59:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFDC75E58
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 03:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFA0D60B57
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 10:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2E1C385A5;
        Thu, 14 Apr 2022 10:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649933840;
        bh=JM6d77b3QacQ+wYu6xypSKdDQHRM8d7LyVrcS/atry0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vUA7AJbsf8ldfPCPo8ynm3A7cGWgE7hDymKzOXRVfUHEbftWk1LBROZl86UxsqrOu
         GPYdWdFjLw3NHn5uNcxX0MH/KCFADIEiV0F4JvOrBA+rmbhEcH7a8JN27lCjS8Zrjp
         ekK6m6AwkyqK3jLlA9jOXW1X7sY0K45X6sZ53EDA=
Date:   Thu, 14 Apr 2022 12:57:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Gong, Richard" <Richard.Gong@amd.com>
Subject: Re: Allow playing dead in C3 for 5.15.y
Message-ID: <Ylf+DcjOorOMYnkN@kroah.com>
References: <BL1PR12MB5157E3D352FB769DB61E2D0DE2ED9@BL1PR12MB5157.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB5157E3D352FB769DB61E2D0DE2ED9@BL1PR12MB5157.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 10:15:37PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> A change went into 5.17 to allow CPUs to play dead in the C3 state which fixed freezes on s2idle entry if a CPU is offlined by a user.
> This has had some time to bake now, and a regression was identified on an ancient machine that is now fixed.
> 
> Can you please backport these commits to 5.15.y to fix that problem and avoid the regression?
> commit d6b88ce2eb9d2698eb24451eb92c0a1649b17bb1 ("ACPI: processor idle: Allow playing dead in C3 state")

Now queued up.

> commit 0f00b1b00a44bf3b5e905dabfde2d51c490678ad ("ACPI: processor: idle: fix lockup regression on 32-bit ThinkPad T40").

There is no such commit in Linus's tree :(

thanks,

greg k-h
