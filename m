Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E714A1320CD
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 08:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgAGH7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 02:59:55 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34580 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgAGH7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 02:59:54 -0500
Received: by mail-ot1-f68.google.com with SMTP id a15so75275068otf.1
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 23:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kv6FRY8OwWj47F7It0WGFE/aOvlTBaagpwp57DH7F3M=;
        b=DjZag54PzFZ292t7QsQkkyyLXvMNPFKUdaEnJCoN5C0iN0tvo4XNIqqpy1B9VCnjAo
         WfN1bdzhiWZ2w0qEvwlidhnmf6TwEJSBWvqrvEItsX8kJQE7VddiRJLeImzUWk4rlx1z
         xm49rQ9jhaIk0BLTVVMhng1ZkzdtN/GgYQiSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kv6FRY8OwWj47F7It0WGFE/aOvlTBaagpwp57DH7F3M=;
        b=M7+5EDW4amL+9MLC3KF8u/Zdz7sa+Fhet6GOWfLH9vUgIlYt9BcwTVurlJB3GMhxoL
         k/Iyb+QuJBc2thlZ7eDAwTWXOGOZEnqyLtgstyjFwRsxY3ZJ5sh4YL9TpJApBP+cSTAz
         ZXNN+4UXeZ/q8NFv46Qmf1C+295pbQu+3ixaLIfhdMHOp5Ru+ln+GmsgTHejwsT7hIfo
         ioZOcXUxoh7TExp0Egzi7iWY+1/XqrU3HNNRonvt8EuU+4suGpU7yk32tbEt9bYTLYa7
         N1HbKYwREMnOk/HgvHZrdvO5Oq7KHqu0qDvfizNl3ANVQyaptBcRuIeNWEcB5xwjt6qX
         NrMg==
X-Gm-Message-State: APjAAAUe2Uedux9cdi8pmWmmlOcuQygcPCjsIojxCKXwSB/HQF8eTNR9
        QmB3XIXAmZsz5/GxpZrNlWkdfMfLfLY0Qj/QWSdWXw==
X-Google-Smtp-Source: APXvYqyIwG0zMo78MdF6cnI92Lq1D5+FUpd4KNCnqcxALsWBRMk8aJGrLW3E7nXdeS3NXZYtD7bHCVOYoTsxjIYODNU=
X-Received: by 2002:a9d:7410:: with SMTP id n16mr108846483otk.23.1578383993785;
 Mon, 06 Jan 2020 23:59:53 -0800 (PST)
MIME-Version: 1.0
References: <1578051155-14716-9-git-send-email-anand.lodnoor@broadcom.com> <20200104053110.9D26124649@mail.kernel.org>
In-Reply-To: <20200104053110.9D26124649@mail.kernel.org>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Tue, 7 Jan 2020 13:29:26 +0530
Message-ID: <CAL2rwxrJ62sxGo0jQhXyOydrh6w+LWLh3JDHapmU9GNpvMXe5A@mail.gmail.com>
Subject: Re: [PATCH 08/11] megaraid_sas: Do not initiate OCR if controller is
 not in ready state
To:     Sasha Levin <sashal@kernel.org>
Cc:     Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 4, 2020 at 11:01 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.4.7, v5.3.18, v4.19.92, v4.14.161, v4.9.207, v4.4.207.
>
> v5.4.7: Build OK!
> v5.3.18: Build OK!
> v4.19.92: Failed to apply! Possible dependencies:
>     Unable to calculate
>
> v4.14.161: Failed to apply! Possible dependencies:
>     Unable to calculate
>
> v4.9.207: Failed to apply! Possible dependencies:
>     45f4f2eb3da3 ("scsi: megaraid_sas: Add new pci device Ids for SAS3.5 Generic Megaraid Controllers")
>     69c337c0f8d7 ("scsi: megaraid_sas: SAS3.5 Generic Megaraid Controllers Fast Path for RAID 1/10 Writes")
>     a73b0a4b5d17 ("scsi: megaraid_sas: Change RAID_1_10_RMW_CMDS to RAID_1_PEER_CMDS and set value to 2")
>     d0fc91d67c59 ("scsi: megaraid_sas: Send SYNCHRONIZE_CACHE for VD to firmware")
>     fdd84e2514b0 ("scsi: megaraid_sas: SAS3.5 Generic Megaraid Controllers Stream Detection and IO Coalescing")
>
> v4.4.207: Failed to apply! Possible dependencies:
>     179ac14291a0 ("megaraid_sas: Reply Descriptor Post Queue (RDPQ) support")
>     18365b138508 ("megaraid_sas: Task management support")
>     2c048351c8e3 ("megaraid_sas: Syncing request flags macro names with firmware")
>     308ec459bc19 ("megaraid_sas: Dual queue depth support")
>     69c337c0f8d7 ("scsi: megaraid_sas: SAS3.5 Generic Megaraid Controllers Fast Path for RAID 1/10 Writes")
>     6d40afbc7d13 ("megaraid_sas: MFI IO timeout handling")
>     8a01a41d8647 ("megaraid_sas: Make adprecovery variable atomic")
>     8f05024cd3db ("megaraid_sas: Fastpath region lock bypass")
>     a73b0a4b5d17 ("scsi: megaraid_sas: Change RAID_1_10_RMW_CMDS to RAID_1_PEER_CMDS and set value to 2")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
Hi Sasha,

Please pick this patch for stable trees where it cleanly gets applied
after it is upstream.
We will backport this patch for stable trees where it does not get
applied cleanly.

Thanks,
Sumit
>
> --
> Thanks,
> Sasha
