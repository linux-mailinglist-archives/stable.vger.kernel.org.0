Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E00C60E5C5
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiJZQvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbiJZQuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:50:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677476FC54;
        Wed, 26 Oct 2022 09:50:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02DE961FB6;
        Wed, 26 Oct 2022 16:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15A8C433C1;
        Wed, 26 Oct 2022 16:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666803044;
        bh=qpcQS8lczMLHUd7LVCPLR0gc9MBr1RJ7LwTwbdQqorU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NYivzWv40An3zYGcZA0N2zbOs+MLydgMmudeVPoC5ve/LMLH2zOUeULIVtjXt5Xig
         JLIlsYogs26glQvgTfEY4ZWJgt3VA7l8m2gUuqH6Ug4dgdorgU/m1e9DdacEMmAiE1
         J5RlRFrgwlZt0yGt+LgzHeLDs+B1fR7jVeY/RG+o=
Date:   Wed, 26 Oct 2022 18:50:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ionela Voinescu <ionela.voinescu@arm.com>,
        Shreyas K K <quic_shrekk@quicinc.com>,
        Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Reiji Watanabe <reijiw@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH stable 4.9] arm64: errata: Remove AES hwcap for COMPAT
 tasks
Message-ID: <Y1llYbMMb+vIilNs@kroah.com>
References: <20221020230110.1255660-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020230110.1255660-1-f.fainelli@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 20, 2022 at 04:01:05PM -0700, Florian Fainelli wrote:
> From: James Morse <james.morse@arm.com>
> 
> commit 44b3834b2eed595af07021b1c64e6f9bc396398b upstream

All now queued up, thanks.

greg k-h
