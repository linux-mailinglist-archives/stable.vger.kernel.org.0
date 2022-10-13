Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451705FE020
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiJMSEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiJMSDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:03:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD91160EDC;
        Thu, 13 Oct 2022 11:02:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F248BB82022;
        Thu, 13 Oct 2022 17:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97446C433D6;
        Thu, 13 Oct 2022 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665683717;
        bh=nxgfWbmszJW/pcNngF+ADL4BRBz+QPL7HdS6m/seybw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lAn3wQCTC5ZT0cF/8KoWCEfjdzLn+JUQ/CwYKkEDGUA+PfFV3uiswKXpQzXonn2z3
         5DR37REMXazF507SZLlH/Mc2P3QEOeObMwekWxBPPoFOw2ZF7QrvwMuGRK4ygKUeeX
         PEWqPVa6rdWnvfmSbnkvvKc6c8UxQBJQMcV+b5dzIf0hRwYNJ1D7TMTxx3/5g7G+5x
         vm5VpL5SLOYVFSlON/zpefA9E6XWhvyZk0kMjgQCeYi63mR5syokW3krL1faOZB76U
         s3qHr6OAVMEI6Y8xG5QuxTT0dOz+htKq+PqzBAXOiRh2DjpdbsL5pvlFIYcyyaiHEm
         2/3nOD4c2vKEQ==
Date:   Thu, 13 Oct 2022 13:55:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Conor Dooley <conor@kernel.org>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        Daire McNamara <daire.mcnamara@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        mturquette@baylibre.com, sboyd@kernel.org,
        linux-clk@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 20/67] clk: microchip: mpfs: add MSS pll's
 set & round rate
Message-ID: <Y0hRBNz4opKb09Ei@sashalap>
References: <20221013001554.1892206-1-sashal@kernel.org>
 <20221013001554.1892206-20-sashal@kernel.org>
 <93982EAD-5EE5-4096-9AD6-BFA76905F1BB@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <93982EAD-5EE5-4096-9AD6-BFA76905F1BB@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 06:29:03AM +0100, Conor Dooley wrote:
>Not a fix, NAK. Same for 5.19.

Ack

-- 
Thanks,
Sasha
