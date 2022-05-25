Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB78533884
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 10:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiEYIcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 04:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiEYIcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 04:32:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E98238A8
        for <stable@vger.kernel.org>; Wed, 25 May 2022 01:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD0D36184D
        for <stable@vger.kernel.org>; Wed, 25 May 2022 08:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF840C385B8;
        Wed, 25 May 2022 08:32:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QIMV8g1z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653467555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lz2KAUBjbjElGiylj9gylrDs6h+qcKumvTIaq10oU1c=;
        b=QIMV8g1zp5yzwG5yM+Gk1o2dm/i6LVr5b+w9/XwhOdSZKZeAL3FVGxhyZg89X41jrSdXOu
        WBKWBV2N08DUtr/hDjeaIy7VQm/WSV+IRi0/rg7kl/oV44kM8/Mz+wN0mxIK1DWtgGz5r4
        6GhV+Ynsrk+WF1utkoNi6dSV6wzdhDc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bf83c0e4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 25 May 2022 08:32:34 +0000 (UTC)
Date:   Wed, 25 May 2022 10:32:26 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: Re: random.c backports for 5.18, 5.17, 5.15, and prior
Message-ID: <Yo3pmh9hiUFtQz77@zx2c4.com>
References: <YouECCoUA6eZEwKf@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YouECCoUA6eZEwKf@zx2c4.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 02:54:45PM +0200, Jason A. Donenfeld wrote:
> Assuming that Linus merges my PR for 5.19 [1] today, all of these
> patches are (or will be in a few hours) in Linus' tree.

This is now done, with [1], so everything should be properly upstream
now.

Jason

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ac2ab99072cce553c78f326ea22d72856f570d88
