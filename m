Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2D84FAF08
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 18:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243668AbiDJQoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 12:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238184AbiDJQoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 12:44:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E264B841;
        Sun, 10 Apr 2022 09:42:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8FAFB80E18;
        Sun, 10 Apr 2022 16:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326A2C385BB;
        Sun, 10 Apr 2022 16:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649608921;
        bh=01McTTLBX/RzXMJb16VibZQqPQGnBa6CpsLcFull0FE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ij509aT4VHMEslbHqIP9u1UZVsFJjf+yJDNAiDFuek0LIFlF+QCvXw4SMLiR6qOkq
         YYbq5Nme7To3cov2yvKCEGdlRM6yT0o3J8U+1EnkWiqHF8QrL7HtjSun793aoKa2W5
         XZPTMs9lY5D8XLJKgN39yLvyKbNkufygnx/n9KnO2aKchCzaH5RP3sLclffVNMfQif
         eGao9Ck0QAxaT5FlRB9ez5pJBqHZdsgSKZLePPbP551t8zwPuS85KRclEDBXWcCMg1
         tmoUXK4Bn8IyKds7MfdDWHY8NWbXbyXyeM/xIPTeuBskGFTkEbyCs0i56029Nx9O7U
         d7h/Y3LZhulyA==
Date:   Sun, 10 Apr 2022 17:49:52 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     Gwendal Grignou <gwendal@chromium.org>, robh+dt@kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 1/8] iio: sx9324: Fix default precharge internal
 resistance register
Message-ID: <20220410174952.6660e013@jic23-huawei>
In-Reply-To: <CAE-0n532f37UD8OyiFc0_ROzgc24Hb=aOYN+ALgruiehiNTfuQ@mail.gmail.com>
References: <20220406165011.10202-1-gwendal@chromium.org>
        <20220406165011.10202-2-gwendal@chromium.org>
        <CAE-0n532f37UD8OyiFc0_ROzgc24Hb=aOYN+ALgruiehiNTfuQ@mail.gmail.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
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

On Wed, 6 Apr 2022 10:14:01 -0700
Stephen Boyd <swboyd@chromium.org> wrote:

> Quoting Gwendal Grignou (2022-04-06 09:50:04)
> > Fix the default value for the register that set the resistance:
> > it has to be 0x10 per datasheet.
> >
> > Fixes: 4c18a890dff8d ("iio:proximity:sx9324: Add SX9324 support")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> > ---  
> 
> Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Applied to the fixes-togreg branch of iio.git.

I'm crossing my fingers that I'll be able to simultaneously
queue this fix and the rest of the series on different branches
without any significant merge problems...

Jonathan

