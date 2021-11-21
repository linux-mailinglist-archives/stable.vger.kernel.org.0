Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F26458734
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 00:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhKUXlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 18:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhKUXlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 18:41:14 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82C9C061574;
        Sun, 21 Nov 2021 15:38:08 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id l22so71968251lfg.7;
        Sun, 21 Nov 2021 15:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YPOtm/OEYq9+Jn4Mj0aBpoQwr/iK+obQeVk8uZUmqOg=;
        b=O02JlR5FwEi+uFevjBB6FYK5QvDra7RVsR8Y6hePJyi8BQHBUPMY7kkgj662JcDb8D
         I8xLuhDlZRc+5Ea114DPKQWxZxLDeOH1GNRpJsy6KW/tkonu/b6wBr78wBOg/7TifNWq
         vF/PpYTeJx1PaCwSGpM4mV1kdzP3ohT8h6BpSBgAA6pZ44FbEWPQup3X5dIIaxEhXhwu
         35XnFRdgTHOflsjh9nCcYg1PFZVS1u8eSnBW2ep7mTv8aEUmCxKjPCfHMxA1LLf7HpkC
         cGY9d1ERvMhP2ZNBlwkMqeWokU/fVgBhA1if+CZaoKe4rfOnOz6mMzRP7ftqdlKk3Ltm
         F2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YPOtm/OEYq9+Jn4Mj0aBpoQwr/iK+obQeVk8uZUmqOg=;
        b=OnSsdFS5HhVfsojTwswK+TBL3QKrogM71tt+8XTf03KLoRFfeEGVT/ahABDStAv6zu
         uW5PKkVw4EMbPYJ4+d1QkseeRXBfF8cjzgil3LxwxjxpuB5ZCwkuALjkvZwF5st6sVFg
         zuwQayrRVltJwB6wX5MZahsCsQFIX7MDymMSwuAcKkXgcpRbGhDYNeGi+0oatnBOX4W6
         aVJgngNQ+st4sEPZd96rnesKrp1+EFh0pgEZFVZath5gW6isX7+zQqP1cc6O+nhXrVp0
         J5ClPy8QqzHOLnP1lwQ60jaG+AFFvG7w5LU+YnoDpfYaMo3ASauroNxA1wy2IHR5LNrE
         JMgw==
X-Gm-Message-State: AOAM531q9ea+gbvptAsXfF9RiHPe2oCaIscaQBiiDGe2djAAGQM3uBUc
        oQ6OV6MdfN88Ug6kmsdnPxxHHm8deoYJu3MSd2nsXJw8XVc=
X-Google-Smtp-Source: ABdhPJzf1jB9nZ67gjicvbbM9Gh9GDs1icnKevWjd04ZqHIiq+31fgdItefLGC1RazuTBzPVDT5PH/Lz7CjSNjiyi1o=
X-Received: by 2002:a2e:3304:: with SMTP id d4mr46472796ljc.377.1637537887185;
 Sun, 21 Nov 2021 15:38:07 -0800 (PST)
MIME-Version: 1.0
References: <20211121232535.93218-1-sashal@kernel.org>
In-Reply-To: <20211121232535.93218-1-sashal@kernel.org>
From:   Sohaib Mohamed <sohaib.amhmd@gmail.com>
Date:   Mon, 22 Nov 2021 01:37:56 +0200
Message-ID: <CAOz-JA6xVGS9nUsgnGQxZ1=c8__XewdTfefGbMQvWmMAQVPWcQ@mail.gmail.com>
Subject: Re: Patch "perf bench: Fix two memory leaks detected with ASan" has
 been added to the 4.9-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, stable@vger.kernel.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Sasha

On Mon, Nov 22, 2021 at 1:25 AM Sasha Levin <sashal@kernel.org> wrote:
>
> This is a note to let you know that I've just added the patch titled
>
>     perf bench: Fix two memory leaks detected with ASan
>
> to the 4.9-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
> The filename of the patch is:
>      perf-bench-fix-two-memory-leaks-detected-with-asan.patch
> and it can be found in the queue-4.9 subdirectory.
>
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
>
>

I think this patch should not be added to the stable tree. I think
this patch should be reverted soon.

Thanks,
- Sohaib

>
> commit b1c29e2248629770cee7ac88cb9dfea91e07146b
> Author: Sohaib Mohamed <sohaib.amhmd@gmail.com>
> Date:   Wed Nov 10 04:20:11 2021 +0200
>
>     perf bench: Fix two memory leaks detected with ASan
>
>     [ Upstream commit 92723ea0f11d92496687db8c9725248e9d1e5e1d ]
>
>     ASan reports memory leaks while running:
>
>       $ perf bench sched all
>
>     Fixes: e27454cc6352c422 ("perf bench: Add sched-messaging.c: Benchmark for scheduler and IPC mechanisms based on hackbench")
>     Signed-off-by: Sohaib Mohamed <sohaib.amhmd@gmail.com>
>     Acked-by: Ian Rogers <irogers@google.com>
>     Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>     Cc: Hitoshi Mitake <h.mitake@gmail.com>
>     Cc: Jiri Olsa <jolsa@redhat.com>
>     Cc: Mark Rutland <mark.rutland@arm.com>
>     Cc: Namhyung Kim <namhyung@kernel.org>
>     Cc: Paul Russel <rusty@rustcorp.com.au>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: Pierre Gondois <pierre.gondois@arm.com>
>     Link: http://lore.kernel.org/lkml/20211110022012.16620-1-sohaib.amhmd@gmail.com
>     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
> index 6a111e775210f..9322fd166bdaf 100644
> --- a/tools/perf/bench/sched-messaging.c
> +++ b/tools/perf/bench/sched-messaging.c
> @@ -225,6 +225,8 @@ static unsigned int group(pthread_t *pth,
>                 snd_ctx->out_fds[i] = fds[1];
>                 if (!thread_mode)
>                         close(fds[0]);
> +
> +               free(ctx);
>         }
>
>         /* Now we have all the fds, fork the senders */
> @@ -241,6 +243,8 @@ static unsigned int group(pthread_t *pth,
>                 for (i = 0; i < num_fds; i++)
>                         close(snd_ctx->out_fds[i]);
>
> +       free(snd_ctx);
> +
>         /* Return number of children to reap */
>         return num_fds * 2;
>  }
