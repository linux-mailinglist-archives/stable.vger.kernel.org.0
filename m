Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B391E8817
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 21:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgE2Tpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 15:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbgE2Tpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 15:45:36 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DACC03E969;
        Fri, 29 May 2020 12:45:34 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id q11so5270112wrp.3;
        Fri, 29 May 2020 12:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q2UX0XT3q1+VKkrr7ERRQ3ssJ5O6tWEzOH6RrBra1fk=;
        b=SakfLbfwKTPnrqNnMBMz7f9c+cRsebh8kjbJESDKLw9QecZWLqOmzI/F1idNzEafqu
         OI7AKeqx4bu4VDboyT7s/45zCruLvLsbhKJOS6WZvV3omqC+GJ1TKmVzxL3z6bA6mXdG
         tmrW67imzQ0UNAOoUuCBr7FSrPBZ611l4rJtl35oYEeqTZ1XtGTUs8BS2PZFIS4zsHgK
         WEGHQe8pblEpAb4WGQ/BE6HISfUwt7v7y4r5Ykal3Ei8cbb2UtAAaYkMc6bwZnveUJ6l
         Ff2TyEmZScwiXObyV70ozN8yDGu+vau2tYOaRLF/xL4QaoxYw8Jd6zMXw64N+3HLrOrH
         Ti6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q2UX0XT3q1+VKkrr7ERRQ3ssJ5O6tWEzOH6RrBra1fk=;
        b=cS8sg9hwCULM00lukFzocQkU4kWxNl8861/WpJuebjrS7Dx9Dzz3Az5FRsyDdHChYK
         ytZwI/z1ld5uKN8sxpbq7TUlcRifRpgAQQu0e88JAqw28UJm6/67IxGnQ+vzGg4vEqhw
         YVMRTLm3xfkpR1GKObfKWnCQDfL6xl+pXhxum6/dI1mAzHsLu+5fbz8rqmOjxqrWLSk1
         OsNdggXsfFExr8Yk7NASdUE2iPnBqB7TT/VLdqiH1m4GHq55W3O2XZ2PsCnemZzpNrrQ
         mnsAl5u7Sa73cQpkpYgnTTFHVHvFpftRZkZl8VcrwyHLzE9AITJY9rNpyjgC/Y8TYLcf
         AhPA==
X-Gm-Message-State: AOAM531XqMwwkA9piZgIeYASquI/tIutYIzOf2Z87dY26EEv8fNPU9xW
        xX2xDv11QOp36B6vtp7HgTnpoWdo4Im/xrRkHFI=
X-Google-Smtp-Source: ABdhPJzMyKqPdvKFf/JlW4XvMDAA/Kn5DzwpnR5HlZnSWWs8FRytUYkbN1WwJxW8aBz0E+2fDUWEnEpU9w4Wr9tKy40=
X-Received: by 2002:adf:e3c4:: with SMTP id k4mr10017124wrm.262.1590781533277;
 Fri, 29 May 2020 12:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <1d3bae1b3048f5d6e19f7ef569dd77e9e160a026.1590753016.git.hminas@synopsys.com>
 <CAD=FV=W1x_HJNCYMUb11QNA8yGs0heEiZzHZdeMPzFaRHaTOsA@mail.gmail.com>
 <0f6b1580-41d8-b7e7-206b-64cda87abfd5@synopsys.com> <CAD=FV=UCMqyX92o9m7H40E3sHzAFieHSu3TUY953VqNb-vuPPg@mail.gmail.com>
 <CAJz5OpfDnHfGf=dLbc0hTtaz-CERsQyaBNeqDiRz7u4jMywNow@mail.gmail.com>
 <CAD=FV=URUeE55xyL3iB5GmS7BRoDG2ey3UE4qSwwc7XZHR0c-Q@mail.gmail.com>
 <CAJz5OpdMDumfdYC+aj0N20p4qVEkEkHhNY3uKest6RSpPtrDWQ@mail.gmail.com>
 <CAD=FV=XsLA3w2QPcNF3-mgZbZoGsz4kg_QvHcoZV=XTVDYhnSg@mail.gmail.com>
 <20200529190031.GA2271@rowland.harvard.edu> <CAD=FV=UUULUgw_fnpbv2b-m8=CrOJimOba+ewRJj_hMB7niK1A@mail.gmail.com>
 <52f936c5-7f3f-5da0-33b8-3e6d4a4008d1@synopsys.com>
In-Reply-To: <52f936c5-7f3f-5da0-33b8-3e6d4a4008d1@synopsys.com>
From:   Frank Mori Hess <fmh6jj@gmail.com>
Date:   Fri, 29 May 2020 15:45:22 -0400
Message-ID: <CAJz5OpcP860ANLLZELB7GNSsGAY2SvataZVAMyQj_HG0udkOmg@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc2: Fix shutdown callback in platform
To:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Cc:     Doug Anderson <dianders@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 29, 2020 at 3:33 PM Minas Harutyunyan
<Minas.Harutyunyan@synopsys.com> wrote:
> So, can we conclude on this solution?
>
> dwc2_disable_global_interrupts(hsotg);
> synchronize_irq(hsotg->irq)

That solution is fine with me.  Disabling the dwc2 interrupt sources
in initialization before the handlers are registered is also worth
doing, but it doesn't have to be in the same patch.

-- 
Frank
