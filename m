Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478056778A
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 03:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfGMBqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 21:46:17 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45949 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbfGMBqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 21:46:17 -0400
Received: by mail-ot1-f65.google.com with SMTP id x21so11243888otq.12;
        Fri, 12 Jul 2019 18:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RJggIoi1WuUJiWJbJhM4FX0KGoxeELa70x1WQjNhHL4=;
        b=LmshNrSKmoo+LJuiEF3vWYXLEuy4d/RvWUI1HEE8vlBFNWDM1e3+JvPOhqxu43p88W
         tHFP18wkBUqfz2hFEYWmM1RMDGmVKrkTBKcs0SL8hzZj9YLi4i9dE+w40ctSQIFbOfk9
         l8NJYQKtuJeLVvJjtOZV788QBU5IdgjCSWPmErY6lZxeW6N/QARvWl01nGVApC/pgdgF
         REy+UDYdH7rZ6Am5fPolzO0GMr64NHdbdgyRHIj7fEBk7cpoa8MSoHgHe8qebO5spvVf
         dMCkTLzfWxn8vE/pLm6IEh89T/NC2jhnm3FtyaURBje3czNAg8fipUz5dWAblz+ikKxV
         7e9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RJggIoi1WuUJiWJbJhM4FX0KGoxeELa70x1WQjNhHL4=;
        b=BMn4awOPwGKsGVttti9Z3EcNUVhnHzSnzWaZ29SKCZ5SVUhI0iEtcC+AJ9ojUG2gv4
         zQFLfT/i9gTnZzgptCYuSBvvRmza89fqaDRiqNQGdsNm0LDE7gdjvKHHQKPz83t1gzSq
         KPyqYIUHlekbmZu7BboiD5AhEvu9XgDNksjW7X31a+Al3r0Lkksv4R4uAQXPubVIWJYu
         AFtnc4R+fPq8g4tJicK2ufOp7aDKrDXACdWBoi1cJdxCelmwzx0LGToPayvYWTEMxdEi
         0S4N+aQhhru/q9rdsTQUW1q+139VrgHrFxD/Rk0898vtq9hXGbhmM4WNNtcmShvKFaWi
         eCpA==
X-Gm-Message-State: APjAAAUsr/EATgD2IuahYodq8y6RUZpx3vmSJHUK0T0aKRnV3QVSXsMR
        k1pKf/f4eQgldGz7YUpl1CA=
X-Google-Smtp-Source: APXvYqzancg/wWyb2ElQ0BIGXapMi4huf2UzabvWjv7xebotAe2UpT5vui/aF619ph4geW0j9sWUKQ==
X-Received: by 2002:a9d:5c11:: with SMTP id o17mr10308522otk.107.1562982376655;
        Fri, 12 Jul 2019 18:46:16 -0700 (PDT)
Received: from rYz3n ([2600:1700:210:3790::40])
        by smtp.gmail.com with ESMTPSA id q20sm3525559otm.32.2019.07.12.18.46.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 18:46:16 -0700 (PDT)
Date:   Fri, 12 Jul 2019 20:46:15 -0500
From:   Jiunn Chang <c0d1n61at3@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/138] 5.1.18-stable review
Message-ID: <20190713014614.xfvf2q2bt6n5bhui@rYz3n>
References: <20190712121628.731888964@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 02:17:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.18 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

Hello,

Compiled and booted fine.  No regressions on x86_64.

THX,

Jiunn
