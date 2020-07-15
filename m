Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D3C220C20
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 13:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbgGOLtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 07:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbgGOLtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 07:49:09 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840DEC061755;
        Wed, 15 Jul 2020 04:49:09 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id e64so1841690iof.12;
        Wed, 15 Jul 2020 04:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EJtrToUExV1qmgPKQ5wcLwVvOhkSi2Go4qi0eonxQqk=;
        b=e7shuYGwUt4R5oPb8p6uuFSBGdw63Pwu5mOnuLGFvOVtw+Gh5STG+NHto9s1IaQVgR
         TEFladTV0v+/G2a4Wlteau0j2/cD8BdXOwnScm2t0NGG+ds/klVDaG29A/yMSwg2nqFj
         B1PfIIk4rPUDQMstPVgx/ESYo7kjqZn6lxPHqM9lyG0UvmogikSboeW9QV1EnJrY1OkA
         4HQmrYeY2GIRQhcMkkRJVzEdeqTuenNcznbpdX3AR3PjnaqbV4QjpeRWYEAueT06lxiS
         Pn83q0m9aTLh4lJJQDp8PouQ/zw5KVR7bNBWPhXatjfmcKitOGjx49Yi6+BXrHYTTXTJ
         c4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EJtrToUExV1qmgPKQ5wcLwVvOhkSi2Go4qi0eonxQqk=;
        b=ItzwCpicbwZrox9tHhbqewmK1AGf4mCixXgim6UE71z/cObrZ1353VRYjP+CYy5+1c
         wjAi3ln49Ek9N6iEDJotq8I0yR2KyIl3MNUiAs4fDQlQjZrcl6MQJveHTYtFv2xBY+5g
         HbwIK9iWtiWHS55zTwqeaonYSA6Y0M9Wosw9T/bp5e8ca7W027yeeZrXQL0b3cNCces2
         QvA3A0IcfozPZkGpGZcIITSYVKmnBh/oNVDkvB9pJ49jWQd97z8cxxUbv6Dfpdt6/sd2
         a0NdwUq2NghBj72lGUVarAUf0SUiP+vCgMdN1zySeFxH+OR7WYB/WdkhN1vqWvFLiB5N
         ctRQ==
X-Gm-Message-State: AOAM532TtVeTeDzazlj2mkbdtFh2y+Uhbxgo20pFNdzUJgTPqIFEmxsg
        Ie7+tQpjAP9FLtZ3ZQIqWSeMQAetXZfY72ExfDQ=
X-Google-Smtp-Source: ABdhPJyllEzZprr7CRw31PdknfhagqCIlpavNXQvf5ajsusHxrlUzk8Y3NspGuPzKLiZEYM6U2hgyNJTecoP09mXR4I=
X-Received: by 2002:a5e:8f4b:: with SMTP id x11mr9255230iop.90.1594813748738;
 Wed, 15 Jul 2020 04:49:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200714184115.844176932@linuxfoundation.org>
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
From:   Puranjay Mohan <puranjay12@gmail.com>
Date:   Wed, 15 Jul 2020 17:18:57 +0530
Message-ID: <CANk7y0gpHGAvSiELbvdhiohD299efrDVYs1jYdDxM1bR-wWr3Q@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/166] 5.7.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 12:27 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.7.9 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
Compiled and booted on my computer running x86_64,
No dmesg Regressions found.

thanks,
--Puranjay
