Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD82C4058DA
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 16:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240804AbhIIOUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 10:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238789AbhIIOUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 10:20:43 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D71C028BF4;
        Thu,  9 Sep 2021 05:45:49 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id h16so3445580lfk.10;
        Thu, 09 Sep 2021 05:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gPbmP5OYCk3pZuf75KqV5gSYDzljR3Z2Mm9WPnd4Bk4=;
        b=mOwcyAdjD6ycDn1sjpwVp4EgAvANh85SbnkohQwhEbeJaW7A+Fz5GKSMFnHtJrouNe
         p44Zj/D9JVKGBYVhVQ+rnBCfbx8EDNo2/VAVNH0DRlyhiTLC10qDe6vqWlUQwTEWGqXs
         86Mn46JNLdTZzmY6+ogR2CNh58AMdntTAbBApv3S+Fnf/oaB3nKHt3o9Dm0Uh0dFXC/j
         nkzZ5TXXgqoCjSOWaK/GHcGhvefYjZZqFMlggeKHtlR7lbzSvhNUMdn1Zmx+go6zuts2
         WuH5x0A6q92yEOX5fPrjZxWdFTgPewLdf0KmCYf78MIJDpGiCJkEnQjaRfsahoSKzFNc
         gU4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gPbmP5OYCk3pZuf75KqV5gSYDzljR3Z2Mm9WPnd4Bk4=;
        b=wpKzWOSaRNgFZb37G4Vjk5kegGI3HAuC9th3u7VCwNsThHA7umPDzk0PsldEtKMoib
         ZKAvyNlESUpC8AxSHXibzu51XXhxRekEuZV1w7nvStJAToNDxyoP36liMhA48q9+/lv5
         4OpG6zIJrCO8zcbnWB5H6yCBYz24X7Xtx/8kVq+MitexzHXF7IWVAKOZJV3jEt9FdZ6N
         fzoNth6r1Ttzz99x0f6hxnGL6HAQpgP+3gj7fTk4iQeMOSZ7IwHXpBPTfWFmXHJRfTBq
         hyDKo3LDR5118FE/cQvDRwP1pORxUu14gr34WzXQuHQvj65S6t6Isruj2pdQCVbCVO/v
         vMtw==
X-Gm-Message-State: AOAM531J1p04pBPospK4oT5OPA/e3IaZJTZt/ufAkmwZN/wk8kaaV5Z7
        fWOZqajneKpitybRfcUTlcOBFHLsejw=
X-Google-Smtp-Source: ABdhPJxN40TrAFfGyOSxHMPCwsTC56MX5CalN8xiR+3NYIq0lPYpwdHR2nPTVBg1/plZdVwCkMf2rQ==
X-Received: by 2002:ac2:5923:: with SMTP id v3mr2173632lfi.459.1631191547269;
        Thu, 09 Sep 2021 05:45:47 -0700 (PDT)
Received: from [192.168.2.145] (46-138-3-129.dynamic.spd-mgts.ru. [46.138.3.129])
        by smtp.googlemail.com with ESMTPSA id d24sm193710ljj.8.2021.09.09.05.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 05:45:46 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.14 133/252] spi: tegra20-slink: Improve runtime
 PM usage
To:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-tegra@vger.kernel.org
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-133-sashal@kernel.org>
 <20210909123751.GA5176@sirena.org.uk>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <f75c5c9c-8430-f650-5d0a-3490ac6aa3de@gmail.com>
Date:   Thu, 9 Sep 2021 15:45:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210909123751.GA5176@sirena.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

09.09.2021 15:37, Mark Brown пишет:
> On Thu, Sep 09, 2021 at 07:39:07AM -0400, Sasha Levin wrote:
>> From: Dmitry Osipenko <digetx@gmail.com>
>>
>> [ Upstream commit e4bb903fda0e9bbafa1338dcd2ee5e4d3ccc50da ]
>>
>> The Tegra SPI driver supports runtime PM, which controls the clock
>> enable state, but the clk is also enabled separately from the RPM
>> at the driver probe time, and thus, stays always on. Fix it.
>>
>> Runtime PM now is always available on Tegra, hence there is no need to
>> check the RPM presence in the driver anymore. Remove these checks.
> 
> This feels new featureish to me - it'll give you runtime PM where
> previously there was none.
> 

Apparently all patches which have a word 'fix' in commit message are
auto-selected. I agree that it's better not to port this patch.
