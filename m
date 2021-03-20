Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A2E342BE0
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhCTLOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbhCTLOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 07:14:33 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEFCC0613BE
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 03:50:12 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v4so11642891wrp.13
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 03:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ye3KfsXzi9dh3VxvINZWtd4ka7iKiH1UUioassuyPFI=;
        b=TfjreTWHIEM3VRJOb+WPiSuEyHgvCEvfIdBW5LpoJtM/XPrB/59WkubXNWA97q9otq
         xFrE4AypuZGdWzq6o6EB2nm5+p47vPA7POcA8OCvaf791eM5zF2lDNoRtM5xv5M0UmwN
         iosu3i4cTQpUV/2R0QIbMxprUJw+WI+P0D4LxBADKE6wX3fDEgo7IO14KDfsU5AfLwtR
         LbVKT9m0pQoB33x+zix6WcyGNXvq+tsktRxbaMYtv2I7KJvwdhj2KhFe7CJ+t8cL0jeI
         bM/QuJOHs9uvPg95TWEBd5oxghrdCX/3R57oA2LKfsarB/Mu2HLl2f0/0ez4KUdkBX3l
         9K2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ye3KfsXzi9dh3VxvINZWtd4ka7iKiH1UUioassuyPFI=;
        b=BG8Myjt+0BnEaqjGdAh6EcHZhM52OxdDdsy0tpSjZDpS7KX2sfHSNPcFOEIF8MgEqS
         vGvJ/P+zZEKjx1B4tPGvbMy8DhpPovRze68EgkIx7vclzI4tB9GSv8MC+2tdturnrOnT
         2TUjjhQuchip6vK7rvt6VSVPSi4lHcvN+LKjW1tEH+6B1yN00KGAN1NXDGJUvXQYdIEU
         sHlX4Icb8qsavjIOkFYnF4vGBQkjAL27tEEdVYKA377dAHYwprTPKo/Ce6C6v39VTN4u
         6o6YlmuTGTgzLR22z7AJACORxrLN3CjedsGmARQl9EKcl0wA4Z1jSt3aVwamodBvw999
         ytGQ==
X-Gm-Message-State: AOAM531zzaLHiKg3jk4cw5eW9G3GCXwgeIHYuFzaCAeZ9QHCkPFZRGnX
        4WcIF4WmSFH1VkE0ePHxS42n55969o4eMgTAxumroTVGpByE/DAb
X-Google-Smtp-Source: ABdhPJxn4Y8yOspMSSKyxrtiCxvTBsmy/3h+GcbfCoKVCjOZlTD03/pNj7Jg3FPpLvmNfeL0RYMahrpAv4j/E4FHoYA=
X-Received: by 2002:a5d:4281:: with SMTP id k1mr8812166wrq.374.1616237411342;
 Sat, 20 Mar 2021 03:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAFzhf4qk9aFhhEtraUo0b9Si2y5taYDgdGwVZoSJ9Yj-59RGrw@mail.gmail.com>
 <YFXRtrt5wPb8l0Sj@kroah.com>
In-Reply-To: <YFXRtrt5wPb8l0Sj@kroah.com>
From:   Piotr Krysiuk <piotras@gmail.com>
Date:   Sat, 20 Mar 2021 10:50:00 +0000
Message-ID: <CAFzhf4rbtm7KA_9oL0zZtPhq+zzcaRCSJacATT8wdND_m9KdLQ@mail.gmail.com>
Subject: Re: bpf speculative execution fixes for 4.14.y
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for the quick turn-around,

Piotr

On Sat, Mar 20, 2021 at 10:43 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Mar 19, 2021 at 11:56:18PM +0000, Piotr Krysiuk wrote:
> > I noticed that bpf speculative execution fixes are already queued for
> > 4.14.y except for f232326f6966 ("bpf: Prohibit alu ops for pointer
> > types not defining ptr_limit").
> >
> > It is important that for all patches from this series to be applied
> > together, so we avoid introducing a new vulnerability.
> >
> > For the missing patch, I see conflicting lines in the context diffs
> > due to API change that apparently caused import to fail.
> >
> > I'm attaching a copy of the patch that is backported to 4.14.y. The
> > only change comparing with version queued for newer version is that
> > "verbose" API does not take "env" parameter.
> >
> > Please queue or let me know how to proceed.
>
> Now queued up, thanks!
>
> greg k-h
