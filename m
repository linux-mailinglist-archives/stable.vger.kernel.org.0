Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD31A984A
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 04:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbfIECUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 22:20:32 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39759 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730273AbfIECUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 22:20:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so782889wra.6
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 19:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yUV0LFmuD4w2VK31lJUAxT6aOwDIfbXLOFt99Otv1TA=;
        b=JMPa18B+1uZ3/eiiyylGl65S2BVMmVc+/U47ClAenwGSD+tpRe5SJgKzH9pU92V73q
         V/18SOw8Z5/8d0Y9JcBR158PfPlaIh0KBEVYRynxzuHhSC1TMDiUtpnw12i2qt5pZ1Wb
         zOrsjIwct16El4sU2BWqBPLIFkdzQOqEnt/TmYpQWV3QMUyOgy8Bd8mjHIwJh2WozTX9
         9lTbwTLXGsgTdMJHIX9wKjUPIE0C5lP89OWx54YpEswEKi0g3XJ4iKyzgPDtfxK+TmYk
         Aksfs+WJn6x58zqOfH9CvmQS/n3l988VCChKvTCbTJoNk3RToUMcN/jVDejM5jrt/YZ2
         1MSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yUV0LFmuD4w2VK31lJUAxT6aOwDIfbXLOFt99Otv1TA=;
        b=mpKBKPEiYIVLK3dsYQEVYFMzJyrAquXh8xy3uf9X300wz27vFjoJtYEo6ZCuEb9a/F
         86aosoBnBWY+9OLE60wSq4CbePO3TJECiXkcNp5WCnQ7K3+8SxYS8wICNSGgn9YiaGS3
         xvicLVY6QWDgvEKK99poQ8JWAfvx2Da7wvDYjl2Z2LPfAi+YYlrCK00NVQjl6kf6vui+
         OOq1Mekl6pwhDPfPkh3nlyJH4sDhireXjxlP4+qS8exbcKkA4DBAAdfTmvdVAXJtqiDB
         wgEc8tvxWCDiZQn6ZmmTtQQgLCKUJ1pfHfJgfhmOYR0+YUbnOVU7AH4vdem45T5A2e5P
         qYdg==
X-Gm-Message-State: APjAAAVvqeYYk7utpdrwsyPKat5jIH4B8/S5RCDGivLtHdYe4S60rcqO
        IExsVO2T6gYh8J1SLTTkBXR0WU8tU1ozLKkZX8U=
X-Google-Smtp-Source: APXvYqx6dQolbw8Rp/LcZrv/1k/mZG5cye9NRQhCdm7Ji8WlLBIHLw58x9t5q/LZQqF76ZkeHIjJQL+dlujcK2dNEYM=
X-Received: by 2002:a5d:6302:: with SMTP id i2mr475900wru.249.1567650029920;
 Wed, 04 Sep 2019 19:20:29 -0700 (PDT)
MIME-Version: 1.0
References: <1567536830154206@kroah.com> <20190903204427.GO5281@sasha-vm>
In-Reply-To: <20190903204427.GO5281@sasha-vm>
From:   Chunyan Zhang <zhang.lyra@gmail.com>
Date:   Thu, 5 Sep 2019 10:19:53 +0800
Message-ID: <CAAfSe-seN08PhaJ1o-X5PegsQqpYAnbZAwDXHNGcsT1pPT5wyA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] mmc: sdhci-sprd: add get_ro hook function"
 failed to apply to 5.2-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Sep 2019 at 04:44, Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, Sep 03, 2019 at 08:53:50PM +0200, gregkh@linuxfoundation.org wrote:
> >
> >The patch below does not apply to the 5.2-stable tree.
> >If someone wants it applied there, or to any other stable or longterm
> >tree, then please email the backport, including the original git commit
> >id to <stable@vger.kernel.org>.
>
> I've fixed it up for 5.2, it's not needed on older kernels. Contextual
> conflict due to missing 7486831d7d6ae (mmc: sdhci-sprd: Implement the
> get_max_timeout_count() interface), I just took 7486831d7d6ae as well.

Many thanks!

Chunyan

>
> --
> Thanks,
> Sasha
