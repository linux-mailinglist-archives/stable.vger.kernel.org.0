Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5EF0175EA4
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 16:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgCBPoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 10:44:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:33690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgCBPoQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 10:44:16 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D869F21D56;
        Mon,  2 Mar 2020 15:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583163856;
        bh=LN1RQWc8RpwciBFPczlzKo3MGBV/kh9Vl+67Fn3oi34=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=lfL5rB8inaBro71qAg38OsI/ZwmcdXiH4W/kIBlxAaGn2GU4IGoeokAax3ikTXpfl
         vpxJ2gFaPwlE4Im1Jwm4bYvCDGHmwg/lqEhMeIZf0iFO8yoZ0RpF3PIC/on2kdpgpU
         6mStsfCfHC/rIj/qWR5JDEOR7tcT7Xti6xZnBDd0=
Date:   Mon, 02 Mar 2020 15:44:15 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Paul Boddie <paul@boddie.org.uk>
Cc:     devicetree@vger.kernel.org, linux-mips@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5 3/5] MIPS: DTS: CI20: fix interrupt for pcf8563 RTC
In-Reply-To: <32910df46c8723097830e002a13580904ac74a65.1583005548.git.hns@goldelico.com>
References: <32910df46c8723097830e002a13580904ac74a65.1583005548.git.hns@goldelico.com>
Message-Id: <20200302154415.D869F21D56@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 73f2b940474d ("MIPS: CI20: DTS: Add I2C nodes").

The bot has tested the following trees: v5.5.7.

v5.5.7: Failed to apply! Possible dependencies:
    5314215430e5 ("MIPS: DTS: CI20: fix PMU definitions for ACT8600")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
