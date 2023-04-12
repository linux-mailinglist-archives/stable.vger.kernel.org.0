Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C9D6DEBA6
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 08:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDLGRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 02:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjDLGRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 02:17:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC4D59ED
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 23:17:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB91E62ACE
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 06:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E96EC4339C;
        Wed, 12 Apr 2023 06:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681280229;
        bh=/gil3lglGDF1jvoGYMzb4Ynf340cBS678GTVARi7dMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a6H+7ODTAROuthce5Yj5YdST3JM+T61KsfgZMt/dRXGIu33Ml/Qr3It8s7uu7A5/U
         x1IV8khoDSDur8BSgtpum3096WYvZFfEILr31Iqvz1p4fCMwKH8MgP0WqneMoQxjni
         YCDDO92r4tpsdOQJBlknQMV1O6nJzXC3QuIdTqPA=
Date:   Wed, 12 Apr 2023 08:17:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     sashal@kernel.org, conor@kernel.org, stable@vger.kernel.org,
        llvm@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: Re: [PATCH 5.10 0/4] Backport of e89c2e815e76 to linux-5.10.y
Message-ID: <2023041223-nastily-huntress-cfa2@gregkh>
References: <20230328-riscv-zifencei-zicsr-5-10-v1-0-bccb3e16dc46@kernel.org>
 <20230411162001.GA3308382@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411162001.GA3308382@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 09:20:01AM -0700, Nathan Chancellor wrote:
> Gentle ping, did this get lost?

Nope, just burried under a raft of other proposed backports.  It's still
in my review queue, will get to it eventually...

thanks,

greg k-h
