Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F171B910A
	for <lists+stable@lfdr.de>; Sun, 26 Apr 2020 17:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgDZPDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 11:03:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgDZPDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Apr 2020 11:03:40 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D166208FE;
        Sun, 26 Apr 2020 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587913420;
        bh=p3Mga8iTwm/dBrCD1R6Ne3Zt3/Mk4u7B8EbWFRU5Lf4=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=s2hOukVstWVsQ+/QU8H8bhLLXlmYxAxonbuK/RSBvE/xIB+iZzR75p/8tUqCvZnUS
         dR9W6nUhlsSqL/W1+o+PzCntj368pMCkQt4mnT7vPvDxoCYb7dqithbk4hdke+HA9j
         JvL6T8mMOwO/1O3pGuxFrXdCeQn9/L8iELbCRo9M=
Date:   Sun, 26 Apr 2020 15:03:39 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
To:     linux-pm@vger.kernel.org, rjw@rjwysocki.net, len.brown@intel.com
Cc:     linux-kernel@vger.kernel.org, ming.lei@redhat.com
Cc:     Bart Van Assche <bvanassche@acm.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] PM: hibernate: Freeze kernel threads in software_resume()
In-Reply-To: <20200424034016.42046-1-decui@microsoft.com>
References: <20200424034016.42046-1-decui@microsoft.com>
Message-Id: <20200426150340.1D166208FE@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.7, v5.4.35, v4.19.118, v4.14.177, v4.9.220, v4.4.220.

v5.6.7: Build OK!
v5.4.35: Build OK!
v4.19.118: Build OK!
v4.14.177: Build OK!
v4.9.220: Build OK!
v4.4.220: Failed to apply! Possible dependencies:
    ea00f4f4f00c ("PM / sleep: make PM notifiers called symmetrically")
    fe12c00d21bb ("PM / hibernate: Introduce test_resume mode for hibernation")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
