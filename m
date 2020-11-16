Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F072B4D82
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 18:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbgKPRh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 12:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387497AbgKPRhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 12:37:55 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2CBC0617A7
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 09:37:54 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id i17so19986010ljd.3
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 09:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0hFcYQjYTxN6TPp3Kdg1NeqlnTpUC7G+cLOAuMz+zHE=;
        b=HKbDpA8RbHc7R9WeYnYhMYC3gxw9weFs3lMu3SDaX0XkAID5B1sf9E42rWBynbT+Sx
         yT3uEIqvHZJzSY1G2ko5rQ9hLa877Siaz6/opPHEMxfi0DtcEJEuWQQNCPcD356BV5kx
         d7ODwPPcAS09cbveKqn/VdCocdxDt/vjlquyU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0hFcYQjYTxN6TPp3Kdg1NeqlnTpUC7G+cLOAuMz+zHE=;
        b=CtIq7kX3wR8hED+8fdIHENjXBiFBlIejzRWOxe/OLVnQMLBUF/GKGmebQiarVEUM9N
         Ze1ZdGYMytnG2aY/XdYxtdG0v76KW8VtLDLdsYifF8C442f0MZgzhmZrpLiQh3+2teqj
         EodC+s573osvqYYOSGroFczkT8ajiq+fvOxmwIyI7SKOkU/sOvc1fs+i82HAnOjaTLMK
         c0Yu/UTDwWUgRRbv4K/D24AVaUZMSdAl0xLQZm2gjJIy2WvvtCQdOQHO1H19PPFTA7an
         1X/sMXwEdNh7ksU5gsXeVObHbQfiYQkbLfI4zgmFi1NIaP/ug32fNsVp+FtxmNaynjXt
         lx3w==
X-Gm-Message-State: AOAM533cruEHjMzMTgXcpt8T4aNyempBKGOmmLe3him6Pt3FrQTtzHx7
        dHVgn9KXzkxL/5XXRMELL6JJAa0ZVlIZZA==
X-Google-Smtp-Source: ABdhPJx4+FcZgM9YtyDBqoHu3zyfYzhvys2a3ASsAONqNlx3XFYSFXwfBTYz0wGQnVX5jXDdQFRH2Q==
X-Received: by 2002:a2e:8883:: with SMTP id k3mr210819lji.80.1605548272853;
        Mon, 16 Nov 2020 09:37:52 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id 13sm2871430lfy.90.2020.11.16.09.37.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 09:37:49 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id 11so21113175ljf.2
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 09:37:48 -0800 (PST)
X-Received: by 2002:a05:651c:2cb:: with SMTP id f11mr153620ljo.371.1605548268341;
 Mon, 16 Nov 2020 09:37:48 -0800 (PST)
MIME-Version: 1.0
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
 <20201114111057.GA16415@infradead.org> <0fd0fb3360194d909ba48f13220f9302@huawei.com>
 <20201116162202.GA15010@infradead.org> <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
In-Reply-To: <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 16 Nov 2020 09:37:32 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com>
Message-ID: <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com>
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in ima_calc_file_hash()
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 8:47 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> This discussion seems to be going down the path of requiring an IMA
> filesystem hook for reading the file, again.  That solution was
> rejected, not by me.  What is new this time?

You can't read a non-read-opened file. Not even IMA can.

So don't do that then.

IMA is doing something wrong. Why would you ever read a file that can't be read?

Fix whatever "open" function instead of trying to work around the fact
that you opened it wrong.

             Linus
