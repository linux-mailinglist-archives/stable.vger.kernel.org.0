Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B18E61312B
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJaHX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiJaHX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:23:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEABE299;
        Mon, 31 Oct 2022 00:23:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B18261003;
        Mon, 31 Oct 2022 07:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79924C433C1;
        Mon, 31 Oct 2022 07:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667201035;
        bh=/l+bnPa+QpO2aKJ1A1iRYqzj0CbaaJY5jam4oQUCoSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uRkFDgMKqIQ4lED1kKnYIKCcFBuVk1Zi0YPILaM1iY5qbtHyYN3ri3myorYz7IcQu
         wvMWiZgVCgHAxcJVbOmuFF9ZVhve3VJ3O04Luq6l+RPJsNhrG1WDS5CUO5xHA4svuj
         G5WWNLvDlTguUdrqyOBSaCZSE9cZyQu5ymYMZNgY=
Date:   Mon, 31 Oct 2022 08:24:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Sasha Levin <sashal@kernel.org>,
        Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= 
        <marmarek@invisiblethingslab.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/3] Stable backports of gntdev fixes
Message-ID: <Y194Q9lH3ye4jJOU@kroah.com>
References: <20221030071243.1580-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221030071243.1580-1-demi@invisiblethingslab.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 30, 2022 at 03:12:40AM -0400, Demi Marie Obenour wrote:
> I backported the recent gntdev patches to stable branches before 5.15.
> The first patch is a prerequisite for the other backports.  The second
> patch should apply cleanly to all stable branches, but the third only
> applies to 5.10 as it requires mmu_interval_notifier_insert_locked().

Patches 1 and 2 now queued up, see my comments on 3.

thanks,

greg k-h
