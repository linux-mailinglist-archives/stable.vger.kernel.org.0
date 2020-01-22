Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 962F614569A
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbgAVN2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:28:02 -0500
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:41954 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731953AbgAVN2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 08:28:00 -0500
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id C4B243C04C1;
        Wed, 22 Jan 2020 14:27:58 +0100 (CET)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id x3LQ2mdH3c4V; Wed, 22 Jan 2020 14:27:53 +0100 (CET)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id A14D13C00C5;
        Wed, 22 Jan 2020 14:27:53 +0100 (CET)
Received: from lxhi-065.adit-jv.com (10.72.93.66) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.468.0; Wed, 22 Jan
 2020 14:27:53 +0100
Date:   Wed, 22 Jan 2020 14:27:50 +0100
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        <stable@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: Re: [PATCH v2] arm64: kbuild: remove compressed images on 'make
 ARCH=arm64 (dist)clean'
Message-ID: <20200122132750.GA16142@lxhi-065.adit-jv.com>
References: <20200121155439.1061-1-erosca@de.adit-jv.com>
 <20200122022626.797B324677@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200122022626.797B324677@mail.kernel.org>
X-Originating-IP: [10.72.93.66]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Wed, Jan 22, 2020 at 02:26:25AM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 0723c05fb75e ("arm64: enable more compressed Image formats").
> 
> The bot has tested the following trees: v5.4.13, v4.19.97, v4.14.166, v4.9.210, v4.4.210.
> 
> v5.4.13: Build OK!
> v4.19.97: Build OK!
> v4.14.166: Build OK!
> v4.9.210: Build OK!
> v4.4.210: Failed to apply! Possible dependencies:
>     f8fa70f392fa ("arm64: localise Image objcopy flags")

The heuristics of your scripts is correct.

Upon picking f8fa70f392fa ("arm64: localise Image objcopy flags")
first, the backporting conflict of ("arm64: kbuild: remove compressed
images on 'make ARCH=arm64 (dist)clean'") is avoided.

> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Shared my thoughts above. Any other input needed?

-- 
Best Regards
Eugeniu Rosca
