Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6422A218D
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 21:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgKAUeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 15:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgKAUeb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 15:34:31 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCAEC0617A6;
        Sun,  1 Nov 2020 12:34:31 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id f37so10715994otf.12;
        Sun, 01 Nov 2020 12:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=y2KX4eXqEBFd3N13MAMD1R601G4yAEV0IrtHFCZnFDw=;
        b=WTNRjYOvOvfJfW/uQCnnLn/hrs6xZLE9pkoQ7q/ylkdswhadxSLO1XwQTIGu50qDw3
         AoHv1AV8CiZ3OBaX7W2wRgLPH6PVd3Kss1YRhEyKZt33vcVlQoJ6czp3By0P1HoV2GTe
         /BKAZPwkxrJ5BV6UkEfMmNwHA78E28hCeKPfk6CyM+4OXzRi/XD3b5WUb9hhHEg8PGrg
         3dgFLvZM9N/9GSmYwnWm/kvaThfDCu7G4gZ7b3yNPac64+h5ErWW/lL425jVMN7Tk6wD
         w1jrp9W2BdLaHGqPIzVyaRrbGe6svIyEkt7RLgSG7RsaFr4M6CWZA524vxxaSDdfItFv
         dwrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=y2KX4eXqEBFd3N13MAMD1R601G4yAEV0IrtHFCZnFDw=;
        b=tUB6aT5xZDCxRajlc4bsnXcInIc6W6ytw0pSVgHUDuqPyfNNSPABNp9ucVZTQsmOxL
         TXOOaIl0pIAe5B7QYZVJ5ncxk5WPmpj/7/3Zu8rbcVMNK90sRHgJ3yrYlDwn42HdLPjS
         gCrFSQFYcUJRWpFVtjTr9xgk4g0md5oybZU0TFPHuWs+9m2Sr2U3ysMd4Q+Ob7raDJQN
         m/2WiRHsweiwBQzQzhqUIl0xauiQLAe+MNV/Pr/CAmpciJN3N1ejVFphGeEWorvLzoOk
         xRvyzZIIAA69+8wr77qh/QkmAiuc3i/HX5h91gFtIaFxq5Mmgj+CyS18Ci9mM84Yl911
         xytw==
X-Gm-Message-State: AOAM530lwqNKt0HkMMdqsLeATCxCDwQHo2tG+ybK52ZClqgEk5HCZ/Lp
        HRBR5oL1P7XAc0PXPGsIEUU=
X-Google-Smtp-Source: ABdhPJzyb2JemqyuUeg+2PxSrG0wLHyouKTEH7+fGf1hXm2RID51Ma7cSz4FXlsIk6QZJl9w/O0o/A==
X-Received: by 2002:a9d:828:: with SMTP id 37mr8952103oty.147.1604262870362;
        Sun, 01 Nov 2020 12:34:30 -0800 (PST)
Received: from ?IPv6:2600:1700:4a30:eaf0::41? ([2600:1700:4a30:eaf0::41])
        by smtp.gmail.com with ESMTPSA id h7sm2959273oop.40.2020.11.01.12.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 12:34:29 -0800 (PST)
Subject: Re: [PATCH] Add devices for HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE
To:     Greg KH <greg@kroah.com>
Cc:     Chris Ye <lzye@google.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, trivial@kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jikos@kernel.org>
References: <20201028235113.660272-1-lzye@google.com>
 <20201029054147.GB3039992@kroah.com>
 <CAFFudd+7DrJ+vYZ5wQ58mei6VMkMPGCpS1d7DwZMrzM-FVKzqQ@mail.gmail.com>
 <20201029191413.GB986195@kroah.com>
 <8975d128-e47f-c97c-fbd9-6045de67f34a@gmail.com>
 <20201030104831.GD2395528@kroah.com>
From:   Chris Ye <linzhao.ye@gmail.com>
Message-ID: <a18b62e9-2c40-c20c-9822-13e0a9930aeb@gmail.com>
Date:   Sun, 1 Nov 2020 12:34:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201030104831.GD2395528@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Greg,  I just sent out the v2 version of patches, to maintainers 
of HID core layer.


On 10/30/20 3:48 AM, Greg KH wrote:
> A: http://en.wikipedia.org/wiki/Top_post
> Q: Were do I find info about this thing called top-posting?
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>
> A: No.
> Q: Should I include quotations after my reply?
>
> http://daringfireball.net/2007/07/on_top
>
> On Thu, Oct 29, 2020 at 01:04:06PM -0700, Chris Ye wrote:
>> Hi Greg,
>>
>> Yes, I can see them on https://lore.kernel.org/linux-input/ now.
>>
>> But I didn't put [PATCH v1] in subject,  should I sent them again with
>> version?
> It should be v2 at the least, right?  And please read the documentation
> for how to do that properly.
>
> thanks,
>
> greg k-h
