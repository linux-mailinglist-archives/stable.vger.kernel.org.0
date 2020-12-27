Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDB82E32BC
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 22:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgL0VHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 16:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgL0VHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Dec 2020 16:07:49 -0500
X-Greylist: delayed 16457 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 27 Dec 2020 13:07:08 PST
Received: from meesny.iki.fi (meesny.iki.fi [IPv6:2001:67c:2b0:1c1::201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90F5C061795;
        Sun, 27 Dec 2020 13:07:08 -0800 (PST)
Received: from [IPv6:2001:14ba:a809:f00:1137:69c3:b9fb:26c] (d1yft0yyvh9z8jrs7yl2y-3.rev.dnainternet.fi [IPv6:2001:14ba:a809:f00:1137:69c3:b9fb:26c])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: jussi.kivilinna)
        by meesny.iki.fi (Postfix) with ESMTPSA id 8402D20179;
        Sun, 27 Dec 2020 23:07:03 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
        t=1609103223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pSkhHgANc1p6Fjud3MYN6cMvyVc4SUF9sTF7UEzXJQ8=;
        b=MhSuNSkwhU8ZcATckKDT799JtbJLRr6Xqt+0BMenmBMiC+AgRep/dth6qSxByXgZ/vnkXU
        WAb+v17hdiy6TKJSIUzsXXLXOEjY873gFU+M1jWIzUQUHa+Px2zzVtmO2M2QIDM1XyZt1a
        Dqn4L01oVDrYrLZQIj3bd2yg5uDcuTI=
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
 <b45f1065-2da9-08c0-26f2-e5b69e780bc6@iki.fi>
 <CAHk-=wgy6NQrTMwiEWpHUPvW-nfgX7XrBrsxQ6TkRy6NasSFQg@mail.gmail.com>
From:   Jussi Kivilinna <jussi.kivilinna@iki.fi>
Message-ID: <d6c82d0c-52e9-0dc2-a08a-b6f26ecfdf75@iki.fi>
Date:   Sun, 27 Dec 2020 23:07:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgy6NQrTMwiEWpHUPvW-nfgX7XrBrsxQ6TkRy6NasSFQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1609103223; a=rsa-sha256; cv=none;
        b=Ouv+RYlHmw3rknkGkZEaffSNQna9egqsWbRJ9dV+C/dM7zS1LJO4XxDJWLhmd2KZAGgNII
        vzvuEiS8EGE+7KkxjS0vb0ZhpJmRKAerIKSFeimrQbcUecGOW+wXBUI/De5rag5TohzLQg
        cii+XxyvwHdhCo1f5xMVRHqF1Vhrk9M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=meesny; t=1609103223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pSkhHgANc1p6Fjud3MYN6cMvyVc4SUF9sTF7UEzXJQ8=;
        b=McIPRkwX4H6/3Yl225n+73sJAXNUV+A6AMHL/5FC3IhIlOdxVbHKSWtaxmmAMsPQ6v6DRE
        G1dYrYBT4e3n4WNcn2RIA1mX5rSJluRJdnW4bIOVmGAqcL5/mrYB9rRJ2yCD1/ht8MltZs
        F6+47il7mMVCfTDgrUOp6y+SNB8vTco=
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=jussi.kivilinna smtp.mailfrom=jussi.kivilinna@iki.fi
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.12.2020 21.05, Linus Torvalds wrote:
> On Sun, Dec 27, 2020 at 10:39 AM Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote:
>>
>> 5.10.3 with patch compiles fine, but does not solve the issue.
> 
> Duh. adding the read_iter only fixes kernel_read(). For splice, it also needs a
> 
>          .splice_read = generic_file_splice_read,
> 
> in the file operations, something like this...
> 
> Does that get things working?
> 

Yes, LXC works for me now. Thanks.

-Jussi
