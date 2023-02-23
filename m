Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48ABD6A056D
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbjBWJzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbjBWJzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:55:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A579553EF1;
        Thu, 23 Feb 2023 01:55:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C10F61638;
        Thu, 23 Feb 2023 09:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBB2C433EF;
        Thu, 23 Feb 2023 09:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677146142;
        bh=6jNYtTBdruuYIQ1Msq7XzYvT2vPLWW4RkHsct7FIAhg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lhXwyf5R/buYCiLzNae3C9JyeO6vcP+U/Vevm1E0LKVE0AKb01fv2cNv8vKpT02l0
         kgkXp04vgF7H7pqsUMiHvnm2i87QwVvTSEZOzZx3djIeQew1z2LQKUZyDFmmd21AJ8
         uU/cIgStWrPzZGNZCvhV0ZYolwkUaMcjTFaKhg6M=
Date:   Thu, 23 Feb 2023 10:55:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [PATCH 5.15 v2 0/5] Fix Build ID on arm64 if CONFIG_MODVERSIONS=y
Message-ID: <Y/c4G34O0B8zqobt@kroah.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 10, 2023 at 01:18:39PM -0700, Tom Saeger wrote:
> Build ID is missing for arm64 with CONFIG_MODVERSIONS=y using ld >= 2.36
> on 5.4, 5.10, and 5.15
> 
> Backport BuildID fixes.

I do not understand why you are applying patches from 6.2 that "fix"
something that is not in this kernel (or the older ones).  Please
document that really well on your next set of submissions.

I've taken the 6.1.y series only and dropped all the others.

thanks,

greg k-h
