Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2938A2F062B
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 10:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbhAJJW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 04:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbhAJJWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jan 2021 04:22:25 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14344C061786
        for <stable@vger.kernel.org>; Sun, 10 Jan 2021 01:21:45 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id v14so11253580wml.1
        for <stable@vger.kernel.org>; Sun, 10 Jan 2021 01:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UQ67TvKAZwTSJJyS4wfyfVxfRuP3N4HdanGuCfvJ1aQ=;
        b=OYOb+lN9SXoMjHJsumjJyccR07w/tvMrkzNg5s3kvsXFq8R5RZwzv7VhXSNvSkgHv3
         YNZ4U7Zvx7GAOiidt/v9JPIEebSkbok6XOFeDdHXnDX07fUJV6ffOyh0sOQh1TajaCiB
         lpOvxBOK83lSHUEl+wbKStsBsgaDaFlBgZYNrCengsrus6If2ji+FzPxv+KGbVrQ3hn3
         NbEXU+Wxsv2HFInzNrPoERGraKuXgzBxxw9F3alj0+RAIcaX9yFa62CYuM5wl93fvoB5
         ctoO+wrPp9HtzQSCQFPDWG1hrrfgGLJkP4PIWMfJAitliP2f6IDUqejVZgdEC9aJ3FKn
         trSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UQ67TvKAZwTSJJyS4wfyfVxfRuP3N4HdanGuCfvJ1aQ=;
        b=omft4vVISyzx3xzzWk1V80vQj8DGTh5wC6jzP86Be21p3x03mi+buRpZ+rvHTwdrdN
         TgIpmwrKWwZQTDkWLHn+ZslGLatIbR1dvjUmHmb5r3oveogObiE1a2PEQ3ibZhVkok5w
         xC0UvcqLEHp6BNjkZG3Coq5p3ZcqzrvuFyMJj1JxoXTfhJtIwStu19JUCc26eBhzLXfa
         j6/RxPMhDsIMFG3S208v+rw8l6poq+WFVLc5uy0CNOu+FRJxa1q/+dh9a4YsIq3Pz9MK
         2gGLZVyPsyFCQXCt6MsPWv0lFynlGkj+nalk7VO+0fwcXlEipWmNUlzsjuDBWYZ8ZvXT
         AyzA==
X-Gm-Message-State: AOAM532IElE3Hl3tz4qg/01j3jfkwjFGSMXisduJYe4YlhklY/2kW868
        407kha9p2JE9bbTbnWpMatpCdw==
X-Google-Smtp-Source: ABdhPJzt9b0N+a68pfVGpZPovrnWaf51VRJ2VrCFZxFQNrXUcC0f+sF/yPgmonBM/sKIHnvgprj4cw==
X-Received: by 2002:a1c:2ed2:: with SMTP id u201mr10156613wmu.79.1610270503751;
        Sun, 10 Jan 2021 01:21:43 -0800 (PST)
Received: from [192.168.0.13] ([83.216.184.132])
        by smtp.gmail.com with ESMTPSA id s6sm21676723wro.79.2021.01.10.01.21.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Jan 2021 01:21:43 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 1/3] bfq: Avoid false bfq queue merging
From:   Paolo Valente <paolo.valente@linaro.org>
In-Reply-To: <AF7DA035-BC93-42D2-B0B6-8ECC3273DEBC@linaro.org>
Date:   Sun, 10 Jan 2021 10:21:42 +0100
Cc:     linux-block <linux-block@vger.kernel.org>, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <58F09812-52B9-4B55-A37B-E180364DD4AA@linaro.org>
References: <20200605140837.5394-1-jack@suse.cz>
 <20200605141629.15347-1-jack@suse.cz>
 <FC3651A1-DB65-4A77-9BFB-ACAB80E54F3E@linaro.org>
 <20200611083149.GB18088@quack2.suse.cz>
 <AF7DA035-BC93-42D2-B0B6-8ECC3273DEBC@linaro.org>
To:     Jan Kara <jack@suse.cz>
X-Mailer: Apple Mail (2.3445.104.11)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> Il giorno 11 giu 2020, alle ore 16:12, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>=20
>=20
>=20
>> Il giorno 11 giu 2020, alle ore 10:31, Jan Kara <jack@suse.cz> ha =
scritto:
>>=20
>> On Thu 11-06-20 09:13:07, Paolo Valente wrote:
>>>=20
>>>=20
>>>> Il giorno 5 giu 2020, alle ore 16:16, Jan Kara <jack@suse.cz> ha =
scritto:
>>>>=20
>>>> bfq_setup_cooperator() uses bfqd->in_serv_last_pos so detect =
whether it
>>>> makes sense to merge current bfq queue with the in-service queue.
>>>> However if the in-service queue is freshly scheduled and didn't =
dispatch
>>>> any requests yet, bfqd->in_serv_last_pos is stale and contains =
value
>>>> from the previously scheduled bfq queue which can thus result in a =
bogus
>>>> decision that the two queues should be merged.
>>>=20
>>> Good catch!=20
>>>=20
>>>> This bug can be observed
>>>> for example with the following fio jobfile:
>>>>=20
>>>> [global]
>>>> direct=3D0
>>>> ioengine=3Dsync
>>>> invalidate=3D1
>>>> size=3D1g
>>>> rw=3Dread
>>>>=20
>>>> [reader]
>>>> numjobs=3D4
>>>> directory=3D/mnt
>>>>=20
>>>> where the 4 processes will end up in the one shared bfq queue =
although
>>>> they do IO to physically very distant files (for some reason I was =
able to
>>>> observe this only with slice_idle=3D1ms setting).
>>>>=20
>>>> Fix the problem by invalidating bfqd->in_serv_last_pos when =
switching
>>>> in-service queue.
>>>>=20
>>>=20
>>> Apart from the nonexistent problem that even 0 is a valid LBA :)
>>=20
>> Yes, I was also thinking about that and decided 0 is "good enough" =
:). But
>> I just as well just switch to (sector_t)-1 if you think it would be =
better.
>>=20
>=20
> 0 is ok :)
>=20

Hi Jan,
I've finally tested this patch of yours. No regression.

Once again:
Acked-by: Paolo Valente <paolo.valente@linaro.org>

Thanks,
Paolo

> Thanks,
> Paolo
>=20
>>> Acked-by: Paolo Valente <paolo.valente@linaro.org>
>>=20
>> Thanks!
>>=20
>> 								Honza
>>=20
>> --=20
>> Jan Kara <jack@suse.com>
>> SUSE Labs, CR

