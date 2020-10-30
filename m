Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C032A0530
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 13:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgJ3MRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 08:17:17 -0400
Received: from mout.gmx.net ([212.227.17.21]:49561 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ3MRR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 08:17:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1604060235;
        bh=Yznrua1rAYLJyzyX5Y20Rgf33YP7dTKuIxygcJ2Da2w=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Tli26PxQFCN2nmTkC92y1kZc2wOrrkLWFHiWSmYgyirK8zA60x4H5jLU8xHTk7Ele
         6AcKXSe/R1O3xeJNtb4sc8qUQUwaOu4R+6TTTvYxAJ48Lw6bTwKPuKcWio6LQpafoJ
         6Iuar0MK8D1ZXS/jifC/nXsdjxae+rN/yau/r77E=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.24.28]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MDQeU-1kgkoe3UFa-00AUzj; Fri, 30
 Oct 2020 13:17:14 +0100
Subject: Re: [PATCH 5.9 000/757] 5.9.2-rc1 review
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <d8211fcd-ddb5-34e1-1f9e-aa5b94a03889@gmx.de>
 <20201029091412.GA3749125@kroah.com>
 <16326ab5-79f3-2e1b-511f-31f048608e6f@gmx.de>
 <20201029191750.GA988039@kroah.com>
From:   Ronald Warsow <rwarsow@gmx.de>
Message-ID: <0928177e-0c93-b06b-59a6-b7597659ff34@gmx.de>
Date:   Fri, 30 Oct 2020 13:17:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201029191750.GA988039@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jlKTkQkRJNc4/WpJSp7XUBcjiDU1w7e05OzY18NKpkvOPYuI4Ds
 jw5Q5fz+ZzzstfYK2LzM367Phajud5vGMnld85PTzbLZmci0Ga3vIbm0h87zGRWlDVa0oaD
 XW0sAmAGXpI2Mr/Ad1+bBVMLJINFbnHTc9rH+4oFwTqOVXUi2kg0Z4dxuaduOovonqfkJoJ
 WbgMve/hhitO3MotKKHWg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:AFxalEPT35Y=:uu8SR6GjtLLNlumhHGW3wQ
 9yETuXk8h11rnkRddQb681HVd2Asdk+xUuHQ1x+SuIcB3lovsCPJbekUXvLsamtdIyPSIK6hH
 t10kfS9nBd8DrOeXMI9GH8NjK37cS8kKZt64eA0xUsdl7nKNZ4AVJBCNqdJO2ieKQxMJG1Sit
 LKX3XwwYyKIQiTHgBSgzSeGWYEsFCSKyQJpRd08/nF3jLJodSGzLdLxn+N6SIkU7EL1kFcGwb
 xkgtSjwulBcWjhgnEoMOY57qNSAdozha0cFZQNr/8HrpmFgkKKKq2WVdKyb4dcpvvFO9/Uuip
 S13BOx+YQaGX80uolpfBCo0Y/fp8oqcL9RsNdVS745jWM9RqHm2ukgCqhh6H58lRpOrPkDzsJ
 ZKTq78V8ohF7kDqUxdxyS71SME6bj9X808qTnduBfbggmTxzQu9TaHxo7yn/vv98Y0E7voOZO
 bdn9SUlsXL7VrWUXSztIcwSS+8Twy7nfMCVGcoi0Zv+NDmq+28+IkBD2QyjUSYYcKK/PCg3tJ
 3UmoKH5DK51wHo0ZLk3tdOnZF4xf5o4jpD2K9K4t+spVP1kRJ3IjdhXteroAH+9LqjaW33S53
 yOUffp54zNodOCu+skw8mznsFA877zHqDExdEFV+JHTtlkpuhhZjLbIdfs7Qgyg0z39Dar3iJ
 OxVNQ8/e17q8j9C/kuML+QQuwUpNmohtZ3mbmqTw7hRS7uJw/JSq7Y2V0igg++/mygRNzeiOJ
 w0XSxSs+Pp3VMLPEe8xLCVW5xPK6EC7Td9poqfC4clulUGvF3md8lqKYa4g8S2RngUtZkPYbb
 NlQOgHEH796jbQe0HInFVXmAwrgRnfS5jW2iuDxvGZiHf0t0op3K/xg85tygNGydjtJrQGbMZ
 Ctiz4C2+23F+2uGnw2zA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29.10.20 20:17, Greg KH wrote:
> On Thu, Oct 29, 2020 at 03:42:09PM +0100, Ronald Warsow wrote:
>> On 29.10.20 10:14, Greg KH wrote:
>>> On Tue, Oct 27, 2020 at 07:09:52PM +0100, Ronald Warsow wrote:
>>>> Hallo
>>>>
>>>> this rc1 runs here (pure Intel-box) without errors.
>>>> Thanks !
>>>>
>>>>
>>>> An RPC (I'm thinking about since some month)
>>>> =3D=3D=3D=3D=3D=3D
>>>>
>>>> Wouldn't it be better (and not so much add. work) to sort the
>>>> Pseudo-Shortlog towards subsystem/driver ?
>>>>
>>>> something like this:
>>>>
>>>> ...
>>>> usb: gadget: f_ncm: allow using NCM in SuperSpeed Plus gadgets.
>>>> usb: cdns3: gadget: free interrupt after gadget has deleted
>>>>
>>>>      Lorenzo Colitti <lorenzo@google.com>
>>>>      Peter Chen <peter.chen@nxp.com>
>>>> ...
>>>>
>>>>
>>>> Think of searching a bugfix in the shortlog.
>>>>
>>>> With the current layout I need to read/"visual grep" the whole log.
>>>>
>>>> With the new layout I'm able to jump to the "buggy" subsystem/driver =
and
>>>> only need to read that part of the log to get the info if the bug is
>>>> fixed or not yet
>>>
>>> Do you have an example script that generates such a thing?  If so, I'l=
l
>>> be glad to look into it, but am not going to try to create it on my ow=
n,
>>> sorry.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> first of all: in the above mail it should read "RFC"
>>
>>
>> Surely, who get the most benefit of it (the layout) does the most work.
>> Agreed, I will see what I can do -I'm unsure -
>>
>> Currently, I'm thinking that the data for your shortlog are coming from
>> a sort of an git query or so and it would just be an easy adjustment of
>> the query parameter.
>>
>> This seems not to be the case ?
>>
>> To get an idea if my knowledge is sufficing (I'm no developer):
>>
>> Where do you get the data from to generate your shortlog ?
>
> A "simple" git command:
> 	git log --abbrev=3D12 --format=3D"%aN <%aE>%n    %s%n" ${VERSION}..HEAD=
 > ${TMP_LOG}
>
> If you can come up with a command that replaces that, I'll be glad to
> try it out.
>
> thanks,
>
> greg k-h
>

I'll have a look into it.

=2D-
regards

Ronald
