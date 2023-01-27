Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2400367DC26
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 03:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbjA0CId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 21:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjA0CI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 21:08:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8038F3C0D;
        Thu, 26 Jan 2023 18:08:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D208F61A04;
        Fri, 27 Jan 2023 02:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DCEC433D2;
        Fri, 27 Jan 2023 02:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674785304;
        bh=gsUOOU4dKX6enFS0koRCREnw4eMO6JjDL/OWg7Yy3XA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QAqy5jd5EMUp7l6VDVuSF55yzKqbFgzEOL6HdOTd2oedyg+YURxbQFxxq1f98mVJ7
         9bM5IQWzY3lhOvaqv2XgMcXMPWEKSkpnNbPeVdlJodY5A5yjUs49raqvacw3gYTx6D
         imiEI+V3BDW9+YQMyEsl0swt7Gw5xBOgepxQHR0hcuStjqPTFvcyZP/x5Ps4vConil
         75N23b4yLdBLKTfVA1cxBMtmowa0N8QWa2czlCay+IxAaMLcmAykkmlhdRokjfs7T5
         5TEc3viEzBUpg4wFVCVvepqLjd0NUJtL4OxeobX4stF9cyqq9trAskFASF+RC8G0KN
         OJnMlSl14ACCA==
Date:   Thu, 26 Jan 2023 21:08:23 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 5.4 fix build id for arm64 with CONFIG_MODVERSIONS 0/6]
Message-ID: <Y9MyFyifBDCrwMuq@sashalap>
References: <cover.1674588616.git.tom.saeger@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cover.1674588616.git.tom.saeger@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 02:14:17PM -0700, Tom Saeger wrote:
>Build ID on arm64 is broken if CONFIG_MODVERSIONS=y
>on 5.4, 5.10, and 5.15
>
>Discussed:
>https://lore.kernel.org/all/3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com/
>https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/

Queued up, hopefully it makes it this time :) Thanks!

-- 
Thanks,
Sasha
