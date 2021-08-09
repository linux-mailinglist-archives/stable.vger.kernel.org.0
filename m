Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113B93E4A64
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 18:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhHIQ66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 12:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhHIQ65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 12:58:57 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E024C0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 09:58:36 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id a4so3852437uae.6
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 09:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c2sraGlp4Qavu1YnZf6eQp7El7E+d76ufqfmRz3CV7A=;
        b=w6xtbOlY3toakXjzFP3KVysMgDlrgLmJ+PL+2hSRx5XvDkR3I3wdmezCTaLORb1fLh
         R/hQM3t++s0s7ECBpEM/BwoVBLg8XqiRLyce/OMZT8dZu7Yxt7TQvnRTIn67CiebxgLB
         KsG2qN2xNEs6YSf4CbJXmRwX6H7+QVBNBB9gEoAKTPsmDniQlHWH3mWJCEiT3sHxxPQr
         O117eQPnG9auCKFU+HH09oOybDbe4qkOrqHvGbByKnmp4hBwTrlLtawxNnDBtfAEJ+R7
         S5RBWzh8/Cp7fv7a2NxNlkMB8PPVTg6CFjsrM+IcPWsIkt70snHqnbN4t5gSsg96WZ3L
         5e6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c2sraGlp4Qavu1YnZf6eQp7El7E+d76ufqfmRz3CV7A=;
        b=bHPtDKAyTsLtvj15ArRjmZZzTY+K20aHbLxI7B+iif5ONcbK3DczuuUQlAKrC7b/pb
         Y/+nSux7AmFGRwrPd9+ySRIx+m/jvIG7L1ZuqUh6qCOyfSvG/zd5AP3qzbIp83VsSXwG
         4LTZU83EqbmGtgvRTbbRALJ30RrJyxpAKUGyii4hwQ5Ahb6HGXceJwnX0HP4ZC/mcvp0
         CyqwD/Kh9BuqQggmIOwserM9H50DRxg9SNxoahXVVzAlxNeSuNFAoGxTA7I2GOhTfIo3
         +rTvhkrO3gWWPDqxMZer4IQIOFqz0+O5Ck6q/2+crt3tEIvH/Xug4XSMNBVLnGhF7SRD
         d+/w==
X-Gm-Message-State: AOAM533EYglaFeIi/bLt6ODJwHu6j6C4qw3vouTJPlN82hKVTcUdTtcj
        /icVLsNty94hMOkQAXHrIykQWkc76MSRPX7ld3SxeGFqH9KEKUHw
X-Google-Smtp-Source: ABdhPJwzOhnidcU58phqRCnBK8eQZwSasU5BW++z3gK7zRdZp0LFP+0cDImQZmTiMYQFFrSbogoMO+RACILowP2eNN8=
X-Received: by 2002:ab0:4e22:: with SMTP id g34mr16916470uah.17.1628528315685;
 Mon, 09 Aug 2021 09:58:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAPLW+4nyWAp99CTVy+wJ0rnbs9JpDvNaQaVityJi=sVPTkyDSA@mail.gmail.com>
 <YRDs8YYl1uEycsQl@kroah.com>
In-Reply-To: <YRDs8YYl1uEycsQl@kroah.com>
From:   Sam Protsenko <semen.protsenko@linaro.org>
Date:   Mon, 9 Aug 2021 19:58:24 +0300
Message-ID: <CAPLW+4kOfTMyfwzfBFdXYLqk-75rtp_ihFLsAYtb6h79LfRWjg@mail.gmail.com>
Subject: Re: Add "usb: dwc3: Stop active transfers before halting the
 controller" to 5.4-stable
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 Aug 2021 at 11:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Aug 06, 2021 at 04:25:17PM +0300, Sam Protsenko wrote:
> > Hi Greg,
> >
> > Suggest including next patch (available in linux-mainline) to
> > 5.4-stable branch: commit ae7e86108b12 ("usb: dwc3: Stop active
> > transfers before halting the controller"). It's also already present
> > in 5.10 stable. Some fixes exist in 5.10-stable for that patch too.
>
> Can you provide a list of the fixes that also need to be backported?  I
> do not want to take one patch and not all of the relevant ones.
>

Sure. Here is the whole list:

[PATCH 01/04]
usb: dwc3: Stop active transfers before halting the controller
UPSTREAM: ae7e86108b12351028fa7e8796a59f9b2d9e1774

[PATCH 02/04]
usb: dwc3: gadget: Restart DWC3 gadget when enabling pullup
UPSTREAM: a1383b3537a7bea1c213baa7878ccc4ecf4413b5
5.10-stable: dd8363fbca508616811f8a94006b09c66c094107

[PATCH 03/04]
usb: dwc3: gadget: Prevent EP queuing while stopping transfers
UPSTREAM: f09ddcfcb8c569675066337adac2ac205113471f
5.10-stable: c7bb96a37dd2095fcd6c65a59689004e63e4b872

[PATCH 04/04]
usb: dwc3: gadget: Disable gadget IRQ during pullup disable
UPSTREAM: 8212937305f84ef73ea81036dafb80c557583d4b
5.10-stable: 9e0677c2e39052ac20efae4474bb20614d9a88c9

Just "git cherry-pick" from upstream kernel seems to work fine.

Thanks!

> thanks,
>
> greg k-h
