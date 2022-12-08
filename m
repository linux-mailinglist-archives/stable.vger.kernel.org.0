Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D4C64774A
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 21:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiLHU3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 15:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiLHU26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 15:28:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0313984B62
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 12:28:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ED79B825FA
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 20:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A40BC433EF;
        Thu,  8 Dec 2022 20:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670531317;
        bh=YNOFGbmz8iNCO+bgMk2BGUnwwsHQZrug9BMvKFM5chM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z6eIOj6R9KA4SE1Epoi8NoDbHiI99bGjlHh0sMwzMqHn/L8qrsUWV0IJkzDx+5FEG
         mQMVyCQZ/iClmZlG/Cr0/Qr7r2UJ4DVinRGAO9QrrI9GIlGiQsB6js2KUZ6QWLMJ8N
         H1b/AxB0jsJ+YvKMew1zFoCTwEIq09YzAPDJbswg=
Date:   Thu, 8 Dec 2022 21:28:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 4.9] mmc: sdhci: Fix voltage switch delay
Message-ID: <Y5JI8mxAkw9SADW5@kroah.com>
References: <20221207140806.19129-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207140806.19129-1-adrian.hunter@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 07, 2022 at 04:08:06PM +0200, Adrian Hunter wrote:
> commit c981cdfb9925f64a364f13c2b4f98f877308a408 upstream.
> 
> Backport to v4.9 by Adrian to cope with host->lock which was removed
> from sdhci_set_ios() in v4.12. Note dependency on fa0910107a9f.

Now queued up, thanks.

greg k-h
