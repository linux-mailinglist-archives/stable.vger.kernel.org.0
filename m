Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C13C1E1876
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 02:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388099AbgEZAYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 20:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbgEZAX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 20:23:59 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E1D320706;
        Tue, 26 May 2020 00:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590452639;
        bh=VDqLLYFDc89OwvbOIZrUyqJZnyXAdGRPNrDdUCgdOtg=;
        h=Date:From:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Lh+eCp7Uhr2hhs63F+M0w8+N0t8+FUevnCYdQaW7tMhCGdmH0hdYvFqnQcUo8/R/6
         IGs1wiXVBKBS3DyrCFoKeV7uOMHWXOwESmRm1lgTKUPI3L7NsPdTp0xy1bfw39b/m8
         QZZtrkleqo09fk1jTeHjB17Htn/KGuCSarjyVOvU=
Date:   Tue, 26 May 2020 00:23:58 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [RFC] power: supply: bq27xxx_battery: Fix polling interval after re-bind
In-Reply-To: <20200525113220.369-1-krzk@kernel.org>
References: <20200525113220.369-1-krzk@kernel.org>
Message-Id: <20200526002359.0E1D320706@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00 driver").

The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181, v4.9.224, v4.4.224.

v5.6.14: Build OK!
v5.4.42: Build OK!
v4.19.124: Build OK!
v4.14.181: Build OK!
v4.9.224: Build OK!
v4.4.224: Failed to apply! Possible dependencies:
    Unable to calculate


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
