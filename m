Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08ED5109A28
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 09:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfKZI3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 03:29:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:64050 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfKZI3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 03:29:38 -0500
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20191126082931epoutp030062baf3b4a76580977c53b04fa64fd9~aqR9aislW0097600976epoutp03x
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 08:29:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20191126082931epoutp030062baf3b4a76580977c53b04fa64fd9~aqR9aislW0097600976epoutp03x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574756971;
        bh=sGZDjNX3Of3xrSYiM4G2qW5GGss8dqlvEhiKt5BxAw0=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=tYnYyxjCD0HBOIxZMBDmwXd+vlpagVuSmEpv9zBGJXvX3FM4LJt3+FNATGDAtJctv
         obBqGyf5VgkLseWUlDypKTcUq9yVythMuNXhjwMq0ejg5y9gP7/5SYsqDUqxV9gMbr
         b+KIoQFyfaNQj2/tNp1R2gJya5aF1SGFNpHPbx3k=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20191126082931epcas1p1ce4b4bdfe0122e26b6f4b09b84d58de2~aqR8s7HSf1687316873epcas1p1X;
        Tue, 26 Nov 2019 08:29:31 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.152]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 47McWr0KDyzMqYkf; Tue, 26 Nov
        2019 08:29:28 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        22.8C.51241.462ECDD5; Tue, 26 Nov 2019 17:29:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20191126082923epcas1p2634e1b74e9ff8513a3b375ed3bb893b0~aqR1hhWfz2046320463epcas1p2T;
        Tue, 26 Nov 2019 08:29:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191126082923epsmtrp16f9f9ace67c8c8836a0b19e70752f34b~aqR1gsEL72933029330epsmtrp1A;
        Tue, 26 Nov 2019 08:29:23 +0000 (GMT)
X-AuditID: b6c32a39-14bff7000001c829-be-5ddce264c431
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B3.BA.10238.362ECDD5; Tue, 26 Nov 2019 17:29:23 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191126082923epsmtip2a2b3ecc47afbf024842a09edfe5d2734~aqR1OLlTG0961509615epsmtip2D;
        Tue, 26 Nov 2019 08:29:23 +0000 (GMT)
Subject: Re: [PATCH v3] PM / devfreq: Add new name attribute for sysfs
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, chanwoo@kernel.org,
        stable@vger.kernel.org
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <c5c9dc78-8209-3b42-4b16-cb40b00b8508@samsung.com>
Date:   Tue, 26 Nov 2019 17:35:28 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191126075333.GA1231308@kroah.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SaUwTURDO67bbBSk+y+HAD61rMIIBumJ1a0BJUNMoPwieMTZ1bTeAtNum
        W8AjJh4JClG0Ek0kIhjUYNGgDfFCQ6CIoogaMMFbDg+MeALiEbXtauTfNzPf92a+eUMR6joy
        lsoTXLxT4Kw0GSq/4IvXJlr6nhi1nR7Munu65eyumnqSvbPznZLtunKUZL/sa0Xs4x21JNtf
        O6Rkq8/3oXTKUHN1UGbwekpIQ1PlGaWhrMGDDF+8U7IUa/NTc3nOwjs1vGC2W/KEnDR62XJT
        hkk3V8skMnp2Hq0ROBufRi/KzEpckmf1z0JrCjlrgT+VxYkinbwg1WkvcPGaXLvoSqN5h8Xq
        0DuSRM4mFgg5SWa7bT6j1c7W+Ynr83N72z/KHFezN7m7nxLbkSejFIVQgOeAr3aAKEWhlBpf
        QtD2vVQpBZ8RvC7dq5CCUQR198/J/0nqh31yqXANQWfrEJKCDwjOnO5BAVYEXgL1jX1BRSSe
        CYPXHwUVBG5EcPfNcWWgQOIEaHrTQwbwRDwNHoz1B8UqvADc7kYigOU4DmpqX/k5FBWF18Dt
        EU6iTIL2IwPB90MwA97Ow4oAJvBkeDRQJZPwVLg4dDRoDvBXEh5e+KSULCwC38nDhIQj4O2N
        hr/5WBjcX/wXb4XT7a2kJN6DoKHpnkIqpEDTyXJZYCACx0P9lWQpPQ0u/6hEUuNweD8S2B3l
        z6tgT7FaokyHrhdPZRKOgZrdJeQBRFeMs1MxzkLFOAsV/5tVI7kHRfMO0ZbDi4xDN/67vSh4
        qAn6S6itM7MFYQrRYaqxO4+NagVXKG62tSCgCDpSNcv3xKhWWbjNW3in3eQssPJiC9L5l+0m
        YqPMdv/ZCy4To5udkpLCzmHm6hiGnqyixu4b1TiHc/H5PO/gnf90MiokdjvSD6tXhX/7GZa/
        kIumbnad3dZxsHJnVWrLyKHCW2yZrdkTc+KZ3lwi/k6vyoobbTezK7OTD5R5j8wylWcX0b0d
        6+JertTMEOIVGpXHUNRREmFs6198bOnXsNUTiorbfnUPLU2fEabzbWiOzlBFbjz1e/C1Qpjy
        cbi36/mKuo536h20XMzlmATCKXJ/AMkkcD++AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWy7bCSvG7yozuxBo2r+S0m3rjCYtG8eD2b
        xdmmN+wWl3fNYbP43HuE0eJ24wo2i8cr3rJbLNj4iNGBw2PxnpdMHptWdbJ57J+7ht2jb8sq
        Ro/Pm+QCWKO4bFJSczLLUov07RK4Mh6e/MBUsCeoYuKVu8wNjKucuxg5OSQETCTWfznM0sXI
        xSEksJtRYt2JGcwQCUmJaRePAtkcQLawxOHDxRA1bxkl5jVOBKsRFnCTWL/7EQuILSKgIfHy
        6C2wQcwgg5ZN3sUI0TGRSaJ351w2kCo2AS2J/S9ugNn8AooSV388ZgSxeQXsJCZO3A02lUVA
        VWLximdgNaICERLPt9+AqhGUODnzCdg2TgFDiU3nprGC2MwC6hJ/5l1ihrDFJW49mc8EYctL
        bH87h3kCo/AsJO2zkLTMQtIyC0nLAkaWVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsY
        wbGlpbmD8fKS+EOMAhyMSjy8P87ejhViTSwrrsw9xCjBwawkwqt9+E6sEG9KYmVValF+fFFp
        TmrxIUZpDhYlcd6neccihQTSE0tSs1NTC1KLYLJMHJxSDYxLd27fsezrst1CN+PzvNYVbRZS
        LVrC8jCxdxOvmXD62+lBtitnaEWZ5C2bsHOR/82046qX3/91Kz716Pkmpbh379gm3msrUDYJ
        Cm/J+NnK/WSp7Myic9dXMN6/c2fzGfVHdslxCSKfFTnqpKdkve56fX//5tlrj+wN2p6VmqBg
        NHPWXbObjXuXKrEUZyQaajEXFScCAOYI2qqpAgAA
X-CMS-MailID: 20191126082923epcas1p2634e1b74e9ff8513a3b375ed3bb893b0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20191125005755epcas1p2404d0f095e6ce543d36e55e2427282f8
References: <CGME20191125005755epcas1p2404d0f095e6ce543d36e55e2427282f8@epcas1p2.samsung.com>
        <20191125010357.27153-1-cw00.choi@samsung.com>
        <20191125085039.GA2301674@kroah.com>
        <48cadf42-4675-ffe1-a3d4-a97a37538955@samsung.com>
        <20191126075333.GA1231308@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/26/19 4:53 PM, Greg KH wrote:
> On Tue, Nov 26, 2019 at 12:08:18PM +0900, Chanwoo Choi wrote:
>> Hi Greg,
>>
>> On 11/25/19 5:50 PM, Greg KH wrote:
>>> On Mon, Nov 25, 2019 at 10:03:57AM +0900, Chanwoo Choi wrote:
>>>> The commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for
>>>> sysfs") changed the node name to devfreq(x). After this commit, it is not
>>>> possible to get the device name through /sys/class/devfreq/devfreq(X)/*.
>>>>
>>>> Add new name attribute in order to get device name.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for sysfs")
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> ---
>>>>  Changes from v2:
>>>> - Change the order of name_show() according to the sequence in devfreq_attrs[]
>>>>
>>>> Changes from v1:
>>>> - Update sysfs-class-devfreq documentation
>>>> - Show device name directly from 'devfreq->dev.parent'
>>>>
>>>
>>> Shouldn't you just revert the original patch here?  Why did the sysfs
>>> file change?
>>
>> The initial devfreq code used the parent device name for device name
>> corresponding to devfreq object instead of 'devfreq%d' style.
>> Before applied The commit 4585fbcb5331 ("PM / devfreq: Modify
>> the device name as devfreq(X) for sysfs"), the devfreq sysfs
>> showed the parent device name as following:
>>
>> For example on Odroid-XU3 board before applied the commit 4585fbcb5331,
>> 	/sys/class/devfreq/soc:bus_wcore
>> 	/sys/class/devfreq/soc:bus_noc
>> 	...(skip)
>>
>>
>> But, I think that devfreq subsystem had to show the consistent
>> sysfs entry name for devfreq device like input, thermal, hwmon subsystem.
>>
>> For example on Odroid-XU3 board,
>> - The input subsystem show the 'input%d' style for input device.
>> $root@localhost:/# ls /sys/class/input/                                         
>> event0  event1  input0  input1  mice  mouse0
>>
>> - The thermal subsystem show the 'cooling_device%d' style for thermal cooling device.
>> $ root@localhost:/# ls /sys/class/thermal/                                       
>> cooling_device0  cooling_device2  thermal_zone1  thermal_zone3
>> cooling_device1  thermal_zone0    thermal_zone2  thermal_zone4
>>
>> - The hwmon subsystem show the 'hwmon%d' style for h/w monitor device.
>> $root@localhost:/# ls /sys/class/hwmon/                                         
>> hwmon0
>>
>>
>> So, I tried to make the consistent sysfs entry name for devfreq device
>> by contributing commit 4585fbcb5331 ("PM / devfreq: Modify the device name as
>> devfreq(X) for sysfs"). But, The commit 4585fbcb5331 have missed that sysfs
>> interface had to provide the real device name. Some subsystem like thermal
>> and hwmon provide the device type or device name through sysfs interface.
>> It is possible to make the user to find their own specific device by iteration
>> on user-space.
>>
>> root@localhost:/# cat /sys/class/thermal/cooling_device0/type 
>> pwm-fan
>> root@localhost:/# cat /sys/class/thermal/cooling_device1/type                  
>> thermal-cpufreq-0
>> root@localhost:/# cat /sys/class/thermal/cooling_device2/type                  
>> thermal-cpufreq-1
>>
>> root@localhost:/# cat /sys/class/hwmon/hwmon0/name                             
>> pwmfan
>>
>>
>> So, I add the new 'name' attribute of sysfs for devfreq device.
>>
>>>
>>>> Documentation/ABI/testing/sysfs-class-devfreq | 7 +++++++
>>>>  drivers/devfreq/devfreq.c                     | 9 +++++++++
>>>>  2 files changed, 16 insertions(+)
>>>>
>>>> diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
>>>> index 01196e19afca..75897e2fde43 100644
>>>> --- a/Documentation/ABI/testing/sysfs-class-devfreq
>>>> +++ b/Documentation/ABI/testing/sysfs-class-devfreq
>>>> @@ -7,6 +7,13 @@ Description:
>>>>  		The name of devfreq object denoted as ... is same as the
>>>>  		name of device using devfreq.
>>>>  
>>>> +What:		/sys/class/devfreq/.../name
>>>> +Date:		November 2019
>>>> +Contact:	Chanwoo Choi <cw00.choi@samsung.com>
>>>> +Description:
>>>> +		The /sys/class/devfreq/.../name shows the name of device
>>>> +		of the corresponding devfreq object.
>>>> +
>>>>  What:		/sys/class/devfreq/.../governor
>>>>  Date:		September 2011
>>>>  Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
>>>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>>>> index 65a4b6cf3fa5..6f4d93d2a651 100644
>>>> --- a/drivers/devfreq/devfreq.c
>>>> +++ b/drivers/devfreq/devfreq.c
>>>> @@ -1169,6 +1169,14 @@ int devfreq_remove_governor(struct devfreq_governor *governor)
>>>>  }
>>>>  EXPORT_SYMBOL(devfreq_remove_governor);
>>>>  
>>>> +static ssize_t name_show(struct device *dev,
>>>> +			struct device_attribute *attr, char *buf)
>>>> +{
>>>> +	struct devfreq *devfreq = to_devfreq(dev);
>>>> +	return sprintf(buf, "%s\n", dev_name(devfreq->dev.parent));
>>>
>>> Why is the parent's name being set here, and not the device name?
>>
>> The device name style in struct devfreq is 'devfreq%d' instead of
>> parent device name in order to keep the consistent naming style for devfreq device
>> as I mentioned above. 'devfreq%d' name is consistent name style for devfreq device.
>> But, it don't show the real h/w device name. So, show the parent device name
>> which is specified on device-tree file.
> 
> I'm sorry, but I still do not understand.  Can you show me the directory
> tree before and after here?
> 

I'm sorry for not enough description. I add the following example on Odroid-XU3 board.


1. Before applied commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X),

root@localhost:~# ls /sys/class/devfreq                                        
soc:bus_disp1       soc:bus_fsys_apb  soc:bus_gscl_scaler  soc:bus_mscl
soc:bus_disp1_fimd  soc:bus_g2d       soc:bus_jpeg         soc:bus_noc
soc:bus_fsys        soc:bus_g2d_acp   soc:bus_jpeg_apb     soc:bus_peri
soc:bus_fsys2       soc:bus_gen       soc:bus_mfc          soc:bus_wcore

root@localhost:~# ls -al /sys/class/devfreq
total 0
drwxr-xr-x  2 root root 0 Jan  1 09:00 .
drwxr-xr-x 52 root root 0 Jan  1 09:00 ..
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_disp1 -> ../../devices/platform/soc/soc:bus_disp1/devfreq/soc:bus_disp1
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_disp1_fimd -> ../../devices/platform/soc/soc:bus_disp1_fimd/devfreq/soc:bus_did
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_fsys -> ../../devices/platform/soc/soc:bus_fsys/devfreq/soc:bus_fsys
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_fsys2 -> ../../devices/platform/soc/soc:bus_fsys2/devfreq/soc:bus_fsys2
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_fsys_apb -> ../../devices/platform/soc/soc:bus_fsys_apb/devfreq/soc:bus_fsys_ab
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_g2d -> ../../devices/platform/soc/soc:bus_g2d/devfreq/soc:bus_g2d
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_g2d_acp -> ../../devices/platform/soc/soc:bus_g2d_acp/devfreq/soc:bus_g2d_acp
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_gen -> ../../devices/platform/soc/soc:bus_gen/devfreq/soc:bus_gen
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_gscl_scaler -> ../../devices/platform/soc/soc:bus_gscl_scaler/devfreq/soc:bus_r
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_jpeg -> ../../devices/platform/soc/soc:bus_jpeg/devfreq/soc:bus_jpeg
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_jpeg_apb -> ../../devices/platform/soc/soc:bus_jpeg_apb/devfreq/soc:bus_jpeg_ab
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_mfc -> ../../devices/platform/soc/soc:bus_mfc/devfreq/soc:bus_mfc
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_mscl -> ../../devices/platform/soc/soc:bus_mscl/devfreq/soc:bus_mscl
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_noc -> ../../devices/platform/soc/soc:bus_noc/devfreq/soc:bus_noc
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_peri -> ../../devices/platform/soc/soc:bus_peri/devfreq/soc:bus_peri
lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_wcore -> ../../devices/platform/soc/soc:bus_wcore/devfreq/soc:bus_wcore



2. After applied commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X),

root@localhost:~# ls  /sys/class/devfreq                                       
devfreq0   devfreq11  devfreq14  devfreq3  devfreq6  devfreq9
devfreq1   devfreq12  devfreq15  devfreq4  devfreq7
devfreq10  devfreq13  devfreq2   devfreq5  devfreq8

root@localhost:~# ls -al /sys/class/devfreq                                    
total 0
drwxr-xr-x  2 root root 0 Jan  1 09:02 .
drwxr-xr-x 52 root root 0 Jan  1 09:02 ..
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq0 -> ../../devices/platform/soc/soc:bus_wcore/devfreq/devfreq0
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq1 -> ../../devices/platform/soc/soc:bus_noc/devfreq/devfreq1
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq10 -> ../../devices/platform/soc/soc:bus_jpeg/devfreq/devfreq10
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq11 -> ../../devices/platform/soc/soc:bus_jpeg_apb/devfreq/devfreq11
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq12 -> ../../devices/platform/soc/soc:bus_disp1_fimd/devfreq/devfreq12
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq13 -> ../../devices/platform/soc/soc:bus_disp1/devfreq/devfreq13
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq14 -> ../../devices/platform/soc/soc:bus_gscl_scaler/devfreq/devfreq14
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq15 -> ../../devices/platform/soc/soc:bus_mscl/devfreq/devfreq15
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq2 -> ../../devices/platform/soc/soc:bus_fsys_apb/devfreq/devfreq2
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq3 -> ../../devices/platform/soc/soc:bus_fsys/devfreq/devfreq3
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq4 -> ../../devices/platform/soc/soc:bus_fsys2/devfreq/devfreq4
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq5 -> ../../devices/platform/soc/soc:bus_mfc/devfreq/devfreq5
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq6 -> ../../devices/platform/soc/soc:bus_gen/devfreq/devfreq6
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq7 -> ../../devices/platform/soc/soc:bus_peri/devfreq/devfreq7
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq8 -> ../../devices/platform/soc/soc:bus_g2d/devfreq/devfreq8
lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq9 -> ../../devices/platform/soc/soc:bus_g2d_acp/devfreq/devfreq9


Best Regards,
Chanwoo Choi

