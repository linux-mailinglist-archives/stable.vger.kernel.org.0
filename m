Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981A8380E0E
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 18:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhENQU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 12:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhENQU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 12:20:56 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCC6C061574;
        Fri, 14 May 2021 09:19:44 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id lg14so3518456ejb.9;
        Fri, 14 May 2021 09:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2fijQ7TKMIt7SfOlxpBNp924p9/bMB3BjK7YiFJWydk=;
        b=K5AGusU4Cph9q2+XN73VdvwMe/zmv80CTSzNFULZtkYS7qXl7u+Np3wYLzOEYj+V5N
         iT66kBWC7KI+TN3FGCOw/vuXGdAMaknKH24CfgmVj8G+WhEVq7pPhlhDocTnbZFPncVM
         FM4QA7Kvj2CQ9sleFQMP5g3a2G8YmIAzTayMYMPmUiX7NuCTiQJu/p81xU85jPjYM/JZ
         aP5A5hIAg8vO8flu8d4+k38+LryRjtrFvl4oYuAWZyE7SQDesyVEyBOxvbo28NipQUKo
         P6gMiw+SQFZN2TGKk2EygP2hGs4QL2DS76nCBGQDRYSPXVimneWgrmcwPyZkpcRve+zs
         sXmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=2fijQ7TKMIt7SfOlxpBNp924p9/bMB3BjK7YiFJWydk=;
        b=O97rMLOxWdP7IDIfq8NTM+u/cPs45pjjTVD+fhZ++VYqPWj2QsRDQflvdbfSCm2YQy
         Y5BltsdrRUdb5tnm6aM7ZTVgL/ntZplqSdzJLD9DF496LphzNGCTOz5Fx0hLgyfA7ZNS
         YIjntas3L3niCyOoymlcG/1g4awK8lQujWgEmDRQwIXet+SBa83/UJ0RUlhOhCs3DkU5
         iwXppcDOk6y8r5kz/Afu7jHmfAv3s9LI5O8wjGA94ItWyv8L67sBpW3aHihkssXbPicp
         1ra0G/eM4ZlgY2rq3zjy8pvjO6wGf3GuvHPr1Oo2aVtgodWZwkcvQ9FoYhiU0D3R1lWz
         C42Q==
X-Gm-Message-State: AOAM533UKyZ/AQOVJC+A6YJpGAQz2rW3ucKtBXOSphBy7n1KYpKLxuoW
        kZ+rK6d7MEmVt8tpQ8fqKUVM1gUwE4A=
X-Google-Smtp-Source: ABdhPJz2e+/vBRn0gbJcNGsHvN7pZSCa5AJlxDcLOUG9cRasI/v3FYYeQ90PRON3ZH+4J4P8VWhVzQ==
X-Received: by 2002:a17:906:a1c7:: with SMTP id bx7mr11571928ejb.401.1621009183679;
        Fri, 14 May 2021 09:19:43 -0700 (PDT)
Received: from gmail.com (0526E777.dsl.pool.telekom.hu. [5.38.231.119])
        by smtp.gmail.com with ESMTPSA id g17sm6081759edv.47.2021.05.14.09.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 09:19:43 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Fri, 14 May 2021 18:19:41 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Thomas Gleixner' <tglx@linutronix.de>,
        'Maximilian Luz' <luzmaximilian@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Sachi King <nakato@nakato.io>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
Message-ID: <YJ6jHYM5oXyYHIX9@gmail.com>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com>
 <9b70d8113c084848b8d9293c4428d71b@AcuMS.aculab.com>
 <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com>
 <e43d9a823c9e44bab0cdbf32a000c373@AcuMS.aculab.com>
 <87tun54gg3.ffs@nanos.tec.linutronix.de>
 <bbf5d417ee0d4edbbed31f19ef40fad0@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbf5d417ee0d4edbbed31f19ef40fad0@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* David Laight <David.Laight@ACULAB.COM> wrote:

> > > It is also worth noting that the probe code is spectacularly crap.
> > > It writes 0xff and then checks that 0xff is read back.
> > > Almost anything (including a failed PCIe read to the ISA bridge)
> > > will return 0xff and make the test pass.
> > 
> >         unsigned char probe_val = ~(1 << PIC_CASCADE_IR);
> > 
> > 	outb(probe_val, PIC_MASTER_IMR);
> > 	new_val = inb(PIC_MASTER_IMR);
> > 
> > How is that writing 0xFF?
> 
> Sorry I misread the code and diagnostic output.
> 
> In any case writing a value and expecting the same value back
> isn't exactly a high-quality probe.

It's not, and it's not intended to be: 0x21 is a well-known port nobody was 
crazy enough to override yet, so that probe basically filters out the 
"there is nothing at that port, at all" case, which would normally return 
0xff, or in a few weird cases 0x00 perhaps.

Writing something inbetween those values and getting the same value back 
tells us that something functional occupies that well-known IO-port, 
pretending to be a i8259 PIC.

Which is what we wanted to know, given the context.

Thanks,

	Ingo
