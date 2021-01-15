Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EA82F70CB
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 04:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbhAODJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 22:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbhAODJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jan 2021 22:09:08 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55954C061575
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 19:08:28 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ke15so3631349ejc.12
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 19:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jsbtt2/rQGE0Do8XWjZwxhZTkmQRp9AyCR3YwuyIMnA=;
        b=moupxgZZPuJtTwzxhu5PewK0un24iZjOrjTR8YmicS0DsU9L7WcRv4yjvTY/E4j0q0
         h5AeLfs7BFbJG3MjoX7uXOHhkZFqVkYi1QnYVEgbKPEL5bdW+yY/hZruQSme//IcjwZB
         1RBghYHtYaWv518+9vHMU5DXkXAlV3/vF7/SrKBgr+9sXRVyU+gdIPerMMzc1jSFCgzW
         VBXZZeTE3bWKWKg8yjbloYehCfvJJnewT7S7XUECFYrKPHIkqwBIVP0bcDlBuwGpVwqI
         qU1+5qPZ77dDHt0CYyW29PBeKzoGfICngAc+1OV/01/2fiLlfVPm0uXsT0PFQJzZV2Eh
         woYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jsbtt2/rQGE0Do8XWjZwxhZTkmQRp9AyCR3YwuyIMnA=;
        b=dqHph6SkeaCdwQMplpnjemPYfvQWSQ+pgv3ZDW2MyWe1/2A55/v06Ad+jKrt6vjf7M
         aGZovc197f4BRaR5kc1IYrpQVWeh+j2krmlfsMNyycBmlG4QEas0R3oEu9Z/PESi8OgD
         0BSbhLS0oHrYqgTIQVjkRgqSw9lgogAtg6lMLGrfYLOgeD0IhuB8sDHM5eq9qa3qsmZf
         2jqzeuRpzaAXMqrIQLTpVlHkaJWeAcEg4zVXb32LxmmNUT4tNxmyFsQDyivHmHQvOmrG
         3MkZfrQKzCRgeDQu6reI3lUS4NJvF1+z27wGrUL/G1ZySfcBJ8subcw4vLjrR7CuBwIE
         7n7A==
X-Gm-Message-State: AOAM533OcT/e9JcNn6KoaxGaI9meZ/SKnA+CR3tChQTvTrOKG6w4bx8b
        UVZCrfXfHIqz9yuz/hIpQ15zdocJf4ulq/aoZUs65g==
X-Google-Smtp-Source: ABdhPJyRSjzrXzy3WGo5rB8Q65x808CvjCT9Al3qZMNSjBOXBJH7wWZszF/DPI+KMSZmLOM2yyKcfvbjyWNJnFbaRHM=
X-Received: by 2002:a17:907:2061:: with SMTP id qp1mr7026466ejb.222.1610680106703;
 Thu, 14 Jan 2021 19:08:26 -0800 (PST)
MIME-Version: 1.0
References: <CA+Um-ghfTG=+x8iT-uPikM7NNsN1J6CCiztxsBgQ9OJPUBQjyg@mail.gmail.com>
 <20210115024330.GW4035784@sasha-vm> <7c22b3d8-0f33-19b5-feeb-db0c684a6c35@kernel.dk>
In-Reply-To: <7c22b3d8-0f33-19b5-feeb-db0c684a6c35@kernel.dk>
From:   Saied Kazemi <saied@google.com>
Date:   Thu, 14 Jan 2021 19:07:50 -0800
Message-ID: <CA+Um-ggp_6wVCCDb23vhJ449qRQWCWEMNFQpd1mQFdbYW3twDw@mail.gmail.com>
Subject: Re: Fix CVE-2020-29372 in 4.19 and 5.4
To:     Jens Axboe <axboe@kernel.dk>, sashal@kernel.org
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Vaibhav Rustagi <vaibhavrustagi@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Our internal system reported that the issue affected "do_madvise in
mm/madvise.c in the Linux kernel before 5.6.8" so we assumed that it
affects 5.4 and 4.19.

Thank you for clarifying that 5.4 and 4.19 are not affected and it's
safe to revert the commit.

--Saied


On Thu, Jan 14, 2021 at 6:45 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/14/21 7:43 PM, Sasha Levin wrote:
> > On Thu, Jan 14, 2021 at 05:55:13PM -0800, Saied Kazemi wrote:
> >> Hi Greg,
> >>
> >> To fix CVE-2020-29372 in COS kernel versions 4.19 and 5.4, we
> >> cherry-picked the commit "mm: check that mm is still valid in
> >> madvise()" (bc0c4d1e176e) that Jens introduced in kernel version 5.7.0
> >> into our kernel sources.  The commit is small and the cherry-pick was
> >> successful for both COS kernels versions.
> >>
> >> Because COS 4.19 and 5.4 kernels track 4.19.y and 5.4.y respectively,
> >> can you please cherry-pick the commit to those stable branches?
> >
> > 5.4 didn't support IORING_OP_MADVISE and 4.19 didn't have io_uring to
> > begin with, how is this an issue on those branches?
>
> Good point on 5.4, I didn't even think of that. So yeah, doesn't seem
> like it's applicable to any of those kernels?
>
> --
> Jens Axboe
>
