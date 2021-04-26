Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D66836B878
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 20:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237644AbhDZSBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 14:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237632AbhDZSBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 14:01:51 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D1DC061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 11:01:08 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id x20so23507782oix.10
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 11:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/OAC6k1pHnhVBbtW02dOnUV5t3rAOLQxdb8bNt3y+RY=;
        b=ZNoKcezkbXI9npOLyEE6ldr+9cAOT+LtPxlafGT4hRYlo5823BcjWquSJWjxVpSXEx
         NVIipOZ1rYf9QPIZ8+AREmMR7WAdI1gCEp2wrwqw0PioUabQGJ0vIeT0Ng3QObAD2whT
         qJrqAZHz9pQMn9o/e0PlhyQ0o4So+G3Pdk28496Gb2xvqsUbmDzLA7HmMhbwjdZuQSYg
         RlEkN673MR7trD1LVaX0tvY91SfQfh74BLluVOiVpB21cIjIRBONsxTX5tkJDpTjAnVy
         dQamapkfxDLJ/5JHT8EnpJ810l+MCHPhHCc+6dWeDrqWtrRBnVWnOrdGeXrB5m712A4E
         S3Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/OAC6k1pHnhVBbtW02dOnUV5t3rAOLQxdb8bNt3y+RY=;
        b=YfHD9hWZDam67YiQTP4t5QVA85Q8ad8kDNqJ2V4m2a6Sx5UYGrzfDdu4oN5tH5MNvE
         3Jr2s3kK6fUrhDpxPqo2uPnP1Zhm2yUzd5Nrciorzp5VpNbHhpxSmlAPz6T79reAV4gE
         vwvawI3xuACvawdxn/QG5UvsWhnhIyCOO61AH0ooiaZ8kmslJv8fjBQE0ChVljgfSgfy
         ecBpdO2S7OsrK36bNqFr8qmfb4jgpEA90/Voa+TRr/frzEDfaUwXcD/fJSvk3Nf3LPHB
         +0M2+ifMwAddSRnVKIxzn7Z3KVstoaTxu1IeLoSUcHBlY/Mb8j4qYrcENTjJyglgX1iW
         OWNA==
X-Gm-Message-State: AOAM531LN6aKsOH5qB6jl/wYjLOoT6bwbtIubkNzIBTT0V0e2JIuucGP
        ChcAShJ7MbF08uFKG+yYjfBKdyCqd3Eu+Aq0uY2rj4Ga69st1w==
X-Google-Smtp-Source: ABdhPJxxUJqBCIf4OuqBEx/g2RSacI8xWh/PcsZ1spHAgGwlfW5msTpOhZh7VmG2K5dD6tDO3Sc8mTUYdovzSc8zd4k=
X-Received: by 2002:a05:6808:1393:: with SMTP id c19mr605527oiw.149.1619460068018;
 Mon, 26 Apr 2021 11:01:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210405210230.1707074-1-jxgao@google.com> <YG2q6Tm58tWRBtmK@kroah.com>
 <CAMGD6P1OEhOXfFV5JpPfTjWPhjjr8KCGTEhVzB74zpnmdLb4sw@mail.gmail.com>
 <YILkSsR4ejv5CraF@kroah.com> <CAMGD6P2gUpUuX5cdPi1Q0nqRFmsBPctUR+hBt+DnPK+H4jHiiQ@mail.gmail.com>
 <YIQupJuzbdgif6WA@kroah.com>
In-Reply-To: <YIQupJuzbdgif6WA@kroah.com>
From:   Jianxiong Gao <jxgao@google.com>
Date:   Mon, 26 Apr 2021 11:00:56 -0700
Message-ID: <CAMGD6P3SY=BeXjKAajCiHXXRXzLMnDiPo8weagJVurY_Ew0T2w@mail.gmail.com>
Subject: Re: [PATCH v5.10 0/8] preserve DMA offsets when using swiotlb
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, marcorr@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 24, 2021 at 7:43 AM Greg KH <greg@kroah.com> wrote:
> Ok, and what prevents you from adding this new feature do your "custom"
> kernel, or to use 5.12 instead?
>
> This is a new feature that Linux has never supported, and these patches
> are not "trivial" at all.  I also do not see the maintainer of the
> subsystem agreeing that these are needed to be backported, which is not
> a good sign.
>
So this is not about a new feature. This is about an existing bug that
we stumbled onto while using SEV virtualization. However SEV is not
needed to trigger the bug. We have reproduced the bug with just
NVMe + SWIOTLB=force option in Rhel 8 environment. Please note
that NVMe and SWIOTLB=force are both existing feature and without
the patch they don't work together. This is why we are proposing to merge
the patches into the LTS kernels.
> So I recommend just using a newer kernel version, that way all will be
> good and no need to backport anything.  What is preventing you from
> doing that today?
>
> thanks,
>
> greg k-h



-- 
Jianxiong Gao
