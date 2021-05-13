Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E012737F5C0
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 12:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhEMKkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 06:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbhEMKkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 06:40:23 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07480C061574;
        Thu, 13 May 2021 03:39:12 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gx5so39184041ejb.11;
        Thu, 13 May 2021 03:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UtUNJRyrclRlq2GZYbMBzdxMc4UcBRTvZYokrHl2QGk=;
        b=PZXgd9dJdsiP4g4TY8MjbZtvQLpaGLv9KmNndTy/1i8A2axVajesSq0AV49uvarHW9
         jyFeJZQMXYxNzoCXUW7aDSQe0mdPApgOvShf83cYZ62Z1SzRUw1m7cjQVuVYfSqJYjZe
         Kfkvoniy0iNgr3C1bI7FHZTJEOy2LScoeS30fUjF3t9n40ldwnQzJs2J/qDWCk1/gb+D
         hGAhiFZblUfN+4sv06aEND8NAOZSkj9hmVVWt98y+drh3p42YKDFlCs9uhss+OZNOGxe
         ST0FHEtsMCb1CgU3WSwrmMVrB3aH25h2pjo0IFYVw4xCI9yecej0tcJgy/FmKjdhd1IT
         /lLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=UtUNJRyrclRlq2GZYbMBzdxMc4UcBRTvZYokrHl2QGk=;
        b=MxI/DlctmQ81Hh/TWDIaJu10cJPnXBkGza4WsIKKBxbCzMOVAVJRGup/lfxVP68FKh
         gd6eyTd+PJoyOd8xjgEuH6yTC0FSM9jtkdb7nvhevhTJDyFQxStIdqAsgn8MCd5O7mAf
         s+n+uhwIerP4OaDbKoXfuB8lF1DWsgvB8Kr8ysXFu/cLx6xqD1uMPSfNHXwDEt2oYuR7
         asEhmyrPLlieVHSFHRMSNbPA8mPzH4qdj8yJYLoSTRr2dEiARR0KJodn0fL5lsW4fbzR
         LAt+u52mMmgTKU8mLexYDPCRje6TtWUiMolNvz2B+k/JXAMKQdhDuS9DNysZZfWZVTot
         jFLg==
X-Gm-Message-State: AOAM53009yCH9y6N9IfBEpkZrcLrlj4vkNoX7OIdTYy7SNTEMDG5e33H
        juXM9ttgtOymUb71RAq73Sw=
X-Google-Smtp-Source: ABdhPJwIl28mdtghWAjSftlijbsM9F1wEfkGpaU4F/Bep3N1rDKnkOHtqR7UxnyQIRHnszycqNUCMw==
X-Received: by 2002:a17:906:1e0b:: with SMTP id g11mr42469971ejj.291.1620902350840;
        Thu, 13 May 2021 03:39:10 -0700 (PDT)
Received: from gmail.com (0526E777.dsl.pool.telekom.hu. [5.38.231.119])
        by smtp.gmail.com with ESMTPSA id k20sm30488eja.10.2021.05.13.03.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 03:39:10 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Thu, 13 May 2021 12:39:08 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Huang Rui <ray.huang@amd.com>
Cc:     Alexander Monakov <amonakov@ispras.ru>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        "Fontenot, Nathan" <Nathan.Fontenot@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
Message-ID: <YJ0BzPs0WPJ42qG1@gmail.com>
References: <20210425073451.2557394-1-ray.huang@amd.com>
 <alpine.LNX.2.20.13.2105130130590.10864@monopod.intra.ispras.ru>
 <YJxdttrorwdlpX33@gmail.com>
 <20210513042420.GA1621127@hr-amd>
 <YJz7fp17T1cyed4j@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJz7fp17T1cyed4j@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> No need to send v5, done!
> 
> I have a system that appears to be affected by this bug:
> 
>   kepler:~> lscpu | grep -i mhz
>   CPU MHz:                         4000.000
>   CPU max MHz:                     7140.6250
>   CPU min MHz:                     2200.0000
> 
> So I should be able to confirm after a reboot.

'CPU max Mhz' seems to be saner now:

  kepler:~> lscpu | grep -i mhz

  CPU MHz:                         2200.000
  CPU max MHz:                     4917.9678
  CPU min MHz:                     2200.0000

Thanks,

	Ingo
