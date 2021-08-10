Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3BC3E82C8
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbhHJSRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbhHJSRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 14:17:00 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88D3C0532CF
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 10:55:51 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id h17so8142922vsu.0
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 10:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i36tNyUdj9HOzgbjgbpX0/wruZ0ovuk6xNxFggoDO48=;
        b=fSNtR60ghKUS+gwVG7G3x1pd64QvugYTgq6ckQmaAUNqk0Z2bfwoYSdqZy8IjI3w76
         owD4iVlr5ZvwSqSFMJlKoKf9/lskK49uWA+LTq5sriYuWCyByuc2zLJXk6rML1/WWU3E
         nQQ7jGZaVUtBBdlRvYho4kxeGvcp/OnKbX0XL0b4ciAO13t2ice4ZYHl+1wDvFu9W3jL
         yRL6BHJ3mBuHuaUHBSxXs6fO2/QFh831h4ZCA7/9aHa/mMMvApnh7K+tf6UpbNZGUGBf
         4e+QqOt9x9k70zq1Mc0+HRAJO2eTSP1sh99GtYB81t59QxlwEWIo2ZzNwKT90Kx8byi4
         ePRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i36tNyUdj9HOzgbjgbpX0/wruZ0ovuk6xNxFggoDO48=;
        b=EyjzpCBpb/xscoUgyRxx/pNAEPIRxDyA0JkpAr+l9lTDNxZ5GF2s9XyZnVQLzBVkyu
         YmQ5VVp12+RG8mQq4spIs+URWQkdItZicy4qCRjebUsNkaj3Lmi0N+CzpX4HRB4CyPr2
         U1yS6lYusvBAKF0TDC9UU8wam8lJ0UHu8LUbwatHIE3efaa2bUximx9em0+dRCONh5QC
         rKekMOYSs9uhAHQ1qU7kJEH9ZdED354kvsAlnGk6zNbXAFtlS42lT/+XQjXLnOh8tdJT
         J+7oAIAkBCYrejt09D+S/ABcDf76ax4SKm240x+hVXnrCwLLNCrceQoVFWN0S3hABo9n
         BL+w==
X-Gm-Message-State: AOAM532aVo1P8BzCUTXRjSqxd8I8gIoyeWXdKP5j0iSp4nHSvQvkOipz
        WIFZa4xAmaAnKax1tnwdkeQew/HshhRlvJh6iAUoaooDWEm5zA==
X-Google-Smtp-Source: ABdhPJx0n1yX3U9eqnE67DFs2qdZtr379KBNUrJGd9gQy4Tvk9Ek88kYydQnBvnq5W9BHtxvvAjY28xndDfzy1Qe8Pk=
X-Received: by 2002:a05:6102:942:: with SMTP id a2mr10779409vsi.30.1628618150832;
 Tue, 10 Aug 2021 10:55:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAPLW+4nyWAp99CTVy+wJ0rnbs9JpDvNaQaVityJi=sVPTkyDSA@mail.gmail.com>
 <YRDs8YYl1uEycsQl@kroah.com> <CAPLW+4kOfTMyfwzfBFdXYLqk-75rtp_ihFLsAYtb6h79LfRWjg@mail.gmail.com>
 <YRIqUe9KBd2+6pAd@kroah.com> <YRKSuxwJk6N05Iv6@kroah.com> <YRKUDDmz3ylrUBmd@kroah.com>
In-Reply-To: <YRKUDDmz3ylrUBmd@kroah.com>
From:   Sam Protsenko <semen.protsenko@linaro.org>
Date:   Tue, 10 Aug 2021 20:55:39 +0300
Message-ID: <CAPLW+4=BngUFjt76PmWU5H-US6SL4bZ0WTFsBeeGZjnirLYh9Q@mail.gmail.com>
Subject: Re: Add "usb: dwc3: Stop active transfers before halting the
 controller" to 5.4-stable
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Aug 2021 at 17:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Aug 10, 2021 at 04:52:43PM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Aug 10, 2021 at 09:27:13AM +0200, Greg Kroah-Hartman wrote:
> > > On Mon, Aug 09, 2021 at 07:58:24PM +0300, Sam Protsenko wrote:
> > > > On Mon, 9 Aug 2021 at 11:53, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Fri, Aug 06, 2021 at 04:25:17PM +0300, Sam Protsenko wrote:
> > > > > > Hi Greg,
> > > > > >
> > > > > > Suggest including next patch (available in linux-mainline) to
> > > > > > 5.4-stable branch: commit ae7e86108b12 ("usb: dwc3: Stop active
> > > > > > transfers before halting the controller"). It's also already present
> > > > > > in 5.10 stable. Some fixes exist in 5.10-stable for that patch too.
> > > > >
> > > > > Can you provide a list of the fixes that also need to be backported?  I
> > > > > do not want to take one patch and not all of the relevant ones.
> > > > >
> > > >
> > > > Sure. Here is the whole list:
> > > >
> > > > [PATCH 01/04]
> > > > usb: dwc3: Stop active transfers before halting the controller
> > > > UPSTREAM: ae7e86108b12351028fa7e8796a59f9b2d9e1774
> > > >
> > > > [PATCH 02/04]
> > > > usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup
> > > > UPSTREAM: a1383b3537a7bea1c213baa7878ccc4ecf4413b5
> > > > 5.10-stable: dd8363fbca508616811f8a94006b09c66c094107
> > > >
> > > > [PATCH 03/04]
> > > > usb: dwc3: gadget: Prevent EP queuing while stopping transfers
> > > > UPSTREAM: f09ddcfcb8c569675066337adac2ac205113471f
> > > > 5.10-stable: c7bb96a37dd2095fcd6c65a59689004e63e4b872
> > >
> > > This patch did not apply cleanly :(
> > >
> > > Can you send a working set of backported patches so that I know to get
> > > this all fixed up correctly?
> >
> > Ok, I think I got this myself...
>
> Ick, no, the 4th patch had problems.  I need a backported series,
> thanks!
>

Sure, will do shortly. As I remember, kdiff3 resolved those conflicts
automagically for me (correctly).

> greg k-h
