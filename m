Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F325ADB75
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 00:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiIEWga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 18:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiIEWg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 18:36:29 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A835721D;
        Mon,  5 Sep 2022 15:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1662417385;
        bh=yiVesrfOlJpJOX7dz3BqyA0z9eHEptVvoWN+YAoJE3g=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=hzm0A+rQLqza+2eAqagSF6PaFlllOUXLJp3brh1KEDnNNWeJ/kVUJN5kkl+2C8aCR
         GT+mcMhvshSsisT9WA5vE7k9AC9BlbspEWP7GNcTErT0DSP13b+bIZI2iVjdGCJVUR
         1dEsanB7tCm/uLZ2kO/jhg9GKdOAnMka7XHhN1qE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MbRk3-1p78ID1Dp3-00buE2; Tue, 06
 Sep 2022 00:36:25 +0200
Message-ID: <8cdde981-6b70-3aa5-7cf6-5f7445c529e6@gmx.com>
Date:   Tue, 6 Sep 2022 06:36:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v3 1/3] btrfs: enhance unsupported compat RO flags
 handling
Content-Language: en-US
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1660021230.git.wqu@suse.com>
 <1b3011f4b1bf4e60479568fcd3e090ea8b68d253.1660021230.git.wqu@suse.com>
 <20220905145321.GF13489@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20220905145321.GF13489@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0as7XjgXT923CdCaaN1mFVgtaUlO86Z50EzlcMSxkFh7WDulTuS
 6Iv4ttN1jMww4cfXWt1P3Jerh6vsLAjyKoQ6qow15qrKMuzqrzBrF5C6KOUNTI2VDEUnxRw
 2ks8G+R0pEwsDBfyIwRsWp6pm2L6Ql5ixfYGg7W1K6dl4jV5iDjxvYe7HB9FB1p/YXw8iFp
 YN297o7qIVU+c5rk045DQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:J4LcuF+pD7Y=:A0JhZoNnO+ONVVU+gZyZcL
 +sygKGQXgfbulyaPPVfcj6c1gyr8fjW7Spaw98hh0rKbDc2oj8lPB9Z7A7MhKUececyTGfeuK
 fFHrk2H6DmbwsA6rV8LeB34Dgb/oviXXCAtOD1nnqppBeyoBMW6zoRqf7SkLwFmij9Zyp4YPt
 /z4w+d3+8mFCfOg/EPmv0Sn8euaXe3ph/RQq3ZzAa0fxRZwlwT0L3fxO3Ktt0jF4SNn/RxuCY
 8QOw9/wUMNP+JxKycbiZ92PeUbu2a2Lc5E2aPh8d2xfT7kU+nNDYKydEA0cDanHZ6Z4QzQPFZ
 OJd0oWSmia9XsLS7HKE6W96MuWARpboETNPH6KfUiAVUwOLv86tt8cmzbLpG3ixSm9jI9W6QM
 UiMy2ZekETEzHu9GsuJa0zRvFMVqdP/1MW7D1OMmwdOph8FEFkJJL5jspI12oMPJrlmLzlmKO
 oWv59hW2NqIWy2UMhv34Few0JF4zFCRvc4CSPSwpbCxCFqW+agmV59c8G9ClSC9r+fzb5yQag
 2Som8m9ahjGcqpd6xw9EAMUNBUCPX8HfUxLrBdcBjZPpghzYSOckR6eeFIU5zrsoiMLFArm+Q
 Rp2pc5lMOo5UQGvYvbGqjRxYvv7N2twY2xsDrZTDDSUQmsjJ7LpcACHfpC9RWIZp4FeRuOkFX
 Y9k2k8L/9hyFIUNAOkUcOlNJqSvpmm7VQtVvghdABnIJrLklvW/UDQBYp/j/V2t1poJWKIgg8
 HnIp6No2jEFVJW++gH3pSdYleUEeBOwjlNAc5q8W7gpxWIVDrTWUrAualbe3lm7Ui2CXGEoZf
 pwM7H9S4aCVV/+NQWs94DEitackDRY0RQAjYB9RtJKgQLad8kdf6bAWF50vM8f7ChdMQAhFjF
 6nRcYmM4Rg2Y/ZE5/17rGyITYvIsbVgVO1d555pAQKqbQi+YV42jzyttz9O6+Z6majyDTbIOF
 kitqKvN91E4RGX36dwBycZxtNCOmY3XrTWqFQrccjWGxqnC0t4ZfkOLWRGlCG+c9mmWZd6s5D
 ptEMI9QaR3NK3IjhjsWs2zXHV5mMmVDZLoLcXnQ4faFKczEY3aBlqMpJXEf7xd66/jYwmmaaJ
 HoGPQIzJOdn53BLdlAETniYDp8QAuHuY/C+uV1m9b2e7Hg1LhSKQuY8u8ioRzOskSK1Lq+L8f
 xwe8m9xFydm1KdtxwB120i+sU8
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/9/5 22:53, David Sterba wrote:
> On Tue, Aug 09, 2022 at 01:02:16PM +0800, Qu Wenruo wrote:
>> Currently there are two corner cases not handling compat RO flags
>> correctly:
>>
>> - Remount
>>    We can still mount the fs RO with compat RO flags, then remount it R=
W.
>>    We should not allow any write into a fs with unsupported RO flags.
>>
>> - Still try to search block group items
>>    In fact, behavior/on-disk format change to extent tree should not
>>    need a full incompat flag.
>>
>>    And since we can ensure fs with unsupported RO flags never got any
>>    writes (with above case fixed), then we can even skip block group
>>    items search at mount time.
>>
>> This patch will enhance the unsupported RO compat flags by:
>>
>> - Reject RW remount if there is unsupported RO compat flags
>>
>> - Go dummy block group items directly for unsupported RO compat flags
>>    In fact, only changes to chunk/subvolume/root/csum trees should go
>>    incompat flags.
>>
>> The latter part should allow future change to extent tree to be compat
>> RO flags.
>>
>> Thus this patch also needs to be backported to all stable trees.
>>
>> Cc: stable@vger.kernel.org
>
> This applies cleanly only to 5.19, anything else would need a separate
> backport. I'm planning to send this patch among 6.0 fixes so this
> should give us time to get it to older stable kernels before the block
> group tree is released.

No problem, in fact I (normally) only start backports when I got the
failed to apply message from Greg.

So I'd go the regular backport cycle for it.

Thanks,
Qu
