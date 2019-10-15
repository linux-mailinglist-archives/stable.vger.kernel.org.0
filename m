Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA61CD6C75
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 02:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfJOAcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 20:32:08 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:39094 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfJOAcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 20:32:08 -0400
Received: by mail-qt1-f169.google.com with SMTP id n7so28045055qtb.6;
        Mon, 14 Oct 2019 17:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nbwEWIMOPgAvRW9g6yMzibpiveKEJMzvaV/BsYwRlYQ=;
        b=WoC6t5usZr5JbstP9UPkNvEnuRJ546xzn0MB9flDYi/Vc4bXLGkntwIHTlQp2TerVE
         PX/jO9rE39uao+NmlI4l/+fSvJ8qyuKhTBwAgsIjs3Zcb4uy+43SDCIEOsFjYkVl+Isu
         a7VTaolDM6yBbVI2/6e73M/IaWH4Vi3P4hs21lI3nNpjezK7k+6hSC+Ou4yzN5zx33Bu
         aQYZhKq0X4aImWs+RAjF3lurb7615s0YPd6FwGP9bI/a3Hep4okpzIY/yaCPufWOSoyY
         AP1crCvR2PaZKMHRc2jZkBU6HMqgK4VcQXa5Ewzcf1cVHG4TIwBWugfwC4oHnLtD56lg
         fW+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nbwEWIMOPgAvRW9g6yMzibpiveKEJMzvaV/BsYwRlYQ=;
        b=bdXDPRZb9YGdOLWXvt+l8I934Oli81A9DkldDTcCdnckBTrze7YUtHrAiT63NkHmaV
         N6j3/NtBcNvccm0DXvERqQMUb4IzVg8Ha8Y3+Ya/yJ+u/Typ4KVph13a0XkaHBztlIW8
         uO/MTT2ZHo0Dt5RR0f/A5q9aICdvp2F52GjeiRm2mRyJt3ZXHSQWvo2gYbGuQhSJCJjp
         3VAqNpUfmvepYsFLBn1SyDgXC24L0p586fzEZZ5cwSFrV92/nLaRVKFQwzwejzMuw0hk
         GxHof48mFwwlnI1arjf7rZIt5bfLBAC99Mpvd4Aa/G8ZaK5pf9fpVEWhWbyhwWx+91e6
         rORw==
X-Gm-Message-State: APjAAAUpP4ZmfU4KdaCrd9f2peto09fhT57FYr+kB1b/VommGp3cjKnw
        t8IgvKW/io71kJFP7Zkoqyf0qVVLV3aOLwPtXuc=
X-Google-Smtp-Source: APXvYqzs9DHXOgqoWTkJ5TaWlVOIoiXi4BQc8njn2jbtunnG3x/8W5rnh+ARtDvwUWAaPy4c2TRyIt6bpVOWHcMyQdU=
X-Received: by 2002:a0c:e64a:: with SMTP id c10mr21998491qvn.96.1571099526091;
 Mon, 14 Oct 2019 17:32:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190925055449.30091-1-yuyufen@huawei.com> <5bce906d-3493-982e-63b1-66d1b9813e1e@huawei.com>
In-Reply-To: <5bce906d-3493-982e-63b1-66d1b9813e1e@huawei.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 14 Oct 2019 17:31:55 -0700
Message-ID: <CAPhsuW6BMA5RXo8JwWBLWNA9B6Kq0RfvG-vdkjrsNANybvrORQ@mail.gmail.com>
Subject: Re: [PATCH v2] md: no longer compare spare disk superblock events in super_load
To:     Yufen Yu <yuyufen@huawei.com>
Cc:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 6:35 PM Yufen Yu <yuyufen@huawei.com> wrote:
>
> ping

Sorry for the late reply.

The patch looks good over all. Please fix issues reported by
./scripts/checkpatch.pl
and resubmit.

Thanks,
Song
