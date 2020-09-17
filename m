Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACAC26E4A9
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 20:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgIQSya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 14:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbgIQQU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 12:20:29 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0EFF20872;
        Thu, 17 Sep 2020 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600358013;
        bh=pVMSsiVv3gZHXJ9bFe9WkE6WCVOgOWTWH5ktEUexLNs=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=PGMRa17Q4UHIIs02Q3eGuKk/9QM2yp10YqrpHE03Nx0yempsgFjqDcyHdydpRlahx
         VTP5vsEcmWsIIZkDW/wwO6kDqMmM1C+23EE58UOZ6sqq0P9ji8ZcdWb+0/rG8xXbUU
         THO60xlek5hnkNyFx9csrDTBwu4egaZtfdCRIFjg=
Date:   Thu, 17 Sep 2020 15:53:32 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5] lib/string.c: implement stpcpy
In-Reply-To: <20200914161643.938408-1-ndesaulniers@google.com>
References: <20200914161643.938408-1-ndesaulniers@google.com>
Message-Id: <20200917155332.E0EFF20872@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.9, v5.4.65, v4.19.145, v4.14.198, v4.9.236, v4.4.236.

v5.8.9: Build OK!
v5.4.65: Build OK!
v4.19.145: Failed to apply! Possible dependencies:
    458a3bf82df4 ("lib/string: Add strscpy_pad() function")

v4.14.198: Failed to apply! Possible dependencies:
    458a3bf82df4 ("lib/string: Add strscpy_pad() function")

v4.9.236: Failed to apply! Possible dependencies:
    458a3bf82df4 ("lib/string: Add strscpy_pad() function")

v4.4.236: Failed to apply! Possible dependencies:
    458a3bf82df4 ("lib/string: Add strscpy_pad() function")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
