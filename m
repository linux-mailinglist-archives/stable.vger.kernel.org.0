Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907D821B7AF
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgGJODJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728449AbgGJODE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 10:03:04 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72DCC2082E;
        Fri, 10 Jul 2020 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594389784;
        bh=PIClI0sFL2uSyFyo6uiNIL8cUhLjKb6+sOqjCYDTVAg=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=eTjjUsY0sgCe9aVrzVIDtVhGdxw7Xd005E9N0tEJwwAGJ0RZLqApWE1xfE8/AUqi8
         6k5JSCawuGRflxK/t/oCaTDgoDHQSLuKmKRoYF/7J3rox5KB8tgv9e9lsDzRDwguJh
         WN9jrO4UiKzwx3HPTkKK44moqnmpG4FCVDxobS7k=
Date:   Fri, 10 Jul 2020 14:03:03 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4/4] intel_th: Fix a NULL dereference when hub driver is not loaded
In-Reply-To: <20200706161339.55468-5-alexander.shishkin@linux.intel.com>
References: <20200706161339.55468-5-alexander.shishkin@linux.intel.com>
Message-Id: <20200710140304.72DCC2082E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 39f4034693b7 ("intel_th: Add driver infrastructure for Intel(R) Trace Hub devices").

The bot has tested the following trees: v5.7.7, v5.4.50, v4.19.131, v4.14.187, v4.9.229, v4.4.229.

v5.7.7: Build OK!
v5.4.50: Build OK!
v4.19.131: Build OK!
v4.14.187: Failed to apply! Possible dependencies:
    c2d2c7de972d7 ("intel_th: Don't touch switch routing in host mode")

v4.9.229: Failed to apply! Possible dependencies:
    c2d2c7de972d7 ("intel_th: Don't touch switch routing in host mode")

v4.4.229: Failed to apply! Possible dependencies:
    c2d2c7de972d7 ("intel_th: Don't touch switch routing in host mode")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
