Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EF9697DBE
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 14:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjBONqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 08:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBONqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 08:46:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A6E9F
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 05:46:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A713FB821FF
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 13:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CFAC433EF;
        Wed, 15 Feb 2023 13:46:03 +0000 (UTC)
Date:   Wed, 15 Feb 2023 13:46:01 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     andreyknvl@gmail.com,
        Qun-wei Lin =?utf-8?B?KOael+e+pOW0tCk=?= 
        <Qun-wei.Lin@mediatek.com>,
        Guangye Yang =?utf-8?B?KOadqOWFieS4mik=?= 
        <guangye.yang@mediatek.com>, linux-mm@kvack.org,
        Chinwen Chang =?utf-8?B?KOW8temMpuaWhyk=?= 
        <chinwen.chang@mediatek.com>, kasan-dev@googlegroups.com,
        ryabinin.a.a@gmail.com, linux-arm-kernel@lists.infradead.org,
        vincenzo.frascino@arm.com, will@kernel.org, eugenis@google.com,
        Kuan-Ying Lee =?utf-8?B?KOadjuWGoOepjik=?= 
        <Kuan-Ying.Lee@mediatek.com>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: Reset KASAN tag in copy_highpage with HW tags only
Message-ID: <Y+ziGQAB3nhVqFY3@arm.com>
References: <20230214015214.747873-1-pcc@google.com>
 <Y+vKyZQVeofdcX4V@arm.com>
 <CAMn1gO4mKL4od8_4+RH9T2C+6+-7=rsdLrSNpghsbMyoVExCjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMn1gO4mKL4od8_4+RH9T2C+6+-7=rsdLrSNpghsbMyoVExCjA@mail.gmail.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 08:44:36PM -0800, Peter Collingbourne wrote:
> On Tue, Feb 14, 2023 at 9:54 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > If yes, I think we should use:
> >
> > Fixes: 20794545c146 ("arm64: kasan: Revert "arm64: mte: reset the page tag in page->flags"")
> > Cc: <stable@vger.kernel.org> # 6.0.x
> 
> I agree with the Fixes tag, but are you sure that 6.0.y is still
> supported as a stable kernel release? kernel.org only lists 6.1, and I
> don't see any updates to Greg's linux-6.0.y branch since January 12.

Yeah, that doesn't matter. I normally generate this with a git alias and
it matches the release containing the commit. I don't have to think
about which stable kernels are still maintained.

> I'm having some email trouble at the moment so I can't send a v2, so
> please feel free to add the Fixes tag yourself.

I can add the fixes tag.

-- 
Catalin
