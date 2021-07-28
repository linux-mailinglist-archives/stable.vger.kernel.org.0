Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F82F3D933E
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 18:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhG1Qax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 12:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhG1Qaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 12:30:52 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD492C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 09:30:49 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d8so3306076wrm.4
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 09:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1OFRoqPDhFatbXMraJGltr3pxSt5vz1ZLbbZmTHeBLw=;
        b=em6gpe715hiwCDayT9YcDczRcrpqZeU/oouShLLy45Kn+3MQZKqMPva+Tsh/BGOjDr
         qyCmpSKYVmkHaDrZfwgyD3v8aqDze1PUGm4bVPX3NCNNErtJxLyR2X0/6yoX4nU44FHM
         Yxt2hnCO8DYDbOV/al1eIpJAtu87Og28dvJOoVroH2px2ombEwkZujKYzhOZ3EkoJneE
         vHK7pkMsYpIwmLz8v6NMNeEPa564PzKdMoY9isjMcPAjIG/9k7VH6c7fWvK55/bFEdab
         us2AH15eal8KR1HY0Do6aW3RHwaU3pRGW5DsYdJ4EbCiYiIdJzu4hdhSLEMnjDdsjYoA
         9uxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1OFRoqPDhFatbXMraJGltr3pxSt5vz1ZLbbZmTHeBLw=;
        b=NysVKa1HYHBay3mSUiKfgRUxw8oOBsFKQM+/hnmI/lxC+VRWmct3i48MUR78Lj8FTP
         2d4haX5hHOcxPGiLH/MDjm5V0lIT0cJYb9w0QOqPsGUSJ3EyJLGzfEIbuFIVi5hOSZUq
         v1x6tRVp4o3HSjwrk24zA4YPWGohj7XbsdkIxovEZ1NXOQyNmMjMvq3jlfnO/z78cUVK
         RQjRa5DrPktxyOBE0VGETvNZLkiJwX+QmFXF1oGHG++aefRA+0eu8wbNpk0TJlS1CqtI
         3nodHHeElJxuPwDQaB58T2mKpRSlyWsFR8jZEYImUNWt0WTYh+/3bztbQERP7+aWqYbM
         XZPw==
X-Gm-Message-State: AOAM531lPQbyAydzscgiRyEA3LeSmt307O8+tUjfXvA5z0X1cKnYWIHg
        RXu5CvzBqlC+sMr3lqKRn7U=
X-Google-Smtp-Source: ABdhPJwqJajFVQHCfxMJpXaKpQIIb7QDre57HKq4REdYHujo7+OMDW5mEb/0CF3uSz34xltlzFQF2g==
X-Received: by 2002:adf:eec9:: with SMTP id a9mr255631wrp.226.1627489848427;
        Wed, 28 Jul 2021 09:30:48 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.100])
        by smtp.gmail.com with ESMTPSA id p5sm479825wme.2.2021.07.28.09.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 09:30:47 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix link timeout refs
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Stable <stable@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
References: <caf9dc2dc29367bb38fee4064b7d562d9837e441.1627312513.git.asml.silence@gmail.com>
 <6564af0e-72b0-5308-4561-706ec4026385@gmail.com>
 <CADVatmOa91JbMME8XpiN5ChFM_qUm5gNzPFfLaNxW4R1UZD1Sg@mail.gmail.com>
 <YQGCP8ct1ncB1oex@kroah.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <bcd188e6-d849-524d-0ffe-5e1a6506f80e@gmail.com>
Date:   Wed, 28 Jul 2021 17:30:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQGCP8ct1ncB1oex@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/28/21 5:13 PM, Greg Kroah-Hartman wrote:
> On Mon, Jul 26, 2021 at 06:07:52PM +0100, Sudip Mukherjee wrote:
>> On Mon, Jul 26, 2021 at 4:22 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 7/26/21 4:17 PM, Pavel Begunkov wrote:
>>>> [ Upstream commit a298232ee6b9a1d5d732aa497ff8be0d45b5bd82 ]
>>>
>>> Looking at it, it just reverts the backported patch,
>>> i.e. 0b2a990e5d2f76d020cb840c456e6ec5f0c27530.
>>> Wasn't needed in 5.10 in the first place.
>>>
>>> Sudip, would be great if you can try it out
>>
>> Applied on top of v5.10.54-rc2 and tested, issue not reproduced. Thanks Pavel.
>>
>> Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> 
> So this is all good in the latest 5.10.54 release, right?

Right. And you can either take this or revert 0b2a990e5d2f76d0,
both ways are identical.

-- 
Pavel Begunkov
