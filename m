Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B096AA874
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 07:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCDGqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 01:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCDGqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 01:46:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A013B1A678;
        Fri,  3 Mar 2023 22:46:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 258B860C16;
        Sat,  4 Mar 2023 06:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A1BC4339C;
        Sat,  4 Mar 2023 06:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677912369;
        bh=luuUmF31JLBAn14SDtDxN5t4wt1kEB0qUtWNkvD36tI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JdcTdmZ9vvThlQTzfhs3J+Xays4UKXMEMfB+Fej3iahsZCaTboHLC++qCyIzVwJew
         4fdnJWQbPTuquBHruP+vnXE8KXAeWXYklvDCZQX0m7QVePlw41nerOOiXgo5DK2VRs
         0c/cWtFfxfpu6rwAPuSzzHR4kqWbE9Apshl2mNP8=
Date:   Sat, 4 Mar 2023 07:46:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Wheeler <stable@lists.ewheeler.net>
Cc:     stable@vger.kernel.org, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: Re: [CHERRY-PICK] bcache: fixes that missed a Cc:
 stable@vger.kernel.org
Message-ID: <ZALpL/xVJHFwuCIL@kroah.com>
References: <81201ca-5263-1b20-8e21-8c88edb552c9@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81201ca-5263-1b20-8e21-8c88edb552c9@ewheeler.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 03, 2023 at 01:26:53PM -0800, Eric Wheeler wrote:
> Dear stable tree maintainers: 
> 
> Please pick the following commits that should be pulled into stable but 
> missed the `Cc` tag to make it happen automatically.
> 
> I have checked with Coly, the bcache maintainer, and he agrees that they 
> should go into stable:
> 
> 
> d55f7cb2e5c0 bcache: fix error info in register_bcache()
> 7b1002f7cfe5 bcache: fixup bcache_dev_sectors_dirty_add() multithreaded CPU false sharing
> a1a2d8f0162b bcache: avoid unnecessary soft lockup in kworker update_writeback_rate()
> 
> # NOTICE: These two depend on each other, so apply both or neither!
> 0259d4498ba4 bcache: move calc_cached_dev_sectors to proper place on backing device detach
> aa97f6cdb7e9 bcache: fix NULL pointer reference in cached_dev_detach_finish

What stable tree(s) should these all go to?

thanks,

greg k-h
