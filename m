Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27174FD004
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350497AbiDLGlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349901AbiDLGkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:40:21 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1513377D5;
        Mon, 11 Apr 2022 23:35:38 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Kcwvr710jz4xNl;
        Tue, 12 Apr 2022 16:35:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1649745337;
        bh=KOPW0YoznaEOZ4lHn5MCkotY+XFXHkyZcvx9GTXAcm0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Nd2yL4IAil9l07N83Be0MuQoHG40q8hyQNcyuSclpT9ck/FCYnf69VZYQ4NEYacv4
         BcKfzxbI3pNdPqHbXdt4S2rH354m26hd6KTRRL4fXnERJsBnbEJqFxRhCIYmo/m1JI
         w2C1INiK4P0Ih7STQs/sGI9cAALCuVDm5s7yTVRaXmRaj4VCIHH4VfdyRtFMT87a/y
         V3pL42K3fJ+/QdHfl5G5xHnn8F6YfEC+jR8pTW3ot2Tg8Y6ECQo12hK40uJ2QqS7q4
         mvEGqFT1I8K6vp2mKU5GhtyKsFekrHWuBlnNbvidM2VQoNabqqVVV6TT6Z6uZb9T4y
         4qtCnPitjVZ7A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH AUTOSEL 5.17 40/49] powerpc: Fix virt_addr_valid() for
 64-bit Book3E & 32-bit
In-Reply-To: <20220412004411.349427-40-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
 <20220412004411.349427-40-sashal@kernel.org>
Date:   Tue, 12 Apr 2022 16:35:35 +1000
Message-ID: <87sfqi6c7c.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:
> From: Kefeng Wang <wangkefeng.wang@huawei.com>
>
> [ Upstream commit ffa0b64e3be58519ae472ea29a1a1ad681e32f48 ]
>
> mpe: On 64-bit Book3E vmalloc space starts at 0x8000000000000000.

This cherry-pick is good, but can you also pick up the immediately
following commit:

  1ff5c8e8c835 ("Revert "powerpc: Set max_mapnr correctly"")

For v5.16 and v5.17. Thanks.

cheers
