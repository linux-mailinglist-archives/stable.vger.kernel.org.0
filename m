Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD6525EC48
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 05:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgIFDQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 23:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbgIFDQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Sep 2020 23:16:10 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D36472086A;
        Sun,  6 Sep 2020 03:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599362170;
        bh=c2GrxgrMt3GFp+t7fcfNkZNP4fs5v8VnasxHI628keU=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=U/tLbF9EpGVx6yrd2s+r9tbnFcCGBDhYlqdwomOJsvwKHiLWTy6gmn2lUbciTsGIB
         ukgAkFRxw7s17gcTbsNBCuaUtfd3Tje3Aa+aXTXiGRebMOI1/8M23XNY9FR+iCqxVr
         tt6iFWouDy/2EyQS5ky3dGtkuPK/vHTbsxbFdVxY=
Date:   Sun, 06 Sep 2020 03:16:09 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sami Tolvanen <samitolvanen@google.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 16/28] init: lto: fix PREL32 relocations
In-Reply-To: <20200903203053.3411268-17-samitolvanen@google.com>
References: <20200903203053.3411268-17-samitolvanen@google.com>
Message-Id: <20200906031609.D36472086A@mail.kernel.org>
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
    f51a03c82ca3 ("lib/string.c: implement stpcpy")

v4.14.196: Failed to apply! Possible dependencies:
    458a3bf82df4 ("lib/string: Add strscpy_pad() function")
    f51a03c82ca3 ("lib/string.c: implement stpcpy")

v4.9.235: Failed to apply! Possible dependencies:
    458a3bf82df4 ("lib/string: Add strscpy_pad() function")
    f51a03c82ca3 ("lib/string.c: implement stpcpy")

v4.4.235: Failed to apply! Possible dependencies:
    458a3bf82df4 ("lib/string: Add strscpy_pad() function")
    f51a03c82ca3 ("lib/string.c: implement stpcpy")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
