Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D9E4CA521
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 13:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241895AbiCBMr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 07:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241892AbiCBMr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 07:47:27 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3ADC1C96;
        Wed,  2 Mar 2022 04:46:44 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K7v4t5npwz4xZ5;
        Wed,  2 Mar 2022 23:46:38 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Anders Roxell <anders.roxell@linaro.org>, mpe@ellerman.id.au
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
In-Reply-To: <20220224162215.3406642-1-anders.roxell@linaro.org>
References: <20220224162215.3406642-1-anders.roxell@linaro.org>
Subject: Re: [PATCHv2 1/3] powerpc: lib: sstep: fix 'sthcx' instruction
Message-Id: <164622491295.2052779.4708365470490989992.b4-ty@ellerman.id.au>
Date:   Wed, 02 Mar 2022 23:41:52 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 24 Feb 2022 17:22:13 +0100, Anders Roxell wrote:
> Looks like there been a copy paste mistake when added the instruction
> 'stbcx' twice and one was probably meant to be 'sthcx'.
> Changing to 'sthcx' from 'stbcx'.
> 
> 

Applied to powerpc/next.

[1/3] powerpc: lib: sstep: fix 'sthcx' instruction
      https://git.kernel.org/powerpc/c/a633cb1edddaa643fadc70abc88f89a408fa834a
[2/3] powerpc: fix build errors
      https://git.kernel.org/powerpc/c/8667d0d64dd1f84fd41b5897fd87fa9113ae05e3
[3/3] powerpc: lib: sstep: fix build errors
      https://git.kernel.org/powerpc/c/8219d31effa7be5dbc7ff915d7970672e028c701

cheers
