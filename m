Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF233242EF4
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 21:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgHLTOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 15:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgHLTOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 15:14:38 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98DBC061383;
        Wed, 12 Aug 2020 12:14:37 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id z14so3506782ljm.1;
        Wed, 12 Aug 2020 12:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=tYFf59hA9v+jMzuapZ0MlLUMVG9vOUbRt2fp4Brw40A=;
        b=VCIfzsH+uCHsKlZRNHmr1W3grdz/j0GxKXLKQF0Bj+PTue4HBBvlFy9Fa0NfoVEBMf
         mRbNnLIIuQhlUlceVmz1Hw4l5puMLGo0z6yZ9J6RaNigMk/fsFc3g+rUtx/MwBKT9MZt
         ReYEgMQ67q9KYLMHvK/3D3QNIUDDJvrkwyMUKTS/hE36MWWzbw94vdKfcdS5z1T5bGIV
         qQ+k6nvOictNYh5rWywIz5hMBKo+xZBjppID8lgAAvXhUjMLnheOp6depw9cF0eh7TXr
         26j9DcNdNvFV8jWSmS3Mt0DmnYRKq+pVpSX7VrWtBSDxIMymcbOc+2I0DiKqCrrXwFSC
         4xog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=tYFf59hA9v+jMzuapZ0MlLUMVG9vOUbRt2fp4Brw40A=;
        b=IRAe87nE98eANkCEBRgqDrJbaDT9YO0jNpaB8BsAL7Nk5v+Nu4gL9f88ezC4KuwOMg
         jByq5HfHtwkdXpeqIe1jeDaFs8LcBwHKJJiEdMCX2PquljA0bbJ2vZo+w9kyPalEtM03
         EUnH05HewQdSUdkG5z2e6ypIDX29H3xN8xUgzRkzLgxV5DniCRT5v0S7TS9Zqy2njjYK
         MJ55MjE7Wu/cYRr1twtNV7o6/Xfd+snVQZIZIbAQL7Qrjk7/nfqMTIzRPK4uF+QXDzKP
         MyvGIGMIGTFgXQUWaa12TQ+3oasl/1wGn3anU6gsX2TD0wEsbz2gWFIRAw+sIWqLUznV
         Y/jA==
X-Gm-Message-State: AOAM532gzOe8FiAPkkrXv1tyI0L+nWXC7EkoXRyo7WJLa2KxwUQg55M5
        NLFhqyFDG65cAAaJBg73PG0=
X-Google-Smtp-Source: ABdhPJypq/7BRfReIxcwzBms77PIV8Tf9CfaRzMDGjw4q5DavOE4FVKVMp2HzV0HjGdchXmV+q7jTg==
X-Received: by 2002:a2e:b619:: with SMTP id r25mr353668ljn.220.1597259676032;
        Wed, 12 Aug 2020 12:14:36 -0700 (PDT)
Received: from [192.168.2.145] (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.googlemail.com with ESMTPSA id j17sm668713lfr.32.2020.08.12.12.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 12:14:35 -0700 (PDT)
To:     Stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Erik Faye-Lund <kusmabite@gmail.com>,
        Mark Brown <broonie@kernel.org>
From:   Dmitry Osipenko <digetx@gmail.com>
Subject: Request to pick up couple NVIDIA Tegra ASoC patches into 5.7 kernel
Cc:     "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        alsa-devel@alsa-project.org
Message-ID: <2db6e1ef-5cea-d479-8a7a-8f336313cb1d@gmail.com>
Date:   Wed, 12 Aug 2020 22:14:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, stable-kernel maintainers!

Could you please cherry-pick these commits into the v5.7.x kernel?

commit 0de6db30ef79b391cedd749801a49c485d2daf4b
Author: Sowjanya Komatineni <skomatineni@nvidia.com>
Date:   Mon Jan 13 23:24:17 2020 -0800

    ASoC: tegra: Use device managed resource APIs to get the clock

commit 1e4e0bf136aa4b4aa59c1e6af19844bd6d807794
Author: Sowjanya Komatineni <skomatineni@nvidia.com>
Date:   Mon Jan 13 23:24:23 2020 -0800

    ASoC: tegra: Add audio mclk parent configuration

commit ff5d18cb04f4ecccbcf05b7f83ab6df2a0d95c16
Author: Sowjanya Komatineni <skomatineni@nvidia.com>
Date:   Mon Jan 13 23:24:24 2020 -0800

    ASoC: tegra: Enable audio mclk during tegra_asoc_utils_init()

It will fix a huge warnings splat during of kernel boot on NVIDIA Tegra
SoCs. For some reason these patches haven't made into 5.7 when it was
released and several people complained about the warnings. Thanks in
advance!
