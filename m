Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACBD11B854
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbfLKQQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:16:13 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35818 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbfLKQQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 11:16:13 -0500
Received: by mail-pl1-f194.google.com with SMTP id s10so1609435plp.2
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 08:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MXCmGsW8itYCIi8NQSaIAK7ukbEUBNXl9j1T5nEaHGg=;
        b=QYbpSDQ2ua8NL7xqSA7Yua4lzs3qw0Y2LRv5eR4tKEHeqN4y2AIh0DfI3n32mq5Lyk
         K2YcwlgVgXBFIbPN8iKzh6/Av3Tna25NpPxtMXC7tFDJw721dCygn/iS61q3djNkZyni
         mVLji0Q3kWK/tmec/FYAzpUJV4jMCgqQKzUjvlrBvHRJ552N/SWr8lHgG66PyrzCeOjm
         /eAiijUF1AbL6iuzYqF3CxklerZ6ab6pOzFcoHrxQ9UbftOLwmG7VOydxcUMOHJCJgD4
         eZnpEwsESIiZ8RL15o28nzn2cnOzaexYax0e8z8aChBRgec7Cn0PR+351Bh94kFEKvzg
         yh5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MXCmGsW8itYCIi8NQSaIAK7ukbEUBNXl9j1T5nEaHGg=;
        b=AHuQ6zIYc/0ypL9W3utF1y6DZQ+e5/ENICS5IRgCKWgvaO3bMlAA+wh6Rz4eIyQJdi
         vDAPXodjzkC0EnJhg5f7okQ8rGqEcszoXz9X4gMtlyGEopEI2uym4o+gJ7hEcxfwcNyx
         NDShxgeZfTXsDqAYfiqOyQzna4Or7attyNPR2wPA1QxUBNExOGolfEsdi8TXSZfq90RA
         j8ubGhPP49Qz4vUAO+oeFXOYcZg2wTG1I704bFBkJUDClPodhtfk3bnT7qjvy22DW5vI
         kjJHazVELWJqrIA6eog93veKQVAR/mgicoGWbpw3CI0J3T2pOfWslOvYA88mumeC9IE7
         Zevg==
X-Gm-Message-State: APjAAAXArAsBNcDG3wYG+iRWFX4C02Hv3SNwetUUeMtjA7l2tapUbE5B
        oYBKxcNPvNtUhN3P2QgRD6f9jg==
X-Google-Smtp-Source: APXvYqzPX/v+hnR4/KASF/sKEAiVdz7cVmusLRs3j8+NqWPNeiSzXGfmWsd+4qjgjod4f3I2HjMdqw==
X-Received: by 2002:a17:902:64:: with SMTP id 91mr4134443pla.307.1576080972467;
        Wed, 11 Dec 2019 08:16:12 -0800 (PST)
Received: from debian ([122.164.82.31])
        by smtp.gmail.com with ESMTPSA id c19sm3829604pfc.144.2019.12.11.08.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 08:16:11 -0800 (PST)
Date:   Wed, 11 Dec 2019 21:46:05 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.3 000/105] 5.3.16-stable review
Message-ID: <20191211161605.GA4849@debian>
References: <20191211150221.153659747@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 04:04:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.16 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

i get the following when i try to compile...

-------------------x--------------------x--------------------x--------------
$sudo make -j4
  DESCEND  objtool
make[4]: *** No rule to make target 'arch/x86/lib/x86-opcode-map.txt', needed by '/home/jeffrin/UP/linux-stable-rc/tools/objtool/arch/x86/lib/inat-tables.c'.  Stop.
make[3]: *** [/home/jeffrin/UP/linux-stable-rc/tools/build/Makefile.build:139: arch/x86] Error 2
make[2]: *** [Makefile:50: /home/jeffrin/UP/linux-stable-rc/tools/objtool/objtool-in.o] Error 2
make[1]: *** [Makefile:67: objtool] Error 2
make: *** [Makefile:1752: tools/objtool] Error 2
make: *** Waiting for unfinished jobs.
------------------x-------------------------x----------------x-----------

the file "x86-opcode-map.txt" has been deleted upstream.


--
software engineer
rajagiri school of engineering and technology

