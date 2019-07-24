Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AB172D98
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 13:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfGXL3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 07:29:34 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45376 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbfGXL3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 07:29:34 -0400
Received: by mail-lj1-f193.google.com with SMTP id m23so44077612lje.12;
        Wed, 24 Jul 2019 04:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=28ujsUDRYTGiHQoWOiE7oDtm2ZKyW6ds67/AR1tB5C0=;
        b=M5gMtoA0itRtKd2wtHXfYhVwV5ZvA6LEcHrhp5oda7Cyn1YOO78nDV+YLavLAKiEno
         a/DCzgysJx57P89LWLuPyZ4G4eRF5OTpVbSR06ccL4uJNHZAmvKpUaBcT3XfKMK0nAvX
         DqhQw5bsSYLnV+BJ0Zb91PxHJfV4TwXIa9lDiU8seil20xwBNQzwxHqzvmwdJZyWtqJK
         yJkyuPr4S4KG9b+WBsk888SlooS7q1wSE8DaTNQGuZcH9hVO41VzWH6yKwXHiVog9Djg
         djRX2LAX5mOxQ8rvd+sG1+hXkbg4hSdMBDl6TWTOL6i0JoCu+NVVnh4WbVz0vUcLMqvD
         JYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=28ujsUDRYTGiHQoWOiE7oDtm2ZKyW6ds67/AR1tB5C0=;
        b=EjpKSpMdFjDVokoSn8prswhM+b6QWrXYEQjAEyphZRgneH2sxblt/BUOlNC+Xq8Pae
         KBUqKrx9IirjUcM8CEYm6cNxNRLqXRdenXLVWMpUbLYCM/riBGDk22eBZBscpzMW7E/G
         IO03trKO2wWOrdMWzpX5bN0j2svwXSihLFNjUqXqBESLSrXx19/ksSyMnXwlHiAQZFyR
         EvuDmNJmzEHsE1UPHOeXC1C3283uuHQM/pH4yrUOOHb3OvplBIf4Xt5gJhYLc/GAKmSZ
         vRo9DNdieonDkYWVDSeYoC3qz+h6STpQUs0L7CoVxWPoHXysbEGPQIlaoz0PNPHsZ43R
         fDWg==
X-Gm-Message-State: APjAAAUbQePefysCE66IEeKz58ht6fG/YKSXXkTi+MYOUCeSaiSacbSB
        PR5uoagdD6Y1ZUT5k6ApGXkho6wV
X-Google-Smtp-Source: APXvYqyUmgToDevHLGoMl6YaetUuYHM/g8qZL5bpUTSXO6p9lG58UfclhclSAdZpdn8sd/q1R4siVg==
X-Received: by 2002:a2e:2b01:: with SMTP id q1mr41734898lje.27.1563967771562;
        Wed, 24 Jul 2019 04:29:31 -0700 (PDT)
Received: from [192.168.2.145] (ppp91-78-220-99.pppoe.mtu-net.ru. [91.78.220.99])
        by smtp.googlemail.com with ESMTPSA id h22sm8608824ljj.105.2019.07.24.04.29.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 04:29:30 -0700 (PDT)
Subject: Re: [PATCH v3] drm/tegra: sor: Enable HDA interrupts at plug-in
To:     Jon Hunter <jonathanh@nvidia.com>,
        Viswanath L <viswanathl@nvidia.com>, thierry.reding@gmail.com
Cc:     airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1563885610-27198-1-git-send-email-viswanathl@nvidia.com>
 <0ba35efb-44ec-d56c-b559-59f1daa3e6e4@gmail.com>
 <8b113ad7-07b4-7dfb-e2e5-653514686085@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <341b9177-180c-8fc1-f9cc-27f3b48a8b9c@gmail.com>
Date:   Wed, 24 Jul 2019 14:29:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <8b113ad7-07b4-7dfb-e2e5-653514686085@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

24.07.2019 14:11, Jon Hunter пишет:
> 
> On 24/07/2019 10:27, Dmitry Osipenko wrote:
>> 23.07.2019 15:40, Viswanath L пишет:
>>> HDMI plugout calls runtime suspend, which clears interrupt registers
>>> and causes audio functionality to break on subsequent plug-in; setting
>>> interrupt registers in sor_audio_prepare() solves the issue.
>>>
>>> Signed-off-by: Viswanath L <viswanathl@nvidia.com>
>>
>> Yours signed-off-by always should be the last line of the commit's
>> message because the text below it belongs to a person who applies this
>> patch, Thierry in this case. This is not a big deal at all and Thierry
>> could make a fixup while applying the patch if will deem that as necessary.
>>
>> Secondly, there is no need to add "stable@vger.kernel.org" to the
>> email's recipients because the patch will flow into stable kernel
>> versions from the mainline once it will get applied. That happens based
>> on the stable tag presence, hence it's enough to add the 'Cc' tag to the
>> commit's message in order to get patch backported.
> 
> I believe 'git send-email' automatically does this.

Indeed, completely forgot that I have '--suppress-cc=all' in my git's setup.
