Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9722E3271
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 19:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgL0SkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 13:40:19 -0500
Received: from meesny.iki.fi ([195.140.195.201]:46988 "EHLO meesny.iki.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgL0SkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Dec 2020 13:40:18 -0500
Received: from [IPv6:2001:14ba:a809:f00:9bdb:bc60:9f35:3af2] (d1yft0yf77r0hbj51jn5y-3.rev.dnainternet.fi [IPv6:2001:14ba:a809:f00:9bdb:bc60:9f35:3af2])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: jussi.kivilinna)
        by meesny.iki.fi (Postfix) with ESMTPSA id 62D89200E0;
        Sun, 27 Dec 2020 20:39:36 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
        t=1609094376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zfGJ83mwc8NB1n7vpkInF42560CNDb8MZgd/OC8YpCs=;
        b=q1eUNcIa2CDoMrBGTZLQzBQCKPuW9wv58839fvEo8BRs9BFhp9Tieqm8ma4WMBH4eK5XlC
        KVWQGw8RgRcFp0viU9MkWb0Oi1HIUG7T28KIESqDnbdOjgwiWK9UhNvaoa90iOcclXmxPr
        3Ze1Z01pbalngPwgZnozFK6qBY4h/NU=
Subject: Re: LXC broken with 5.10-stable?, ok with 5.9-stable (Re: Linux
 5.10.3)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
References: <16089960203931@kroah.com>
 <5ab86253-7703-e892-52b7-e6a8af579822@iki.fi>
 <CAHk-=wgtU5+7jPuPtDEpwhTuUUkA3CBN=V92Jg0Ag0=3LhfKqA@mail.gmail.com>
From:   Jussi Kivilinna <jussi.kivilinna@iki.fi>
Message-ID: <b45f1065-2da9-08c0-26f2-e5b69e780bc6@iki.fi>
Date:   Sun, 27 Dec 2020 20:39:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgtU5+7jPuPtDEpwhTuUUkA3CBN=V92Jg0Ag0=3LhfKqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1609094376; a=rsa-sha256; cv=none;
        b=uaGSaxBUtqd7ms52UeZ/zQzyA0W886omOLXwnDG37QVLVAK9yczjCmICj7x8Vc3gA96UXK
        ZDk+j7CJW6yDTGZQ8UWNrgzpSpHHkiWXgxDiM2d/TWs+jF9TFHukePEZ102kjoQagY4nmm
        dIJtws7RN6e9m5br7rt7FbK61Or2qo8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=meesny; t=1609094376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zfGJ83mwc8NB1n7vpkInF42560CNDb8MZgd/OC8YpCs=;
        b=vWnowbdW5eFWTHchzWW/xD2rqB4RpTH095cE3WF0gFjzxk+7ZRzV07x9Jw7Tk4athmoh7M
        vI5jdKRN8Cyu7UxW38oPtQWZaNKqLI4100Wi0H5dCyuVV8KEzalc668gHNu0rIGD1pJz28
        D7kWU3GtOcILEJRPEpqxMQqQ4SHP3Hw=
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=jussi.kivilinna smtp.mailfrom=jussi.kivilinna@iki.fi
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.12.2020 19.20, Linus Torvalds wrote:
> On Sun, Dec 27, 2020 at 8:32 AM Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote:
>>
>> Has this been fixed in 5.11-rc? Is there any patch that I could backport and test with 5.10?
> 
> Here's a patch to test. Entirely untested by me. I'm surprised at how
> people use sendfile() on random files. Oh well..
> 

5.10.3 with patch compiles fine, but does not solve the issue.

The test case from bugzilla still fails and LXC container wont start.

-Jussi
