Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D473D4DB65D
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 17:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351743AbiCPQmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 12:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbiCPQmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 12:42:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471B66CA67;
        Wed, 16 Mar 2022 09:40:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F06F5B81C4E;
        Wed, 16 Mar 2022 16:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2555EC340E9;
        Wed, 16 Mar 2022 16:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647448855;
        bh=Zup3poA3bavvhTcRqI3Ak9LCuwt+HercxiUK+Q87cp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZO08rqhbqtkQU5pJh6w0asmBru02yOv3aida7ya7nzt7wDAkUqEqCzTDsmPB5HYJ/
         TtaHI0+6iEC4lSGjuWlxtxUksAPSiBfHD87dgXr5gf73Qv6DEBzLDWWXZ046kHgg2D
         Bz1AvgdcRMW6ZifgKWKig+PJ3s3AXIg5fqGBbFOIqcYfRcLLQwt41fpJ2sQ4U5criu
         hNUhxAbzoFyB1BU4/Vk7xR5glziv4EaaAOAGjJwVihKHigs1YU0DiOvWX+NApGBQhq
         atjoC0ubD6TK5LZrzS55BmOP6RRkjkvWVFJ3x0CpzwfxsFYQcka4t0KT/r3LDInaTu
         Xn4ttQ7P7awig==
Date:   Wed, 16 Mar 2022 12:40:51 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Mark Brown <broonie@kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.16 12/13] spi: Fix invalid sgs value
Message-ID: <YjITE6eOTyZBNhwI@sashalap>
References: <20220316141354.247750-1-sashal@kernel.org>
 <20220316141354.247750-12-sashal@kernel.org>
 <CAMuHMdVtGb6LCTbDKo9vn=1MmP+RZJTe2=VNTtrNsPa-=1Q6zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMuHMdVtGb6LCTbDKo9vn=1MmP+RZJTe2=VNTtrNsPa-=1Q6zA@mail.gmail.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 05:07:28PM +0100, Geert Uytterhoeven wrote:
>Hi Sasha,
>
>On Wed, Mar 16, 2022 at 3:15 PM Sasha Levin <sashal@kernel.org> wrote:
>> From: Biju Das <biju.das.jz@bp.renesas.com>
>>
>> [ Upstream commit 1a4e53d2fc4f68aa654ad96d13ad042e1a8e8a7d ]
>
>This commit is not 100% correct, cfr.
>https://lore.kernel.org/lkml/CAHk-=wiZnS6n1ROQg3FHd=bcVTHi-sKutKT+toiViQEH47ZACg@mail.gmail.com
>Please postpone backporting until the issue has been resolved.

Will check back in a week, thanks!

-- 
Thanks,
Sasha
