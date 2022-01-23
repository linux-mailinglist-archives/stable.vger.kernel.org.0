Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB07F4971A1
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 14:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236438AbiAWNc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 08:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbiAWNc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 08:32:26 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D0BC06173D
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 05:32:26 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id z7so4549145ljj.4
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 05:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=embecosm.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=cE6Axky5J7q71j8VqIGIKtEH+qBJqkdNssC7NWs86H8=;
        b=fxPH+CMyD8ijeP+PzzSwa9fAaxhxpX3i6NZy7SQ2LBTrTOcRyWNDJPMcDSWmtI84/F
         i6fY5XaVrBqDe9GxipWwsn648QK5z96KzrOyFuQ1bUdG2he6eGH+4mgWfmuJeNFjy8sc
         hmYB3qqTtBFlySvIP/RTTi/WK3wTtpET2vYWgWO5Zd8j3+uOBTsLqrg9X0lxJfcM6BUY
         UBZchkynCaIrys3hcH8ZT08Mqpplxb9PJOgNmy8pTE5UdsH6MUgXBBV84SrufPVn2djO
         aao+ytLeDTLvci62sXwZOSOmkvGMiVVLzNeZDMMKPYul6K1omosB0X9UGzUpnqjah6B+
         gFmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=cE6Axky5J7q71j8VqIGIKtEH+qBJqkdNssC7NWs86H8=;
        b=2wX9fciBkEFB+bLMGLF6Cq2mdvyk2FmxKxs7OQ2Csjq5sOgZNzKY5Xy3Dwqf+gv2aH
         KwbuB4NtUNmrJekLYBj26xHf7+WrVTme2fAE6tE5ycA6n3rCimB1Y0vsxxS9NEuHVBqV
         B5auFiMioB20LxeOKExsZToztoq8fkG8va1L9ZnOceP8AVABSsBI/pIQ8kciBalS9LaS
         zzgmLq6Fdk/iSQleySfO4aqBJ+qonVZkG7sRzfe69sIh1e7gxIQj9flcVFAqGra7Rvq4
         nincmR+f+hADOCyawKVZW7IsWQpumpDB7PafZcu+vu5bIKU+YBrQkV15EpIDjxNSDW7U
         OKlw==
X-Gm-Message-State: AOAM530LD563Vy6quOXn9GsKMcMZuT95wcR95hwJtRQDtd9EOZPe/0I0
        D7WSibDgoymcpIt6006kAByjSg==
X-Google-Smtp-Source: ABdhPJwVKBBfitqoZV7BPsMNJS5lEhfb0kTHUARViYS1GnX/vzLgZD+rzB+8fN3ejh16YYF4XwGCIQ==
X-Received: by 2002:a2e:9b9a:: with SMTP id z26mr8315854lji.381.1642944744222;
        Sun, 23 Jan 2022 05:32:24 -0800 (PST)
Received: from [192.168.219.3] ([78.8.192.131])
        by smtp.gmail.com with ESMTPSA id br24sm230913lfb.175.2022.01.23.05.32.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jan 2022 05:32:23 -0800 (PST)
Date:   Sun, 23 Jan 2022 13:32:21 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@embecosm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Jiri Slaby <jirislaby@kernel.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tty: Revert the removal of the Cyclades public API
In-Reply-To: <YeWx5aKmG44sWPEI@kroah.com>
Message-ID: <alpine.DEB.2.20.2201171827130.11348@tpp.orcam.me.uk>
References: <alpine.DEB.2.20.2201141832330.11348@tpp.orcam.me.uk> <YeKDD6imTh1Y6GuN@kroah.com> <alpine.DEB.2.20.2201151231020.11348@tpp.orcam.me.uk> <YeWx5aKmG44sWPEI@kroah.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 Jan 2022, Greg Kroah-Hartman wrote:

> >  Because they have become a part of the published API.  Someone may even 
> > use a system using headers from the most recent version of the Linux 
> > kernel (though not necessarily running such a kernel) to build software 
> > intended to run on an older version that still does implement the API.  
> > Times where people individually built pefectly matching software from 
> > sources to run on each system they looked after have largely long gone.
> 
> For hardware-specific things like this, it's not the same.  I can see
> adding the .h file as empty just to keep things building, but if no one
> is actually ever using the structures and definitions in the file, it
> should stay removed.
> 
> In looking at the file itself, it just looks like it wants a single
> structure, struct cyclades_monitor, and then never actually does
> anything with it.

 According to the error messages I got when I added the missing structure 
only it refers a number of ioctls as well, clearly making use of them 
somehow:

.../libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc:836:35: error: 'CYGETDEFTHRESH' was not declared in this scope; did you mean 'IOCTL_CYGETDEFTHRESH'?
  836 |   unsigned IOCTL_CYGETDEFTHRESH = CYGETDEFTHRESH;
      |                                   ^~~~~~~~~~~~~~
      |                                   IOCTL_CYGETDEFTHRESH

etc.

> So I guess I should submit a patch to the llvm developers to remove
> these lines and add back the single structure definition to allow this
> to keep building now?

 Side note: I've encountered it with libsanitizer bundled with GCC rather 
than LLVM; I don't know what use of libsanitizer LLVM makes or what their 
maintenance/release policies are.

 You can't add anything back to something that has been released long ago, 
e.g. <ftp://ftp.gnu.org/gnu/gcc/gcc-9.1.0/gcc-9.1.0.tar.gz>.  OK, it's 
less than 3 years ago, so not very long really, but the same applies: that 
release has been cast in stone and `gcc-9.1.0.tar.gz' will be as it is 
forever.  A user will expect to just download it and successfully build 
with their system, be it now or in 10 years' time.

 Of course reality may vary, but that is only supposed to happen because 
people make mistakes and not because they deliberately and unilaterally 
terminate a contract such as an API is.

> >  Well, they have been exported, so they have become a part of the API.  
> > This user program may not use them, another one will.  If you don't want 
> > an API to become public, then do not export it in the first place.
> 
> That happened a very long time ago, for hardware that no one has, sorry.
> 
> So the "ABI" broke when the driver was removed.  Given that no one has
> the hardware, no one noticed the breakage, so there is no breakage :)

 The ABI is still there, that is if a binary that has been built according 
to this API tries to use it the kernel with the driver obsoleted won't do 
anything unexpected.  It will of course return some kind of an error, but 
returning errors has been a part of the API and therefore any sane program 
must have been prepared to handle anyway (e.g. driver not configured in, 
hardware not present, device on fire, etc.).

> >  So it shouldn't have been a part of the user API in the first place.  
> > Given that it has become a part of it it has to stay, that's the whole 
> > point of having a user API.
> 
> But what user program uses that value?  I can't seem to find any, so
> pointers would be appreciated.

 Well, an API is an API.  A contract as I pointed out.  Such a program 
need not be publicly available and we may not be able to trace it.

> I'll gladly take a patch that just adds the one needed structure to keep
> this file building.  But that's all that is needed unless someone can
> point out other code that needs these definitions.

 Well, I don't feel like arguing even though I don't think it's the right 
approach, so taking your word for acceptance I'm sending v2 adjusted to 
your requirements right away.

  Maciej
