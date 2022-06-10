Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75799546911
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 17:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiFJPJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 11:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiFJPJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 11:09:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16BC47076
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 08:09:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F4DEB8360E
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 15:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3F6C3411D;
        Fri, 10 Jun 2022 15:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654873765;
        bh=HySg0vGnnAQLD0e18prW5Rgfl3/ZycE41BZej6VHnJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZVz5HV+I7kP1DK2r1LYmLQLv/FmWgO+HwEKl5bR8JOLVPQEGmVyoRjwdLjHc0PsqZ
         ubRvEJ1mN6UjMGGDwHD8Q0d/pXC06CKA6Tc7o4HAuO3XY4AEhA9qiXeSG8MtENLXIw
         F9bgV2DFk8BGCPA08uM1vFfqfAEw/1amEm/UCcWQ=
Date:   Fri, 10 Jun 2022 17:09:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     stable@vger.kernel.org, echaudro@redhat.com, i.maximets@ovn.org
Subject: Re: net/sched: act_police: more accurate MTU policing
Message-ID: <YqNeoTphHJV5jRYy@kroah.com>
References: <YqNcHbk0K20+qfxP@dcaratti.users.ipa.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqNcHbk0K20+qfxP@dcaratti.users.ipa.redhat.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 04:58:37PM +0200, Davide Caratti wrote:
> hello,
> 
> Ilya reports bad TCP throughput when GSO packets hit an OVS rule that does
> tc MTU policing. According to his observations [1], the problem is fixed
> by upstream commit 4ddc844eb81d ("net/sched: act_police: more accurate MTU
> policing"). Can we queue this commit for inclusion in stable trees?

Did you test this, and what kernel(s) do you want it applied to?

thanks,

greg k-h
