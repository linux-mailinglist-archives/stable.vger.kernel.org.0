Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87AD86BAAF2
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 09:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjCOIk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 04:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjCOIkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 04:40:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FA26B94F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 01:40:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C34FBB81D91
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 08:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E704FC433D2;
        Wed, 15 Mar 2023 08:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678869649;
        bh=7VqEcMTEaK0oBxw1NUyrtxxEpzsnpInYPfgX5Ah6ZoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SLDMMrNAD4OtvApO4OgS+AlNWUx0bOaiPXP3TcnWEJRXTwH0TiEaw6l88sVkkD4Ak
         oum0sY1e009Mxc5lRZEMp2sRYFA+WevjOdX9VpkGW6P2wxnSdWkC+isAhfpr4uOiDZ
         Gio62lvOfHK0x0lEvJpbG1B/roZVxQ+IJ8wmXQoQ=
Date:   Wed, 15 Mar 2023 09:40:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        "H.J. Lu" <hjl.tools@gmail.com>, Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Ard Biesheuvel <ardb@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nathan Chancellor <nathan@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5.4 v3 0/6] Fix Build ID on arm64 if CONFIG_MODVERSIONS=y
Message-ID: <ZBGEj2/DMA8979Zb@kroah.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 07:06:58PM -0700, Tom Saeger wrote:
> Build ID is missing for arm64 with CONFIG_MODVERSIONS=y using ld >= 2.36
> on 5.4, 5.10, and 5.15

All now queued up, hopefully the builds all work better this time
around.

greg k-h
