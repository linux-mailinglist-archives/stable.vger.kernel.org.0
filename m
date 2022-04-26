Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650425105EF
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 19:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiDZR4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 13:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiDZR4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 13:56:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA44B11A14;
        Tue, 26 Apr 2022 10:53:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54108B80ECC;
        Tue, 26 Apr 2022 17:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562F3C385A0;
        Tue, 26 Apr 2022 17:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650995579;
        bh=kmZi1cLdIYN2KtLsTq/cOvLBMOfPugUMZg11JTEai0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nTJJwqyiXBBu92cmm6xgE/OzGo2kOeuCuvVZXInraWOow5/RkaJRIqwWrP1hXNlxG
         p79YnJjhgHvL8+glfhuBPrrMwNJFQqfqoJpZdZDEhKqqU6cFgPNcedTC5F3G+0HsdZ
         mskrGLL7g4SttiYU2iIvRAZ9RbUbNCGoDcSSb53U=
Date:   Tue, 26 Apr 2022 19:52:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     john.p.donnelly@oracle.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 5.15 000/124] 5.15.36-rc1 review
Message-ID: <Ymgxd6WGhUBuntkS@kroah.com>
References: <20220426081747.286685339@linuxfoundation.org>
 <09eb98b8-6200-20c2-faa2-ced7f0e4fc95@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09eb98b8-6200-20c2-faa2-ced7f0e4fc95@oracle.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 12:37:21PM -0500, john.p.donnelly@oracle.com wrote:
> 76723ed1fb89 2021-12-01 | locking/rwsem: Make handoff bit handling more
> consistent
> 
> In Linux 5.15.y.

That commit is in 5.15.6, released December 1, 2021.  And this just now
shows up?  How is this related to 5.15.36-rc1?

Please start a new thread with the authors/reviewers of that commit and
we will be glad to discuss it.

thanks,

greg k-h
