Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C0A6D1353
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 01:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjC3XdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 19:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbjC3XdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 19:33:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4277AB5
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 16:33:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E81AB82A90
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 23:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37E7C433EF;
        Thu, 30 Mar 2023 23:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680219182;
        bh=4bFV6B2aLlNy2GeFsrhVevoxwGDd7o0P5F6REco4ges=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RoPuReSjEv9WlLbgOGPIGAwmm2KBJ7rA+KgLYjvyMqK6oUtYpPHBR24gFU43PTdkp
         r8bwjFJtnE6HK83ERwx/BDFoonPamiYem0dMBUzMbN+JFpdDnwN0KPlvqEyg8LSML3
         wZzIRhWYHAF9ni4YZPXqQ+iDnDtaDzrKCXmlpZBgOn8CBfGQuFC3PNNa6MWJ8DWhR0
         Q+qU22eVu3htjf3P0eRL8v36sGAtf6Qz50063P3DRTcvXn4Stip/j47uM//MP0pERY
         laE2klv5/osVw5fFP7scizU+F2bO8m4iR+6KO/Ch7pU/z5EHHdLUTxX+12ijHDsxDq
         Jt6QODSlyjfEQ==
Date:   Thu, 30 Mar 2023 19:33:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nobel Barakat <nobelbarakat@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: 5.10 Backport Request: ovl: fail on invalid uid/gid mapping at
 copy up
Message-ID: <ZCYcLCfRwemynhS2@sashalap>
References: <CANZXNgMFifsEAUjCOtQWwxbZRbSvEYZz_Bwc4zrU6esb3xYRLA@mail.gmail.com>
 <CANZXNgPgFwPSgz1-bE-CfTu1bgPgjKQVw8d8SqydVZe61J_41g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANZXNgPgFwPSgz1-bE-CfTu1bgPgjKQVw8d8SqydVZe61J_41g@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 04:01:24PM -0700, Nobel Barakat wrote:
>Sorry please ignore this, didn't realize the commit that introduced
>this issue landed on 5.11.

Could you share your config? We're not seeing an issue on our end.

-- 
Thanks,
Sasha
