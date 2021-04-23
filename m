Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258A9369CC6
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 00:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbhDWWdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 18:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbhDWWdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 18:33:53 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AD5C061574
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 15:33:14 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id t14-20020a05600c198eb029012eeb3edfaeso1968093wmq.2
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 15:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jVCxuutEEVwGAhJincUori7BhqDHgLeA4IkzXJRFCDM=;
        b=BnmTymGCwdl6l5GKkklPtAVxlAC3b9rRGpuZt8hK4wra3KH64aTlJobDb+5v20HpQk
         Ub72eXK01kADSvAQTq5MuhwE2AbwDMa/chxtgZhdoBWLxp+T6IHWVD8k7YziyJT2l1wN
         iZC4e/yIaYVtXz6ryGLfjWTXUqE0KBjoh3/+qwj9kxU/uolwDMYY4JKbrjm6hyJEQUUM
         ld0SngIlahwIcsoLD+rQhuPziR5BRMmtxeAY6VaWcK5cq0iHShV5sXPxZOU5f6UDWUzt
         WnZU54l6LcysVgHwCk8fyxDnypb2clY91a4p5zlnYvooLb6lDBrZEcBnYcGsIz4VHdNi
         MBJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jVCxuutEEVwGAhJincUori7BhqDHgLeA4IkzXJRFCDM=;
        b=BZ6EMDRwfHg1eXSHPum0/YwKAs6xGt3KA8EK5r/xgLt6OWr+rgiSmng0RM7ukla3Zu
         vaeC5DXgdePk3XTkDHYTl/ct88mBJsr2F3MBWfaaM2R4pI5FZGkoAM/um9v3P8HpZpdd
         gpznM7K7WWdQjtMKLqY1gN/lkz/TH//uz1Abt2wRGjDLDTSeavTm65bIQiTd4n/klueT
         Ss7PFaK9UHly8sltJlDcTjSh+9H1U5gemsecQASSyqxsDbumudkkGQSTyJCjSowaq8wi
         js+qrJPbyf8HzYU0ETbpOR77PA+j5hDB8+QaGjp2ZcWyT0fBAtK+/t4LZ2Dmt8bgfw4j
         OwKw==
X-Gm-Message-State: AOAM532lfCX2+z+eRllhaZoDZBWjTLDa+GlkdWByGPScZ4krupZYtOdH
        imxVccS/fVm2N/BUFnsVQ0ES6iW/YvLiFx93mQJYwrjo2q4mjg==
X-Google-Smtp-Source: ABdhPJzgrkmKG+pe0rKAFwVmzAfvlLxrUyrCBJH8HZnlyae/bSX7bOSi69fsirgP68TQBK6nXPYdviEWFsId34JPGc8=
X-Received: by 2002:a7b:c344:: with SMTP id l4mr7656522wmj.120.1619217193191;
 Fri, 23 Apr 2021 15:33:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210405210230.1707074-1-jxgao@google.com> <YG2q6Tm58tWRBtmK@kroah.com>
 <CAMGD6P1OEhOXfFV5JpPfTjWPhjjr8KCGTEhVzB74zpnmdLb4sw@mail.gmail.com>
 <YILkSsR4ejv5CraF@kroah.com> <CAMGD6P2gUpUuX5cdPi1Q0nqRFmsBPctUR+hBt+DnPK+H4jHiiQ@mail.gmail.com>
 <CAMGD6P1DNoYFm4p8MQjuv83L16B+RuZCUREsO8hA+8Z7uUDW5g@mail.gmail.com>
In-Reply-To: <CAMGD6P1DNoYFm4p8MQjuv83L16B+RuZCUREsO8hA+8Z7uUDW5g@mail.gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 23 Apr 2021 15:33:02 -0700
Message-ID: <CAA03e5EYT=dUAX+r9wVgSVd++s=DnQU-WWZD6kdjig-s910o=Q@mail.gmail.com>
Subject: Re: [PATCH v5.10 0/8] preserve DMA offsets when using swiotlb
To:     Jianxiong Gao <jxgao@google.com>
Cc:     Greg KH <greg@kroah.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 23, 2021 at 3:11 PM Jianxiong Gao <jxgao@google.com> wrote:
>
> +Marc, who can help filling the gaps.
> --
> Jianxiong Gao

Oops. Gao over-trimmed. From lkml, here's Gao's last reply.

>> How?  Anything that installed 5.10 when it was released never had this
>> working, they had to move to 5.12 to get that to work.

> I wasn't clear. The bug is not specific to SEV virtualization. We
> simply encountered it while working on SEV virtualization. This is a
> pre-existing bug.
>
> Briefly, the NVMe spec expects a page offset to be retained from the
> memory address space to the IO address space.
>
> Before these patches, the SWIOTLB truncates any page offset.
>
> Thus, all NVMe + SWIOTLB systems are broken due to this bug without
> these patches.
>
> I searched online and found what appeared to be a very similar bug
> from a few years ago [1]. Ultimately, it was fixed in the device
> firmware. However, it began with NVMe + SWIOTLB resulting in similar
> issues to what we observed without these patches.
>
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=1402533

The bug is not specific to SEV virtualization.  We've repro'd the bug
on vanilla NVMe + SWIOTLB kernels, and confirmed that these patches
fix the issue. We simply first encountered it while working on SEV
virtualization.

The bug itself is that on an NVMe + SWIOTLB setup, `mkfs.xfs -f
/dev/nvme2n1` triggers the following error "mkfs.xfs: pwrite failed:
Input/output error". We observed this on a RHEL system.

An example system where a user might encounter this bug is the
following. On a system with NVMe + older 32-bit devices that has been
configured with the `swiotlb=force` kernel command line flag to ensure
that the 32-bit devices work properly.
