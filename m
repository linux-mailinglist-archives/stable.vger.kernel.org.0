Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6865D29EE8A
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 15:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgJ2Omi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 10:42:38 -0400
Received: from mout.gmx.net ([212.227.17.22]:44233 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbgJ2Omh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 10:42:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1603982530;
        bh=B5fjuh1PbI2SnXgyH1envbzqQOQcynTKeIgMm8qOVds=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=fedIqrvoG7fKh5h3ebq51ck/RbloJoGFlk24O1iojof/4pW5ZmxAiwmarz70gdQWo
         sfjIRFwr56eCdxJWV6uqDqDXbrRhYnpKb/XbLS2UjcEB+oOTNPLvBbc1ZxoNOLRq2i
         InXe8VfPscjBU2TNJERfN0EZftL8VqFXCcyPEcM8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.27.25]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N7iCg-1kKD3Y0wbK-014mRS; Thu, 29
 Oct 2020 15:42:10 +0100
Subject: Re: [PATCH 5.9 000/757] 5.9.2-rc1 review
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <d8211fcd-ddb5-34e1-1f9e-aa5b94a03889@gmx.de>
 <20201029091412.GA3749125@kroah.com>
From:   Ronald Warsow <rwarsow@gmx.de>
Message-ID: <16326ab5-79f3-2e1b-511f-31f048608e6f@gmx.de>
Date:   Thu, 29 Oct 2020 15:42:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201029091412.GA3749125@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:77rbd7w+ZbYuLme15IYdzCwxmDvg/Zo/E4sAWQo30Ttu6x/psgU
 IsSLJBuhMGzbKmHDFYF1DZqUmMRZhDCFAKc63mdhPrzcmw/e477cBuJRQIBvTT/An6f9zPM
 tVwpxB/XviFkNVRqJ6slC5zAYEdInIEDnpzU64nnpPO4rLDFCseDOEpvUIcPxdPUYKJj/N4
 opl1NgYw/4RiMFpIdfKSA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hsNCIb0giBw=:pOB+d7racHse+T+1ZSIBat
 S2Uon1vsgAiPG0+s7saMaw1KhAhkLrjIpI5H2pcIGu/h+cQBJXjXFP5bWuOOWcJ6WCw0JSvBn
 cagxDj9NcQnCYXKDIv0yjiRCCkavYw2KP6Av/3C0MJhWRL/zJdo7FYsPFFqSDYGhiEF4ZkSYt
 SSVbwsgvz2fR6opu6QuLqibyb9boI+9olTXLO0hmXE5mbScR5aulOCK0h9OsoNp4tDd85yrGx
 +UKTPXbuohXxi4zSBfYf9l5tT99IU+UTmfYcvi+W3Yt1+asq38BoJJKm+oXqkdadgXgTnL6ye
 iEwlHyJgbVLpbDjND1Akb02K0bc+80ximHlXBhkgIHgGv/eaP53QUhdOT7e+1eVrYVR5D2MIb
 qMxs8gau9h1WY3GLXDG1Jt/gpCb6nqJ0llbKqZ1paCJf3xDUQY/nZKGEIHLNppMCFa6XucpHG
 Rj1PLa7CtTWLXeMngzeCoailPYwvo49aRNUVNNJ/w/T5byyTxWmuZFMn/qGPDtJDQTTUxhVa5
 ZDKDRkhycLLyFR+jqpj07qr1dAtu+iAxgqX3FqBjMJHIUTzXKB6xP8rMPidtDsT5W84ThlSm1
 oTHH+dQTI235UuaXAOLmNwXRWTVqkjw7jQkInK9N8oxyH0jn6QSm+UHudL8Vm35BC8dQfbIsB
 ptSecyQxabZbfdsHas5m8DKQ1jjEXbAKm3mVmlRF9QY3ApsI/FqkUPXqn+KQvMhxu1BpAzLNb
 L/goixo2wkDQQhH4kFGckNQcEjDTzhJezrbZ7DQI2QIi152r6KTgW9rcT5IHp3nc0vgNjxHAT
 ILux69gYkG9SM4nLQck/tubBdFJ/+bdIboizgusfgkJhjfqKf+BmDKboWfI8aWfX4YUxyVelz
 5ZT1iLvbey0iTtWAfYoA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29.10.20 10:14, Greg KH wrote:
> On Tue, Oct 27, 2020 at 07:09:52PM +0100, Ronald Warsow wrote:
>> Hallo
>>
>> this rc1 runs here (pure Intel-box) without errors.
>> Thanks !
>>
>>
>> An RPC (I'm thinking about since some month)
>> =3D=3D=3D=3D=3D=3D
>>
>> Wouldn't it be better (and not so much add. work) to sort the
>> Pseudo-Shortlog towards subsystem/driver ?
>>
>> something like this:
>>
>> ...
>> usb: gadget: f_ncm: allow using NCM in SuperSpeed Plus gadgets.
>> usb: cdns3: gadget: free interrupt after gadget has deleted
>>
>>     Lorenzo Colitti <lorenzo@google.com>
>>     Peter Chen <peter.chen@nxp.com>
>> ...
>>
>>
>> Think of searching a bugfix in the shortlog.
>>
>> With the current layout I need to read/"visual grep" the whole log.
>>
>> With the new layout I'm able to jump to the "buggy" subsystem/driver an=
d
>> only need to read that part of the log to get the info if the bug is
>> fixed or not yet
>
> Do you have an example script that generates such a thing?  If so, I'll
> be glad to look into it, but am not going to try to create it on my own,
> sorry.
>
> thanks,
>
> greg k-h
>

first of all: in the above mail it should read "RFC"


Surely, who get the most benefit of it (the layout) does the most work.
Agreed, I will see what I can do -I'm unsure -

Currently, I'm thinking that the data for your shortlog are coming from
a sort of an git query or so and it would just be an easy adjustment of
the query parameter.

This seems not to be the case ?

To get an idea if my knowledge is sufficing (I'm no developer):

Where do you get the data from to generate your shortlog ?

=2D-
regards

Ronald
