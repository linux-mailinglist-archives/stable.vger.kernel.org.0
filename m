Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0CE40AF76
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 15:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhINNqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 09:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbhINNqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 09:46:08 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B63AC061574;
        Tue, 14 Sep 2021 06:44:50 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id a4so28939687lfg.8;
        Tue, 14 Sep 2021 06:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LiLFG3jsLAnjnyRijL4uVe0GMRh42AXtUakCNsayxDQ=;
        b=ox3Ob1BWKW9EHiBA6DLTWNQHG6Ri8fNwCj46D8Mn9LQtvLlDjcOQdnELXnRL/Aovpm
         +nT/Eau3mAtAQolDEXBOV1xTdwRNtEoo7g0a1kYcxyxf9lhT1qZE5JgbsR1/OqJiG8o9
         6f3CPWvYdYDwF1Zq9qqkaOMZHzGSFpCDJlZCCi/1T+vn3NJsNsy7OtNp+GRSIQnU2Guy
         +hju6kS3WvmVLnVrrNBK2ssDY+e+/xM7wbmBbtjQJfRlqIESSkPjjlIRa1zqi0fgtV7e
         MxhPJ2MWxpoVvtedazb436UsS1IyVncEA2aJ1nQJFD8T1NomN7QBDlPAURUVgAXJXkYx
         b6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LiLFG3jsLAnjnyRijL4uVe0GMRh42AXtUakCNsayxDQ=;
        b=rLdQ75Ju1E88ncz/Qles0ofr/yasYzYc5okIOGI1Fg8eSrQzSxidyi3iFmdppmmVMy
         FemZjuHfN3RcNyagOxoHjIaAnpWusEFSMotIqrWNzRbmIsV7+eO8FDxE7arVxD4YcwoS
         wLT150x/pPd1maspxRZTq+ZImNW+i8mWmZg/lwswXsM/D5sYoqCODFHdPvQw0DIoFNeB
         AzA9qjbILk7I802fmWFOifFQojWNBVYvhLmbqi9kDngsj8bSewnsbop4BcuiWCBTr1gv
         6boHSPZDlHSYkkvk6CiFxPJYKZY9/khvvMXJvmjr8V5XKWjfkpfNvfAlLLZMkUSMGV4W
         M/Tg==
X-Gm-Message-State: AOAM530CA4XYmbK1QyhFjL3FCoaNeZvcnDZ9QE9+KGUpgxGXq6fuxBu2
        9wtzn7S7kQmBFHJ4LZLYYHaeNi8ShlA=
X-Google-Smtp-Source: ABdhPJxiYS4pffxw5IF8csizK0wbDOGl1IRJGoO7qlkdQqSwq85+R+U51gQaI7oEpxY96waJhJZYzQ==
X-Received: by 2002:ac2:4116:: with SMTP id b22mr13278085lfi.587.1631627088517;
        Tue, 14 Sep 2021 06:44:48 -0700 (PDT)
Received: from [192.168.2.145] (46-138-83-36.dynamic.spd-mgts.ru. [46.138.83.36])
        by smtp.googlemail.com with ESMTPSA id g24sm1350578ljm.6.2021.09.14.06.44.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 06:44:48 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.14 133/252] spi: tegra20-slink: Improve runtime
 PM usage
To:     Sasha Levin <sashal@kernel.org>, Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-tegra@vger.kernel.org
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-133-sashal@kernel.org>
 <20210909123751.GA5176@sirena.org.uk>
 <f75c5c9c-8430-f650-5d0a-3490ac6aa3de@gmail.com>
 <20210909130450.GB5176@sirena.org.uk> <YT+HCdNjfQxQayYH@sashalap>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <b5bf22e8-09bb-4d69-9112-ad4f29e0361a@gmail.com>
Date:   Tue, 14 Sep 2021 16:44:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YT+HCdNjfQxQayYH@sashalap>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

13.09.2021 20:14, Sasha Levin пишет:
> On Thu, Sep 09, 2021 at 02:04:50PM +0100, Mark Brown wrote:
>> On Thu, Sep 09, 2021 at 03:45:45PM +0300, Dmitry Osipenko wrote:
>>> 09.09.2021 15:37, Mark Brown пишет:
>>
>>> > This feels new featureish to me - it'll give you runtime PM where
>>> > previously there was none.
>>
>>> Apparently all patches which have a word 'fix' in commit message are
>>> auto-selected. I agree that it's better not to port this patch.
>>
>> Yeah, it's a fairly common source of false positives :/
> 
> And some of that falls on me: if it's obvious that the "fix" isn't a
> real fix, I won't take it. In cases like this it's not clear to me
> whether it's purely a better behaviour, or whether the devices staying
> on/off/etc causes an actual problem.
> 

You made the right choice. It's indeed not obvious from commit message
what is achieved with this change. This patch shouldn't have any visible
effect on older kernels which don't support power management in a case
of Tegra SoCs. It will have effect using the upcoming kernels, once the
full set of in-progress power management patches will be merged.
