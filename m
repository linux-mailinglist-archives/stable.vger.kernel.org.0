Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99264EC6FA
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 16:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347140AbiC3Ore (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 10:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347019AbiC3Ore (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 10:47:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B87F237FC8
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 07:45:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13D62B81C4D
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 14:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B156C340EC;
        Wed, 30 Mar 2022 14:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648651545;
        bh=9NH5tU46EkEsae391Fqf1lE2ttz3GpOYfFpSXdJEc98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KkXBBbQGM59pefR9ljnhNmRXIJci5Z/fh3R1uEcc4frBbQZhfnZ2//xHhMHWRzcw4
         BtrUcrY8w33fxPIOlLbnQTCpkm78CKTQRE7JGjdmJVOnp/JUW3l8R0mxYjQS92doLy
         YvOFV+QkpfGh32uBR9ig98iJziVGq5zo7s9SO58c=
Date:   Wed, 30 Mar 2022 16:45:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/2] stddef: Introduce struct_group() helper macro
Message-ID: <YkRtFpMlNUUH2/7/@kroah.com>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
 <YkPgO5dmsl+BQzXC@kroah.com>
 <fc9370b1-274c-00f3-0734-4f1d271b98bf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc9370b1-274c-00f3-0734-4f1d271b98bf@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 07:38:12AM -0700, Tadeusz Struk wrote:
> On 3/29/22 21:44, Greg KH wrote:
> > On Tue, Mar 29, 2022 at 03:02:55PM -0700, Tadeusz Struk wrote:
> > > Please apply this to stable 5.10.y, 5.15.y
> > > ---8<---
> > 
> > Why?  What problem does this infrastructure solve?
> 
> It is required to enable the PATCH 2/2
> ("skbuff: Extract list pointers to silence compiler warnings.")

That wasn't obvious :(
