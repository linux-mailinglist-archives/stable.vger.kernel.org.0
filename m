Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94ACE52121D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 12:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiEJK1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 06:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiEJK1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 06:27:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A96C56C3E
        for <stable@vger.kernel.org>; Tue, 10 May 2022 03:23:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AAB661740
        for <stable@vger.kernel.org>; Tue, 10 May 2022 10:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A56C385A6;
        Tue, 10 May 2022 10:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652178236;
        bh=Evq1DHaUXC8q9+hVKUV1U5BlKjr2D7yXx2r8u+1+djc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BlbxK8iRcDGPqEDl+5Pv3n8yHgLfejjV7reGGOlmczKB6/RtU8F9sd8ok5rf5hRIX
         jN1gyGOQIaC8VopiQRQ9JPdjuQFSjJrmZ/pbtePuozOKYj4B5cilBISRZt4CR4mhDD
         u+VovqIgMpYPAB5lEDBciAtYX1i2ySlNk2VMHnIc=
Date:   Tue, 10 May 2022 12:23:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dexter Rivera <riverade@google.com>
Cc:     stable@vger.kernel.org, trond.myklebust@hammerspace.com
Subject: Re: Request to cherry-pick f00432063db1 to 5.10+
Message-ID: <Yno9OGUFttP304Ip@kroah.com>
References: <CAG5dfppH0s-ujBjXyJJ62mGiJRiKz1NOYBPYOx3A1550Z8X7Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG5dfppH0s-ujBjXyJJ62mGiJRiKz1NOYBPYOx3A1550Z8X7Mg@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 09, 2022 at 03:47:02PM -0700, Dexter Rivera wrote:
> Hello all,
> 
> Commit f00432063db1a0db484e85193eccc6845435b80e upstream ("SUNRPC:
> Ensure we flush any closed sockets before xs_xprt_free()") fixes
> CVE-2022-28893. Looking to cherry-pick this fix to versions 5.10+.

Can you provide a working set of backported patches for this for 5.10.y?
A clean cherry-pick does not work as it needs the dependant patches also
to be applied, right?

How did you test this without those also applied?

thanks,

greg k-h
