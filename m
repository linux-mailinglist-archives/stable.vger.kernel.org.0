Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E0D14B28E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 11:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgA1K2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 05:28:19 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36057 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgA1K2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 05:28:19 -0500
Received: by mail-lj1-f196.google.com with SMTP id r19so14146694ljg.3
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 02:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=R/hB3d9WV1ZfOuGwum6uaHEPLLo7pAkJ9wkfhb8ryno=;
        b=priCxcB8LwrgDL3P9hJ8Fhmz7cxKGIy5qUbauEytJmHyUWYu7pXT5HSujg53hLD3Lr
         krD7ENJZwPzwkJrsrHAK6YqYhHgULLtAv3mK/hHiODmlK32heqyLinOp00IRwaIuXApL
         r2IK4w3Ajxik/4eEu8URX3EjVRQlMxzkY/UpVyhmwgZAszAKja9SosTyp8ojYQMuoUn0
         cSNpivomMSRy5LkkEMTLTVtyJgXrq68NQ6QCCrfix2uFvQ4B4DMTtx0XOoo6Fk0Q4F37
         Yc6wsBtUuRXwz3SS71tWgFCnxW+4bCcSWOKSvBjtE13pMU9IvLjbV3IrIpat5Uq1UorZ
         0E6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=R/hB3d9WV1ZfOuGwum6uaHEPLLo7pAkJ9wkfhb8ryno=;
        b=mOMisWGTYLc8QllPOzh90QrtSbGQWNyR0RUdsR6fYBwE4fg+BGiZ2IWabN+SZKx8lQ
         ddQnRQcsKKKZPxrZLolinhXJ8BS8DloI37w0k6QCjFut0Az0VAyb0yrYRum5PqrNOq3L
         P/IizChb6tSUPhb1Vo2LXi6viqlt0xT45y9HD6ruTonnBeiUWQp0zxu340Yz0kNgpWI2
         efb8BvTQE2kHMWqAq96oIdmswXebUTOEDuBRj9k9c7vwA0XT6gWXlETPaD43ce2i1/rK
         aZXkjP/qBBLlujlbEZknplB6ig9mBI7R/b3sPJOraOY9P6RfMaJkMCMMVgkjghW5Kn2e
         87Sw==
X-Gm-Message-State: APjAAAXR9jXoY7Us4vYlyrHhcW6+7ZsCm7xTVSk3z/wts4Q43I7u0tv7
        lppv1GK5a8I7BTDRoVgEZKp3Pg==
X-Google-Smtp-Source: APXvYqz1H+G5sAa2YK3jJrrb2gl81iOk9gR7ql0r3PFxcDlQk+/3WQL3GKFf6/h+4lgSCFz2FboK2w==
X-Received: by 2002:a2e:9c04:: with SMTP id s4mr13050425lji.147.1580207297152;
        Tue, 28 Jan 2020 02:28:17 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id d11sm9687741lfj.3.2020.01.28.02.28.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jan 2020 02:28:16 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, syzkaller@googlegroups.com
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
References: <20191127203114.766709977@linuxfoundation.org>
        <CA+G9fYuAY+14aPiRVUcXLbsr5zJ-GLjULX=s9jcGWcw_vb5Kzw@mail.gmail.com>
        <20191128073623.GE3317872@kroah.com>
        <CAKXUXMy_=gVVw656AL5Rih_DJrdrFLoURS-et0+dpJ2cKaw6SQ@mail.gmail.com>
        <20191129085800.GF3584430@kroah.com> <87sgk8szhc.fsf@unikie.com>
Date:   Tue, 28 Jan 2020 12:28:15 +0200
In-Reply-To: <87sgk8szhc.fsf@unikie.com> ("Jouni \=\?utf-8\?Q\?H\=C3\=B6gander\?\=
 \=\?utf-8\?Q\?\=22's\?\= message of "Wed,
        22 Jan 2020 09:48:47 +0200")
Message-ID: <87zhe727uo.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

jouni.hogander@unikie.com (Jouni H=C3=B6gander) writes:

> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>> > Now queued up, I'll push out -rc2 versions with this fix.
>>> >
>>> > greg k-h
>>>=20
>>> We have also been informed about another regression these two commits
>>> are causing:
>>>=20
>>> https://lore.kernel.org/lkml/ace19af4-7cae-babd-bac5-cd3505dcd874@I-lov=
e.SAKURA.ne.jp/
>>>=20
>>> I suggest to drop these two patches from this queue, and give us a
>>> week to shake out the regressions of the change, and once ready, we
>>> can include the complete set of fixes to stable (probably in a week or
>>> two).
>>
>> Ok, thanks for the information, I've now dropped them from all of the
>> queues that had them in them.
>>
>> greg k-h
>
> I have now run more extensive Syzkaller testing on following patches:
>
> cb626bf566eb net-sysfs: Fix reference count leak
> ddd9b5e3e765 net-sysfs: Call dev_hold always in rx_queue_add_kobject
> e0b60903b434 net-sysfs: Call dev_hold always in netdev_queue_add_kobje
> 48a322b6f996 net-sysfs: fix netdev_queue_add_kobject() breakage
> b8eb718348b8 net-sysfs: Fix reference count leak in rx|netdev_queue_add_k=
object
>
> These patches are fixing couple of memory leaks including this one found
> by Syzbot: https://syzkaller.appspot.com/bug?extid=3Dad8ca40ecd77896d51e2
>
> I can reproduce these memory leaks in following stable branches: 4.14,
> 4.19, and 5.4.
>
> These are all now merged into net/master tree and based on my testing
> they are ready to be taken into stable branches as well.
>
> Best Regards,
>
> Jouni H=C3=B6gander

These four patches are still missing from 4.14 and 4.19 branches:

ddd9b5e3e765 net-sysfs: Call dev_hold always in rx_queue_add_kobject
e0b60903b434 net-sysfs: Call dev_hold always in netdev_queue_add_kobje
48a322b6f996 net-sysfs: fix netdev_queue_add_kobject() breakage
b8eb718348b8 net-sysfs: Fix reference count leak in rx|netdev_queue_add_kob=
ject

Could you please consider taking them in or let me know if you want some
further activities from my side?

BR,

Jouni H=C3=B6gander
