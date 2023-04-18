Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DF66E5DD3
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 11:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjDRJrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 05:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjDRJrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 05:47:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F52810D9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 02:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC15A62F14
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 09:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FCCC433D2;
        Tue, 18 Apr 2023 09:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681811219;
        bh=/xfbOpyupvbqNz2qsHH+H4MqAraE3d2u1isOY9SKHmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P3RILYSZY608JoNmaCMLCq3EX1vBjdMh2BdTdvWV1/8jsNF/pSexOpgeBD6hAC4Lc
         ZEs0coHWgDhkJTGyypg9riN/4uuSixFWhGw4rnW0edLOS/XO7N+RdHTWvPYWmxhGYR
         kzEsL9VxsDYroMshYRrH2KmTjhcNEDOOTdTUtQBA=
Date:   Tue, 18 Apr 2023 11:46:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     sashal@kernel.org, conor@kernel.org, stable@vger.kernel.org,
        llvm@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: Re: [PATCH 5.10 0/4] Backport of e89c2e815e76 to linux-5.10.y
Message-ID: <2023041847-catalyze-unfailing-ffe6@gregkh>
References: <20230328-riscv-zifencei-zicsr-5-10-v1-0-bccb3e16dc46@kernel.org>
 <20230411162001.GA3308382@dev-arch.thelio-3990X>
 <2023041223-nastily-huntress-cfa2@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023041223-nastily-huntress-cfa2@gregkh>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12, 2023 at 08:17:06AM +0200, Greg KH wrote:
> On Tue, Apr 11, 2023 at 09:20:01AM -0700, Nathan Chancellor wrote:
> > Gentle ping, did this get lost?
> 
> Nope, just burried under a raft of other proposed backports.  It's still
> in my review queue, will get to it eventually...

All now queued up, sorry for the delay.

greg k-h
