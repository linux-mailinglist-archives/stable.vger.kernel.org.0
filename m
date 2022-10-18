Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7521B601FC9
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiJRAnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiJRAn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:43:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE2F8C035;
        Mon, 17 Oct 2022 17:43:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 421B561309;
        Tue, 18 Oct 2022 00:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5C7C433D7;
        Tue, 18 Oct 2022 00:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666053762;
        bh=PtTBX06+sIhYe4mIj5jxbfuCUPYJn/Ws/HT8oxx7W84=;
        h=Date:From:To:Cc:Subject:From;
        b=u6DhPRt5HslIqJkeG4NWpR8ycerpkPykFOOQgawgbxNlqapmltzR3VRRLf0cJ2dtC
         f/V+B+8mmArC5BAXEqs9fv1l9nyMvWijCCU35+3HzdKmQD/668oZWhAc7U45CD+s0h
         zM/ryNmAmfqy1Y+Up+KGHg2QIfpTBJQBihthKxQcnx8ZDHiJo37vdBtlJlT7tFoofY
         vHLmfySWyWbXRs7+cK2aH2PJ/f4x3yIyHvGy8pAxPU8z7RdcHegL17BeT5xfoOS8BY
         qdoupzEFshHD2ewsn3DtQ6OPf0I6Rk+nerwbFJxN/lXobHo3+QyuvvHJpW6q+79LLj
         L0cK+32hx36BA==
Date:   Mon, 17 Oct 2022 17:42:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org
Subject: Please don't backport "fscrypt: stop using keyrings subsystem for
 fscrypt_master_key" to stable until it's ready
Message-ID: <Y032gHb9LHSYtVBH@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

Please stop backporting my commits to stable without asking, especially without
Cc'ing to any mailing list that is archived on lore.kernel.org.

"fscrypt: stop using keyrings subsystem for fscrypt_master_key" is a big change,
and there's already a fix for it pending
(https://lore.kernel.org/r/20221011213838.209879-1-ebiggers@kernel.org).  I've
been planning on doing the backports myself once the change has had a bit more
time to soak, which is why I intentionally didn't add Cc stable.

It appears you also backported several other commits just to get it apply
cleanly to 5.10, so please drop those too for now.

- Eric
