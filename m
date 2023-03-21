Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888EB6C2B90
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 08:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCUHnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 03:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjCUHnG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 03:43:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634B13A85C;
        Tue, 21 Mar 2023 00:42:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A6DFB8122F;
        Tue, 21 Mar 2023 07:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B3AC433D2;
        Tue, 21 Mar 2023 07:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679384552;
        bh=cBz2SBKHl0D4/lc0rKksK7HR04Woi+o3Zyt6TOb45CA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n3Y09zJsRWXicikVO+dT52/OvWFowSBgOfB1MCKndoAR+jCBaaUJKH1jkV6ehcvJZ
         Fqbc5tRXaKypcbfgXHEHtLK16Em6UugW/GFGoGFHN74z4F0INySmYKt44nMCdUUBSY
         hu0OaDMW3P9N8TiYxPs8QB7lIKsoyd1Pp3f67dHk=
Date:   Tue, 21 Mar 2023 08:42:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Bowler <nbowler@draconx.ca>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John.C.Harrison@intel.com, regressions@lists.linux.dev
Subject: Re: PROBLEM: Linux 5.4.237 i915 driver crashes on boot (-longterm
 regression)
Message-ID: <ZBlf5RhMUCuM9LRD@kroah.com>
References: <CADyTPEyZCY1cnPsqcbMrgOZejtyHHSdZ=EStouKKBc8YKFrnkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyTPEyZCY1cnPsqcbMrgOZejtyHHSdZ=EStouKKBc8YKFrnkg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 01:36:05AM -0400, Nick Bowler wrote:
> Hi,
> 
> Linux 5.4.237 crashes immediately on my machine every time when the i915
> driver is loaded, with an error like the one below.  Previous versions are OK.
> 
> I bisected it to commit 1aed78cfda7f ("drm/i915: Don't use BAR mappings
> for ring buffers with LLC").  I can revert this on top of 5.4.237 and
> this seems sufficient to make the machine boot and work again.
> 
> Let me know if you need any more info.

This should be fixed in the 5.4.238-rc1 release that is out for testing
right now, if not, please let me know.

thanks,

greg k-h
