Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8AB6403AE
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 10:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbiLBJqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 04:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiLBJqq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 04:46:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAC3638A;
        Fri,  2 Dec 2022 01:46:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A78FFB8211C;
        Fri,  2 Dec 2022 09:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813F5C433D7;
        Fri,  2 Dec 2022 09:46:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="AKWtqlKF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1669974398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EheHaU/FjdrXBCarNx5tWWY2eAZs79C/tTj4LU4xU5w=;
        b=AKWtqlKFT2IKm3ggdrW0xeG3dYA5RzisUH8cTfExlY/ATlZbFBJb22AJXbtdIdpPFfyTdC
        PtSeUuLC2EhHVqbjWFgRElm+CIsdht234RShbPpYLYbBKV1xoh+ufwrEzohNwt9cvaejcL
        3JmwvrlY+d4H6SDuLzBnsM3dTzefmQQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d87882d7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 2 Dec 2022 09:46:38 +0000 (UTC)
Date:   Fri, 2 Dec 2022 10:46:35 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, peterhuewe@gmx.de,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Jan =?utf-8?B?RMSFYnJvxZs=?= <jsd@semihalf.com>,
        linux-integrity@vger.kernel.org, jgg@ziepe.ca,
        gregkh@linuxfoundation.org, arnd@arndb.de, rrangel@chromium.org,
        timvp@google.com, apronin@google.com, mw@semihalf.com,
        upstream@semihalf.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3] char: tpm: Protect tpm_pm_suspend with locks
Message-ID: <Y4nJe+XMoNwTVjlh@zx2c4.com>
References: <20221128195651.322822-1-Jason@zx2c4.com>
 <9793c74f-2dd0-d510-d8b6-b475e34f3587@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9793c74f-2dd0-d510-d8b6-b475e34f3587@leemhuis.info>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for handling this, Thorsten. I had poked Jarkko about this
earlier this week, but he didn't respond. So I'm glad you're on the case
now getting this in somewhere. Probably this should make it to rc8, so
there's still one week left of testing it.

Jason
