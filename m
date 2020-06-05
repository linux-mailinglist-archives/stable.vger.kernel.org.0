Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10981EFA1A
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgFEOLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbgFEOK6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:10:58 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1F7A2086A;
        Fri,  5 Jun 2020 14:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366258;
        bh=bwcOqHPdwKm0azdKeMl+I6C0kfcEZX9lWuHKAHqXtXo=;
        h=Date:From:To:To:To:CC:Cc:Subject:In-Reply-To:References:From;
        b=SuvqyscqF4nilAShW2pvIv6GkFCid5QA7Ux6WRR/16JBaxzhVV6s9Ugc/ZFxtkj/U
         +hdwQm9nMGbgwleVa8oQ85wdnbTvS3tNZhq8ltoNpg5N+eSakXl+UQaqJ6eeLVanVJ
         zfcAkMO+Qv1xy9JisXk3GJVk2AKByNlkDP3AgwUM=
Date:   Fri, 05 Jun 2020 14:10:57 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <tiwai@suse.de>
CC:     <linux-integrity@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ima: Directly assign the ima_default_policy pointer to ima_rules
In-Reply-To: <20200603150821.8607-1-roberto.sassu@huawei.com>
References: <20200603150821.8607-1-roberto.sassu@huawei.com>
Message-Id: <20200605141057.D1F7A2086A@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 07f6a79415d7 ("ima: add appraise action keywords and default rules").

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225, v4.4.225.

v5.6.15: Build OK!
v5.4.43: Build OK!
v4.19.125: Build OK!
v4.14.182: Failed to apply! Possible dependencies:
    Unable to calculate

v4.9.225: Failed to apply! Possible dependencies:
    Unable to calculate

v4.4.225: Failed to apply! Possible dependencies:
    38d859f991f3 ("IMA: policy can now be updated multiple times")
    95ee08fa373b ("ima: require signed IMA policy")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
