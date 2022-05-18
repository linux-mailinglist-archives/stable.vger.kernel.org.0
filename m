Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D78252BEAD
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 17:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239122AbiEROxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 10:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239127AbiEROxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 10:53:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A8F1BB9B1;
        Wed, 18 May 2022 07:53:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85CD8B820E8;
        Wed, 18 May 2022 14:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A779C385A5;
        Wed, 18 May 2022 14:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652885585;
        bh=lXkoTr4TDp4rM2FOPzDoIAso5d5MafhgaSnp5RZ6Pqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lM5hxpshMP7RblMPCzTsVDDDOvD7Wz/oqSTxTuRkn2CNev/CTz6750vPaU7c9ISr0
         GABrREgltlfpZfoNhWUAHQvQdXL/d7O88WtV7rmfenRpPA1S13mXcmIssnUhSD/lB8
         2CtvNyECxuGcSRdae6YRi0B/GyqcC+CETuDTJVojI6NSl7/JDmcNHA5UY0rrEXQQR5
         D8gmtRp0VHd77jKpNhmdrXCe1+nBdG9wkTxsJE71ZCRbNlm8e7N8B893Xiyzn2R0qR
         eZJmU86uIzytGzDmJCFx7wHfSaqP+Mf2P1MBuA3gHa2rtx2+a40vtZItKRZu8cx0+H
         kG6Wt74RZOkNg==
Date:   Wed, 18 May 2022 17:54:45 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        linux-sgx@vger.kernel.org, stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH] selftests/sgx: add test_encl.elf to TEST_GEN_FILES
Message-ID: <YoUItUEAKpzzwoQr@iki.fi>
References: <20220518031619.1179862-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518031619.1179862-1-jarkko@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 18, 2022 at 06:16:19AM +0300, Jarkko Sakkinen wrote:
> TEST_GEN_FILES contains files that are generated during compilation and are
> required to be included together with the test binaries, e.g. when
> performing:
> 
> make -C tools/testing/selftests install INSTALL_PATH=/some/other/path [*]
> 
> Add test_encl.elf to TEST_GEN_FILES because otherwise the installed test
> binary will fail to run.
> 
> [*] https://docs.kernel.org/dev-tools/kselftest.html
> 
> Cc: stable@vger.kernel.org
> Fixes: 2adcba79e69d ("selftests/x86: Add a selftest for SGX")
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

I found this while trying to create an image with BuldRoot containing
the self-tests:

https://github.com/jarkkojs/buildroot-sgx

On SGX capable machine can be built and run in QEMU as

make sgx_x86_64_defconfig && make && output/image/run.sh

BR, Jarkko
