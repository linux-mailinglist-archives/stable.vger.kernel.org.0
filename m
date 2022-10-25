Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104BA60C6D0
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 10:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiJYIqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 04:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiJYIqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 04:46:10 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C6BEA345
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 01:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666687544;
        bh=1hlO0xp1QKme+jWFrFuCBHfanOnxZRk+T6OJTnerW7M=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:Reply-To:
         In-Reply-To;
        b=MrOBXxLir3zQckpgfyhwbCJ079uVvtvE0KipvnhHiep1U4kqnRzYboPPht02awymU
         dbEeEL+1oaeR4X0pnjnOPqrPIV+cxwQHN27bvxmat0RIHDEASG0lqT+S7IjD3P6IhM
         K8nXwvYZbmwgymkbpH+xhA4FlnJII6M33MaP7DRw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.0.179] ([178.165.198.54]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mzhj9-1p07mQ3uT3-00vcqZ; Tue, 25
 Oct 2022 10:45:44 +0200
Message-ID: <95953ffd-32db-62be-bbba-8d4a88cb1ca6@gmx.net>
Date:   Tue, 25 Oct 2022 10:45:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [Regression] CPU stalls and eventually causes a complete system
 freeze with 6.0.3 due to "video/aperture: Disable and unregister sysfb
 devices via aperture helpers"
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Sasha Levin <sashal@kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Javier Martinez Canillas <javierm@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <bbf7afe7-6ed2-6708-d302-4ba657444c45@leemhuis.info>
 <668a8ffd-ffc7-e1cc-28b4-1caca1bcc3d6@suse.de>
 <958fd763-01b6-0167-ba6b-97cbd3bddcb6@leemhuis.info>
 <Y1Z2sq9RyEnIdixD@kroah.com> <51651c2e-3706-37d7-01e7-5d473a412850@suse.de>
 <70e16994-6f5b-d648-0848-2eb7e3ad641a@gmx.net>
 <ef862938-3e1a-5138-2bda-d10e9188f920@suse.de>
Content-Language: de-AT
From:   Andreas Thalhammer <andreas.thalhammer-linux@gmx.net>
Reply-To: andreas.thalhammer@linux.com
In-Reply-To: <ef862938-3e1a-5138-2bda-d10e9188f920@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:zxAssNYuJ/nRnimIBG+dwZkpAmy6Kw0koPKVrMohPbwCL+PxCuO
 3vAq2sUNmIgliuJJb9OYSxbjgSQF/f7MvSDE3gIiJvnxEmKbGyCRhvaVUBhRtZFXy72Sown
 3k6ltKgVD4Ojg8Sj7DRzCKHmhHC7vGAgaBM018VXlMk+08v9Tfjog62BkocadEBANVgCec6
 Zre0WHtTOIXE1xQmaqaNA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jqpKQVu95eU=:Fr6ik1Xo/+cgtdi2+x5Bm2
 RBtiU6svXahvsQYN7VuePRgSIffF4xeM/rf7XXMYPoOa/PVZtDF3vgEbUMrN/aMdfgkqpc7gR
 2Quw+Ftb47/3TVxb5TbJO7x/21afaTsgzAk986wBNfDXQw1myPFegYb6LwQp5LDMPBtOfjIyg
 0TKZK3kN8m1EPgUEtC2+1s0fJlBvDsfXHaNJhQSHGUkJCj/Dz1DfMs5KbTpOuExtqG8MR29sm
 eQGA/ch7Y8acug6hedXZAyWYE/bu09Z8VFtlhogz5YMpulNvREQOrNQTa2PMvDH3LWTknpRei
 bHF9lvnbHkh9fqzuWYRHLfSCAvQDj9n3I19GyElET9PtZg4NZ16nZ0Tlo4j5EZljAoy0mFLeN
 jYbYpP50Mc9Fb1yhoyGygobqpewHwBDAsbLmZBI4Gu/UUbhEuQARKk/bGK/nInG35XsBKrj6S
 A/OtgNedEPkk9pnuNb38IjqiZ8rir7NsTZPnDwcTYhMzjrFY3uuQLGcji9gwnNhby/YBoLv1a
 s3Gy5AFsgiTXHCHBxeyUIUMKy+QcJvhF4op4M8g9pB9DRqMzksRA/spb4wloL7A4uxzCZOxSZ
 6Ck8JTCRM7gUXhYMU3cg4yzVOG0uTw/F6EHQL/oUUK09HvVZgILxnty2fDZL1TtaYZQnC7iQ1
 S7Xk7tAb/94PfVZiLTk/I3jJ13VSRvXXmfpjrNIIEHxeSurKI4xvJ8ohNNfebzWZAqbnPOKMD
 Sq2ph3PZxyziN+k11Y0Ie6NRXx8S4k7CfwlPPc8tmUOz4oP5DT+2V2wklwhDspOQjWICEaLNY
 Xz9xK++/jghqGS/vuiX0xO5yqKPz78yFn+7frGgquw9DYJODOFjBXHH0fsNwyny3U6sCZ+c39
 VmF3lwOCPDMLgKs73xzRbwomiv5PLx0MPZvn78cKU3Vb3QhsFTFSvHPOIg77P/TQNfbf/QwE0
 cnV7Vsw8etesLJVxs7JzINW716K1XgrVQsuJ8cI6ez7PUS01bhCrhXxitPxHe8++I6gqC9VyF
 bpcrOMK7rrj8s1nnkarQm/SpF7DQXHjz+sw7n2QNhzxlIphCE0A64oC0m8oYklWW97eFzfrWQ
 EQC6AyL1eGT2grwL9VPcNPUAOODfi4XPdCCzSNCCyFj/eAPJirPhkpqCu2qPy9wxuTAS9/Zqu
 ERPTeI3YtzK2wRmaQf6xrdnlV7SF/G/59yBFjVJeNyfkGzp9DlAbHUxZB1caVl8pYgRtaPOqt
 uelvdem5aTlbKUGPvCRJgqzYdTJcFKei85pfmdT9zvgV1soijNH0a2NGjashd+4Q/sjo0z71b
 uwQSb0BrcjwMxKNr2mRoJLKX3RRJZiY7QsdonLGKskf6dQxjD9xIcR2DOfH6Q2qaJNo1JVLnN
 lCzjk6lPla7RyU7TeYt6z/FzQHP9YCCgke8kkEbhTGkrPLsoL/3JpPYZBfcARzBvp5OBSVlZ1
 oltpsa9rHBRaa7RyV4HAoZR7ckPylNJT0hwRVgzj1hMrRbkCKnu8hQAbmCpE3Jt9V47OCoLuy
 86VSNXgrfXTcgrBEY1tBul0XOmjTIKT48HeG85ad9UL17D8XJN/+p9ZGw9WknGlAN7A==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 25.10.22 um 10:16 schrieb Thomas Zimmermann:
> Hi Andreas
>
> Am 24.10.22 um 18:19 schrieb Andreas Thalhammer:
>> Am 24.10.22 um 13:31 schrieb Thomas Zimmermann:
>>> Hi
>>>
>>> Am 24.10.22 um 13:27 schrieb Greg KH:
>>>> On Mon, Oct 24, 2022 at 12:41:43PM +0200, Thorsten Leemhuis wrote:
>>>>> Hi! Thx for the reply.
>>>>>
>>>>> On 24.10.22 12:26, Thomas Zimmermann wrote:
>>>>>> Am 23.10.22 um 10:04 schrieb Thorsten Leemhuis:
>>>>>>>
>>>>>>> I noticed a regression report in bugzilla.kernel.org. As many
>>>>>>> (most?)
>>>>>>> kernel developer don't keep an eye on it, I decided to forward it =
by
>>>>>>> mail. Quoting from
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D216616=C2=A0 :
>>>>>>>
>>>>>>>> =C2=A0=C2=A0 Andreas 2022-10-22 14:25:32 UTC
>>>>>>>>
>>>>>>>> Created attachment 303074 [details]
>>>>>>>> dmesg
>>>>>>
>>>>>> I've looked at the kernel log and found that simpledrm has been
>>>>>> loaded
>>>>>> *after* amdgpu, which should never happen. The problematic patch ha=
s
>>>>>> been taken from a long list of refactoring work on this code. No
>>>>>> wonder
>>>>>> that it doesn't work as expected.
>>>>>>
>>>>>> Please cherry-pick commit 9d69ef183815 ("fbdev/core: Remove
>>>>>> remove_conflicting_pci_framebuffers()") into the 6.0 stable branch
>>>>>> and
>>>>>> report on the results. It should fix the problem.
>>>>>
>>>>> Greg, is that enough for you to pick this up? Or do you want
>>>>> Andreas to
>>>>> test first if it really fixes the reported problem?
>>>>
>>>> This should be good enough.=C2=A0 If this does NOT fix the issue, ple=
ase let
>>>> me know.
>>>
>>> Thanks a lot. I think I can provided a dedicated fix if the proposed
>>> commit doesn't work.
>>>
>>> Best regards
>>> Thomas
>>>
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>
>> Thanks... In short: the additional patch did NOT fix the problem.
>
> Yeah, it's also part of a larger changeset. But I wouldn't want to
> backport all those changes either.
>
> Attached is a simple patch for linux-stable that adds the necessary fix.
> If this still doesn't work, we should probably revert the problematic
> patch.
>
> Please test the patch and let me know if it works.


Yes, this fixed the problem. I'm running 6.0.3 with your patch now, all
fine.

Thanks!
Andreas

>
> Best regards
> Thomas
>
>>
>> I don't use git and I don't know how to /cherry-pick commit/
>> 9d69ef183815, but I found the patch here:
>> https://patchwork.freedesktop.org/patch/494609/
>>
>> I hope that's the right one. I reintegrated
>> v2-07-11-video-aperture-Disable-and-unregister-sysfb-devices-via-apertu=
re-helpers.patch
>> and also applied
>> v2-04-11-fbdev-core-Remove-remove_conflicting_pci_framebuffers.patch,
>> did a "make mrproper" and thereafter compiled a clean new 6.0.3 kernel
>> (same .config).
>>
>> Now the system doesn't even boot to a console. The first boot got me to
>> a rcu_shed stall on CPUs/tasks, same as above, but this time with:
>> Workqueue: btrfs-cache btrfs_work_helper
>>
>> I booted a second time with the same kernel, and it got stuck after
>> mounting the root btrfs filesystem (what looked like a total freeze, bu=
t
>> when it didn't show a rcu_stall message after ~2 min I got impatient an=
d
>> wanted to see if I had just busted my root filesystem...)
>>
>> I booted 6.0.2 and everything is fine. (I'm very glad! I definitely
>> should update my backup right away!)
>>
>> I will try 6.1-rc1 next, bear with...
>>
>

