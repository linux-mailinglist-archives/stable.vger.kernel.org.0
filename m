Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C6B2467E7
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 16:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgHQODJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 10:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgHQODI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 10:03:08 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1AFC061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 07:03:08 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ep8so7737362pjb.3
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 07:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HV/EMzOGCVO9qqnDD6buHcDsuc1JeZWBO9wGnHx3D0s=;
        b=2EESDErOQ6+7gj8CMTuLQmIMkIzQqPA9eMwosEb1VEHCb81Y/WgRiXM5eWNi1pdNqn
         Gqam9hQt5wmfS0E9bXZT6SzStwF1s9DCnqweIhevKL0gDOzHJAQnWZPWVoQ7K5jDQSxc
         YDLGNLs1VIc7Gnub8/pvgmOwNDKe5wKwu6fQ+7s8lFHSGB+DXlNFiOvSSgLvKqcOeTko
         xuROy6wZpJ3D1pkIKsL7v01vXSS48R3hVX7g0TI4IkA0+jY02GKFWVE1Uyqs/G+y4CNv
         hUWYBio+LqUkITQNiMuIv8I1DtzcJJt5ZEYnOlxdGnHHsY+liLIPbAIuwJjRvlAM88Qe
         Osog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HV/EMzOGCVO9qqnDD6buHcDsuc1JeZWBO9wGnHx3D0s=;
        b=UkW+oyWrNl0vEL3pDYu0fA8/fixfZQhrcrwh+KEEqWQXPLVeURBB3YIp9Gd38LdIYI
         3p3OnnqrW2ff23HNjO0lhEj7cEuykHCYTvgkeBg0lkNbkeTyjPIPgzo/ZkHXjFAkLD3U
         J/A6m4o6pIblBsreUtYw2a0bb9uiTZOt9t11VRGugSTn8KxkicMEZCIISk1qAHvyfgnh
         nh3mmr9SbyJEVEJ2DG0WvqwBhS8cTdDq8uWWcXhLEbu6qXTyi0bCiQ7zx57Z3O0awmNa
         gougtdy32nwWUhxLuzMwcYZf/aSmnRb0fOLYGIjC9Zwnv4dQ+YBOvFPJsxr/Md/Q85SH
         DGNw==
X-Gm-Message-State: AOAM533eLnc9+C+A0LotsfvSR3TTc9GGVmpjh93pour9HS+MdNOe5Wk8
        f5YoLHVeBpCyORD3MTuGiNYlgC9z3nrVfA==
X-Google-Smtp-Source: ABdhPJw5so/Aqa68m2udQD1urJxvSMgxFvsJEuuVJAYAfZbdFlt4ujP/j/iaIy4I4sTnibdQDomSbQ==
X-Received: by 2002:a17:90a:e544:: with SMTP id ei4mr12646980pjb.122.1597672987664;
        Mon, 17 Aug 2020 07:03:07 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id g2sm17552138pju.23.2020.08.17.07.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 07:03:06 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: hold 'ctx' reference around
 task_work queue +" failed to apply to 5.8-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <1597661043160117@kroah.com>
 <6d363f5c-711c-6953-d417-2f9dfbf3dd7a@kernel.dk>
 <20200817131341.GA208556@kroah.com>
 <da8acd62-2312-1baf-8562-d2085c78e062@kernel.dk>
 <20200817134412.GE359148@kroah.com>
 <cd794f40-ba84-0766-a68e-d6f0cb8c77e2@kernel.dk>
 <20200817135557.GA503390@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <45a49f1e-7fa2-4d0e-eb53-13d2309c0b37@kernel.dk>
Date:   Mon, 17 Aug 2020 07:03:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200817135557.GA503390@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/17/20 6:55 AM, Greg KH wrote:
> On Mon, Aug 17, 2020 at 06:48:26AM -0700, Jens Axboe wrote:
>> On 8/17/20 6:44 AM, Greg KH wrote:
>>> On Mon, Aug 17, 2020 at 06:21:02AM -0700, Jens Axboe wrote:
>>>> On 8/17/20 6:13 AM, Greg KH wrote:
>>>>> On Mon, Aug 17, 2020 at 06:10:04AM -0700, Jens Axboe wrote:
>>>>>> On 8/17/20 3:44 AM, gregkh@linuxfoundation.org wrote:
>>>>>>>
>>>>>>> The patch below does not apply to the 5.8-stable tree.
>>>>>>> If someone wants it applied there, or to any other stable or longterm
>>>>>>> tree, then please email the backport, including the original git commit
>>>>>>> id to <stable@vger.kernel.org>.
>>>>>>
>>>>>> Here's a 5.8 version.
>>>>>
>>>>> Applied, thanks!
>>>>>
>>>>> Looks like it applies to 5.7 too, want me to take this for that as well?
>>>>
>>>> Heh, didn't see this email, just going through this by kernel revision.
>>>> Either one should work, sent a specific set for that too.
>>>
>>> Oops, it did not build on 5.7, so I still need a working backport for
>>> that.
>>
>> Maybe I missed that, in any case, here it is. This one is for 5.7, to be
>> specific.
> 
> That worked, thanks!

Great, thanks. I think that concludes the stable fest from me this morning :-)

-- 
Jens Axboe

