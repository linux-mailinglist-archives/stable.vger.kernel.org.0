Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014DC52D325
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 14:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbiESMzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 08:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbiESMze (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 08:55:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18861A7E2B
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:55:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0903B8248C
        for <stable@vger.kernel.org>; Thu, 19 May 2022 12:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40587C385AA;
        Thu, 19 May 2022 12:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652964931;
        bh=KXn83IneQsk+4Z2Gs5JkUPHDTmTPTMnSYWPw9o0FG8Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yAeJGw2LQkA7D6Jg8blppf7uQBgRaHS9CyKUL2tC2SBdRvDsUhR8jM4zrasDByX/S
         7pCFsqA8t7DOc/WchI173xo2lGALmO25APkOE0lCypzqXqIrHzlsT4wVP500K78fhu
         4TSN1NShBb9e2CBztSEcuL1LHaLqaFQyfsYuTTBk=
Date:   Thu, 19 May 2022 14:55:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Markus Boehme <markubo@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4 0/2] x86/xen: Make the idle task stacks reliable
Message-ID: <YoY+QFlo6RF9OQYZ@kroah.com>
References: <20220516205439.255114-1-markubo@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516205439.255114-1-markubo@amazon.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 16, 2022 at 10:54:37PM +0200, Markus Boehme wrote:
> Linux v5.7 introduced a couple patches to make walking the stack of the
> idle tasks reliable when Linux runs as a Xen PV guest. Attached are the
> backports for the 5.4 LTS, which are of special interest when using the
> livepatch subsystem.

Now queued up, thanks.

greg k-h
