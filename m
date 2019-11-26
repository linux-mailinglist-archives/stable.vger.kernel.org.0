Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C32A1097F4
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 04:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfKZDCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 22:02:22 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58855 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfKZDCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 22:02:22 -0500
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20191126030218epoutp02a7d952a5769223309bc8495d8a23598c~al0QwFIN90883208832epoutp02O
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 03:02:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20191126030218epoutp02a7d952a5769223309bc8495d8a23598c~al0QwFIN90883208832epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574737338;
        bh=OMciozHpLzOj5UGxa+m6g2T+kC1AYWSBJic5bkxy8Zc=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=GSKSZjzLTEUIeDV+JG2EIJdDcHBChw2xHxPI9EmT1C8YORuB4K5rXbXE5y1q2R/p2
         0KotCfG+qn0pL7w8MxQHiAHXH18/2SMixpS+YnZcrRw6IaVxLoRkgkDPHGJMJJ/ulO
         eiZPVfj7sWTNSSHf/3tK28mr2sm34jx8rsXrhJCI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20191126030218epcas1p28e00c9942427257eb9c3663dee8cadbe~al0QEORS72788927889epcas1p2I;
        Tue, 26 Nov 2019 03:02:18 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.152]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 47MTGJ02c1zMqYkf; Tue, 26 Nov
        2019 03:02:16 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        95.59.57028.4B59CDD5; Tue, 26 Nov 2019 12:02:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20191126030212epcas1p457db612973b544c32b7aabb8e0f88c45~al0KqbNOQ1984919849epcas1p41;
        Tue, 26 Nov 2019 03:02:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191126030212epsmtrp10cf62ccbb6aef0b403f4291f120d5a34~al0Kpp7vm1622616226epsmtrp10;
        Tue, 26 Nov 2019 03:02:12 +0000 (GMT)
X-AuditID: b6c32a35-50bff7000001dec4-14-5ddc95b49162
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.7D.10238.4B59CDD5; Tue, 26 Nov 2019 12:02:12 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191126030212epsmtip26164004f75da06e57e9a1f123fc46e9c~al0Kb7KYk2303723037epsmtip2K;
        Tue, 26 Nov 2019 03:02:12 +0000 (GMT)
Subject: Re: [PATCH v3] PM / devfreq: Add new name attribute for sysfs
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, chanwoo@kernel.org,
        stable@vger.kernel.org
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <48cadf42-4675-ffe1-a3d4-a97a37538955@samsung.com>
Date:   Tue, 26 Nov 2019 12:08:18 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191125085039.GA2301674@kroah.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHebd5dpRWb7P00Q+mpwtlbO5o02OkBdlY5QcrjAiWnvSk5m7t
        bNLFILuaXVTMwmFlSWqrGJqU3dDMLlJmZoVY0U3KlRk0Cml02c4p8tuP5/k//+fyvqRU2UBE
        kgVmO2czs0aKCJFdujVHpWqtfmHQNJxVMZUDT2TMrno3wfTsHJEz/VdrCcZ7qAsxz0uaCOZd
        02c5U9f8Fi0i9fXXPRJ9i2s/oW8/fl6uP9zqQnpvS1RG0NrCBfkcm8vZojlzjiW3wJyXQi1f
        lbU4S5uooVV0MpNERZtZE5dCpaVnqHQFRv8sVHQRa3T4Qxksz1NxqQtsFoedi8638PYUirPm
        Gq3JVjXPmniHOU+dYzHNpzWaeK1fmF2Y3zPYi6xVczeXO19KdiAXVYaCScDzoK/jpKwMhZBK
        3IbA23hRFkgo8VcED9yEyN8RfGpcVoZIoaBmZJMYvoHgty9E5C8I7ng2BDgU68B97a1gMwXP
        Bs/tQcFfiq8h6B0+JQ8kCBwL7cMDgv8kHANPx96hACtwKvzeXS1oZHgmjJQclQT6TsVr4P43
        VpRMhu6aIcE/GNPg9TQLNlIcDoNDJyUiT4PLn2ulgb6AfQRUvHojExdOg9qOE0jkUPh4t1Uu
        ciR4yvf+5W1wtruLEItLEbS2PwoSEwnQfqZKGEiK54D7apwYjoErvuNIbDwRRr8dDBJvpYDS
        vUpRMh36X7+UiBwB9fv2ExWIco5bxzluBee4FZz/m9UhmQuFcVbelMfxtJUe/9ItSPijsdo2
        dORheifCJKImKMZ6nhuUQWwRv8XUiYCUUlMUup4Bg1KRy27ZytksWTaHkeM7kdZ/7Epp5NQc
        i//Hm+1ZtDY+ISGBmUcnammaCleQY30GJc5j7Vwhx1k52786CRkcuQPdGopZl/asO7O7uHFG
        mLFr1oXpFf2X6zeePtD8pCgz7kbmr9ThAzefqSXqDz/WuO49zc45lt47GjsQE3XiVNL60iVr
        Vz+qC96o7agMu+DzPu5bWBKxdE+Tj5ypPhc++l7SsKR6xc/bXXrdxJWa8/eLddsTDRrHe/e9
        F6+Hthsbk0Pjm+soGZ/P0rFSG8/+AaX81zi5AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSvO6WqXdiDeas4raYeOMKi0Xz4vVs
        Fmeb3rBbXN41h83ic+8RRovbjSvYLB6veMtusWDjI0YHDo/Fe14yeWxa1cnmsX/uGnaPvi2r
        GD0+b5ILYI3isklJzcksSy3St0vgyjh76zxjwWTtiv5Zd5kaGFcpdTFycEgImEjMfFPYxcjF
        ISSwm1GiYe4yti5GTqC4pMS0i0eZIWqEJQ4fLoaoecsocenYUrAaYQE3ifW7H7GA2CICGhIv
        j95iASliBhm0bPIuRpCEkMBWRok9l11BbDYBLYn9L26ANfMLKEpc/fEYrIZXwE7if8tUdhCb
        RUBV4k3jNCYQW1QgQuL59htQNYISJ2c+AVvGKWAo8fnlRrA5zALqEn/mXWKGsMUlbj2ZzwRh
        y0tsfzuHeQKj8Cwk7bOQtMxC0jILScsCRpZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5
        mxjBcaWluYPx8pL4Q4wCHIxKPLw/zt6OFWJNLCuuzD3EKMHBrCTC63b2RqwQb0piZVVqUX58
        UWlOavEhRmkOFiVx3qd5xyKFBNITS1KzU1MLUotgskwcnFINjIXPZqosmCCpydSdteCVAGNp
        4KS5P6Xv7757JPtzye+39hmu/7JW6z29I/FxfvtZuTmps3LK5uRHcT5K0rFePZWhfPbahMt/
        /gsdXrA+2H7niatf2Rd71cq5/1hepdl20vGZ8Inlq74/8tlRWflUftU2k9RHl98y856KP8mc
        tZhJXb37amnyQVklluKMREMt5qLiRABaC0xvpwIAAA==
X-CMS-MailID: 20191126030212epcas1p457db612973b544c32b7aabb8e0f88c45
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
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 11/25/19 5:50 PM, Greg KH wrote:
> On Mon, Nov 25, 2019 at 10:03:57AM +0900, Chanwoo Choi wrote:
>> The commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for
>> sysfs") changed the node name to devfreq(x). After this commit, it is not
>> possible to get the device name through /sys/class/devfreq/devfreq(X)/*.
>>
>> Add new name attribute in order to get device name.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for sysfs")
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  Changes from v2:
>> - Change the order of name_show() according to the sequence in devfreq_attrs[]
>>
>> Changes from v1:
>> - Update sysfs-class-devfreq documentation
>> - Show device name directly from 'devfreq->dev.parent'
>>
> 
> Shouldn't you just revert the original patch here?  Why did the sysfs
> file change?

The initial devfreq code used the parent device name for device name
corresponding to devfreq object instead of 'devfreq%d' style.
Before applied The commit 4585fbcb5331 ("PM / devfreq: Modify
the device name as devfreq(X) for sysfs"), the devfreq sysfs
showed the parent device name as following:

For example on Odroid-XU3 board before applied the commit 4585fbcb5331,
	/sys/class/devfreq/soc:bus_wcore
	/sys/class/devfreq/soc:bus_noc
	...(skip)


But, I think that devfreq subsystem had to show the consistent
sysfs entry name for devfreq device like input, thermal, hwmon subsystem.

For example on Odroid-XU3 board,
- The input subsystem show the 'input%d' style for input device.
$root@localhost:/# ls /sys/class/input/                                         
event0  event1  input0  input1  mice  mouse0

- The thermal subsystem show the 'cooling_device%d' style for thermal cooling device.
$ root@localhost:/# ls /sys/class/thermal/                                       
cooling_device0  cooling_device2  thermal_zone1  thermal_zone3
cooling_device1  thermal_zone0    thermal_zone2  thermal_zone4

- The hwmon subsystem show the 'hwmon%d' style for h/w monitor device.
$root@localhost:/# ls /sys/class/hwmon/                                         
hwmon0


So, I tried to make the consistent sysfs entry name for devfreq device
by contributing commit 4585fbcb5331 ("PM / devfreq: Modify the device name as
devfreq(X) for sysfs"). But, The commit 4585fbcb5331 have missed that sysfs
interface had to provide the real device name. Some subsystem like thermal
and hwmon provide the device type or device name through sysfs interface.
It is possible to make the user to find their own specific device by iteration
on user-space.

root@localhost:/# cat /sys/class/thermal/cooling_device0/type 
pwm-fan
root@localhost:/# cat /sys/class/thermal/cooling_device1/type                  
thermal-cpufreq-0
root@localhost:/# cat /sys/class/thermal/cooling_device2/type                  
thermal-cpufreq-1

root@localhost:/# cat /sys/class/hwmon/hwmon0/name                             
pwmfan


So, I add the new 'name' attribute of sysfs for devfreq device.

> 
>> Documentation/ABI/testing/sysfs-class-devfreq | 7 +++++++
>>  drivers/devfreq/devfreq.c                     | 9 +++++++++
>>  2 files changed, 16 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
>> index 01196e19afca..75897e2fde43 100644
>> --- a/Documentation/ABI/testing/sysfs-class-devfreq
>> +++ b/Documentation/ABI/testing/sysfs-class-devfreq
>> @@ -7,6 +7,13 @@ Description:
>>  		The name of devfreq object denoted as ... is same as the
>>  		name of device using devfreq.
>>  
>> +What:		/sys/class/devfreq/.../name
>> +Date:		November 2019
>> +Contact:	Chanwoo Choi <cw00.choi@samsung.com>
>> +Description:
>> +		The /sys/class/devfreq/.../name shows the name of device
>> +		of the corresponding devfreq object.
>> +
>>  What:		/sys/class/devfreq/.../governor
>>  Date:		September 2011
>>  Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>> index 65a4b6cf3fa5..6f4d93d2a651 100644
>> --- a/drivers/devfreq/devfreq.c
>> +++ b/drivers/devfreq/devfreq.c
>> @@ -1169,6 +1169,14 @@ int devfreq_remove_governor(struct devfreq_governor *governor)
>>  }
>>  EXPORT_SYMBOL(devfreq_remove_governor);
>>  
>> +static ssize_t name_show(struct device *dev,
>> +			struct device_attribute *attr, char *buf)
>> +{
>> +	struct devfreq *devfreq = to_devfreq(dev);
>> +	return sprintf(buf, "%s\n", dev_name(devfreq->dev.parent));
> 
> Why is the parent's name being set here, and not the device name?

The device name style in struct devfreq is 'devfreq%d' instead of
parent device name in order to keep the consistent naming style for devfreq device
as I mentioned above. 'devfreq%d' name is consistent name style for devfreq device.
But, it don't show the real h/w device name. So, show the parent device name
which is specified on device-tree file.

> 
> The device name should be the name of the directory, and the parent's
> name is the name of the parent directory, why is a sysfs attribute for a
> name needed at all?

I add my comment why 'name' attribute is needed with the example of
other subsystem in the linux kernel. Instead of adding duplicate answer,
you could check my comment above.

> 
> confused,
> 
> greg k-h
> 
> 

Best Regards,
Chanwoo Choi
