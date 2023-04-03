Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0D36D4475
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 14:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbjDCMcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 08:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjDCMcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 08:32:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A5D18F8A;
        Mon,  3 Apr 2023 05:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 665D860DCB;
        Mon,  3 Apr 2023 12:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D24C4339B;
        Mon,  3 Apr 2023 12:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680525151;
        bh=ulRUO8fEKtK/fjgnpqilfVtOG7bGfaNe2DcuHFEQvow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MxjHLqvp/wt7HJ/F9QbFK6KWaWwpZFxvvTYu/GSbf6mOMipizMMWyzbcIMGwIXbSa
         PA7vML9GO7CztqywOEP+WeOVjiAAur7/z1zx3mF43VjGkIZfA25ks/voXfgkwZ6fRw
         GnghkpJgKjaJ9I3NBW8afx61VWKSw20ogLBGp8CnntJCNF1plBybvSshB2KSBRDaLN
         OmMX5OfUqoWLkSCzgx4mIJ1TCHA9P7Q3B7wyMnSxvUGhjEkeBvG0p+BwxvTAqoZr9M
         fV1D7wbQGu0wM6NFeTeoWJDD1Arf42feCLn8Czf5ToXR7luCZBD117hs/X5KPQ3Rz5
         GX76CF3Ah8u9Q==
From:   rfoss@kernel.org
To:     Neil Armstrong <neil.armstrong@linaro.org>,
        Francesco Dolcini <francesco@dolcini.it>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        dri-devel@lists.freedesktop.org,
        Adrien Grassein <adrien.grassein@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@gmail.com>
Cc:     Robert Foss <rfoss@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] drm/bridge: lt8912b: Fix DSI Video Mode
Date:   Mon,  3 Apr 2023 14:32:17 +0200
Message-Id: <168052510957.3322285.11626143716583284143.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230330093131.424828-1-francesco@dolcini.it>
References: <20230330093131.424828-1-francesco@dolcini.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Foss <rfoss@kernel.org>

On Thu, 30 Mar 2023 11:31:31 +0200, Francesco Dolcini wrote:
> From: Francesco Dolcini <francesco.dolcini@toradex.com>
> 
> LT8912 DSI port supports only Non-Burst mode video operation with Sync
> Events and continuous clock on clock lane, correct dsi mode flags
> according to that removing MIPI_DSI_MODE_VIDEO_BURST flag.
> 
> 
> [...]

Applied, thanks!

Repo: https://cgit.freedesktop.org/drm/drm-misc/


[1/1] drm/bridge: lt8912b: Fix DSI Video Mode
      commit: f435b7ef3b360d689df2ffa8326352cd07940d92



Rob

