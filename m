Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFE64696ED
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 14:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242221AbhLFN2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 08:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244400AbhLFN2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 08:28:00 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3A8C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 05:24:31 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id m12so20910686ljj.6
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 05:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aJIMRxOK3HF68sW8228e15woaAW1AoaRy90HC6KodT8=;
        b=j9jCbo23X0cTr91+A6lwyeDCgOFUYZs6i8fnLgxQdl5uoCdn6u5MZBjxUr/FG2RJ1A
         M711bS7+YaG4BSzzzZo0yQ1mafkN9LIZDfJ7YEfPsMbD7jGyJ9YO5zcdkBpLhl90WHsV
         2dGVyyJgTrhIUta62nb5fy3z8dQYkIztg6QhS13qGPQwbIIyGz8YXAtCANezmm3Fx6uv
         agZyL9Z/w8Lm4C65RpDREV4ERuX3zS5eMES64Jcaq3x2GHirSCLc/xPAU0NsPShlNjAu
         Y9iBrVJ0/K7Sro/qje8/1xWA9FvQbEmcpK9KB0wUHhq+Pusbd8CFtZOa9fqdF5GnLFSJ
         Y/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aJIMRxOK3HF68sW8228e15woaAW1AoaRy90HC6KodT8=;
        b=3/aMA53GwRJsw9TcPTrYxAjYCo7+3mzKn78gzvolBM1BsEGNZJNEGBvDVokSBhEoGc
         WfPOR/3QgOF3KGE2+fLgqzfIIwxA4UOWxxBVlH8mSW22N4MEsU7PuX+hs8OL/gDq8H7m
         aZ8EgY/FW91pIYdFudinPBf3OQMC7p3vp9n4ceqFMUjaJrxbnsYRDJ5ydMGbQpWA4c9+
         +TvCOzOcwM39x5n7I/peBhsfmst3XRuGX1uAkpSuDo0wh4ZbfXfspg4+RtSk6IWjot/t
         gvb1sPVoOd9jaDG1JJrTzl1FOorvQT5IG2ZFYppfz5jpPQPxOeLB0Uiw4ckqPupz/trk
         noxw==
X-Gm-Message-State: AOAM531y2t9XKXJfztpi2KiRtrt93VI2TJt88yOLzxoojiLu6y+KZPMo
        fZDKZK9vFf/d/F6CWKQoXWgdSRychKoY4A==
X-Google-Smtp-Source: ABdhPJxznv+YEIjoe8xi5B40B96pGErvKzS13Slhy1K3kv67rV3VKvSTh7m2lzasje4RFyabGbOwlg==
X-Received: by 2002:a2e:8156:: with SMTP id t22mr36647048ljg.223.1638797069788;
        Mon, 06 Dec 2021 05:24:29 -0800 (PST)
Received: from [213.112.1.193] (c-51aad954.51034-0-757473696b74.bbcust.telenor.se. [213.112.1.193])
        by smtp.gmail.com with ESMTPSA id e14sm1308777ljn.78.2021.12.06.05.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 05:24:29 -0800 (PST)
Message-ID: <dbf6b329-03ae-fc92-80a6-8f80d88e28cf@gmail.com>
Date:   Mon, 6 Dec 2021 14:24:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Could the fix for broken gcc-plugins with gcc-11 be backported to
 5.10?
Content-Language: en-GB
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, keescook@chromium.org
References: <a11f5d22-658c-44e9-51ab-d39c5e8776da@gmail.com>
 <Ya4KYD9lpKaQI9G7@kroah.com>
From:   Thomas Lindroth <thomas.lindroth@gmail.com>
In-Reply-To: <Ya4KYD9lpKaQI9G7@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/21 14:04, Greg KH wrote:
> On Mon, Dec 06, 2021 at 01:59:31PM +0100, Thomas Lindroth wrote:
>> Build support for gcc-plugins are not detected with gcc-11 in lts kernels.
>> Gentoo and Arch apply their own patch to fix the problem in their distribution
>> kernels but I would prefer if a proper fix was applied upstream.
>>
>> https://bugs.gentoo.org/814200 a gentoo report with the relevant info.
>>
>> I've searched for any upstream discussions about the problem but I've only found
>> one message saying the backport needs an additional fix. That was almost a year
>> ago. https://www.spinics.net/lists/stable/msg438000.html
> 
> We can not take a patch in a stable kernel release unless it is already
> in Linus's tree.  Please work to get a patch accepted there first,
> before worrying about older kernel versions.
> 
> thanks,
> 
> greg k-h
> 

The problem was fixed in Linus tree in commit 67a5a68013056cbcf0a647e36cb6f4622fb6a470
"gcc-plugins: fix gcc 11 indigestion with plugins..." added in v5.11

That's the patch that needed some kind of additional fix before it could be backported
but that fix never materialized.

/Thomas Lindroth
