Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA436E6939
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 18:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjDRQTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 12:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjDRQTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 12:19:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106261386A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 09:19:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FAB96364E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 16:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3D3C433EF;
        Tue, 18 Apr 2023 16:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681834772;
        bh=rjCJgj3IuUXB+KMYP0dE2Q1zZouJ/iv0wsSFGHMlwCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pxom4GbEnS2sAH8Qd4YlaSHokC7ntgKttB4AOynP2+JBLVM2ga0OvTSQrRAlhlZSg
         gz2crHvc1fCs4PiHhlI6jNBVtc6v1TkRXP8+c/uN01auvSc0ANazJCMDxW7jTLOpiV
         jRNd2oN79bTYe2k5GqAk5BJEmv03TfhboiaeD5Kun/NPQNH7VhMmV+lGRplI9AisUY
         rRoSi1rFmFJk7SD0gPZ7R8yeScCB3ypApa/S4gqhXIZvV5NE8uG3gn+UpVuRLUwHET
         WGkbvym4wmOvYkDkVR7osavwkJ5F5LJaKBkE9CwkduFzIgi1P9REBUZF8YqD3orvvo
         dsf58a/v9ffhw==
Date:   Tue, 18 Apr 2023 09:19:30 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, conor@kernel.org, stable@vger.kernel.org,
        llvm@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: Re: [PATCH 5.10 0/4] Backport of e89c2e815e76 to linux-5.10.y
Message-ID: <20230418161930.GA4411@dev-arch.thelio-3990X>
References: <20230328-riscv-zifencei-zicsr-5-10-v1-0-bccb3e16dc46@kernel.org>
 <20230411162001.GA3308382@dev-arch.thelio-3990X>
 <2023041223-nastily-huntress-cfa2@gregkh>
 <2023041847-catalyze-unfailing-ffe6@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023041847-catalyze-unfailing-ffe6@gregkh>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 11:46:56AM +0200, Greg KH wrote:
> On Wed, Apr 12, 2023 at 08:17:06AM +0200, Greg KH wrote:
> > On Tue, Apr 11, 2023 at 09:20:01AM -0700, Nathan Chancellor wrote:
> > > Gentle ping, did this get lost?
> > 
> > Nope, just burried under a raft of other proposed backports.  It's still
> > in my review queue, will get to it eventually...
> 
> All now queued up, sorry for the delay.

Thanks a lot, I will take later over never :)

Cheers
Nathan
