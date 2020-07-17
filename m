Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DCD224179
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 19:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgGQRIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 13:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgGQRIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jul 2020 13:08:48 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F18AB207DD;
        Fri, 17 Jul 2020 17:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595005728;
        bh=9N8+ZdOzuhLEfauEOtZL3Pz3V8sOdbC0+AJJLcjfRK0=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=HroLxN4wn6+ypr6AYgjTfb75KBNwW7uUYtXK8AMHknmE7eE0v4yjtq7KxlmzOZxN0
         pVgRjoHPVYolEdUAPENqNZwTjXtRi6r38d9d9DaFRGE6Ox5XCHuZ609jpOxYCs5J4m
         RkZMjjOrzJL5xtj/wl0Y/kS/uuacO68PpZdHW2aU=
Date:   Fri, 17 Jul 2020 17:08:47 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Chanwoo Choi <cw00.choi@samsung.com>
To:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     cw00.choi@samsung.com, chanwoo@kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] PM / devfrq: Fix indentaion of devfreq_summary debugfs node
In-Reply-To: <20200713073112.6297-1-cw00.choi@samsung.com>
References: <20200713073112.6297-1-cw00.choi@samsung.com>
Message-Id: <20200717170847.F18AB207DD@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 66d0e797bf09 ("Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"").

The bot has tested the following trees: v5.7.8, v5.4.51, v4.19.132, v4.14.188.

v5.7.8: Build OK!
v5.4.51: Failed to apply! Possible dependencies:
    490a421bc575d ("PM / devfreq: Add debugfs support with devfreq_summary file")

v4.19.132: Failed to apply! Possible dependencies:
    490a421bc575d ("PM / devfreq: Add debugfs support with devfreq_summary file")

v4.14.188: Failed to apply! Possible dependencies:
    490a421bc575d ("PM / devfreq: Add debugfs support with devfreq_summary file")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
