Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFD7A0692
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 17:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfH1PrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 11:47:21 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46897 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfH1PrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 11:47:21 -0400
Received: by mail-io1-f67.google.com with SMTP id x4so374985iog.13
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 08:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=OLmCeKExThOqBBqGUMvKQ7fb5lWuMtsbj4GhsnAJmTo=;
        b=kH4pulSWk9fZv+l9VbURgSAIxoicYHuL69PDuZJaYMTiGFN5KdOBotPdbwc9FEqK7H
         U49IuxWn8sJLTKezb2Z+QxX92I2CHAQXp1z0xIs2Fz04oqTJabvUoVDVpeY+Otxxut4x
         vZ7vMczxFY7Em2Ig7fo2pcWdbgkwNcg6QW6Olwkc3H+/6mCegVteILMHSR02phC/Sht5
         FU9PVEsmzpkM+BmhiE+I9Gmrdt9ULJLfVA5RFbeTUVpMa9DB1iHV4Jnv2qMl0wgvGhC7
         sviMLuRvwHEszadv9R2q7+9hcLJv39JL7ndc3KUHbhNce1s7ed1LETLCTUFaWlGq2CGu
         AZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=OLmCeKExThOqBBqGUMvKQ7fb5lWuMtsbj4GhsnAJmTo=;
        b=d3OdbViZZEXyz4CT+tU2dEMJg1YTpQHhss4gO9hA6h2jdI78N/3UzKq46XwU++rjgF
         GkljNHxiLO879COpSDeHF5jzw1YlVOxRbwXdHuH3Cug/ZnHnfOzwqQGmCLIVXdtRkOAF
         g6biJ/Uvy9mz+PXmA6ro4v9eIjQVcB6Zeuucawm21J5vR5xdpeRUahFLt3O+cKS6LW9f
         JBSBwLwhAVzpKcTwhf50Mjj41TUXRNrpLkOVcVMT3kbtBgT+pR33avAw/cV7UBMYIAG0
         CKa/GwzWe2+2LP+SJDuPqoThohzh8BC/0G0WXsW26rhy7Re5E71wEn6Q/Rc+QjV6KpDa
         kQmw==
X-Gm-Message-State: APjAAAU8L88eEXG7U1e0IDH51mzjae5gS/cSIVPXHZm4+z6nVzCVxVi4
        iOrvWzfAt1shWgmJrsjZBsRrEQ==
X-Google-Smtp-Source: APXvYqwswuaiWrAZi4jcfIM7D6Oth6MAafqo3bw3WWNNxcKDWUgHSRrHfIU/xm8HgBP4JJ2EorgQtQ==
X-Received: by 2002:a6b:3c07:: with SMTP id k7mr2631851iob.107.1567007240632;
        Wed, 28 Aug 2019 08:47:20 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id t2sm4152644iod.81.2019.08.28.08.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 08:47:19 -0700 (PDT)
Date:   Wed, 28 Aug 2019 10:47:18 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.2 000/162] 5.2.11-stable review
Message-ID: <20190828154718.nesaolp7gfxxh5o5@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Shuah Khan <shuah@kernel.org>,
        patches@kernelci.org, Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
References: <20190827072738.093683223@linuxfoundation.org>
 <CA+G9fYtmHsr8XWvmSLy9QKvF37KfZ4v+T1VnRy2uhpE0HB4Ggg@mail.gmail.com>
 <20190828151608.GC9673@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190828151608.GC9673@kroah.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 05:16:08PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Aug 28, 2019 at 10:30:09AM +0530, Naresh Kamboju wrote:
> > On Tue, 27 Aug 2019 at 13:30, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.2.11 release.
> > > There are 162 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.11-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > Results from Linaro’s test farm.
> > No regressions on arm64, arm, x86_64, and i386.
> 
> Thanks for testing all of these and letting us know.
> 
> Also, how did you all not catch the things that the redhat ci system was
> catching that caused us to add another networking aptch?

Hi Greg -

I'll follow up with them off list. That said, I expect different CI
setups to find different issues - that's the point, after all. It would
be bad if we all ran the exact same things, and found the exact same
things, because then we'd also miss the exact same things. In the macro
sense, there is a lot to test, and I would rather see CI teams go after
areas that are weak, rather than areas that are well covered.

Dan

> 
> thanks,
> 
> greg k-h

-- 
Linaro - Kernel Validation
