Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA94A11236F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 08:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfLDHOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 02:14:46 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:46356 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfLDHOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 02:14:42 -0500
Received: by mail-wr1-f43.google.com with SMTP id z7so7086217wrl.13
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 23:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lO5JYKHbjBjFAq0hKJQ8JdWsBUBr0lRorddlK5xGyPk=;
        b=VdOyF9MctoPo2FlpH97gJ84zc3RuOHWcrmWi46ZfdzjUQZosnwbhEL6KXLHbrzHXgJ
         gVbDy0Qbxx970w8scqktMh/czzSudXcFQqneEnxdnXrGMkhLeMCWrVaTKM9+l0EF0m/q
         ZWL1wU6I9EG6Z6bs8L8aSQwyiLrZhg/Zne8FGSGffMP6Evl0fi7iCQ8KZ35zWZAySuQh
         QxuWGGnN3LY1rDYvyuFvq/bQr2Y9rr8g9USSw9120SSAjh6PvhGy5iHKUALck4NqJEss
         92T9e34vEs4LEIOQRTBXaeVxUrRqWMoPk3iGaUmrJ2GXEtFEPRiqvLzg3tiQA61hVx4o
         +9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lO5JYKHbjBjFAq0hKJQ8JdWsBUBr0lRorddlK5xGyPk=;
        b=uSD+TWbWjzKa5WF1+3iG2CfPvl1ev1yOOP1m0E4b8BvIPEMdKMSm8ixwUqEo2QHe3D
         qJvBtpmulj5/bxyTnvUc7rm6Neue+DY0XwrWGRbG7QRQ9+dzwUcQt9ileYbj4MvF5fcg
         oxLsJyi/UKo/ea/2oJX7ML6H5kazuNGqqkorrdRSmzh8YoU6pwMQNZ2ud4s87ABakrM/
         MrO6+OzyktoE/HVIOfckcGr6zPuNs7uP/9hflJmJEuAZZUN2lS3c3ZQPfO0qeTgHgTbE
         YuYVjwCERvRiRCb/aIj7M6+08P1RJ/35Kb4FQMGPSStbzQTIYkF0r6RDU/w5YtlKSclQ
         FPBA==
X-Gm-Message-State: APjAAAWNpnG+DZxo7KzyarLXM8WZnC3fshuzoMqloJEUOugglSHi2bop
        KKh2bFUcJiofxuF5NVoajD2ICmK06qKCkN6VHKde3tk1kcY=
X-Google-Smtp-Source: APXvYqxkCYGI+p78YxD0vMpDCOf34JWsyZusdUYM+ov1x2az86l8a9E5CKoqlLb7A9VDAvTMzQ9J1blyMLK3MGcLZ1o=
X-Received: by 2002:adf:f80b:: with SMTP id s11mr2129449wrp.12.1575443680348;
 Tue, 03 Dec 2019 23:14:40 -0800 (PST)
MIME-Version: 1.0
References: <CAPtwhKrmvw8wm1u_36YEoLgQ8pGe=v5xaV2RN4W6jVw3zOgeQQ@mail.gmail.com>
 <20191203230944.GA3495297@kroah.com> <CAPtwhKpZCequxTMzAcVcJ34EW4AFqNDcWuoud-D3nywpYxzx5Q@mail.gmail.com>
 <CAPtwhKqiKZtTGO_7Jpx9nEDhQu8LESvaZth4uHb5a8Ur+=65SA@mail.gmail.com>
 <CAPtwhKrCY4ZWFPYsr5N3LcAJOJVStN9Qb93-zk+GFRNVsfGxgQ@mail.gmail.com>
 <CAPtwhKoMk+AY2D9Akoh_v4fSTj9JtUT1k+DQ_qcuK=zbZSdpgw@mail.gmail.com>
 <CAPtwhKpjLswXm3fSZ6o0hiNxM2Zgj3zmfsLLPYtPpqmN91792g@mail.gmail.com> <20191204071156.GA3513626@kroah.com>
In-Reply-To: <20191204071156.GA3513626@kroah.com>
From:   Xuewei Zhang <xueweiz@google.com>
Date:   Tue, 3 Dec 2019 23:14:28 -0800
Message-ID: <CAPtwhKrpO2ARxua3ScdmXZGZYViz03DJydY0-e=t5dJgX-FjkA@mail.gmail.com>
Subject: Re: Request to backport 4929a4e6faa0 to stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 3, 2019 at 11:12 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Dec 03, 2019 at 03:37:36PM -0800, Xuewei Zhang wrote:
> > Hi Greg,
> >
> > I sent the backports which should apply cleanly to the 5 stable kernel
> > versions: 4.19, 4.14, 4.9, 4.4, 3.16.
> >
> > Does it work for you? Please let me know if I should submit them using
> > some other formats. Apologize ahead if my current format is wrong.
>
> That looks good, I'll queue them up later this week once the current
> round of stable kernels are released.
>
> thanks,
>
> greg k-h

Thanks for the help Greg!

Best regards,
Xuewei
