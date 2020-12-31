Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C4C2E7FA9
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 12:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgLaLc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 06:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgLaLc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Dec 2020 06:32:26 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91EDC061573;
        Thu, 31 Dec 2020 03:31:45 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id t16so19894770wra.3;
        Thu, 31 Dec 2020 03:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=NetuAQ3tAGo/yEGinEHsE/lyqwm3xy3dMQvLbO/Uhjg=;
        b=rOWefD88HPMFfm4hmIR//V8/ciZbGZtTbQ3U2eM/l0BG8xJR4d+5iDms+LuFGN0oJg
         sXuYm67IEJlb4fq3loobJlLHcahWTxFb9T6Uv5tOOiNIleCl8GrGE8yi+YHSOCnI+0i5
         i1SnkfpbHrvt1cZxcKSL1NRwDePjvPoktBjtgxuX7oKUa/cmp1ax2p3TfnqS6fhlebyG
         3XJu+zxFizxzW2U/kgQR2SGRNf6k2C8nLf1ffeL1NC3+PQeIWPoeXhBtEOHWAIaE0iMS
         Jp+4YThqaH2U1rI8AzAIMt6RtUqXlOou1QRwog8lypzEqmrbn7ZQW2nBMr1SEJ18fOJr
         vPoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NetuAQ3tAGo/yEGinEHsE/lyqwm3xy3dMQvLbO/Uhjg=;
        b=Np32TVOpcxRdBvsYwhTTavt8mbYH3QOMfjS1l4jAbrShiKNwSopzuuQ1G9P+hbd2LI
         aVfwVYNNpeDz4OAxyduZrBa9gpRfH89PhldY9sysiKLiOO9VPLvv+wtPrHY9Diig9L67
         qrEBe8tnlILo040yehBjFPTaWyGgYtvW/A37mjAwlckGYtgPHKszL/XgyTDGFZ6yr9Bi
         4h1PayMjEfZ2l4D1mYAZfY95Uf66emt3tVGoDR7NMYuA6h8VlQrvJSfZ4qw743Uf6ftZ
         Sc6yjLzBCgQ6FqoUkh4Q3HCLTh822b3kxAaOZvyP8tI3cNBpmvQ67BQa+hvjtWukzNnv
         ANSA==
X-Gm-Message-State: AOAM533QRYlwdOW0zTScfAGCFunvjfdlxplE9bBBXKl4EiB8wtKvwxZv
        Ved0D6a7iFMUlUzFfBhbl4k=
X-Google-Smtp-Source: ABdhPJxLy10Wo+8i9+R2td2BnVBE8yx8EwH27vZnUZlvKHJb70Ijtc+s+4bQNgVtyOIa/S3ADwdsKQ==
X-Received: by 2002:adf:d843:: with SMTP id k3mr64975335wrl.346.1609414304212;
        Thu, 31 Dec 2020 03:31:44 -0800 (PST)
Received: from cl-fw-1.fritz.box (p200300d86714220053af1ffdd671ac4f.dip0.t-ipconnect.de. [2003:d8:6714:2200:53af:1ffd:d671:ac4f])
        by smtp.gmail.com with ESMTPSA id t10sm67717146wrp.39.2020.12.31.03.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Dec 2020 03:31:43 -0800 (PST)
Message-ID: <8b005c64fe129fc2a283da90b2949b1fcb42e8c2.camel@gmail.com>
Subject: Re: Haswell audio no longer working with new Catpt driver
From:   Christian Labisch <clnetbox@gmail.com>
To:     Amadeusz =?UTF-8?Q?S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Akemi Yagi <toracat@elrepo.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Greg Kroah-Hartman <stable@vger.kernel.org>,
        Greg Kroah-Hartman <linux-kernel@vger.kernel.org>,
        Justin Forbes <jforbes@redhat.com>
Date:   Thu, 31 Dec 2020 12:31:42 +0100
In-Reply-To: <4c5b8a03-6508-541f-2a72-39cb3052b4f1@linux.intel.com>
References: <2f0acfa1330ca6b40bff564fd317c8029eb23453.camel@gmail.com>
         <efc6d5e8abc1da3cac754cb760fff08a1887013b.camel@gmail.com>
         <X+2MzJ7bKCQTRCd/@kroah.com>
         <a194639e-f444-da95-095d-38e07e34f72f@metafoo.de>
         <267863e8ca1464e4e433d83c5506ed871e3899b2.camel@gmail.com>
         <4c5b8a03-6508-541f-2a72-39cb3052b4f1@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Amadeusz,

Now, who has to do what ?
I assume many users will be affected !

Regards,
Christian

On Thu, 2020-12-31 at 12:20 +0100, Amadeusz Sławiński wrote:
> On 12/31/2020 11:50 AM, Christian Labisch wrote:
> > Hi Lars-Peter,
> > 
> > Thank you, please find attached the requested information from both kernels.
> > I freshly installed the fedora kernel 5.10.4 to give you the latest results.
> > 
> > Regards,
> > Christian
> > 
> > Christian Labisch
> > Red Hat Accelerator
> > clnetbox.blogspot.com
> > access.redhat.com/community
> > access.redhat.com/accelerators
> > 
> > 
> > On Thu, 2020-12-31 at 11:04 +0100, Lars-Peter Clausen wrote:
> > > On 12/31/20 9:33 AM, Greg Kroah-Hartman wrote:
> > > > On Wed, Dec 30, 2020 at 07:10:16PM +0100, Christian Labisch wrote:
> > > > > Update :
> > > > > 
> > > > > I've just tested the kernel 5.10.4 from ELRepo.
> > > > > Unfortunately nothing changed - still no sound.
> > > > Ah, sad.  Can you run 'git bisect' between 5.9 and 5.10 to determine the
> > > > commit that caused the problem?
> > > 
> > > The problem is that one driver was replaced with another driver. git
> > > bisect wont really help to narrow down why the new driver does not work.
> > > 
> > > Christian can you run the alsa-info.sh[1] script on your system and send
> > > back the result?
> > > 
> > > You say sound is not working, can you clarify that a bit? Is no sound
> > > card registered? Is it registered but output stays silent?
> > > 
> > > - Lars
> > > 
> > > [1] https://www.alsa-project.org/wiki/AlsaInfo
> > > <https://www.alsa-project.org/wiki/AlsaInfo>
> > > 
> > > 
> 
> Hi,
> 
> from reading provided files it seems that you use snd_intel_hda driver, 
> it should be possible to git bisect it between 5.9 and 5.10 as it wasn't 
> replaced.
> 
> Catpt driver is used on machines using DSP.
> 
> Amadeusz

