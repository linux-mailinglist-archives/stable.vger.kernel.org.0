Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2809D23B1A6
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 02:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgHDA0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 20:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729062AbgHDA0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 20:26:15 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B26EC06174A;
        Mon,  3 Aug 2020 17:26:15 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ha11so1050228pjb.1;
        Mon, 03 Aug 2020 17:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5LLqz6v3iunhPCbEM0MOMdCKabmAik+3jIuenBGSPWE=;
        b=VpzeRT+2u8AD2XRWMIjIK0jinm38SQpoNcJNX2woAhgUuQPGdZRx5WAshGPchBhnp0
         EcMNklWfTT3tfiibcLbdt7/ltiA7cfk/fQhX9AKaAeCno/PGSQ39YcD+vZDsSwIHy49l
         PD1a2CGGC37t2UuNgj/3+P3eBviLVMkdeg4bumJOU62REyAxSk+qhmrdBrXXrAztf06m
         1tMqEU7CRxXr6MPItNN+n5dLScFFZnuS7ccaInmujITkFJau6fhJurfCe0mFX7vTzjZw
         SMfdeXjN2P0eWdyCHorx2X3RuzvfQfyywcvX1DbNa7tdNq0ZGaszhrrOXUAgxHDaiBm0
         Z6Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=5LLqz6v3iunhPCbEM0MOMdCKabmAik+3jIuenBGSPWE=;
        b=YxRGG3jD8gDHZm6NJHAQ2wWRbWdOHX96l9Oh2JsnhbS/GFyBi5IHF4HTOC/VWGVs1a
         +T/WZVl7hMuvwoFe9Bm8N1Dn7q6lLiBhz6mduTf5fMHMeF4iSbJz9xsdCdSu+/wXiMun
         aZ1Z0tZrMXRxFrqtxYQuhgvEl3Jpzl67cFh1DTPqODRwYLHx6OiwxTn22YXLAVMs2TJB
         ySdDYh9MtpK4F43p8xvVHuKwRciJxt38Q74XiEngm5OF27qS8540GUiqsyaTraz0jIK4
         4xMSn5OrbQEEDkDDJwnQAkMJ+LnzG87OAchYHmnGorsuVaFE7/AdZqY3edzH1ZXre12Q
         x8Fw==
X-Gm-Message-State: AOAM531qprxQWAEH045Q/cxBQfRfZnwFnYCEkeR/NBJmtenwRQ3Y+92A
        PEDJuirzhDD2yUHVmiQPK0t8uBmQ
X-Google-Smtp-Source: ABdhPJwBtIYZha2/No8ds4PEBhV5U3QSpju3WmA5NFb9RTPJbQWfTNcvBDEwhCyXSi0ZEdigTLHDJA==
X-Received: by 2002:a17:902:6544:: with SMTP id d4mr16951396pln.138.1596500774810;
        Mon, 03 Aug 2020 17:26:14 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e15sm6686340pgr.39.2020.08.03.17.26.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Aug 2020 17:26:13 -0700 (PDT)
Date:   Mon, 3 Aug 2020 17:26:12 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/120] 5.7.13-rc1 review
Message-ID: <20200804002612.GA28720@roeck-us.net>
References: <20200803121902.860751811@linuxfoundation.org>
 <20200803155820.GA160756@roeck-us.net>
 <20200803173330.GA1186998@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803173330.GA1186998@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 03, 2020 at 07:33:30PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Aug 03, 2020 at 08:58:20AM -0700, Guenter Roeck wrote:
> > On Mon, Aug 03, 2020 at 02:17:38PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.7.13 release.  There
> > > are 120 patches in this series, all will be posted as a response to this one.
> > > If anyone has any issues with these being applied, please let me know.
> > > 
> > > Responses should be made by Wed, 05 Aug 2020 12:18:33 +0000.  Anything
> > > received after that time might be too late.
> > > 
> > 
> > Building sparc64:allmodconfig ... failed
> > --------------
> > Error log:
> > <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> > In file included from arch/sparc/include/asm/percpu_64.h:11,
> >                  from arch/sparc/include/asm/percpu.h:5,
> >                  from include/linux/random.h:14,
> >                  from fs/crypto/policy.c:13:
> > arch/sparc/include/asm/trap_block.h:54:39: error: 'NR_CPUS' undeclared here (not in a function)
> >    54 | extern struct trap_per_cpu trap_block[NR_CPUS];
> > 
> > Inherited from mainline. Builds are not complete yet;
> > we may see a few more failures (powerpc:ppc64e_defconfig
> > fails to build in mainline as well).
> 
> If it gets fixed upstream, I'll fix it here :)
> 

Are you serious ? This problem literally affects all branches, starting
with v4.4.y. And, yes, the powerpc builds fail as well for all branches.
Just like mainline. I guess that means it doesn't matter either ?

Building powerpc:ppc64e_defconfig ... failed
--------------
Error log:
In file included from arch/powerpc/include/asm/paca.h:22,
                 from arch/powerpc/include/asm/percpu.h:13,
                 from include/linux/random.h:12,
                 from lib/uuid.c:22:
arch/powerpc/include/asm/mmu.h:131:22: error: unknown type name 'next_tlbcam_idx'

Congratulations, looks like all stable releases are "bug for bug compatible"
with mainline.

Does it even make sense to provide full reports for this set of releases ?

Guenter
