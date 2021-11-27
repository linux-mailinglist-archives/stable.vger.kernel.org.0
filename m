Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F80545F7F1
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 02:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344837AbhK0BXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 20:23:09 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:31208 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbhK0BVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 20:21:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637975875; x=1669511875;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=utQLa83hwo/LT3g1aLDWo1eI0/DqR7aayg7wMGJqu70=;
  b=LqpJMk93auBRxYW4H6IB2ydg052mYPcVygKRvHMn5BsarxSmEdzAQZgp
   amk8FVZrxZOXFweBNpNIWovc2b6r/KcwctyHD4heZgVYSAqpetFGDom2d
   aMALRdx4+tNEXP2EHMm/hCW7N/J/AhFjUpoBd6DiZz6wBNlMk1H7Hwp+h
   iUr5WT53y9hg76C4aQ1nTg4OYqnDYEuA0DEigYLYzHabJIkrdwa+T8TPZ
   Fo1zq6aWvk3todpR0GgG6HvMDt6eSzYNIJmmPJ83QnjHOiiKB30KvKxi4
   gK5oz2H7fqazbEjg1VMHGm6nxReey7I7iIiYVsse/eda+F8rO+FE8kwaq
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,267,1631548800"; 
   d="scan'208";a="185778782"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Nov 2021 09:15:55 +0800
IronPort-SDR: 1xBCgNnfX8G2K9E10dEpkeh5xmGGBIHB6RNOeQKNPOR+XTN8ZF+PqJQh8lW3Fmq3/q0wvr5t2d
 leH78slQxtaS6WVlbUYWEtSgb2OUJxJ/mhvxlzaFSuJPGE/tUacUr+n84sUK3H6yNs0UpxgthG
 0IF6AmYO4UzAUUaIt5UC32IIna3+vPhISRozRrbRTmgjk264FCWgjPkTHVm+W49hONGbbLAA0b
 dLg5BUme6HT0a45FaZ2zRdzGHvyrd+V+j+PLdcqiy8kC0Do/9BOPslksfcwzT9C57kz0vqtjLd
 EXd7EHhPz8rjROrY8MVUyxqb
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 16:49:12 -0800
IronPort-SDR: qn0xGnnk9kCgPKG5KuRhMNUR3e4Amfoiv0DUdeGGJVUdcQsh2Oo++mErj102BVXlipp42E6xg8
 BjR6bOT2umBc57NQr1b95Q2/6tsIIfezdjj61k2jwZpkh8MG2dU3qb3COFWt62LoBpcMiIy08t
 3d65d6weiDio0P9qwPrb4yPqMVS78jc967m+6cBrlZRQ40l+WjyT5qBt0d1/MDlYZyczcMKrIk
 eI76uVX1K1wKGCVVZpK5K5bvLZb6aPn/am69WmQK+kMwfUxkHaVtRX5Yrxqi9eb2nK3Zhfj2qC
 QKU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 17:15:55 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J1DFl0Gzmz1RtVw
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 17:15:55 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637975754; x=1640567755; bh=utQLa83hwo/LT3g1aLDWo1eI0/DqR7aayg7
        wMGJqu70=; b=Xuo7PYG1tXSUDqz8aNP4JV/uYIPuHQF4yk9dy8GhY9SpAaSJ82G
        KrB3oIiVJXJpi7AP3LbCGaluD0UpqJU1loHZfF17eMxg6wxR3t2UubnAhCMAAI0c
        l9Fcaok+yRsVwsuzapM0UTrAKbt3QbcbqBKXqxLPKoBGllu0Lh2wEbXPsfFq1b+b
        oEoLQFDpkpo7VCgf1MJ6KtBLfJzuqySOU6jWxQXX1ay8Tpy2GziOow03s2fzWOPB
        Tp1gZM0l5hTpTYdkw0BhrWH9Park2jEocDbEZRVYBQm9ZfTTfoasxNkJPPSzn5/W
        bP2OCBJ2mEPuqcjElnDjQMP8vyrFVFsqfNA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UXK7UkMg1Xj2 for <stable@vger.kernel.org>;
        Fri, 26 Nov 2021 17:15:54 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J1DFj1ZRdz1RtVl;
        Fri, 26 Nov 2021 17:15:52 -0800 (PST)
Message-ID: <92cc74fd-ce93-b844-830f-71e744e0c084@opensource.wdc.com>
Date:   Sat, 27 Nov 2021 10:15:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [Regression][Stable] sd use scsi_mode_sense with invalid param
Content-Language: en-US
To:     Tom Yan <tom.ty89@gmail.com>, linux-scsi@vger.kernel.org,
        damien.lemoal@wdc.com, martin.petersen@oracle.com,
        sashal@kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
References: <CAGnHSE=uOEiLUS=Sx5xhSVrx-7kvdriC=RZxuRasZaM2cLmDeQ@mail.gmail.com>
 <CAGnHSEmFoAS-ZY6u=ar=O0UU=FPgEuOx5KLcBWkboEVdeFXbGg@mail.gmail.com>
 <CAGnHSEmkTyq_QqP9S6TemsHOKxj2Gzq3R7X6+PxbQs_R-iBB7Q@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <CAGnHSEmkTyq_QqP9S6TemsHOKxj2Gzq3R7X6+PxbQs_R-iBB7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/11/27 6:33, Tom Yan wrote:
> Hi Greg,
> 
> Could you help pulling c749301ebee82eb5e97dec14b6ab31a4aabe37a6 into
> the stable branches in which 17b49bcbf8351d3dbe57204468ac34f033ed60bc
> has been pulled? Thanks!

Yeah, in retrospect, these 2 patches should really have been squashed together.
Sorry about that. Note that none of these were marked for stable though. I think
that Sasha's bot picked-up automatically
17b49bcbf8351d3dbe57204468ac34f033ed60bc for stable because of the "Fix" in the
commit title. But c749301ebee82eb5e97dec14b6ab31a4aabe37a6 also has "Fix" in its
title but was not picked-up. Weird.

Greg, Martin,

To fix this, c749301ebee82eb5e97dec14b6ab31a4aabe37a6 is needed in stable !

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=215137

Thanks.

> 
> Regards,
> Tom
> 
> On Sat, 27 Nov 2021 at 05:21, Tom Yan <tom.ty89@gmail.com> wrote:
>>
>> Ahh, looks like the required change to sd
>> (c749301ebee82eb5e97dec14b6ab31a4aabe37a6) has been added to upstream
>> but somehow got missed when 17b49bcbf8351d3dbe57204468ac34f033ed60bc
>> was pulled into stable...
>>
>> On Sat, 27 Nov 2021 at 05:11, Tom Yan <tom.ty89@gmail.com> wrote:
>>>
>>> Hi,
>>>
>>> So with 17b49bcbf8351d3dbe57204468ac34f033ed60bc (upstream),
>>> scsi_mode_sense now returns -EINVAL if len < 8, yet in sd, the first mode
>>> sense attempted by sd_read_cache_type() is done with (first_)len being
>>> 4, which results in the failure of the attempt.
>>>
>>> Since the commit is merged into stable, my SATA drive (that has
>>> volatile write cache) is assumed to be a "write through" drive after I
>>> upgraded from 5.15.4 to 5.15.5, as libata sets use_10_for_ms to 1.
>>>
>>> Since sd does not (get to) determine which mode sense command to use,
>>> should scsi_mode_sense at least accept a special value 0 (which
>>> first_len would be set to), which is use to refers to the minimum len
>>> to use for mode sense 6 and 10 respectively (i.e. 4 or 8)?
>>>
>>> Regards,
>>> Tom


-- 
Damien Le Moal
Western Digital Research
