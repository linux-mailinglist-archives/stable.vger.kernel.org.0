Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFB15F8D48
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 20:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJISp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 14:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiJISp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 14:45:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB29A29375
        for <stable@vger.kernel.org>; Sun,  9 Oct 2022 11:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0C439CE0E30
        for <stable@vger.kernel.org>; Sun,  9 Oct 2022 18:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AF5C433C1;
        Sun,  9 Oct 2022 18:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665341122;
        bh=46DykRjklIQ+pY7738qCfgZPjPfFZdL+ezi0W1mU8es=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A6C+4Jjrfrp8wz6iG4qtQI5P7Lo8gHHpuDxrKHq4H9Qw+AyydFG2fBy+3Q3IEDTEU
         gwwtomR8KrSjpeCwkLR1uxFXeZVRGCehYQWp54im7X5ZRPN3rxwMboYEnwbkw2FWC0
         RqfLB+n1huOTNoYylOXtULnX1TSXhOhb63EJ306g=
Date:   Sun, 9 Oct 2022 20:45:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH] compiler_attributes.h: move __compiletime_{error|warning}
Message-ID: <Y0MW5Zw9lFKG2NOe@kroah.com>
References: <20221007193436.906-1-bvanassche@acm.org>
 <Y0CBzgaKnW7SYzem@kroah.com>
 <e387f65b-da09-cd0b-fa0d-bc7221243c68@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e387f65b-da09-cd0b-fa0d-bc7221243c68@acm.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 07, 2022 at 12:52:14PM -0700, Bart Van Assche wrote:
> On 10/7/22 12:45, Greg KH wrote:
> > On Fri, Oct 07, 2022 at 12:34:36PM -0700, Bart Van Assche wrote:
> > > From: Nick Desaulniers <ndesaulniers@google.com>
> > > 
> > > commit b83a908498d68fafca931e1276e145b339cac5fb upstream.
> > 
> > This is already in 5.15, what stable kernel tree(s) is this a backport
> > for?
> 
> This is for the linux-5.10.y branch.

Now queued up, thanks.

greg k-h
