Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CAA5B46D2
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 16:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIJOek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 10:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiIJOeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 10:34:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE984A112
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 07:34:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84DC8B80A0C
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 14:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DA4C433D7;
        Sat, 10 Sep 2022 14:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662820461;
        bh=aO7oX5p5tztXusnTywUsf69vFNbyvsBkyBxvMiLHmZs=;
        h=Date:From:To:Cc:Subject:From;
        b=ViWA6FiyQe6t8L50SnQzXykmb+hbxQqrZ93mJ+ivyquPgphtEo/25K0tUBE2CjghA
         PdGQkBZ8feSetyhq7ua7d7plSx6j9dbq3ZdUs9XpbWpGpR9T/cDudHUiGuASBuwwnE
         vLfAwNP6yjLyJ6Fza3JlmrhpoOkVmZK+b4iI+3+ZG/NhN6fZN94QCPP3zD8z8kL4Pa
         YUlvk7YojXSo12G9g8A6oveNXXctmb37kUjrdnJrApCBV0h43ylsFJLHzm1WdyPhif
         nCf23fPrRchPnjF7dhKLr0cyR5E9xf22atfRLLWUbiGsmHNXB0a3Pgx/AMHtTcOZgZ
         P7gFeNeVm9gcA==
Date:   Sat, 10 Sep 2022 07:34:19 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, llvm@lists.linux.dev
Subject: Apply 5c5c2baad2b55cc0a4b190266889959642298f79 to 5.10+
Message-ID: <Yxyga8k1jee5A9Vs@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Sasha,

Please apply commit 5c5c2baad2b5 ("ASoC: mchp-spdiftx: Fix clang
-Wbitfield-constant-conversion") to 5.10 and newer, as it fixes a
warning with tip of tree LLVM. There will be a minor conflict that can
be resolved by taking commit 403fcb5118a0 ("ASoC: mchp-spdiftx: remove
references to mchp_i2s_caps") before it, which seems reasonable to me.
If that is not acceptable, I can send a backport with just 5c5c2baad2b5.

Cheers,
Nathan
