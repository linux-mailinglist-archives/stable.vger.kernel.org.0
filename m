Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3286C1120
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 12:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjCTLrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 07:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjCTLrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 07:47:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CC32200D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 04:47:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3A740CE1271
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 11:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DFEC433D2;
        Mon, 20 Mar 2023 11:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679312848;
        bh=WSsdG+aCRWEdaTpKmbDAnnaxgR2VZMIEWKsynM8+qhA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wP+zJsb1pejyBbriodObmJdprgPPQw9hZwt8vn2ZlPE7IrzT4BUTxst5r4Smn8J4j
         JUSQinLWYXby3/bgqYpivuhBVb/ut54JO5KJ1QIRl+Q2u5T/JIAh8kVF2fPzQRBnEX
         lEpS7yIcaykVjfHyZQTQsB+WcidSAZQjcF8GyOXE=
Date:   Mon, 20 Mar 2023 12:47:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc/boot: Don't always pass
 -mcpu=powerpc when building" failed to apply to 6.1-stable tree
Message-ID: <ZBhHzXH9hgRnTlOd@kroah.com>
References: <1678953691202116@kroah.com>
 <20230317172157.ces5ikgyj3rt2vne@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230317172157.ces5ikgyj3rt2vne@pali>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 17, 2023 at 06:21:57PM +0100, Pali Rohár wrote:
> On Thursday 16 March 2023 09:01:31 gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 6.1-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > To reproduce the conflict and resubmit, you may use the following commands:
> > 
> > git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
> > git checkout FETCH_HEAD
> > git cherry-pick -x ff7c76f66d8bad4e694c264c789249e1d3a8205d
> 
> It applies cleanly for me with above steps.
> 
> > # <resolve conflicts, build, test, etc.>
> > git commit -s
> > git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678953691202116@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..
> > 
> > Possible dependencies:
> > 
> > ff7c76f66d8b ("powerpc/boot: Don't always pass -mcpu=powerpc when building 32-bit uImage")
> 
> Probably you are missing fix for CONFIG_TARGET_CPU_BOOL as mentioned
> previously. Commit is:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=45f7091aac3546ef8112bf62836650ca0bbf0b79

Ok, will try that out now, thanks!

greg k-h
