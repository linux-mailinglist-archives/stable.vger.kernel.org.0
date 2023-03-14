Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36CD6BA362
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 00:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjCNXKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 19:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjCNXKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 19:10:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A030D37702;
        Tue, 14 Mar 2023 16:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 350CA61A87;
        Tue, 14 Mar 2023 23:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20E87C433A4;
        Tue, 14 Mar 2023 23:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678835421;
        bh=Y0PSkm58IIOZziuW7EzUa97Zrez1ej5mXtPbTp0dJLc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q5xN8aIwFXeW7MGimKYbTxfDB9RfS9bSDiVu7XA1MUDUslUdTFpH/1SLEM623NKnN
         EfoTRLfqzbjLcSkgBhm2/3TsRFj79sI6P0JHaohg3xV7p/0/ObB5hFaftP+9eHCJzu
         DkJVMTAdh8ZcIKzRAO2Euk3JuOK2aMo56PRao7PoedDMQGw9Xfd5VY4vJf6CmxbaL6
         ubo9mvkfVLsyjP9/yC2WxJABGueMCiG3hbCyfgMGOd9CC8L45EcL8gQfNduA2iTQ70
         /gqlpGPb9v1aJ72qQvuIVUP+W20YB6KzV+ufY6kcZbJa81G3UoPvrGQWIITEaxWiWb
         0G19sPzRP+4/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08D05E52507;
        Tue, 14 Mar 2023 23:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND] bluetooth: btbcm: Fix logic error in forming the
 board name.
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167883542103.4543.14888292350332012679.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Mar 2023 23:10:21 +0000
References: <20230224-btbcm-wtf-v1-1-98b56133a5b7@gmail.com>
In-Reply-To: <20230224-btbcm-wtf-v1-1-98b56133a5b7@gmail.com>
To:     Sasha Finkelstein via B4 Relay 
        <devnull+fnkl.kernel.gmail.com@kernel.org>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, fnkl.kernel@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Fri, 10 Mar 2023 11:28:42 +0100 you wrote:
> From: Sasha Finkelstein <fnkl.kernel@gmail.com>
> 
> This patch fixes an incorrect loop exit condition in code that replaces
> '/' symbols in the board name. There might also be a memory corruption
> issue here, but it is unlikely to be a real problem.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sasha Finkelstein <fnkl.kernel@gmail.com>
> 
> [...]

Here is the summary with links:
  - [RESEND] bluetooth: btbcm: Fix logic error in forming the board name.
    https://git.kernel.org/bluetooth/bluetooth-next/c/3629e1ce7721

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


