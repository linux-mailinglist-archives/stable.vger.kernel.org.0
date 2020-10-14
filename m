Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187F028E66F
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 20:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbgJNScH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 14:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbgJNScH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 14:32:07 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D78C061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 11:32:07 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id f19so296964pfj.11
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 11:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=c6axx0JELED5T9x8hDekihgKHYOlBdjdLpETONjmu8c=;
        b=cLEGBAMzgBYqIeyntg76eUJMmxXJ1MNUZxeTtNAIZKQnCBei6uRmaz7ndRk1t9iTWI
         Pl7mzQXPFw1zp2QZrQ5B2LoxmW5TKl5nxb7hXGVoDdtBIzUG0oIXjH5XjA1Pi2CXbuwc
         5Bh7gFzREGuR4L/ynTKBnwhE5XNyF+46+46O1fD+hfALFjlm1Mtdr5pKZ2BeYK+yXtUD
         Hp62bbIVlhWP+3caL3fMcJ5d4BWSoFvV+BOeEtBoWDBDIS8QjklV1xeieC3qdfmDE25Y
         GkHrTGdx0HV6fO/SGtZkpy1b0797P2vn6B8geeqXilBtlN3QtekGZas8NkhDl2xA2W18
         tFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=c6axx0JELED5T9x8hDekihgKHYOlBdjdLpETONjmu8c=;
        b=CL8NO924vPzawIWsjXIR7aVNkO+HU1td0myNxQYpK6W3SiWdHC4+S+UDJX0sJZ0AxB
         UK6JjjjphqhiVl4I3pZ7JRfr7CeBYkhgS6iTwJvJTO2Z/q9HERr/jovXp+oPTPUgcXLm
         u7nKaE3+aKOEUhODcNJ03brMM89YXVO9CGYk+SNLir59Fh5APj2xFugqI+VKUFkSS5uk
         ryZgI6beMBnFSFpDg6uVblk5TIrAJob2zSzVvrSgJj9S7TYTA2cOUJQkGcZt1cRH5Vss
         hJUZU5Me+raRCzT5Dw0hXy4jPAhxNozGcPRECO5B2O6x+VrnJG523XujRt/UAspBlBiX
         tI/A==
X-Gm-Message-State: AOAM531GWFyGcp0UAL1Ah+I0gTQpu9HG19ZBqfaiBxfqNfHjbqCL8heu
        9L/ffsXj4jtnwSdbqxrSZ7Vvgw==
X-Google-Smtp-Source: ABdhPJxQzA+WhcXkPBbng2l0r2nsFfK2oQ9wNzu93wQ7S/hbLO8j28mBmTbydltYT5ssCx3UBl+DKg==
X-Received: by 2002:a05:6a00:786:b029:155:2e1d:a948 with SMTP id g6-20020a056a000786b02901552e1da948mr605567pfu.22.1602700326761;
        Wed, 14 Oct 2020 11:32:06 -0700 (PDT)
Received: from debian ([171.61.243.166])
        by smtp.gmail.com with ESMTPSA id p16sm335175pfq.63.2020.10.14.11.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 11:32:05 -0700 (PDT)
Message-ID: <f1ed28462ca01522e683ef023f4f497e7a17a768.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.8 000/124] 5.8.15-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Date:   Thu, 15 Oct 2020 00:01:56 +0530
In-Reply-To: <20201014095652.GA3599360@kroah.com>
References: <20201012133146.834528783@linuxfoundation.org>
         <d31bda1df5cc75e3217d88eece08dcc2c3c29531.camel@rajagiritech.edu.in>
         <20201014095652.GA3599360@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-10-14 at 11:56 +0200, Greg Kroah-Hartman wrote:
> On Mon, Oct 12, 2020 at 11:00:07PM +0530, Jeffrin Jose T wrote:
> >  * On Mon, 2020-10-12 at 15:30 +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.8.15
> > > release.
> > > There are 124 patches in this series, all will be posted as a
> > > response
> > > to this one.  If anyone has any issues with these being applied,
> > > please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 14 Oct 2020 13:31:22 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	
> > > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.15-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> > > stable-rc.git linux-5.8.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > hello,
> > 
> > Compiled and booted 5.8.15-rc1+ .  No typical dmesg regression.
> > I also  have something to mention here. I saw  a warning related in
> > several  kernels which looks like the following...
> > 
> > "MDS CPU bug present and SMT on, data leak possible"
> > 
> > But now in 5.8.15-rc1+ , that warning disappeared.
> 
> Odds are your microcode/bios finally got updated on that machine,
> right?
> 
i do not think thot the bios got updoted, becouse the bug is still
shown 
to be present in 5.8.13-rc1+  . so moy be the updoted kernel is fixing
the 
bug or gives  o workround.

-- 
software engineer
rajagiri school of engineering and technology

