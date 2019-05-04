Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D235D136EE
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 03:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfEDB2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 21:28:14 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45707 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfEDB2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 21:28:14 -0400
Received: by mail-io1-f66.google.com with SMTP id b3so1021454iob.12;
        Fri, 03 May 2019 18:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fqoxiZyCvyf+sKhxeClpHtSGA08x0zbRLqOhBkhWRcU=;
        b=PuVZYNeN9paugDedZluU0+Pnfxj09pUnMxZdpb8xEkS17IgNgchlUxgrnQ/Z6gO3s6
         O4PhncNb+3OmvX7eKalHCCYgiigBOwpMHEQaAPb2dX15nil75T7aLUYoa0F+JWzRSHOO
         KQnNgZsmNm277KnLWTSZj4La3HHfT+4Nl4bYz5zebMDzRG1Aj6tKfnkFOWoQrkVgi9zE
         7gPhLFS8mr7KpQHtP0kpmBL4fORMh3liWizt/ppQKomENoK9Y3e4Iu8AgOI/aW2zcNiv
         Gkk46hYLF1puCxBftcFRhNuzXvFxr/f+2TIucwv1GNB5NaTHVejlNGS6ekz79QAyOw28
         3wsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fqoxiZyCvyf+sKhxeClpHtSGA08x0zbRLqOhBkhWRcU=;
        b=dP2nZf5HXL+mixEFAVKeEHqSGZxiiQpVc8qg5LC04VHYZtVr0xbuzCqN6JlDI1Z3XQ
         vKzzTamj5kvOTxmDZdeCQRUr+zzzxLHMimTnJWM6ZxoEVbedc46WuqFWsBTuXt0xArRl
         5i3OenXYP3IT47PcmdR5iOq98jXTwnC0Zp1gTGQ9bDRKjkvKilwykjvUQlnNRo6bMR8g
         iWlAZj2uQR6Sjep1ISTb4lwYkDkT5AhHQ9jJOOz5yFUU9vEnyLCuJCfY7AE4W+2aKbjv
         XWhHdOuH88hngsydju1F2poELLWPEvcPBtrfrwjup0v6LLrCAHe2ys1H8lbGXnw6p9AR
         Pyrg==
X-Gm-Message-State: APjAAAXy6GM/y3ZDkzFw2F6pQqFo4HQOg3lmp+ZNfmPWD0lwVIHAbxuq
        NA2CxQVZnDknfAZfSRzBPreSJquaNXFw/A==
X-Google-Smtp-Source: APXvYqwKe+cIFUdbkRF72PFk0UVrYJLo2sQ80sv0NiPxl5SJGkeAxjTsptrCur2oUC9ABF9hi8gzaQ==
X-Received: by 2002:a6b:c901:: with SMTP id z1mr5149311iof.3.1556933293852;
        Fri, 03 May 2019 18:28:13 -0700 (PDT)
Received: from asus (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id q207sm1738281itc.37.2019.05.03.18.28.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 18:28:13 -0700 (PDT)
Date:   Fri, 3 May 2019 19:28:11 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.0 000/101] 5.0.12-stable review
Message-ID: <20190504012810.GA20514@asus>
References: <20190502143339.434882399@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 05:20:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.12 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 04 May 2019 02:32:10 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled, booted, and no dmesg regressions on my system. 

Cheers,
Kelsey 
