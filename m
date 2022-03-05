Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB26C4CE509
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 14:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiCENnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 08:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiCENnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 08:43:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD80E2399C4
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 05:42:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E54CB80968
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 13:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970BFC004E1;
        Sat,  5 Mar 2022 13:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646487731;
        bh=TJBAAQO4k+aPVC4LVwFEzp07bmOtzgUK8sDprHjAMvs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tyhvyfqyOl+6hVmP9x+/LM/iYwrmfZzEJHb1CzgpPWzYd+eS1OBAbnlezypucunip
         hmbu+5qJQZxZuvSvOBCk3AL2WyTjukFAIpo849nhiNcJ5jWTPTja3uJ+RX2LsoXZ6g
         C4PC2ixCZoxmEPJkUaR1d+Xy4hpunlqi03gzunp4=
Date:   Sat, 5 Mar 2022 14:42:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/3] ice: Fix not stopping Tx queues for VFs
Message-ID: <YiNormnvQJRMawzn@kroah.com>
References: <20220228205114.3262532-1-jacob.e.keller@intel.com>
 <20220228205114.3262532-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228205114.3262532-2-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 12:51:13PM -0800, Jacob Keller wrote:
> From: Brett Creeley <brett.creeley@intel.com>
> 
> commit b385cca47363316c6d9a74ae9db407bbc281f815 upstream.
> 
> [ This commit is already in stable/linux-5.10.y as d83832d4a838 ("ice: Fix
> not stopping Tx queues for VFs"). It's missing from v5.8, v5.9, v5.11, and
> v5.12 ]

That's because all of those branches are end-of-life, can't add new
stuff to them, sorry.

greg k-h
