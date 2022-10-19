Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D89604497
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiJSMJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbiJSMJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:09:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD12DEF1C
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 04:44:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90313B822B1
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 11:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF45C433C1;
        Wed, 19 Oct 2022 11:43:52 +0000 (UTC)
Date:   Wed, 19 Oct 2022 12:43:48 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Evgenii Stepanov <eugenis@google.com>
Cc:     stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: backport of arm64: mte: move register initialization to C
Message-ID: <Y0/i9FPtzJ1HmA2N@arm.com>
References: <CAFKCwrhcszDEzW8S2Y_aCZW2o5H6S=Z-Ao1ASpzPw3ZOm9UAtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFKCwrhcszDEzW8S2Y_aCZW2o5H6S=Z-Ao1ASpzPw3ZOm9UAtw@mail.gmail.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 18, 2022 at 03:33:08PM -0700, Evgenii Stepanov wrote:
> please backport the following commits to 5.15-stable:
> 
> commit 973b9e37330656dec719ede508e4dc40e5c2d80c upstream.
> 
> Please note that the extra backport below can be avoided with a
> trivial change in the above patch. Let me know if that's preferable.
> 
> Cc: <stable@vger.kernel.org> # 5.15.y: e921da6: arm64/mm: Consolidate TCR_EL1 fields
> Signed-off-by: Evgenii Stepanov <eugenis@google.com>

If cherry-picking commit e921da6 is sufficient for the backport, I'd go
with that. Note that I haven't tried, does it work for both 5.15 and
5.10?

-- 
Catalin
