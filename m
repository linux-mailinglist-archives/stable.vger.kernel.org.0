Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037452A50D4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgKCUXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgKCUXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 15:23:24 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4956FC0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 12:23:23 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id f6so16028998ybr.0
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 12:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BHZrUmGJZveYgc6+fxUvFSdW+LIoK3yyYTSw6pTdn+0=;
        b=jMAiPmxb7r0Hbe39vbuT73C1vrPGo4rQMLA51SLuHgQ2Yx2Gfr09cN49etlldIneuP
         mV/ZWag3Fak5MborIxTZep+hoVW86z8rpR1/EcYdBjWvU4wsHhYD9s0cgzD8BFavtQ9/
         BkzqM+wsQv/Do81/zW4y+JUg/MGgklBxAheMVexUaMnisql0h3TmahrhnZ8SWK7ksa/t
         K/NwRUYh85edAedc8dE8gXw3Pd3gZDnEz+wSftGnCsWb3M4BOH+V2pkHvQgFhQ4WzrGs
         3k+xT/SG/HfdcyN1Y24lUt7UK4zDFdyCakRDO2P4kjO0eVNi6TZs/JDa+ZzkjDwCcoSi
         lrYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BHZrUmGJZveYgc6+fxUvFSdW+LIoK3yyYTSw6pTdn+0=;
        b=VlW9KjxpXbx+ii03d1RQjVA4z0PoSU/mvfJYbEdTA5kftv6IcfWjLPiA1D8SlplBtA
         U8V9y6t8sIFm4firzjPSUuzX/Ep4pBa6xXDOm3Mn0VwrqZ2f4hgqdatB4Ruzt3OEo3pT
         gFMv6aQ6d2eDIPP84SC87/ERfHNaTaA+BDX8mk5UDNchVlJiopJ+I8iKqxBsyGUu1VbO
         1lDThIAW+lGTJodbNXE0LdL8WAk/Bnrp+mQda3ZpgVC4JCmb0piRqG73BdESlGMjOIqd
         LBX0vXHmNnAuDlUCJahhlU42MRhxILY9oVn//M5zb7ttWcQe9qJ9uZ0BWM0qcmAi1LgC
         Vpfw==
X-Gm-Message-State: AOAM532CxJUvqGRdOn5FayRqPggHZasotVC9Ta9syLZ73nePwSmsiTw5
        BCIRdczkxlxQN33Inmq5rqjMRe1UzkPMZ2hzWO3Bo62e
X-Google-Smtp-Source: ABdhPJysdgtG/hIpnAIyweuimLl6MuBePKHAffsSrrG3+SmnGKGokq/2AVdVvfyFCV2NLr0fX3MKfd4TUpmLHKRwxFg=
X-Received: by 2002:a25:8190:: with SMTP id p16mr29138664ybk.134.1604435002598;
 Tue, 03 Nov 2020 12:23:22 -0800 (PST)
MIME-Version: 1.0
References: <20201103162903.687752-1-alexander.deucher@amd.com> <20201103184925.GB173459@kroah.com>
In-Reply-To: <20201103184925.GB173459@kroah.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Tue, 3 Nov 2020 15:23:11 -0500
Message-ID: <CADnq5_NcnS74fP1tGu-mvUH4FCRc+5jTb06qcarDW_+VovXhSQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] backports of upstream fixes for stable
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "for 3.8" <stable@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 3, 2020 at 1:49 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Nov 03, 2020 at 11:28:55AM -0500, Alex Deucher wrote:
> > These commits failed to apply cleanly to stable so I have
> > cherry-picked them from Linus' tree and fixed up the conflicts.
> > The original uptream commit is referenced in the commit message
> > as I used cherry-pick -x.
>
> What stable tree(s) should these go to?

5.9.x

Thanks,

Alex

>
> thanks,
>
> greg k-h
