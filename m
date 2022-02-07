Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C6D4AB6B0
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 09:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbiBGIWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 03:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241269AbiBGIOe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 03:14:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47AAC043181;
        Mon,  7 Feb 2022 00:14:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7935EB80CAF;
        Mon,  7 Feb 2022 08:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF403C004E1;
        Mon,  7 Feb 2022 08:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644221671;
        bh=BLXainC3o4aEn0YdR91odXDlOiGAVQqi+j0LKRoNEwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1wmSaLz9UlPEYwprWbF8nMw7j8kAVlxfuzLzwlngEZCz0T85gTHLSEwRXKFxDNl+G
         ndQ6n6Un7Hl7hsVE5WANNIBsu8rmGtn35e+oD2Uun/uw1Qy37Oryua2ckRrvUhBVf4
         yGQQohVxAuRbSMn2E6riNtXwHEK36SBL9JK+49CA=
Date:   Mon, 7 Feb 2022 09:14:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     luofei <luofei@unicloud.com>
Cc:     stable@vger.kernel.org, tony.luck@intel.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm, mm/hwpoison: fix unmap kernel 1:1 pages
Message-ID: <YgDU3+KsiaQ54J5N@kroah.com>
References: <20220207075242.830685-1-luofei@unicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207075242.830685-1-luofei@unicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 02:52:42AM -0500, luofei wrote:
> Only unmap the page when the memory error is properly handled
> by calling memory_failure(), not the other way around.
> 
> Fixes: 26f8c38bb466("x86/mm, mm/hwpoison: Don't unconditionally unmap kernel 1:1 pages")

This commit is not in Linus's tree.  Please use the correct commit id.

thanks,

greg k-h
