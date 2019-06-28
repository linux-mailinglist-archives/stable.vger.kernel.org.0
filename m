Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF725A27C
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 19:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfF1Rem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 13:34:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32913 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfF1Rem (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 13:34:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so7152634wru.0
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 10:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wfYsXjgMtSJMKRVcej6axjnBpa0bNSgyGbaA3V/sZW0=;
        b=QL+daD/S/+WS/smsjeTHTw9ZQlYVxzs1Hk5IrT5MoLHHxjQ41/WsN9x5rSz4rDY8cq
         bGs7JwpqrM9VhUGjWwn5AdA6O2FuhYND40p1hLKl9RN9eU1pMf2a9YXqVJsKKXjQ5fkM
         SbVL+xlN3Jmu1cGTVZ3M/3H2z4NUS7sldsTH1yONdPed0mfjY5JukxMYzhksHSUPdFnw
         CMIikWvPv1u0IEE/KSDTJEOHQrTaHyLQQTMvBuI+uDVJNaBk5D7CBu0UYTbr+4NIBm0p
         HMatXjCaSvKgTVQRKqFj6Bu+TObQ4ahJ9esshlrJqKbmLdEWZzc8oi5MSSwWAH6eQgZ7
         1XHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wfYsXjgMtSJMKRVcej6axjnBpa0bNSgyGbaA3V/sZW0=;
        b=k4QtaXh/w29xkN2/hcueCwQgf50C7ICiXOe8lITTIP95PicproPaDu/aSw4/NiPA06
         80zh21tKDUd/bdvnJ8PMvtQ/2ZmBXbLmU2p1xZubnKwL5w+6FnSxiqASXiSjIqDvWwpU
         nOcg8Tt+J12HKXbD+1eBT/gmt+HqcgJv0ehSGWhf0nKUMECGNUN7/3aMLWCzdQkFbp/L
         Hwy3+BEMxQ9hHV0OqbDSSO1rivh3BuLLo5WKow0JmobFPri5l9w3RqtcDs+6wmk3+8ds
         mjQcXUcVDjy8Z5EL2BXVf5bedMo5gROznAcn4D1Mg/F+4A8WZP1GgAh+g9Ntm6MadPBh
         TJFg==
X-Gm-Message-State: APjAAAX/5xfU0gX3ng91lGo9kFdaTLrG8d3hlkjTCK7YBajXK8H4bgM5
        i4PG/S/099e2mfIoAVHwYUqPHzA+uk3gu/5mvmyIMw==
X-Google-Smtp-Source: APXvYqwIMk+3js1vyyzfs0+8+SEezw5y0QHn3rHvhObht78rWwNV0/WRBUzjVvVk8VSbC/m9LLKB7FyHHrzBYPwfAQE=
X-Received: by 2002:adf:afe8:: with SMTP id y40mr8241222wrd.328.1561743279906;
 Fri, 28 Jun 2019 10:34:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190627205240.38366-1-john.stultz@linaro.org>
 <20190627205240.38366-9-john.stultz@linaro.org> <20190628055414.GA3380@jackp-linux.qualcomm.com>
In-Reply-To: <20190628055414.GA3380@jackp-linux.qualcomm.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Fri, 28 Jun 2019 10:34:27 -0700
Message-ID: <CALAqxLWop2uYWJSz3P8i+bqGqJD0v6mcYTjJ8szHma3qfkT5LA@mail.gmail.com>
Subject: Re: [PATCH 4.19.y 8/9] Revert "usb: dwc3: gadget: Clear
 req->needs_extra_trb flag on cleanup"
To:     Jack Pham <jackp@codeaurora.org>
Cc:     stable <stable@vger.kernel.org>, Fei Yang <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 27, 2019 at 10:54 PM Jack Pham <jackp@codeaurora.org> wrote:
> On Thu, Jun 27, 2019 at 08:52:39PM +0000, John Stultz wrote:
> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > index 879f652c5580..843586f20572 100644
> > --- a/drivers/usb/dwc3/gadget.c
> > +++ b/drivers/usb/dwc3/gadget.c
> > @@ -177,8 +177,6 @@ static void dwc3_gadget_del_and_unmap_request(struct dwc3_ep *dep,
> >       req->started = false;
> >       list_del(&req->list);
> >       req->remaining = 0;
> > -     req->unaligned = false;
> > -     req->zero = false;
>
> Given that these structure members are removed in Patch 1/9, wouldn't
> having these lines remain until this revert patch present compilation
> errors when applying the patches in this series individually?
>
> For bisectability would it be better to fix-up Patch 1 to also convert
> these two flags to req->needs_extra_trb in one shot? Alternatively you
> could sandwich Patch 1 between Patch 8 & 9.

Ah. Good point! I'll respin this.  Thanks for looking this over!

thanks
-john
