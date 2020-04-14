Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048C21A766D
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 10:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437046AbgDNIuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 04:50:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39329 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729365AbgDNIut (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 04:50:49 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200414085046epoutp046b59c681e432b03bb66e98cf77660c27~Fo4edeFvY3014730147epoutp04R
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 08:50:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200414085046epoutp046b59c681e432b03bb66e98cf77660c27~Fo4edeFvY3014730147epoutp04R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586854246;
        bh=zrrHqqNwdMKDWaHTAysIckOfY4g3NTOPlecNpyH6CWI=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=idZ5y9im1W4Y8jngFKmh14GhEiyURP4rDpUhfUcvJ/qe1Yqnt6zql/QSwGm82MQmF
         LpHXoad7H3P+JIZnqtJowfHOSW0f85qMBOyByh6otP5tm73OQNEwqmnjwl/iZb1qMv
         TskOQaKhm3n/iKMXTbKFyVdzkr0JE2itPobgr6oc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200414085045epcas2p448e4e7d53ca99b037f47730f0aa228fc~Fo4d6gUhn2395723957epcas2p40;
        Tue, 14 Apr 2020 08:50:45 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.186]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 491fMl38bFzMqYm0; Tue, 14 Apr
        2020 08:50:43 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B2.DA.04704.269759E5; Tue, 14 Apr 2020 17:50:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200414085041epcas2p408450dc1da5e8fb071ac737e7b3a6c49~Fo4Z-VQ681716717167epcas2p4c;
        Tue, 14 Apr 2020 08:50:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200414085041epsmtrp16129248bfdf5318218148147c0c5c15e~Fo4ZRp9I21345413454epsmtrp1W;
        Tue, 14 Apr 2020 08:50:41 +0000 (GMT)
X-AuditID: b6c32a46-829ff70000001260-5d-5e957962783e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.6A.04024.069759E5; Tue, 14 Apr 2020 17:50:40 +0900 (KST)
Received: from KORDO025540 (unknown [12.36.182.130]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200414085040epsmtip17b8adc0286311d0016ee951017d73cbe~Fo4ZDPCcW0276402764epsmtip1i;
        Tue, 14 Apr 2020 08:50:40 +0000 (GMT)
From:   "Gyeongtaek Lee" <gt82.lee@samsung.com>
To:     "'Greg KH'" <greg@kroah.com>
Cc:     <stable@vger.kernel.org>, <broonie@kernel.org>, <tiwai@suse.com>,
        <tkjung@samsung.com>, <hmseo@samsung.com>, <kimty@samsung.com>
In-Reply-To: <20200414081643.GB4149624@kroah.com>
Subject: RE: [PATCH 0/4] Fixes for ASoC DPCM and topology
Date:   Tue, 14 Apr 2020 17:50:40 +0900
Message-ID: <009501d61239$c692beb0$53b83c10$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQIzFFdprZ/InREUiF4vsng2icudxgJMRC72AgXg9CKnm7cmAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbUhTYRTm3b2797qa3ZbVwaLWrX4UaLtbm1drWdnHKKGBRWSlXdzFSfti
        d1YGgSmYmpaS9jHNTLLAKGst+1IqKyPNElKiMMWw7AOTSrKiom13kf/Oec7znPOc9z0UpjpN
        RFNZDo/gdvA2hlDgTfcWxMVk5FSmaZ7Vy7jKgUGCe1J7HHHHmw7i3Pkev4yrvfwacZfGLiDu
        /v4K2XLS5GsoIkzDA2bTIX8DMjX6e3DTV98sszzVttQq8BbBrRYcGU5LliPTyKxPSU9K1xs0
        bAwbz8UxagdvF4zMqmRzzJosW8AFo97F27IDkJkXRWbRsqVuZ7ZHUFudosfICC6LzcWyrliR
        t4vZjszYDKc9gdVotPoAc4fN+is/D3MNKvZ0tVcRuegWVYwoCujF0Da8vRgpKBV9HcGjox24
        lHxBUHb1pVxKviHo6yrFilFESPH8dle40IKg7vGgTEreIygsySOCLIKOgdG+3pAiilbD07Z2
        MkjC6AIElT9P4cHhETQLb7vpIGcKHQ8jL/pDfJyeD19vtpBBijKAd47GBWElPRkenRjEgzFG
        z4Zrw9VhQ2r48easXMKjoKqoIDx2JXTX3QgZBXqEgKN/RuTSzqugrMMpaafAh4d+Uoqj4f3h
        AlLi5yP41PkrXKhAUHRQJcU68J9slwX7YPQCaLy5SGo5F+6/DFuLhMJ7v0kJVkJhQVjIwOX2
        PzIJBqi5RJYhxjtuL++4vbzjdvH+H1WL8AY0TXCJ9kxB1Lq043/ah0LnuXDNdXTmSXIroinE
        TFSWbahIU8n5XWKOvRUBhTFRykZ7ZZpKaeFz9gpuZ7o72yaIrUgfePVyLHpqhjNw7A5POqvX
        GgyaeD2nN2g5ZrrSN+HFNhWdyXuEnYLgEtz/dDIqIjoXsWvnbRjamrI7F/U0p9StI5MTe791
        V0XqJtXPWW2FJZsjjTX1PYakHP2DUzVRXMuB0qkX60f7ryg2EmbL7sevdCXKd2TbxxloryLh
        +wfX4hUV5QM1vhLj3LEtvxNVDXeH3EcSGzfFL8E81ft0KqH03J3O1GYdYZv5+di87eZZXAeD
        i1aeXYi5Rf4vTBnZRLQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42LZdlhJTjehcmqcwbaZphZTHz5hszi3YAaj
        xYxt3SwWq69uYbJYsPERo8WG72sZLY40TmFyYPfYtKqTzePtwwCPvi2rGD3Wb7nK4vF5k1wA
        axSXTUpqTmZZapG+XQJXxp/mJuaCJ1wVF07NZmtg3M3RxcjJISFgInF9/wVWEFtIYDejxPmN
        ohBxCYkP88+wQ9jCEvdbjgDVcAHVPGeUODfrNyNIgk1AV+LLvTvMILaIgILE+WOn2EGKmAX6
        GCU6v1xkhpi6gVFiwtbqLkYODk4BQ4lnVwRAwsIClhLvb94HK2ERUJX4vGsvO0gJL1D87Bdz
        kDCvgKDEyZlPWEDCzAJ6Em0bwbYyC8hLbH87hxniNAWJn0+XsULERSRmd7ZBXeMkcWXRTtYJ
        jMKzkEyahTBpFpJJs5B0L2BkWcUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERxFWpo7
        GC8viT/EKMDBqMTDO8F/SpwQa2JZcWXuIUYJDmYlEd71uVPjhHhTEiurUovy44tKc1KLDzFK
        c7AoifM+zTsWKSSQnliSmp2aWpBaBJNl4uCUamCsnLt95cxpEeducEXcOc5hMb/1WmrEzz2n
        TWa53HbpqjvPJbqSPdS9O6PkAM+JqackMvteO8X+2LPn5D/LsKObHA8V1XVPj5y1myG+Lmzb
        D9dbG/r2uPzs6AwTWZuqtlTOJHWB7PlFR8R384gxi506a1uuPmvP/JLZG5SNLR9fP9kwcfcL
        66hDSizFGYmGWsxFxYkABM3ztp4CAAA=
X-CMS-MailID: 20200414085041epcas2p408450dc1da5e8fb071ac737e7b3a6c49
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200414014858epcas2p3e9028454a601cd9852ba6444f183d8c9
References: <CGME20200414014858epcas2p3e9028454a601cd9852ba6444f183d8c9@epcas2p3.samsung.com>
        <000401d611fe$dd1589f0$97409dd0$@samsung.com>
        <20200414081643.GB4149624@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 14 Apr 2020 10:25:45 +0200, Greg KH wrote:
>On Tue, Apr 14, 2020 at 10:16:43AM +0200, Greg KH wrote:
>> On Tue, Apr 14, 2020 at 10:48:57AM +0900, Gyeongtaek Lee wrote:
>> > Hi,
>> > 
>> > I'd like to request cherry-picking some fixes for ALSA SoC to stable branch.
>> > Those patches are fix or add couple of functions which are essential when ALSA topology and Compress offload is used with
Dynamic
>> > PCM.
>> > All fixes are tested on 4.19 and 5.4.
>> > 
>> > 1. Fix overflow of register mask when shift value is set to 32.
>> > 2. Default value setting for virtual kcontrol
>> > 3. Error on offload playback start or stop after pause
>> > 4. Prefix missing when a kcontrol is created with ASoC component with name prefix.
>> > 
>> > Commit ID:
>> >   0ab070917afdc93670c2d0ea02ab6defb6246a7c
>> >   3bbbb7728fc853d71dbce4073fef9f281fbfb4dd
>> >   21fca8bdbb64df1297e8c65a746c4c9f4a689751
>> >   abca9e4a04fbe9c6df4d48ca7517e1611812af25
>> > 
>> > Kernel version wish it to be applied:
>> >   5.4
>> 
>> Wait, you say 5.4, but you tested on 4.19?  What about older kernels,
>> some of these seem relevant there too.
>
>Looks like it builds everywhere, so I've now done that.  If I should
>drop this from any specific kernel version, please let me know.
>
>thanks,
>
>greg k-h
>
Thank you so much for your kind work!

Gyeongtaek

