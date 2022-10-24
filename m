Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94DD60BA55
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbiJXUe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbiJXUeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:34:17 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8325410D6BA
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 11:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666637059;
        bh=yEBLDeFnz8EfQ7kKMHjmF2KmCVxvaeuLLjYTy9QKjDc=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:Reply-To:
         In-Reply-To;
        b=EhJ5zqknjZgKa49FkAEuk52ZIK3Tm5Uj4A9UHXQ9At2TaK1y/FmZa7oyOxVAALXoa
         Z70TrS7aHYs5TJUbYTN/3SzLw6pzY5V4dyb8/NelX1W06qptuKtH4mfnKMpd0EMxwt
         GlSH4tz5Ty/Ggt0X6Q3Thm130x1AVtucnmN0fyp8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.0.179] ([91.141.38.147]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mxm3Q-1p0ewS1MR4-00zDVO; Mon, 24
 Oct 2022 18:19:18 +0200
Message-ID: <70e16994-6f5b-d648-0848-2eb7e3ad641a@gmx.net>
Date:   Mon, 24 Oct 2022 18:19:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [Regression] CPU stalls and eventually causes a complete system
 freeze with 6.0.3 due to "video/aperture: Disable and unregister sysfb
 devices via aperture helpers"
Content-Language: de-AT
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
From:   Andreas Thalhammer <andreas.thalhammer-linux@gmx.net>
Reply-To: andreas.thalhammer@linux.com
In-Reply-To: <51651c2e-3706-37d7-01e7-5d473a412850@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BRwFxW5WQgw3ZgRuOhBNRWSsccGlAcy6n5B66EBbfseS4rkhTw9
 21baYB1HQqsrnCm5pD1/B3L35HuQ7y0Meqr/WKqoSjv3x2drjnaEkRVUH8fUfn3DqM29ni2
 eDtumUnpqv9Z7vnmJIxA2OIYarh++Vj4UX1KDnqgoOrKjillriC2UnHvJYkSHO/20WT6p2s
 zWW62wOnnO11Ja8wWiPvQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:5eIS0g+1iQk=:ZEDWHrzY7rQDwcrMpRJP7u
 5flNsZ4H8SPlAvlleFJFrUFj+ZTCAmZkkqq8Fn9LM5eXySn8CLgHbn1x5izXLXEhWbMTlB2q1
 g03GiPjLudDl9TsuftEpNcfhKkI+TI62dsy2Sg26qJdgs7dsJsMWfdkFySiEQFvgkxoG6LiQq
 JIyBxgnjIY0oUTXqbDMeqhfe7kQbW8WQjeZt9FWPq0jWr7gY4Fp5QiqeHL843q+pGzJb5kS07
 JfqSHg06IyZRZyxmmInhiaJnK6C3zzr3OvEw5/Z6UEncSlmPUMY87nNQvs+XI8xu6VPF/T6Ty
 hFHJrZ+QJ2bRyfuI8nbAhBfRe7TrMLwn6A8VCtrcFdz55ZMg6t1ut7BVDXYISFYw1sbwCUksJ
 EPOA3589rVMzwdZJWhT70Nxfd2A9fqiVc560DkJYiQGyCiBfn60f5MKwb64RsMLHmtI5xSl4D
 GXI3eyk62KJ7mp0PQHqxD/tlMf6cfZ+fOlUf/TPYdaIBkujkXLVq3LuM8ORo4eQ7N7IcxtbAG
 /k0fUnOmuiMYtm3/eyjhetizqMVn32jy9uR0uC6y/1yUskCK9zIz6BU+OVUQrScAYYDUbjROL
 nTAL2tEkuaFVPO08yGIZzmkyqtaGWg7/zKigCaB5T5qE60gbYz4dLhPUI5lc3frOzJo8Zlms4
 gWV8ONFHKe6EDt/LhY9gowj2gRj1xgpfCZV0GQBfFNVy1aJOCvwufGgTXnymWq+A2HDgKmPEx
 P1MwYpcLw9yNFp5jTCzp7q26U9xFTs8i5kdsswOHktfhLQIi5tvwT+3/cO+E+BEh0NtaUZneZ
 QoglDrdE07qYMaWmohXwb4JjxMnYh5gpKfATTUm9KrRIT23niR8TREAxV0rqsXWdb1a3o7Rqp
 Rsf8zOivdQA0SL/IsiJMZrimCpmqJT7/fBavHrAm3nRu6B2gDT90rIOpWO8n6c0ECfOX3JNR+
 0R1kHj2i2UgIg4iHnQo+/lTO0DWBS4N+S98SqL6t+wlJl14Wwa+nk0J36R2WJknX8C+/yUDac
 6EWE4z5HYWxMCv3ppj1l+UoTVTJ0Md3wYyHqWmeXZfdUNCzln/W6ldo10piN2kSe2LKkApnUA
 YZFYyhLyArNBgvczLiYizGh7siwZJJtPDl5G96Nr0Dpk1eweirm1u6qPLMr7XSnFQmNuwRdnt
 THFAs35fBl8CdJhKHDC/sVgKFxvKIW8eHWiynhoYwZ+tumGv8BotdMB4ZzNQmtQejch8fvKSR
 obrUOq+/9f3cTPtjM+pj61jC9SpEpJzU5htKcU2/ImJwcyeSwYEXVmxkHibqpoaHyPGvReIvV
 DG1fX80wew/CrhbpO4cfIX0ZjtvWUZt6LeDvZntZl+FG2jd67jwV6YjrS+40KQTPqbOxZwBLR
 fVuoTJ8ZFEaIQoF7OQQcKhOg6ZDs5qSz8naNa9f1UUa1r5uqCH3hImKx23FuZD3kqGOArvZ0E
 B1iF90QiehkdGZhF4BL7vNn5dFIfdQjPb4Na5gsC+DALwIEK0ZSRi31hjikVzeobcpHTnX069
 tYna/GpnB5kc3pJhQKfpTWEJXAL0PpFDOgX2MaHFlqfd5hz2Y1ZsJuHHwjlkgtjxbeg==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 24.10.22 um 13:31 schrieb Thomas Zimmermann:
> Hi
>
> Am 24.10.22 um 13:27 schrieb Greg KH:
>> On Mon, Oct 24, 2022 at 12:41:43PM +0200, Thorsten Leemhuis wrote:
>>> Hi! Thx for the reply.
>>>
>>> On 24.10.22 12:26, Thomas Zimmermann wrote:
>>>> Am 23.10.22 um 10:04 schrieb Thorsten Leemhuis:
>>>>>
>>>>> I noticed a regression report in bugzilla.kernel.org. As many (most?=
)
>>>>> kernel developer don't keep an eye on it, I decided to forward it by
>>>>> mail. Quoting from
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D216616=C2=A0 :
>>>>>
>>>>>> =C2=A0=C2=A0 Andreas 2022-10-22 14:25:32 UTC
>>>>>>
>>>>>> Created attachment 303074 [details]
>>>>>> dmesg
>>>>
>>>> I've looked at the kernel log and found that simpledrm has been loade=
d
>>>> *after* amdgpu, which should never happen. The problematic patch has
>>>> been taken from a long list of refactoring work on this code. No wond=
er
>>>> that it doesn't work as expected.
>>>>
>>>> Please cherry-pick commit 9d69ef183815 ("fbdev/core: Remove
>>>> remove_conflicting_pci_framebuffers()") into the 6.0 stable branch an=
d
>>>> report on the results. It should fix the problem.
>>>
>>> Greg, is that enough for you to pick this up? Or do you want Andreas t=
o
>>> test first if it really fixes the reported problem?
>>
>> This should be good enough.=C2=A0 If this does NOT fix the issue, pleas=
e let
>> me know.
>
> Thanks a lot. I think I can provided a dedicated fix if the proposed
> commit doesn't work.
>
> Best regards
> Thomas
>
>>
>> thanks,
>>
>> greg k-h
>

Thanks... In short: the additional patch did NOT fix the problem.

I don't use git and I don't know how to /cherry-pick commit/
9d69ef183815, but I found the patch here:
https://patchwork.freedesktop.org/patch/494609/

I hope that's the right one. I reintegrated
v2-07-11-video-aperture-Disable-and-unregister-sysfb-devices-via-aperture-=
helpers.patch
and also applied
v2-04-11-fbdev-core-Remove-remove_conflicting_pci_framebuffers.patch,
did a "make mrproper" and thereafter compiled a clean new 6.0.3 kernel
(same .config).

Now the system doesn't even boot to a console. The first boot got me to
a rcu_shed stall on CPUs/tasks, same as above, but this time with:
Workqueue: btrfs-cache btrfs_work_helper

I booted a second time with the same kernel, and it got stuck after
mounting the root btrfs filesystem (what looked like a total freeze, but
when it didn't show a rcu_stall message after ~2 min I got impatient and
wanted to see if I had just busted my root filesystem...)

I booted 6.0.2 and everything is fine. (I'm very glad! I definitely
should update my backup right away!)

I will try 6.1-rc1 next, bear with...

