Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C832109B41
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 10:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfKZJbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 04:31:32 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37834 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbfKZJbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 04:31:32 -0500
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20191126093128epoutp01801cf1379e0b649d9885e6c05cb306e8~arICW2oo30246702467epoutp01N
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 09:31:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20191126093128epoutp01801cf1379e0b649d9885e6c05cb306e8~arICW2oo30246702467epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574760688;
        bh=mkL/g7/FB0iJ6KzjxbDyFtYw0Eg+RbHKsFbTLxR6QFQ=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=NszlaGR0xEPzTPGBXdZO1qvzMqlNs+nHLVoKNi8xUU8BRbvtT9ac4TEl1iVLgAsXK
         9ZMuaiVe4Z54E5pjXecluL8QyXqUmUDuTRiz5dhIiOZvVytsQQQfBPiFGKPAWRL3j7
         2G+7HibEktTqgsoFT9dilSVfH0dYnMw4TwX9JTsU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20191126093127epcas1p424c21ba1b884603e0a87a08afb74fb94~arIBorT4l1182811828epcas1p4A;
        Tue, 26 Nov 2019 09:31:27 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.156]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 47MdvK0RrLzMqYkh; Tue, 26 Nov
        2019 09:31:25 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.8A.48498.CE0FCDD5; Tue, 26 Nov 2019 18:31:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20191126093124epcas1p47390a83ab7a7bb11f65aa99e8c550cf4~arH_x_jAA1172811728epcas1p4-;
        Tue, 26 Nov 2019 09:31:24 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191126093124epsmtrp17bd3c8637e009fef25b59cc21f2ed6ec~arH_xQa3j3066030660epsmtrp1P;
        Tue, 26 Nov 2019 09:31:24 +0000 (GMT)
X-AuditID: b6c32a36-a3dff7000001bd72-9c-5ddcf0ec233d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.D1.06569.CE0FCDD5; Tue, 26 Nov 2019 18:31:24 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191126093123epsmtip213dd40477ace5d24157f28d65ee257e5~arH_kvZz21145911459epsmtip2j;
        Tue, 26 Nov 2019 09:31:23 +0000 (GMT)
Subject: Re: [PATCH v3] PM / devfreq: Add new name attribute for sysfs
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, chanwoo@kernel.org,
        stable@vger.kernel.org
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <2545ff50-8e59-ff9f-1ba0-cb2661d5119a@samsung.com>
Date:   Tue, 26 Nov 2019 18:37:29 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191126091541.GB1371943@kroah.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTYRTn293urtHqa1meJMpuaaWZu7PZ7aEESo0KEoSKaNjNXdTcq91N
        sqCXZBq9LII0NU0iJ9rITC2NhdrL1B5WWNkDk9KVWVlhCdHubpH//c7vnPP7nfN9hyLULjKY
        Src4eLuFM9HkOHldy/yoyMHPPQZNdbuMze9+LGezy90k27H/o5LtulZEssNHWhH7Yl8Fyb6t
        GFSypZd60QpKX940INPXVOaRek9xlVJ/tLYS6YdrZiQqNmUsT+M5I28P4S0pVmO6JTWWXpOU
        HJ+si9EwkcwSdjEdYuHMfCydsDYxcmW6yTcLHZLJmZw+KpETBDoqbrnd6nTwIWlWwRFL8zaj
        ybbEtlDgzILTkrowxWpeymg0Wp2vcEtG2v5j2TJbx7Yd3e3F5F7UtP4QCqAAL4IzDf3yQ2gc
        pcYNCG4PdSqk4CuC1pLGv8EPBCdcLehfi/tZOZIS1xF0/qgipGAIQVf7T5lYNRmvBHdjr1zE
        gXgeDNx87jchcCOC+/1lSjFB4nDw9HeTIp6IZ8GTkbc+WYpS4Ti4nO8UaTkOBffFc4RIT8Eb
        4d53TqRVeBLcLejzywdgBgqOuPwqBA6C531nZRKeCfWDRf7ZAI+S8LPutVzUAZwApZ44aZnJ
        4L1dq5RwMAwcy/mLd4Hrbisp9eYiqPU8UEiJaPCcPykTdQg8H9zXoiR6FlwdLUaS7wT49P2w
        QrJSQW6OWiqZDV1vXsokPA3KD+aRxxFdOGabwjEbFI7ZoPC/WSmSV6KpvE0wp/ICY9OO/ewa
        5D/T8JgGdK5zbTPCFKLHq0Y6XhjUCi5TyDI3I6AIOlAV0dJjUKuMXNZO3m5NtjtNvNCMdL63
        zieCp6RYfUdvcSQzOm10dDS7iInRMQwdpKJGHhrUOJVz8Bk8b+Pt//pkVEDwXlQT9P7TDf3S
        0AP59WvW9V5tY999G85ckHir58MOPruobVWWoWTrlz7XnpwwhtmsKR0tcyu88W/c24c2RZS0
        Mb/cF8LuBE4MVeZ6PYunJ+XN+X1+bpZXO/h7+rtHbeip56vyVXXVxqT1Jae1+urO+L6EZeSV
        U6s37D69tWCz7aOR8obTciGNY8IJu8D9AfiPGam8AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSvO6bD3diDTYfYLGYeOMKi0Xz4vVs
        Fmeb3rBbXN41h83ic+8RRovbjSvYLB6veMtusWDjI0YHDo/Fe14yeWxa1cnmsX/uGnaPvi2r
        GD0+b5ILYI3isklJzcksSy3St0vgymjqb2YqOJtVcePMXLYGxj1hXYycHBICJhLrby5m7GLk
        4hAS2M0oce3JTnaIhKTEtItHmbsYOYBsYYnDh4shat4yStx9vAOsRljATWL97kcsILaIgIbE
        y6O3WECKmEEGLZu8C2rqWyaJv1//sIFUsQloSex/cQPM5hdQlLj64zEjyAZeATuJzRNLQcIs
        AqoS69ctYgaxRQUiJJ5vv8EIYvMKCEqcnPkEbBmngKHEzN6VYGOYBdQl/sy7xAxhi0vcejKf
        CcKWl9j+dg7zBEbhWUjaZyFpmYWkZRaSlgWMLKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS
        83M3MYIjS0trB+OJE/GHGAU4GJV4eH+cvR0rxJpYVlyZe4hRgoNZSYRX+/CdWCHelMTKqtSi
        /Pii0pzU4kOM0hwsSuK88vnHIoUE0hNLUrNTUwtSi2CyTBycUg2MM+9In39T57nEOk8+ebcZ
        z70lngsTeWZF/H/b6uDF/4K/Xc5nu+n5LUrTtL4JT43b+Hr97PCsL7v/mqf7TFKwXjdH26bt
        fM2ceLN7uZnr+48vPrVxy5rlKs/Wqt6ZljNtg8NVbn1ZwRdex8NUl6laG7s98PRXUkicNtX0
        t/7hZ70vNy3bJMWYq8RSnJFoqMVcVJwIADbuL9qoAgAA
X-CMS-MailID: 20191126093124epcas1p47390a83ab7a7bb11f65aa99e8c550cf4
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
        <c5c9dc78-8209-3b42-4b16-cb40b00b8508@samsung.com>
        <20191126091541.GB1371943@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/26/19 6:15 PM, Greg KH wrote:
> On Tue, Nov 26, 2019 at 05:35:28PM +0900, Chanwoo Choi wrote:
>> On 11/26/19 4:53 PM, Greg KH wrote:
>>> On Tue, Nov 26, 2019 at 12:08:18PM +0900, Chanwoo Choi wrote:
>>>> Hi Greg,
>>>>
>>>> On 11/25/19 5:50 PM, Greg KH wrote:
>>>>> On Mon, Nov 25, 2019 at 10:03:57AM +0900, Chanwoo Choi wrote:
>>>>>> The commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for
>>>>>> sysfs") changed the node name to devfreq(x). After this commit, it is not
>>>>>> possible to get the device name through /sys/class/devfreq/devfreq(X)/*.
>>>>>>
>>>>>> Add new name attribute in order to get device name.
>>>>>>
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Fixes: 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for sysfs")
>>>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>>>> ---
>>>>>>  Changes from v2:
>>>>>> - Change the order of name_show() according to the sequence in devfreq_attrs[]
>>>>>>
>>>>>> Changes from v1:
>>>>>> - Update sysfs-class-devfreq documentation
>>>>>> - Show device name directly from 'devfreq->dev.parent'
>>>>>>
>>>>>
>>>>> Shouldn't you just revert the original patch here?  Why did the sysfs
>>>>> file change?
>>>>
>>>> The initial devfreq code used the parent device name for device name
>>>> corresponding to devfreq object instead of 'devfreq%d' style.
>>>> Before applied The commit 4585fbcb5331 ("PM / devfreq: Modify
>>>> the device name as devfreq(X) for sysfs"), the devfreq sysfs
>>>> showed the parent device name as following:
>>>>
>>>> For example on Odroid-XU3 board before applied the commit 4585fbcb5331,
>>>> 	/sys/class/devfreq/soc:bus_wcore
>>>> 	/sys/class/devfreq/soc:bus_noc
>>>> 	...(skip)
>>>>
>>>>
>>>> But, I think that devfreq subsystem had to show the consistent
>>>> sysfs entry name for devfreq device like input, thermal, hwmon subsystem.
>>>>
>>>> For example on Odroid-XU3 board,
>>>> - The input subsystem show the 'input%d' style for input device.
>>>> $root@localhost:/# ls /sys/class/input/                                         
>>>> event0  event1  input0  input1  mice  mouse0
>>>>
>>>> - The thermal subsystem show the 'cooling_device%d' style for thermal cooling device.
>>>> $ root@localhost:/# ls /sys/class/thermal/                                       
>>>> cooling_device0  cooling_device2  thermal_zone1  thermal_zone3
>>>> cooling_device1  thermal_zone0    thermal_zone2  thermal_zone4
>>>>
>>>> - The hwmon subsystem show the 'hwmon%d' style for h/w monitor device.
>>>> $root@localhost:/# ls /sys/class/hwmon/                                         
>>>> hwmon0
>>>>
>>>>
>>>> So, I tried to make the consistent sysfs entry name for devfreq device
>>>> by contributing commit 4585fbcb5331 ("PM / devfreq: Modify the device name as
>>>> devfreq(X) for sysfs"). But, The commit 4585fbcb5331 have missed that sysfs
>>>> interface had to provide the real device name. Some subsystem like thermal
>>>> and hwmon provide the device type or device name through sysfs interface.
>>>> It is possible to make the user to find their own specific device by iteration
>>>> on user-space.
>>>>
>>>> root@localhost:/# cat /sys/class/thermal/cooling_device0/type 
>>>> pwm-fan
>>>> root@localhost:/# cat /sys/class/thermal/cooling_device1/type                  
>>>> thermal-cpufreq-0
>>>> root@localhost:/# cat /sys/class/thermal/cooling_device2/type                  
>>>> thermal-cpufreq-1
>>>>
>>>> root@localhost:/# cat /sys/class/hwmon/hwmon0/name                             
>>>> pwmfan
>>>>
>>>>
>>>> So, I add the new 'name' attribute of sysfs for devfreq device.
>>>>
>>>>>
>>>>>> Documentation/ABI/testing/sysfs-class-devfreq | 7 +++++++
>>>>>>  drivers/devfreq/devfreq.c                     | 9 +++++++++
>>>>>>  2 files changed, 16 insertions(+)
>>>>>>
>>>>>> diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
>>>>>> index 01196e19afca..75897e2fde43 100644
>>>>>> --- a/Documentation/ABI/testing/sysfs-class-devfreq
>>>>>> +++ b/Documentation/ABI/testing/sysfs-class-devfreq
>>>>>> @@ -7,6 +7,13 @@ Description:
>>>>>>  		The name of devfreq object denoted as ... is same as the
>>>>>>  		name of device using devfreq.
>>>>>>  
>>>>>> +What:		/sys/class/devfreq/.../name
>>>>>> +Date:		November 2019
>>>>>> +Contact:	Chanwoo Choi <cw00.choi@samsung.com>
>>>>>> +Description:
>>>>>> +		The /sys/class/devfreq/.../name shows the name of device
>>>>>> +		of the corresponding devfreq object.
>>>>>> +
>>>>>>  What:		/sys/class/devfreq/.../governor
>>>>>>  Date:		September 2011
>>>>>>  Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
>>>>>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>>>>>> index 65a4b6cf3fa5..6f4d93d2a651 100644
>>>>>> --- a/drivers/devfreq/devfreq.c
>>>>>> +++ b/drivers/devfreq/devfreq.c
>>>>>> @@ -1169,6 +1169,14 @@ int devfreq_remove_governor(struct devfreq_governor *governor)
>>>>>>  }
>>>>>>  EXPORT_SYMBOL(devfreq_remove_governor);
>>>>>>  
>>>>>> +static ssize_t name_show(struct device *dev,
>>>>>> +			struct device_attribute *attr, char *buf)
>>>>>> +{
>>>>>> +	struct devfreq *devfreq = to_devfreq(dev);
>>>>>> +	return sprintf(buf, "%s\n", dev_name(devfreq->dev.parent));
>>>>>
>>>>> Why is the parent's name being set here, and not the device name?
>>>>
>>>> The device name style in struct devfreq is 'devfreq%d' instead of
>>>> parent device name in order to keep the consistent naming style for devfreq device
>>>> as I mentioned above. 'devfreq%d' name is consistent name style for devfreq device.
>>>> But, it don't show the real h/w device name. So, show the parent device name
>>>> which is specified on device-tree file.
>>>
>>> I'm sorry, but I still do not understand.  Can you show me the directory
>>> tree before and after here?
>>>
>>
>> I'm sorry for not enough description. I add the following example on Odroid-XU3 board.
>>
>>
>> 1. Before applied commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X),
>>
>> root@localhost:~# ls /sys/class/devfreq                                        
>> soc:bus_disp1       soc:bus_fsys_apb  soc:bus_gscl_scaler  soc:bus_mscl
>> soc:bus_disp1_fimd  soc:bus_g2d       soc:bus_jpeg         soc:bus_noc
>> soc:bus_fsys        soc:bus_g2d_acp   soc:bus_jpeg_apb     soc:bus_peri
>> soc:bus_fsys2       soc:bus_gen       soc:bus_mfc          soc:bus_wcore
>>
>> root@localhost:~# ls -al /sys/class/devfreq
>> total 0
>> drwxr-xr-x  2 root root 0 Jan  1 09:00 .
>> drwxr-xr-x 52 root root 0 Jan  1 09:00 ..
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_disp1 -> ../../devices/platform/soc/soc:bus_disp1/devfreq/soc:bus_disp1
> 
> Ah, that's odd, ok.
> 
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_disp1_fimd -> ../../devices/platform/soc/soc:bus_disp1_fimd/devfreq/soc:bus_did
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_fsys -> ../../devices/platform/soc/soc:bus_fsys/devfreq/soc:bus_fsys
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_fsys2 -> ../../devices/platform/soc/soc:bus_fsys2/devfreq/soc:bus_fsys2
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_fsys_apb -> ../../devices/platform/soc/soc:bus_fsys_apb/devfreq/soc:bus_fsys_ab
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_g2d -> ../../devices/platform/soc/soc:bus_g2d/devfreq/soc:bus_g2d
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_g2d_acp -> ../../devices/platform/soc/soc:bus_g2d_acp/devfreq/soc:bus_g2d_acp
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_gen -> ../../devices/platform/soc/soc:bus_gen/devfreq/soc:bus_gen
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_gscl_scaler -> ../../devices/platform/soc/soc:bus_gscl_scaler/devfreq/soc:bus_r
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_jpeg -> ../../devices/platform/soc/soc:bus_jpeg/devfreq/soc:bus_jpeg
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_jpeg_apb -> ../../devices/platform/soc/soc:bus_jpeg_apb/devfreq/soc:bus_jpeg_ab
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_mfc -> ../../devices/platform/soc/soc:bus_mfc/devfreq/soc:bus_mfc
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_mscl -> ../../devices/platform/soc/soc:bus_mscl/devfreq/soc:bus_mscl
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_noc -> ../../devices/platform/soc/soc:bus_noc/devfreq/soc:bus_noc
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_peri -> ../../devices/platform/soc/soc:bus_peri/devfreq/soc:bus_peri
>> lrwxrwxrwx  1 root root 0 Jan  1 09:00 soc:bus_wcore -> ../../devices/platform/soc/soc:bus_wcore/devfreq/soc:bus_wcore
>>
>>
>>
>> 2. After applied commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X),
>>
>> root@localhost:~# ls  /sys/class/devfreq                                       
>> devfreq0   devfreq11  devfreq14  devfreq3  devfreq6  devfreq9
>> devfreq1   devfreq12  devfreq15  devfreq4  devfreq7
>> devfreq10  devfreq13  devfreq2   devfreq5  devfreq8
> 
> That's better.
> 
>>
>> root@localhost:~# ls -al /sys/class/devfreq                                    
>> total 0
>> drwxr-xr-x  2 root root 0 Jan  1 09:02 .
>> drwxr-xr-x 52 root root 0 Jan  1 09:02 ..
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq0 -> ../../devices/platform/soc/soc:bus_wcore/devfreq/devfreq0
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq1 -> ../../devices/platform/soc/soc:bus_noc/devfreq/devfreq1
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq10 -> ../../devices/platform/soc/soc:bus_jpeg/devfreq/devfreq10
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq11 -> ../../devices/platform/soc/soc:bus_jpeg_apb/devfreq/devfreq11
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq12 -> ../../devices/platform/soc/soc:bus_disp1_fimd/devfreq/devfreq12
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq13 -> ../../devices/platform/soc/soc:bus_disp1/devfreq/devfreq13
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq14 -> ../../devices/platform/soc/soc:bus_gscl_scaler/devfreq/devfreq14
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq15 -> ../../devices/platform/soc/soc:bus_mscl/devfreq/devfreq15
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq2 -> ../../devices/platform/soc/soc:bus_fsys_apb/devfreq/devfreq2
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq3 -> ../../devices/platform/soc/soc:bus_fsys/devfreq/devfreq3
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq4 -> ../../devices/platform/soc/soc:bus_fsys2/devfreq/devfreq4
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq5 -> ../../devices/platform/soc/soc:bus_mfc/devfreq/devfreq5
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq6 -> ../../devices/platform/soc/soc:bus_gen/devfreq/devfreq6
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq7 -> ../../devices/platform/soc/soc:bus_peri/devfreq/devfreq7
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq8 -> ../../devices/platform/soc/soc:bus_g2d/devfreq/devfreq8
>> lrwxrwxrwx  1 root root 0 Jan  1 09:02 devfreq9 -> ../../devices/platform/soc/soc:bus_g2d_acp/devfreq/devfreq9
> 
> Ok, this looks a bit better, but why is there the extra "devfreq"
> directory in there?  That was in the original as well, but that feels
> odd.

What extra directory are you talking about? I didn't create
the any extra directory for devfreq.

If you mention the following 'devfreq' directory, 
it is created by basic device driver code in linux kernel.
- /sys/devices/platform/soc/soc\:bus_wcore/devfreq/

or

Each devfreq0~15 directories indicates the each devfreq device.


For example, show the info of each path
root@localhost:~# ls -al /sys/devices/platform/soc/soc\:bus_wcore/             
total 0
drwxr-xr-x   4 root root    0 Jan  1 09:56 .
drwxr-xr-x 109 root root    0 Jan  1 09:56 ..
drwxr-xr-x   3 root root    0 Jan  1 09:56 devfreq
lrwxrwxrwx   1 root root    0 Jan  1 09:57 driver -> ../../../../bus/platform/drivers/exynos-bus
-rw-r--r--   1 root root 4096 Jan  1 09:57 driver_override
-r--r--r--   1 root root 4096 Jan  1 09:57 modalias
lrwxrwxrwx   1 root root    0 Jan  1 09:57 of_node -> ../../../../firmware/devicetree/base/soc/bus_wcore
drwxr-xr-x   2 root root    0 Jan  1 09:57 power
lrwxrwxrwx   1 root root    0 Jan  1 09:56 subsystem -> ../../../../bus/platform
-rw-r--r--   1 root root 4096 Jan  1 09:56 uevent

root@localhost:~# ls -al /sys/devices/platform/soc/soc\:bus_wcore/devfreq/     
total 0
drwxr-xr-x 3 root root 0 Jan  1 09:56 .
drwxr-xr-x 4 root root 0 Jan  1 09:56 ..
drwxr-xr-x 3 root root 0 Jan  1 09:56 devfreq0

root@localhost:~# ls -al /sys/devices/platform/soc/soc\:bus_wcore/devfreq/devfreq0
drwxr-xr-x 3 root root    0 Jan  1 09:56 .
drwxr-xr-x 3 root root    0 Jan  1 09:56 ..
-r--r--r-- 1 root root 4096 Jan  1 10:03 available_frequencies
-r--r--r-- 1 root root 4096 Jan  1 10:03 available_governors
-r--r--r-- 1 root root 4096 Jan  1 10:03 cur_freq
lrwxrwxrwx 1 root root    0 Jan  1 10:03 device -> ../../../soc:bus_wcore
-rw-r--r-- 1 root root 4096 Jan  1 10:03 governor
-rw-r--r-- 1 root root 4096 Jan  1 10:03 max_freq
-rw-r--r-- 1 root root 4096 Jan  1 10:03 min_freq
-r--r--r-- 1 root root 4096 Jan  1 10:03 name
-rw-r--r-- 1 root root 4096 Jan  1 10:03 polling_interval
drwxr-xr-x 2 root root    0 Jan  1 10:03 power
lrwxrwxrwx 1 root root    0 Jan  1 09:56 subsystem -> ../../../../../../class/devfreq
-r--r--r-- 1 root root 4096 Jan  1 10:03 target_freq
-r--r--r-- 1 root root 4096 Jan  1 10:03 trans_stat
-rw-r--r-- 1 root root 4096 Jan  1 09:56 uevent




-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
