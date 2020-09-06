Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3D425EC46
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 05:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgIFDQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 23:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbgIFDQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Sep 2020 23:16:08 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFE3320782;
        Sun,  6 Sep 2020 03:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599362168;
        bh=TavqaKuXhxOURmuieWxs+DXRZJ3gL0VF3jO3pOSf4BU=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=e9kkgHn/1gxLMazeIFDm1RyUo+OV6BA36oDx3PeSRnIdMhWAVsvIJyBOKfg2OfyuF
         A3M5YQwPrZJ7bJAvabfO/J1Z6QHvCGIJR0qac/TsZuMMjeE+HwSf/hx5EEV9vZM87S
         s4IEqz12D7upDeSEXTCKPKDLCw25/1eJvh6hDPjo=
Date:   Sun, 06 Sep 2020 03:16:07 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sami Tolvanen <samitolvanen@google.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 03/28] lib/string.c: implement stpcpy
In-Reply-To: <20200903203053.3411268-4-samitolvanen@google.com>
References: <20200903203053.3411268-4-samitolvanen@google.com>
Message-Id: <20200906031607.EFE3320782@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.6, v5.4.62, v4.19.143, v4.14.196, v4.9.235, v4.4.235.

v5.8.6: Build OK!
v5.4.62: Build OK!
v4.19.143: Failed to apply! Possible dependencies:
    458a3bf82df4 ("lib/string: Add strscpy_pad() function")

v4.14.196: Failed to apply! Possible dependencies:
    458a3bf82df4 ("lib/string: Add strscpy_pad() function")

v4.9.235: Failed to apply! Possible dependencies:
    458a3bf82df4 ("lib/string: Add strscpy_pad() function")

v4.4.235: Failed to apply! Possible dependencies:
    458a3bf82df4 ("lib/string: Add strscpy_pad() function")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
