Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46331BB5D6
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 07:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgD1FXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 01:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725792AbgD1FXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 01:23:48 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60291C03C1A9
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 22:23:48 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id d197so6324064ybh.6
        for <stable@vger.kernel.org>; Mon, 27 Apr 2020 22:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=draconx-ca.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=soKXOGTdHIofr3Yf+54NHNG9tiLfeyhq6J/nrePKJX4=;
        b=mJpP6O5PXac54J0K+dRqMwRctOq1kyiNf5Rflc9J5ziICtKvPVvnVShRSIzCq3BSuH
         Pd7+KKoUUkdSgBwnOKkq1NevWCaFLNbhut7RF7n9e6rbcKnfCYkqW3xjPfJcZsuvHjqX
         vXjnZHhym4PYvc3SVxmFDq9xQdVrNamtkrCWGa5Qwl6i1a8H28BS9Ht59J3UJeH4jHQC
         wB4sdIIQRqTprEvDyausggtLo4G4CUnh5lCeCZfur+AEG2cQNnzdmnrZpMQG72adqDZ9
         Yny6YR1Ci2ap+Ek6/nmP1FANSuEF2aTMpfdQ40tAsDQ7skn+eTJU60arnDD+V2mtsJIq
         7/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=soKXOGTdHIofr3Yf+54NHNG9tiLfeyhq6J/nrePKJX4=;
        b=KzkuYzUWNXEsivLS8Mu0jfGR0IeCSwzoQ3oKKL0enV6Jj5GJ4YJANbt0IpXj+Mkbgp
         /HZUq2gcCBW4sFhhiKSAIpjEV4umIe6Ou+JRDCqp3tfInh+Al7JW5ijOYMyzLoYonb+M
         tY8mIQCji7Wk3OLbXPO8q+4iHeTLgV/uAvFoAGMUaASvST9l4ViFc8xXkPQG9VrkgGNo
         RLDfUprKoPyFrcCRroeec3seteTeGrMKnue0db1EDHwkNMOxBHhD+vZcqtoxWcSeGY2y
         S9bm6/t71u/CxG/a65nF3Xo573YbkFfnU2xmxcUNp5TCCKpD/MAdZFc/AoTQMcdKow3N
         lOGg==
X-Gm-Message-State: AGi0PubQ5B18PzqTI7TKuUxGkFAkIvzXuOb7en7kjF2AuSBdoCL43aKr
        fQNUopSBldQV1Wb7O2Cs52pVWRHcFjP37lh5l+41tQ==
X-Google-Smtp-Source: APiQypI8lc33BnS/i6tpuW4cnEXzEeQUq7XaUs2oTS8y6bUkrFrtA9hkhaQWD5JgqpSDqBkta9JkVGHW3yeCz1VLG7U=
X-Received: by 2002:a25:bcc8:: with SMTP id l8mr32743079ybm.225.1588051427543;
 Mon, 27 Apr 2020 22:23:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a25:5e84:0:0:0:0:0 with HTTP; Mon, 27 Apr 2020 22:23:46
 -0700 (PDT)
X-Originating-IP: [24.53.240.163]
In-Reply-To: <CA+G9fYtuzvLSyqSkG8kCPk7exz16P4f5tYf-DTqV2p+eucKOLA@mail.gmail.com>
References: <20200418144047.9013-1-sashal@kernel.org> <20200418144047.9013-38-sashal@kernel.org>
 <CA+G9fYtuzvLSyqSkG8kCPk7exz16P4f5tYf-DTqV2p+eucKOLA@mail.gmail.com>
From:   Nick Bowler <nbowler@draconx.ca>
Date:   Tue, 28 Apr 2020 01:23:46 -0400
Message-ID: <CADyTPEyHmxwskNAru-6asz-YYQZnzkMwJ1Rp1pFK+a8QHDRacQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 38/78] nvme: fix compat address handling in
 several ioctls
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
        lkft-triage@lists.linaro.org, Basil Eljuse <Basil.Eljuse@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-04-28, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> On Sat, 18 Apr 2020 at 20:24, Sasha Levin <sashal@kernel.org> wrote:
>> From: Nick Bowler <nbowler@draconx.ca>
>>
>> [ Upstream commit c95b708d5fa65b4e51f088ee077d127fd5a57b70 ]
[...]
>> +static void __user *nvme_to_user_ptr(uintptr_t ptrval)
>> +{
>> +       if (in_compat_syscall())
>> +               ptrval =3D (compat_uptr_t)ptrval;
>
> arm64 make modules failed while building with an extra kernel config.
[...]
> 72 ../drivers/nvme/host/core.c:1256:13: error: =E2=80=98compat_uptr_t=E2=
=80=99
> undeclared (first use in this function); did you mean =E2=80=98compat_tim=
e_t=E2=80=99?

Probably commit 556d687a4ccd5 ("compat: ARM64: always include
asm-generic/compat.h") is required to be backported to 5.4 as a
prerequisite for including this fix in the 5.4 stable series.

Cheers,
  Nick
