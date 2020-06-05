Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7491D1F00CD
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 22:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgFEUNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 16:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbgFEUNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 16:13:22 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E7AC08C5C2
        for <stable@vger.kernel.org>; Fri,  5 Jun 2020 13:13:22 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id h3so10847471ilh.13
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 13:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=juliacomputing-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fbtDa8Hyyhb6x5b5d5Nx0md1ru2BL65F2mqxRZhzXcQ=;
        b=UPRZ8iwg4vJd9gFsssWF5r7eJkNYGMKa39Ce0NJgJrH93DYP3cFgVjNlnCJvjSLR2H
         XeD9gT1iwoMRSjC7T/FjW3oud60hqKst9ypMRdJ0W8Vjl13eqk01QCwt59aq4RlYJjwn
         +x/sRbbHWppkoxprZfFaSnJydZhw5iwFSrRfU9qhaB7XaE9SqELsuUjAcjqYNfzbM/5q
         ic5DmMDUZ8J31SATAhHDs5mfs9wEVwzk9JL7/SwnTNfLAipq/BXo4CfOzRUHq4OgJMrL
         mOSXTEA88+hwlGjRxYNlVKlx3OfdtHCjsT6P/apLGQbVE3YIJnmVNnWCwoRlEpJvGirX
         /V2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fbtDa8Hyyhb6x5b5d5Nx0md1ru2BL65F2mqxRZhzXcQ=;
        b=SqLBw827wCPFqt6xS5HEP1495yTydAuqj/OqvQLh9KCy2H6xGachc0dTAMlOlUIW7x
         FBRma5bd101nUqn8/OrcZ8FMoUvX/r8bbVN6eyDfOs+dQP6Roa1xxJ6s3IsA+E2yOw9T
         Ls1gGalB/BlUKqE0IN1r1y04+4/QfnzSZX5LDhnebyjkS97hZuxfv3eoXO8siRkx+clc
         qeTLIkG2disgN0I7FBnvQBdtcKPiJDgZgTQ7B9eBAcf6ZcdyciUTpwjkRR6YEkdWn6Xu
         XsWzzTv2F7BnPfbD5iE+LRzlc3OIxYuwGKaGwZ99Ur93J/3vsKsOyQ+thF3WM7w2/w5L
         dviQ==
X-Gm-Message-State: AOAM532wydxWtWDcPI4Dtz1wDnef30TUhPaVyL/4NlB/xPT7qIfTegTn
        rRuJIhgRCbZjjj9WraIx5lNXDNmcQFKFSsJA3gLxqA==
X-Google-Smtp-Source: ABdhPJyjLCEG+Zcai/fC8YoM9b8CwgLkdW9GJ8hGiOc8kYIzmZLMT2Z4UEw+ncol7Kyv2UMR2h6KfLFrz8boRdsMtv8=
X-Received: by 2002:a92:d1d0:: with SMTP id u16mr9998422ilg.2.1591388001139;
 Fri, 05 Jun 2020 13:13:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200603151033.11512-1-will@kernel.org> <20200603151033.11512-2-will@kernel.org>
 <CABV8kRwrnixNc074-jQhZzeucGHx9_e5FnQmBS=VuL=tFGjY-Q@mail.gmail.com>
 <20200603155338.GA12036@willie-the-truck> <CABV8kRxSjMY+d+F5aNzq1=5hXhVLGy6TbNLTUsCeSsAncwCzoA@mail.gmail.com>
 <20200604083210.GC30155@willie-the-truck> <fdce5355-8a85-7bdc-0fba-a2a6c08cb0b8@linaro.org>
In-Reply-To: <fdce5355-8a85-7bdc-0fba-a2a6c08cb0b8@linaro.org>
From:   Keno Fischer <keno@juliacomputing.com>
Date:   Fri, 5 Jun 2020 16:12:45 -0400
Message-ID: <CABV8kRxVHWcQ-RS1Xjt557Lzc=GpDxF_HHURRM6LNBdZevdtJg@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm64: Override SPSR.SS when single-stepping is enabled
To:     Luis Machado <luis.machado@linaro.org>
Cc:     Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Luis,

On Fri, Jun 5, 2020 at 12:50 AM Luis Machado <luis.machado@linaro.org> wrote:
>
> 1 - x86-64 seems to get an extra SIGSTOP when we single-step over the
> vfork syscall, though this doesn't seem to do any harm.

Is it possible that on arm64 you attached to the original tracee using
PTRACE_SEIZE, but used some other method on x86-64?
That would explain this difference.

> 2 - This is the one that throws GDB off. In the last single-step
> request, arm64 gets a SIGCHLD instead of the SIGTRAP x86-64 gets.

I believe this is ok. The timing of SIGCHLD is not guaranteed, so it's allowed
to pre-empt the single step. I have seen some differences in signal delivery
order on arm64, but I believe it just comes down to scheduling and performance
differences between the systems, since these interactions are a bit racy.


Keno
