Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304786C32EB
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 14:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjCUNcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 09:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCUNcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 09:32:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F3626584;
        Tue, 21 Mar 2023 06:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C6FB61BC2;
        Tue, 21 Mar 2023 13:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76778C433EF;
        Tue, 21 Mar 2023 13:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679405536;
        bh=bUettMGzcMjgwJSCScLg1Hb4tZJhPlAkfsegcbCV1zg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uK6kAQEjGNyEdV70dHRdyuAPWpuhDzCRDY0acKas/RqAAf3cx0jQERyMXpfKel6Xz
         nnwixoPMunz9m3xx4CvO76OrYb1A7muptIsGDeD2ITrqetZbiKeWfqR/GBCYl70Qql
         Z9BSOZv1YS1B9f7aqgmvp8TKUdi3z7dScL9H0h2Hx0CCBnN5FfKSE/Cn5UgzvJgLwc
         vbgiM9+BnO921AbSkgze/JCLyOaF2DhRFRiUZZcNxNMma1geYPtEHH3prL3Jf3Rd7t
         5WdqHiYbSL3PBe/mObaT0NyhbFmTPuqr06+eZdd5eB6zqjOOBln0POI+cEIQEZh/9U
         egfj6vzw3LuOA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pec7P-0006O6-Sj; Tue, 21 Mar 2023 14:33:40 +0100
Date:   Tue, 21 Mar 2023 14:33:39 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/meson: fix missing component unbind on bind errors
Message-ID: <ZBmyM6yiDaU/Ql/v@hovoldconsulting.com>
References: <20230306103533.4915-1-johan+linaro@kernel.org>
 <CAFBinCBsC+P=zvh6RF3UKiPnferUYU0QZvZfnn1oS5xWX-65Jw@mail.gmail.com>
 <ZBmtu4klxYwQyN7R@hovoldconsulting.com>
 <35aa4401-8b35-09b5-9d97-59867d1df15c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35aa4401-8b35-09b5-9d97-59867d1df15c@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 02:27:08PM +0100, Neil Armstrong wrote:

> Anyway for this patch, sorry for the delay, but it's looks fine:
> 
> Acked-by: Neil Armstrong <neil.armstrong@linaro.org>

Thanks for reviewing!

Johan
