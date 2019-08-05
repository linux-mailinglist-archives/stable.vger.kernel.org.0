Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D13820DE
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 17:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbfHEPzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 11:55:39 -0400
Received: from mout.gmx.net ([212.227.15.19]:50481 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728759AbfHEPzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 11:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1565020532;
        bh=kpX1eCTg4k6fwGNvDOooQGZcP+ppeClP2cQPXdV5kgo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=l3vJi8uevfZCA0PNRsWf3yJqPTtjKOK8pgltOCp8tM6zD34P1oPJ+bbE1ambZNfl9
         Ele/Gkm+HpwAxc0RR1eFzcDwMCxTh4fx7HYf8I3B6dYbNcG1IGFle9LVYaETmBd4Gy
         PBBTDEYSC3ZZ2wSg/hIOZdKwfB4iVXzfTXUv6uOI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.129.10] ([95.91.214.154]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MPXhA-1hhvrq16oc-00MgC4; Mon, 05
 Aug 2019 17:55:32 +0200
Subject: Re: [PATCH 4.14] HID: Add quirk for HP X1200 PIXART OEM mouse
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
References: <20190724210324.4868F218B8@mail.kernel.org>
 <20190805141056.8764-1-s.parschauer@gmx.de>
 <20190805144351.GA30363@kroah.com>
From:   Sebastian Parschauer <s.parschauer@gmx.de>
Message-ID: <d50b694b-f7fa-227a-0e35-adcf2409daa4@gmx.de>
Date:   Mon, 5 Aug 2019 17:55:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805144351.GA30363@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:55U1YvwQh/WEdPRJvUotWou69623twUy2GXQOiD9QUsekD8aCJJ
 RidvxT46xj8o0EyQ5mWxrZd7vWZY3v5skvzhRyoQnaf+zJVpXsMlEcCCz5MjwnveUctKtkc
 2RRRT+8XcqWRQvNIRd86eLePFITVg/5BNu7fDLos25M8KiWwVsBsz8iFDZdastCzveyK0kN
 BtmSRULQiUiFXvdp5pz5A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wmudFeXd9Kg=:68TmrQXVo7PNj72rL28wxB
 jwNRcLaYxL1xzB0nRJXSTi+AGZVI/F8iDXr6+X1mFO+vJ11zhnuu1L5rhlVomzMkRjRmscX43
 ZteyZOsAT8BqDndSrbln8AWX7Il2WGj/g5yHxab+4lcrRZqDYMwGElbX66SBApuCf2jE/Ou2Z
 wvb/brUeDLpDKT+rAQJMzix/ptZ+EhbFgAAB0r4ob79bxOEtd+NQwWxaGbxIl+QdoXlIJ+NHO
 LzfPDLLKTafk3BzhJtVUwfp0o9POAw4E961etANdCiL9Q58O6+W03NRMJfTlfCJX1IrxVUS57
 IM9FSG/M/DHLICzVJOvvHKYcETQV+UQGArO2HdBq5ySpdudgyLz5JBpBwOf+VWD+pdvdFfRVa
 ylv1iywzAtDmSnhlNnQJXGjT9+YiCHs0j/TlARetiGXh+3D6UONF4yZcvs+fsNGmkjqPYxf/X
 yXe+pdYPa0IVRrhxBwrs0CjkWjiuaDxNlBF4zfuASyKo39LfcNjNzGrC9vmWSd7PsFIFODMOY
 swJtms4lxgfcQY+ch4ZDrdDGd6WnznuaaU0URG8tnfx+Pxf1+7bHkrZ5GRWo1xOd5D/ckQDOf
 u2V8gCLZTzIRy4Q/jgVoGVbaI/ZxBuC5meWPe+lGK5izf3f9oA6rLh8CzzFsf3CyuyzRfBn28
 BGHWr6xpMdlMAor/f0AU47NydIHyeXpSsgp/JQkRp6NETTn/8dsos3w2+iXHxzrclJ2kmV/xe
 Nd0Zn0kpPC4JSHAgTIt29mKuICkdhl8j9QKd766Syc3o+XaXnEWmrCYyQYGGnbDT/WLz4aLKJ
 WVDIicXG4z4gxbD18iRyeVYbGbXXQvG+jKfCRM+pCdxkUvCNH3QnhKVaxmD2t7umPYTNYYiuB
 Kd5WW2qEtNmutaR/9KsfBrJn8XiSZZk92zgkSVZGBev3/5QqNhy/idah4PmeLTgWL2h0DVAqw
 Ogm23V71pHLv1sY2e4Ddhay8tHgthlf9x6kxJUCw8G5dmd4ndupa5VXw+QdPASoRdticMbFgs
 6BRBR30nG9zqA/zsUyWBBWFNhzqo2ehxpIByhDrS0HD6uKceZi7qGkJt6eBAS9eHCid0fhFCw
 zupsRZku7f16p+95oYOut5V2NdQ1yubNDbxYf9M2B3tA3+zq5F3CSI++fDrRnrJpktzklUzaA
 ha1+c=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.08.19 16:43, Greg KH wrote:
> On Mon, Aug 05, 2019 at 04:10:56PM +0200, Sebastian Parschauer wrote:
>> The PixArt OEM mice are known for disconnecting every minute in
>> runlevel 1 or 3 if they are not always polled. So add quirk
>> ALWAYS_POLL for this one as well.
>>
>> Jonathan Teh (@jonathan-teh) reported and tested the quirk.
>> Reference: https://github.com/sriemer/fix-linux-mouse/issues/15
>>
>> Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
>> CC: stable@vger.kernel.org # v4.14.x
>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>> [sparschauer: Backport to < v4.16 hid_blacklist]
>> Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
>> ---
>>   drivers/hid/hid-ids.h           | 1 +
>>   drivers/hid/usbhid/hid-quirks.c | 1 +
>>   2 files changed, 2 insertions(+)
>
> What is the git commit id of this patch in Linus's tree?

Sorry, I was too quick with the backports. It just reached
https://git.kernel.org/pub/scm/linux/kernel/git/hid/hid.git.

Will reply when it's pulled in.

Cheers,
Sebastian
