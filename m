Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B01421262
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 17:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbhJDPOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 11:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbhJDPOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 11:14:04 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47919C061746
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 08:12:15 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 145so14757214pfz.11
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 08:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EdTnE8LHxQ5qsE4h1mP+l9YCbW0cQHMMcRYNQpAyjtM=;
        b=exjYSrq4nXX2bwlK/2PGFh3YatBUKKVQg/gE7KJsBuLl6SQaf6E04NxfIRMWAkE45I
         JPv6cqcsZZIbq6L0ae+j8nVrhvYd72crStjb8hq99tcCUXbArzeUaIjrfptEAKNrTQvc
         82D9YFejSdeTzDgK7ETp1XLyaXGxfcvkOmXKpTlW7Gw5VUDTyipYR6T/BlCA9+X1eyTq
         Ni0EyuvIXThmmXR/IAoilgnjmcHJoQfchtUDpvj6NJw5BZ0lEJApzNN4z7SrD8yP/Qw1
         6gQYhdXny+lpzvweH7r1dESb++NDEsurtG0OFX7hmGEcr+Cb8zPdRm0aO2Fh8HwqfcmK
         tp2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EdTnE8LHxQ5qsE4h1mP+l9YCbW0cQHMMcRYNQpAyjtM=;
        b=zoY18i1sxLfWQHXmqzC9oacn3aKmIwqz/n8I5RYLv3K8jdJwhBHOwDlXD1OQ6h/QZy
         /p+zsjNebOOaGCEScyebOljCnGLRav/bOgGJgWK80iGWwmS5G0FVCgg9ukikezxxjyDl
         djsaqLevNdrbkc0jYoEadv6VXEHomGSkNQ9UfQSzzcMBho1K9UTaR/Yg2XVP9Dc6S9XK
         gC0diVoX5TrdCR4Zj6VrC8VMphxGt4ZUrYFlptDETxoUSYjr6x+sWv0t/5PdyvTTW8Iy
         a9XkJnkJgOWhP6lkHdroRmwAo1+mXygaEIOofDnxTLA12VJ2oWjb1bnqsZkFu4nipf3r
         Eumw==
X-Gm-Message-State: AOAM533Y+4ZUMjLWr3O2zWkURqqmjytXnqdgVHM8f8ZZgF6Na6JvITc+
        a2CNRQOhFnXp7Thd1lz3B1xbVg==
X-Google-Smtp-Source: ABdhPJz+hEZfOWevoZ499SQzdrq1Z2mZ0LBr2DK49KoFcWsRA8yyL5ojTW/OSab9+pivob3aXlwm7A==
X-Received: by 2002:a63:724b:: with SMTP id c11mr11377679pgn.9.1633360334666;
        Mon, 04 Oct 2021 08:12:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q16sm16151347pfk.214.2021.10.04.08.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 08:12:14 -0700 (PDT)
Date:   Mon, 4 Oct 2021 15:12:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     dje@google.com, mathieu.desnoyers@efficios.com,
        pbonzini@redhat.com, pefoley@google.com, shakeelb@google.com,
        tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: rseq: Update rseq when processing
 NOTIFY_RESUME on xfer" failed to apply to 5.10-stable tree
Message-ID: <YVsZytQ+9Bek78lc@google.com>
References: <1632660262120183@kroah.com>
 <YVIcAy/nf+0bBdqG@google.com>
 <YVm69hXIo2j4bf82@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVm69hXIo2j4bf82@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 03, 2021, Greg KH wrote:
> On Mon, Sep 27, 2021 at 07:31:15PM +0000, Sean Christopherson wrote:
> > On Sun, Sep 26, 2021, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.10-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > 5.10 backport sent: https://lkml.kernel.org/r/20210927192846.1533905-1-seanjc@google.comb
> 
> What about 5.14?

The original patch applied cleanly to 5.14, went in as commit 336dabf99386.

https://lkml.kernel.org/r/20210927170234.621422016@linuxfoundation.org
