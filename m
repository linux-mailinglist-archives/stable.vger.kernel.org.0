Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33EB6BAA69
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 09:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCOIGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 04:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjCOIGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 04:06:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA4C22113;
        Wed, 15 Mar 2023 01:06:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4506761BE6;
        Wed, 15 Mar 2023 08:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FF2C433D2;
        Wed, 15 Mar 2023 08:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678867559;
        bh=QoCkV91dLU3WdHeO9GZXCr4B6ThMlsaAQLPzVTot7m4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fDsPpmTCNSsGF5lsh1aWR5FL/47tgALDQ/WeBflRXG1zeZ/XBvcCVaoDUteBl24U+
         olCp0YVHxDniZLdyI2r4QArAjhy101qk+LrB72cfJBuLXCukakHbxwiFW1FDpMwnRu
         xMzTggI61fQJSKPYhEq5IeazJtcGPA7AXWpssu1w=
Date:   Wed, 15 Mar 2023 09:05:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Wheeler <stable@lists.ewheeler.net>
Cc:     stable@vger.kernel.org, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: Re: [CHERRY-PICK] bcache: fixes that missed a Cc:
 stable@vger.kernel.org
Message-ID: <ZBF8ZcxFggKt6FAq@kroah.com>
References: <81201ca-5263-1b20-8e21-8c88edb552c9@ewheeler.net>
 <ZALpL/xVJHFwuCIL@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZALpL/xVJHFwuCIL@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 04, 2023 at 07:46:07AM +0100, Greg KH wrote:
> On Fri, Mar 03, 2023 at 01:26:53PM -0800, Eric Wheeler wrote:
> > Dear stable tree maintainers: 
> > 
> > Please pick the following commits that should be pulled into stable but 
> > missed the `Cc` tag to make it happen automatically.
> > 
> > I have checked with Coly, the bcache maintainer, and he agrees that they 
> > should go into stable:
> > 
> > 
> > d55f7cb2e5c0 bcache: fix error info in register_bcache()
> > 7b1002f7cfe5 bcache: fixup bcache_dev_sectors_dirty_add() multithreaded CPU false sharing
> > a1a2d8f0162b bcache: avoid unnecessary soft lockup in kworker update_writeback_rate()
> > 
> > # NOTICE: These two depend on each other, so apply both or neither!
> > 0259d4498ba4 bcache: move calc_cached_dev_sectors to proper place on backing device detach
> > aa97f6cdb7e9 bcache: fix NULL pointer reference in cached_dev_detach_finish
> 
> What stable tree(s) should these all go to?

Dropped from my queue due to lack of response :(
