Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44259454F1
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 08:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbfFNGo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 02:44:58 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33416 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfFNGo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 02:44:58 -0400
Received: by mail-oi1-f195.google.com with SMTP id q186so1219241oia.0;
        Thu, 13 Jun 2019 23:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6qkg7SUhvpyJrdWcqPtH2YVmHoejIjOCkgMfqRnexdw=;
        b=Lt+kXEMjMesGmycMml4F5Tqa7HjPyoftYLw9BnrZ5DRem8GblSkhIJ8K3f56AR1Enk
         7/Ny7bsxaf7nHDIfEd/NWNSmpwP8lNeSXWO52GpzxQHCMIWgkj9fGD86bDsASF34F3l8
         fcfWaSdhepiFpkStLFYp4DMs6P+iN8GVa82lJmu1aklGnWLLu0AtDHcTik899G2uGM9r
         siojEd/2jtlDrsZQqbrjzpfu3eAf2oj3QKvE+i4vWtJyNJ0viWfJjFWtuczMs00mGRjy
         +3LQlshcpH84hlzG5fs7qqEcjqt4Sdypy3OZtmWgXsFtkxXpt4SlNjiwCN5kXQG6EMQC
         9Zzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6qkg7SUhvpyJrdWcqPtH2YVmHoejIjOCkgMfqRnexdw=;
        b=uGn1q0j7JpN9YKr7xzZZV14StvEXol6IdwCnoDPuEzqQp2sZXCdL6g/bFLUJBj7l9Q
         xMFZlG6A3vRrh0u1AWQzzF3sInbQ2g6JARmMwiCp4XW3tHevzvDcQ6qg+XfW4pbQHgnl
         9WKiSujh4AM/MF2jL8AGd66sS6siRq4fbb9i1UrDAORAddAePtLtjGpm2vq2fcgEARJR
         gNaHdaponjNMp4LwdRsrwxnB9glv56vsUqtojfCnURv7uaNpWXiVxG6J7R9/Uiz2CC3B
         0s/1xIfsG++wcT0FogFU6TBXBr9P9iXzblZ+9Kvuhood71GHB0XMDvHkLebI7nj4c04R
         lDAQ==
X-Gm-Message-State: APjAAAUByba/xqiJgqiqjzIqKe9TQLorU56Znz7Q9ATS/JRh3hjHMeuM
        ieoFyb4WsLIh6iuqkILc358=
X-Google-Smtp-Source: APXvYqwW1As+9tvBcr6jdZG7diw1yI7f8ZF1HYMQ6EFnTt4m0OrF3nekITHCibgay+NrnMEkh4YXjQ==
X-Received: by 2002:aca:c5d0:: with SMTP id v199mr825861oif.144.1560494697362;
        Thu, 13 Jun 2019 23:44:57 -0700 (PDT)
Received: from rYz3n ([2600:1700:210:3790::40])
        by smtp.gmail.com with ESMTPSA id 5sm871863oty.8.2019.06.13.23.44.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 23:44:56 -0700 (PDT)
Date:   Fri, 14 Jun 2019 01:44:56 -0500
From:   Jiunn Chang <c0d1n61at3@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/155] 5.1.10-stable review
Message-ID: <20190614064454.qqvgqsqm6u535qeq@rYz3n>
References: <20190613075652.691765927@linuxfoundation.org>
 <20190613200849.veuc5crfejlcepgh@rYz3n>
 <20190614055040.GD27319@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614055040.GD27319@kroah.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 14, 2019 at 07:50:40AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Jun 13, 2019 at 03:08:49PM -0500, Jiunn Chang wrote:
> > On Thu, Jun 13, 2019 at 10:31:52AM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.1.10 release.
> > > There are 155 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sat 15 Jun 2019 07:54:40 AM UTC.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.10-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > -------------
> > Compiled and booted.  No regressions on x86_64.
> > 
> > This is for 5.1.10-rc2 from git --no-pager log --oneline -1.
> 
> What do you mean by 'git --no-pager log --oneline -1' ?

Hello.  I must have missed an email somewhere.  The review request was for 5.1.10-rc1
but I only had 5.1.10-rc2 from the logs.  Sorry for the confusion.
> 
> thanks for testing,
> 
> greg k-h
