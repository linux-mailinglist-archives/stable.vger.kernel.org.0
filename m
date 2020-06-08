Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3575A1F1987
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 15:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgFHNAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 09:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgFHNAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 09:00:08 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583ACC08C5C2
        for <stable@vger.kernel.org>; Mon,  8 Jun 2020 06:00:08 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id a13so16621192ilh.3
        for <stable@vger.kernel.org>; Mon, 08 Jun 2020 06:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xzqu+iFV41uQ5rRnrlJv4Ne5bNFmgIQ58DyeSLBnd8k=;
        b=t3PnPLTmvPOpmbjXdkW/1/Kek2KUrbYQi8CNCai1CJPJd23TOZ8HSdds1VrVPiBpew
         MT0jXa2Dpx8B41sjvtO7oB3Jw9AddduQnp+zsavv+aQNKij/SsNqnFMbzJWc+kPBkhW9
         qJsTM6jvDy35fpqPXRvJF7/2rmKnstz/UbXbfrnCwVtr1hvyvw45byo3tgL155Hd+DEX
         n6vXMuDz/QG82kqjoGuMXoJaj2hdLyx2MXPaMnn+cYjhCLaI+9gUBe9g76Y1w30GRHaQ
         vrReoQHVXfQDgp4X5ebMTnACi1ZwzXv9jaUibgXqFQimPlfgYOB8djHa7H7TEQfCQv+D
         NCDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xzqu+iFV41uQ5rRnrlJv4Ne5bNFmgIQ58DyeSLBnd8k=;
        b=r67bKrJtGNpBeFrKU+AK1uKALNCIPc8BvFTAKDco4izCCTFZ5TuNPCBWfwB+RsqVBd
         Nl7ayhqkjwD1BR8FG3ZT6SuOlKcVWhkWKnvhonRGWTJdbN72SBQi8Eogihf/7g05m+3m
         zukIVV4mvVQbEfKOLG9V3O+SH9OWzXjSWTGYKAiaxuEnZ63xhSFo6PamCOU2RCtXpSgu
         y914qmY9nB0N8Qd0SAVcmQE2BTfGCG08pyuEnG9uZJm8U/qGCRW7h0miyd9kyBcbQeZp
         rFi5DY+udIpqiRkOVmbzXMvUIdO3MZzalL4rbvT/h/7dTQ+4/l2l7abXT47dhZpHFivn
         X6sA==
X-Gm-Message-State: AOAM5335LIx6KEX33pf01FXIuZfrK1cMYngfbX73MHbufsGa7piXL9Be
        aeybl3vyVXz9FbkqSA7CJERSPv/39E249E1dLzmUfA==
X-Google-Smtp-Source: ABdhPJw5WB9EOySm2wH6EmfWjYA9cFmKhV2arzz+tVkloRXXWnBOmM6OmSpsrtvPxHroOFUQG4srl7ts0LFv8KLUPNM=
X-Received: by 2002:a92:c812:: with SMTP id v18mr22196616iln.178.1591621207231;
 Mon, 08 Jun 2020 06:00:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200608094030.87031-1-gprocida@google.com> <20200608105617.GA295073@kroah.com>
In-Reply-To: <20200608105617.GA295073@kroah.com>
From:   Giuliano Procida <gprocida@google.com>
Date:   Mon, 8 Jun 2020 13:59:50 +0100
Message-ID: <CAGvU0HkztXrxXcAk+W3kv01h3--+MttsT4ee62M+21KUxOwvsg@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-bouncing mail.

That wasn't clever. Apologies.

This one is for 4.9.

Giuliano.

On Mon, 8 Jun 2020 at 11:56, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jun 08, 2020 at 10:40:30AM +0100, Giuliano Procida wrote:
> > From: Jianchao Wang <jianchao.w.wang@oracle.com>
> >
> > commit f5bbbbe4d63577026f908a809f22f5fd5a90ea1f upstream.
> >
> > For blk-mq, part_in_flight/rw will invoke blk_mq_in_flight/rw to
> > account the inflight requests. It will access the queue_hw_ctx and
> > nr_hw_queues w/o any protection. When updating nr_hw_queues and
> > blk_mq_in_flight/rw occur concurrently, panic comes up.
> >
> > Before update nr_hw_queues, the q will be frozen. So we could use
> > q_usage_counter to avoid the race. percpu_ref_is_zero is used here
> > so that we will not miss any in-flight request. The access to
> > nr_hw_queues and queue_hw_ctx in blk_mq_queue_tag_busy_iter are
> > under rcu critical section, __blk_mq_update_nr_hw_queues could use
> > synchronize_rcu to ensure the zeroed q_usage_counter to be globally
> > visible.
> >
> > Backporting Notes
> >
> > This is a re-backport, landing synchronize_rcu in the right place.
>
> You sent this twice?
>
> And what stable kernel(s) does it go to?
>
> thanks,
>
> greg k-h
