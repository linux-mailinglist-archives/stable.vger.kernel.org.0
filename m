Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80FA55D6BD
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236191AbiF0RYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 13:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234714AbiF0RYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 13:24:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D621146D
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 10:24:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C92DB8190F
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 17:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71086C3411D;
        Mon, 27 Jun 2022 17:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656350658;
        bh=Qp5OUyu1Rk1MpO0azpgYtpAW/JJG0vHUNKvI+swWApw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lmQGcj1dzqvKp4e3aCpYebBXPQMa4+R5M5+GgwZogAhnx0yJAToOz2eLwVto9m8xC
         cJiQQsuEQaaJ8a2/3buHznMkZiBals0h2fmogS6TZgz7mgxO5c/tfBdf3d4X7DIFzU
         gLFUdH5cQhR5YieURvH9Lp0toIc07WQW8s+9xGjRAJmixT72WzVP4Kqq1JefAeA4Mq
         4202gveoHfmLB95LgWWtVSkVdHp70oyopLq6ScaxEwG1j+MQnco1SN04n74yNLNrBU
         ch49t1TbvJk/Cw8bioB0YjDxGOEMobdEjrDE60BhOrTCOPrWEUU2u4I/4ONEdL2v82
         Rj0F/8gR2wsDw==
Date:   Mon, 27 Jun 2022 19:24:08 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     cyphar@cyphar.com, hch@lst.de, sforshee@digitalocean.com,
        viro@zeniv.linux.org.uk, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] fs: account for group membership" failed
 to apply to 5.15-stable tree
Message-ID: <20220627172408.h5zfvcksmd5ftnst@wittgenstein>
References: <165571901496212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <165571901496212@kroah.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 11:56:54AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Hm, I just tried on top of v5.15.50:

git cherry-pick -S 168f912893407a5acb798a4a5

and it applied cleanly. Can you try and backport this again, please?
Or tell me how to reproduce the failure you're seeing so I can fix it
and give you an applicable version?

Thanks!
Christian
