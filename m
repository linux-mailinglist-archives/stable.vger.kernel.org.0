Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE6769B962
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 11:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjBRK3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 05:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBRK3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 05:29:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559261ADDF;
        Sat, 18 Feb 2023 02:29:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2D90B8229C;
        Sat, 18 Feb 2023 10:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F353AC433EF;
        Sat, 18 Feb 2023 10:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676716144;
        bh=O4IwxOap0UBh+PYtazDHRSwx5p/lHkdGMqQnaNF2r0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J6Ugpswu6FQ/WOFvTfV1Haylg8I8eVcj5Qgec7ewO/+01s6luHCKua7vJV1bPnzSC
         nNvDsHcbZlGA+AgvGX+kKyT6VKdvMvBR54s4gYB+1mdpW2UeeTicqNXngPk0XrJvzd
         62GbRILHMQamfnElb/0XcMqcH44iQHGzbS16xT0U=
Date:   Sat, 18 Feb 2023 11:29:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Mike Rapoport <rppt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Saravana Kannan <saravanak@google.com>, linux-mm@kvack.org,
        "Kirill A . Shutemov" <kirill.shtuemov@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Rob Herring <robh@kernel.org>, stable@vger.kernel.org,
        kernel-team@android.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15] of: reserved_mem: Have kmemleak ignore dynamically
 allocated reserved mem
Message-ID: <Y/CobZuHXU529cdx@kroah.com>
References: <20230217200731.285514-1-isaacmanjarres@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217200731.285514-1-isaacmanjarres@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 17, 2023 at 12:07:30PM -0800, Isaac J. Manjarres wrote:
> commit ce4d9a1ea35ac5429e822c4106cb2859d5c71f3e upstream.
> 
> Patch series "Fix kmemleak crashes when scanning CMA regions", v2.

Now queued up, thanks.

greg k-h
