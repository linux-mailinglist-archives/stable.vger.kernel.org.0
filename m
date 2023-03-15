Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF2E6BA9A1
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 08:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCOHpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 03:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbjCOHo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 03:44:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B1F38B75
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 00:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B784AB81C9E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3219C433D2;
        Wed, 15 Mar 2023 07:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678866287;
        bh=xUQLV8QTbrANlaeXoWWdZ68XK0XbhZS0R73kYeldLo0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hN3cYxIKw2LjplwVwKjnqeG87by26uoN27pxC/Dwrl3u7uvKuwYapv/TwSSCk2BsS
         DuQqEeij1Xq2VqMcWHB3aVnt0ZOhfD+8cDc9SXvGNoFuSYOS4Kbw0KPZ513Xe/aJhx
         oKMALLQ+p6W/M/twmps1z0mV/QYr1dKxAYb5nezw=
Date:   Wed, 15 Mar 2023 08:44:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexander.deucher@amd.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org
Subject: Re: [PATCH 0/2] DCN 3.2 display fixes
Message-ID: <ZBF3bFOZHyJjav+7@kroah.com>
References: <20230314174140.505833-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314174140.505833-1-alexander.deucher@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 14, 2023 at 01:41:38PM -0400, Alex Deucher wrote:
> Hi Greg, Sasha,
> 
> A couple of patches from 6.3 to fix corrupted display issues on
> DCN3.2-based GPUs in stable.

Now queued up, thanks.

greg k-h
