Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8FB4EB9BF
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 06:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242640AbiC3Eqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 00:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236198AbiC3Eqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 00:46:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04D83FBCF
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 21:44:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58F0661535
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF9DC340EC;
        Wed, 30 Mar 2022 04:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648615486;
        bh=ngDrCotDc5v8gYRCTHmQPGu8q9JDZxFli6a5e7WsaC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ei/UDys7tQJGOvhHUSBMFrdglGbR6MTflooFyHWjaOoD7Zp6Jg91RD/wyDMdiK+TT
         FRHo+9U6aZGqH6PZU4vv83X7Nx9o/TuA8rwNwF9bk6Z6zG3sDDOYb2KCbd1XLzQomj
         jtNaxzL2NGeZ750SmBkCdENetwgBSUDmDMqLeJnA=
Date:   Wed, 30 Mar 2022 06:44:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/2] stddef: Introduce struct_group() helper macro
Message-ID: <YkPgO5dmsl+BQzXC@kroah.com>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329220256.72283-1-tadeusz.struk@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 29, 2022 at 03:02:55PM -0700, Tadeusz Struk wrote:
> Please apply this to stable 5.10.y, 5.15.y
> ---8<---

Why?  What problem does this infrastructure solve?

thanks,

greg k-h
