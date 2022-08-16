Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF51A59534E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 09:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiHPHEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 03:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiHPHDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 03:03:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C34BFE98
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 19:52:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91A0D60F76
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 02:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3890C433D6;
        Tue, 16 Aug 2022 02:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660618335;
        bh=tNxDjR/jE/3l/K2DS1IhzYoV6SmQdG2EdokCmImhd7E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ke1bGPR6/FieYEqpal1O3aj9D1CUwyckknNqeViQ2wUx6ERqewSI4gm+bWLwg3GlA
         x4nidJqOd2oMdOsUF+g9Zu9wvRSmI1l23f3SkDgsGvPZcHYiYRKf6R42rOY/fUiwZz
         xyGiScmEYQqwjc8sIRZOhM82K5DhHyfKunLHWcV7ObziIaSMQdBPbMfcPkFqfKyzm0
         N4y1FdHjaqkrBZgoOgiw1oIOZywm8F1r4dyHKoJsVpo+InOMCNtrjygypHQ5hHTn2C
         6lQeomPy/WZIch3hpkHjLNHgUKDgaWx26bCplXG8NSOznmaOSw5KK7YoIX2xsisO5S
         oeVEsHXNF8M2w==
Date:   Mon, 15 Aug 2022 19:52:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Iwashima, Kuniyuki" <kuniyu@amazon.co.jp>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wei Wang <weiwan@google.com>, LemmyHuang <hlm3280@163.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH stable 5.4] Revert "tcp: change pingpong threshold to 3"
Message-ID: <20220815195213.2588dfc2@kernel.org>
In-Reply-To: <7C2541FE-1DA9-474A-B887-EF434F8EC53F@amazon.co.jp>
References: <7C2541FE-1DA9-474A-B887-EF434F8EC53F@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Aug 2022 02:36:13 +0000 Iwashima, Kuniyuki wrote:
> > Should we wait for the resolution in the original thread first?
> > 
> > https://lore.kernel.org/all/ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org/  
> 
> Oh, I missed that thread being active.

No worries. It's a strange case but hopefully the test can 
be fixed and that will be it.
