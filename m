Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2B95F2891
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 08:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJCG0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 02:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJCG0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 02:26:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAF63DF1B
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 23:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 133BD60F45
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 06:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F92C433D6;
        Mon,  3 Oct 2022 06:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664778392;
        bh=vI4sFMjy82LuUCoYnMPiJfiJ2wbeM7qo4nqZFhuSzow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dMhAc1DuZUsz7ani/t1SwmSqCFVXV+8ETCODpmDAxL/HWet6WAxoh1ivshlA+tlxR
         qGPGNfCgtU1Y8AcPMtymFxZQVzvc50zXfF3cw3A3UXZxVX4HxytZ87sv2IzRNpQUws
         yGztWk5R644SbJvFDMt5tRvOk/fyLPnwIyLCnWUA=
Date:   Mon, 3 Oct 2022 08:27:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Cc:     stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 5.15] drm/i915/gem: Really move i915_gem_context.link
 under ref protection
Message-ID: <YzqAvzqtYriFi2Cy@kroah.com>
References: <20220928152051.267360-1-janusz.krzysztofik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928152051.267360-1-janusz.krzysztofik@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 28, 2022 at 05:20:51PM +0200, Janusz Krzysztofik wrote:
> From: Chris Wilson <chris@chris-wilson.co.uk>
> 
> [ Upstream commit d119888b09bd567e07c6b93a07f175df88857e02 ]

Now queued up, thanks.

greg k-h
