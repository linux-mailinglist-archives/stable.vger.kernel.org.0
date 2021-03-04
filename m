Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4471932DBD3
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 22:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239731AbhCDVbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 16:31:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239763AbhCDVbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 16:31:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D25A964FE1;
        Thu,  4 Mar 2021 21:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614893444;
        bh=uxC+OSAfuVYvvoWdm7rpwbwHMidZTVl9vdI9BVGO684=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T8gCX3lAdL+4kW2yZ5dn3RhaT/dylZXzW/zlmhcTGeAz/jK9QfpTRaqM7EbOeW+ZQ
         aEBDOy5hl2d2D+YqB+Sv9KKVPM9n7nC6Wxa3NuSOy4H2SpVFJxLHYBJtYHgkWzgyOJ
         DgFZJoDtj+RVacV1jweKKhgtY+Uh+sgBCFYijZZq2uNCJYWOuvyAok6FgzSrLE726p
         FXUWM2c5mgtpsu/xXqDz4kOkspE0BTb71l/w4Ej07guBzRgDq4xhE3rsjJIxrR673t
         67Wx2Bupbq2NUV+Z/aPVTSD4v2zuHR1ACidW1MHS1KUaYZJ1UiU2fGlDkDtAjAxj3g
         V5gzxrYEyBsFQ==
Date:   Thu, 4 Mar 2021 16:30:42 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        linux-clk@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 26/52] clk: qcom: gdsc: Implement
 NO_RET_PERIPH flag
Message-ID: <YEFRgsJr4qwxbpTO@sashalap>
References: <20210302115534.61800-1-sashal@kernel.org>
 <20210302115534.61800-26-sashal@kernel.org>
 <161472614572.1254594.7093847798808554286@swboyd.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <161472614572.1254594.7093847798808554286@swboyd.mtv.corp.google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 03:02:25PM -0800, Stephen Boyd wrote:
>Quoting Sasha Levin (2021-03-02 03:55:07)
>> From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
>>
>> [ Upstream commit 785c02eb35009a4be6dbc68f4f7d916e90b7177d ]
>>
>> In some rare occasions, we want to only set the RETAIN_MEM bit, but
>> not the RETAIN_PERIPH one: this is seen on at least SDM630/636/660's
>> GPU-GX GDSC, where unsetting and setting back the RETAIN_PERIPH bit
>> will generate chaos and panics during GPU suspend time (mainly, the
>> chaos is unaligned access).
>>
>> For this reason, introduce a new NO_RET_PERIPH flag to the GDSC
>> driver to address this corner case.
>
>Is there a patch that's going to use this in stable trees? On its own
>this patch doesn't make sense to backport.

Right, I'll also grab a59c16c80bd7 ("clk: qcom: gpucc-msm8998: Add
resets, cxc, fix flags on gpu_gx_gdsc") for 5.10 and 5.11. Thanks!

-- 
Thanks,
Sasha
