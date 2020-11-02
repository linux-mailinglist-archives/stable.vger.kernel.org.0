Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6B22A2292
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 01:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgKBAcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 19:32:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:42120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727333AbgKBAcA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 19:32:00 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5151A2145D;
        Mon,  2 Nov 2020 00:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604277120;
        bh=LMf5DNy40pAYENCc/zNKJUlwXLY6XH8b1Qz4LZ5BMZo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z3aN2eaK1dF1WJmQzZjXSqVjRZ0SmJ1h4OVE+Uw3pazhdvgrDA8cclSDeJuh31FZR
         CEeTtx+J+CprzFZdlA3S2GBembJKhy9czFWY7ImYmpAP55dgrHHaNZ6HRJTZ+bpEKC
         MNHiYQUS8x7cqI2JdBiamNPOAxVnc4zNC2RGdFrw=
Date:   Sun, 1 Nov 2020 19:31:59 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Anson Huang <Anson.Huang@nxp.com>
Subject: Re: [PATCH AUTOSEL 5.9 131/147] soc: imx: gpcv2: Use dev_err_probe()
 to simplify error handling
Message-ID: <20201102003159.GE2092@sasha-vm>
References: <20201026234905.1022767-1-sashal@kernel.org>
 <20201026234905.1022767-131-sashal@kernel.org>
 <CAOMZO5CF=KewxQm5jwXuwGDDeB1b_UqF4JZ5GqJpjV7LPR62zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5CF=KewxQm5jwXuwGDDeB1b_UqF4JZ5GqJpjV7LPR62zw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 08:59:34PM -0300, Fabio Estevam wrote:
>Hi Sasha,
>
>On Mon, Oct 26, 2020 at 8:56 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Anson Huang <Anson.Huang@nxp.com>
>>
>> [ Upstream commit b663b798d04fb73f1ad4d54c46582d2fde7a76d6 ]
>>
>> dev_err_probe() can reduce code size, uniform error handling and record the
>> defer probe reason etc., use it to simplify the code.
>>
>> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
>> Reviewed-by: Guido Günther <agx@sigxcpu.org>
>> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Does this qualify for stable since it is just a cleanup and not a bug fix?

Nope, I'm dropping it, thanks!

-- 
Thanks,
Sasha
