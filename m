Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879041A9EE8
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368295AbgDOMEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368285AbgDOMD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 08:03:57 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D572C061A0C
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 05:03:56 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id y17so16764565iow.9
        for <stable@vger.kernel.org>; Wed, 15 Apr 2020 05:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZIldFXGC9JUy0bJuW478RnLboHGIalbEgP8asYjHrFg=;
        b=hL6GmXGxFNOXqyxS1rsarMNodDld7iNN/mayNzQWSC4bB9oA1C0qdm2rP9xGfFe5K4
         GphmvebMrJS4gbnpYiiDPryBZxE+6hHq6KN9WG5bj7kdz8cV563zL3JMChrKt4GYkrLn
         iEpn4IpmZ7Z1TLdnlvc3xpJ4x0ZBZ7IhIZwYCFumT+m7nFNZrOi3YDyHWTkQt4JUugrU
         pxWmf1bwuG0HQ++wgdlYD3mTz8yTdeDTVLAELu4HtI3zI3MuTdL4e3u+xOXAm9kO3VNZ
         EU1jHtDRUtot6cIndhP4zmsr/IrAWY3eqDCZuEW7LkmF8u3ZR7yoXqvKXPqh5D3Ydohw
         mFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZIldFXGC9JUy0bJuW478RnLboHGIalbEgP8asYjHrFg=;
        b=KNlJ6XeOcl2WcAzL1kXnSmPqhAkW1mhBKWL4x2oz6vHfV4T+9lep4trBNaqFpjo38s
         WESKz7ZRcPELQQeGL/CNd85x+S2ezZl0nqjVPPDNA++XS3ScpK9fQpvnOB/9jypTyK8O
         zqFKXEZv+CcF/AyQqKullsriwpjEeqI+PlKl3bQ11p2jc8kmgH1u5r5kj06xOtUntrQ8
         Fkyw89Ami5UzWxtghru9gxc8RR7fQo1XokGLQOxqvDtEqY/X8nCfqjVJei9JzxTN+Nl4
         vqupBjPCz4xgWXu8m96WKRcMm9T3ryfmz2Dyk+vnWZvgSEZTXpM7kT11ylbt1DWd9sdp
         mFPw==
X-Gm-Message-State: AGi0PuYFbewGGgAdgjvS/2/a4+/hyBDh3Aw8VCbHeuLur0tgozn6Wjke
        O+jNCijJE5yMstNJDX1m3f1h49b5mBh7oeEG1tVjPQ==
X-Google-Smtp-Source: APiQypL9n1Psk472515SULo0/3MCBuXeuu0AhdtJ7UArATCsTzRcFfiCUWK8gZewM4sQhGrhUQ62jqf0AIqwtp6KaeY=
X-Received: by 2002:a02:94cf:: with SMTP id x73mr24669122jah.92.1586952235441;
 Wed, 15 Apr 2020 05:03:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAGvU0Hn2U88Dy2MEP-ZTNvfrWaKF4XL9EtR+4iF5BZ6_GW3Tvg@mail.gmail.com>
 <20200407165539.161505-2-gprocida@google.com> <20200410090339.GA1691838@kroah.com>
In-Reply-To: <20200410090339.GA1691838@kroah.com>
From:   Giuliano Procida <gprocida@google.com>
Date:   Wed, 15 Apr 2020 13:03:38 +0100
Message-ID: <CAGvU0H=v-SBv3y3mPg2DRhaOo+z1kCvF4_2wsx=GAp6hP6_fMw@mail.gmail.com>
Subject: Re: [PATCH 1/4] block: more locking around delayed work
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

No problem.

Will do today.

Giuliano.

On Fri, 10 Apr 2020 at 10:03, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 07, 2020 at 05:55:36PM +0100, Giuliano Procida wrote:
> > commit 287922eb0b186e2a5bf54fdd04b734c25c90035c upstream.
> >
> > The upstream commit (block: defer timeouts to a workqueue) included
> > various locking changes. The original commit message did not say
> > anything about the extra locking. Perhaps this is only needed for
> > workqueue callbacks and not timer callbacks. We assume it is needed
> > here.
> >
> > This patch includes the locking changes but leaves timeouts using a
> > timer.
> >
> > Both blk_mq_rq_timer and blk_rq_timed_out_timer will return without
> > without doing any work if they cannot acquire the queue (without
> > waiting).
> >
> > Signed-off-by: Giuliano Procida <gprocida@google.com>
>
> Don't write your own changelog text for something that is upstream,
> include the original and then add your own later on below, making it
> obvious what you are doing differently from the original commit.
>
> And be sure to cc: all of the original people on that commit, and keep
> their s-o-b also.
>
> thanks,
>
> greg k-h
