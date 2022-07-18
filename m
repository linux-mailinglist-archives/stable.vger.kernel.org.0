Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8AA578518
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 16:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbiGROOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 10:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235900AbiGROOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 10:14:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DFFDEBE
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 07:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 146ED60905
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 14:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9688C341C0;
        Mon, 18 Jul 2022 14:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658153656;
        bh=Uv1l168PZ0pHZCcO1tP0RPj3ZX4BnkOurWAGBOFRbJA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uiynFAOqzgpkHK5PRHWHXPSKCn8F9ktLw/aCzNwTxbnXUaaGIyKNLOT8Z33SmrxGJ
         L8R0FH3EyOMPQvqWw+onqfJLHqvhmaBy+v1V7umXb/hIx7BZXdwZTopjQ6vGF6z9zG
         YiI1IG91PJErxY/ldOsWZHO837VAkO/qZP3Qc3jI=
Date:   Mon, 18 Jul 2022 16:14:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fabio Porcedda <fabio.porcedda@gmail.com>
Cc:     stable@vger.kernel.org, Fabio Porcedda <Fabio.Porcedda@telit.com>
Subject: Re: [PATCH 0/2] Backport support for Telit FN980 v1 and FN990 for
 3.18
Message-ID: <YtVqtV9UFBaofP/k@kroah.com>
References: <20220718121335.386097-1-Fabio.Porcedda@telit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718121335.386097-1-Fabio.Porcedda@telit.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 18, 2022 at 02:13:33PM +0200, Fabio Porcedda wrote:
> Hi,
> these two patches are the backport for 3.18.y of the following commits:

3.18.y is long end-of-life, what about all of the newer kernels on the
front page of www.kernel.org that we currently support?

thanks,

greg k-h
