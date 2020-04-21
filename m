Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36AE41B30C7
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgDUT4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgDUT4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 15:56:16 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B38120747;
        Tue, 21 Apr 2020 19:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587498975;
        bh=6x/wFhtn8aM071j72/VXJj4F4EHWZDkKIF9PYyRrkKM=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=0kx5FJf08ZpB3GtSdyjo56633EJ8qs8lNmDQZKMKzwfslo6dmtB+TK27QpvKXxgzn
         LNZkcB75jQQjuwJ9M1CsVcGlJEOiGN7uwGPMmeRopZcKknz0DEcYiXhRV2NGOuBpYf
         u7uNXDIm1L48XJg5XpT7OA+gq+OEd5kxPYAVJE60=
Date:   Tue, 21 Apr 2020 19:56:14 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Malcolm Priestley <tvboxspy@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Cc:     stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: Power save stop wake_up_count wrap around.
In-Reply-To: <fce47bb5-7ca6-7671-5094-5c6107302f2b@gmail.com>
References: <fce47bb5-7ca6-7671-5094-5c6107302f2b@gmail.com>
Message-Id: <20200421195615.0B38120747@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 43c93d9bf5e2 ("staging: vt6656: implement power saving code.").

The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33, v4.19.116, v4.14.176, v4.9.219, v4.4.219.

v5.6.5: Failed to apply! Possible dependencies:
    10e9a359cea7 ("staging: vt6656: Delete int.c/h file and move functions to usbpipe")

v5.5.18: Failed to apply! Possible dependencies:
    10e9a359cea7 ("staging: vt6656: Delete int.c/h file and move functions to usbpipe")

v5.4.33: Failed to apply! Possible dependencies:
    10e9a359cea7 ("staging: vt6656: Delete int.c/h file and move functions to usbpipe")

v4.19.116: Failed to apply! Possible dependencies:
    10e9a359cea7 ("staging: vt6656: Delete int.c/h file and move functions to usbpipe")
    69cc1f925e1a ("staging: vt6656: limit reg output to block size")
    7156f7d9c387 ("staging: vt6656: avoid discarding called function's return code")
    9df8a97088f2 ("staging: vt6656: Fix styling of the comment related to SPDX-License-Identifier")

v4.14.176: Failed to apply! Possible dependencies:
    10e9a359cea7 ("staging: vt6656: Delete int.c/h file and move functions to usbpipe")
    69cc1f925e1a ("staging: vt6656: limit reg output to block size")
    6b4c6ce89204 ("staging: vt6656: add SPDX identifiers to all vt6656 driver files")
    7156f7d9c387 ("staging: vt6656: avoid discarding called function's return code")
    9df8a97088f2 ("staging: vt6656: Fix styling of the comment related to SPDX-License-Identifier")

v4.9.219: Failed to apply! Possible dependencies:
    0ef48913354e ("staging:vt6656:mac.c Aligned code to match open parenthesis")
    10e9a359cea7 ("staging: vt6656: Delete int.c/h file and move functions to usbpipe")
    69cc1f925e1a ("staging: vt6656: limit reg output to block size")
    6b4c6ce89204 ("staging: vt6656: add SPDX identifiers to all vt6656 driver files")
    6ddcf34f113a ("staging: vt6656: Add missing identifier names")
    7156f7d9c387 ("staging: vt6656: avoid discarding called function's return code")
    759fc3c1e9b6 ("Staging: vt6656: Align lines to match open parenthesis")
    812930665872 ("staging: vt6656: Alignment should match open parenthesis")
    9df8a97088f2 ("staging: vt6656: Fix styling of the comment related to SPDX-License-Identifier")
    a4dc9bd6a35d ("staging: vt6656: convert spaces to tabs for rf.c")
    e2aefba617e3 ("staging:vt6656:baseband.h: fix function definition argument without identifier name issue")

v4.4.219: Failed to apply! Possible dependencies:
    10e9a359cea7 ("staging: vt6656: Delete int.c/h file and move functions to usbpipe")
    1322739849a8 ("staging:vt6656:baseband.h: Fix alignment issue")
    555d7a3ada13 ("staging:vt6656:dpc.h:fix parantheses alignment")
    5678824069d5 ("staging: vt6656: Add space to align functions")
    69cc1f925e1a ("staging: vt6656: limit reg output to block size")
    6b4c6ce89204 ("staging: vt6656: add SPDX identifiers to all vt6656 driver files")
    6ddcf34f113a ("staging: vt6656: Add missing identifier names")
    7156f7d9c387 ("staging: vt6656: avoid discarding called function's return code")
    759fc3c1e9b6 ("Staging: vt6656: Align lines to match open parenthesis")
    9df8a97088f2 ("staging: vt6656: Fix styling of the comment related to SPDX-License-Identifier")
    a9f47a456ae5 ("staging:vt6656:card.c:fix alignment checks")
    e2aefba617e3 ("staging:vt6656:baseband.h: fix function definition argument without identifier name issue")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
