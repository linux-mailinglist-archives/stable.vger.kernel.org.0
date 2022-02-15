Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54A14B70BD
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239233AbiBOOti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 09:49:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239329AbiBOOt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 09:49:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263641133CC
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 06:46:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D62CDB81AA0
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 14:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384ECC340EB;
        Tue, 15 Feb 2022 14:46:30 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Mark Rutland <mark.rutland@arm.com>,
        Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] arm64: Correct wrong label in macro __init_el2_gicv3
Date:   Tue, 15 Feb 2022 14:46:27 +0000
Message-Id: <164493638366.551200.3943571066450302522.b4-ty@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220214175643.21931-1-joakim.tjernlund@infinera.com>
References: <20220214175643.21931-1-joakim.tjernlund@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 18:56:43 +0100, Joakim Tjernlund wrote:
> In commit:
> 
>   114945d84a30a5fe ("arm64: Fix labels in el2_setup macros")
> 
> We renamed a label from '1' to '.Lskip_gicv3_\@', but failed to update
> a branch to it, which now targets a later label also called '1'.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: Correct wrong label in macro __init_el2_gicv3
      https://git.kernel.org/arm64/c/4f6de676d94e

-- 
Catalin

