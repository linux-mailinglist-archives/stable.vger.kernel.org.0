Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E946957EF4A
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 15:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbiGWNv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 09:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiGWNv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 09:51:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D535012AB1
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 06:51:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 703E2611F6
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 13:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F073C341C0;
        Sat, 23 Jul 2022 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658584317;
        bh=WE/hNninK4gle9krgqFlbm9zBJWrBudPmdCsi5w41Oo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n47AgbNA1od9CLZvGIjTF95Q43g7koGuoBILpBfFrVWLgo+FQQEpElRx+Jrya+Fn+
         VHjtktY39tMYqCidWvgD8vcevi09A+SEV3iu6DCZnnarUsYmPcJYTdJDfnwoxbkm1w
         TJzShwEA6byhjo2pXBAXURY3on3UrlEQ0lwBKvT8=
Date:   Sat, 23 Jul 2022 15:51:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     stable@vger.kernel.org, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com, ranjani.sridharan@linux.intel.com
Subject: Re: [PATCH 1/3] ASoC: SOF: pm: add explicit behavior for ACPI S1 and
 S2
Message-ID: <Ytv8+le11KvvVdzW@kroah.com>
References: <20220711155719.104952-1-pierre-louis.bossart@linux.intel.com>
 <20220711155719.104952-2-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711155719.104952-2-pierre-louis.bossart@linux.intel.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 10:57:17AM -0500, Pierre-Louis Bossart wrote:
> commit 6639990dbb25257eeb3df4d03e38e7d26c2484ab upstream.

This is not a commit in Linus's tree :(

