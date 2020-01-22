Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63219144C9A
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 08:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgAVHs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 02:48:56 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46076 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVHsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 02:48:51 -0500
Received: by mail-lj1-f195.google.com with SMTP id j26so5645797ljc.12
        for <stable@vger.kernel.org>; Tue, 21 Jan 2020 23:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=xwjsIpjDVQTLXOURbJxAwsG5lamWs2lFH+xIMZoFUP4=;
        b=AJ/ff+Gl0mtLIrEnboH/T3vQ84C7Z2G/KJQN87cLI9CCUtJc4c+gDKJ8OGYJdcTVOb
         yRRvgOENZNoIbi1x7QQ+gHf9HZb3g1tDmaY/QVLR7dIEoFXutP1T1kbqruCQlOfAkX9b
         4+kZDuKzke7J9kErHxXJAeAfVDQrTfkq5eiQqsyRr74DhlKehM5jIFk42icQiwqLrR/7
         GkP9BhmA9gg1sytA2OjNJQ0BttL4mEsHz14pyHaIl4/pQ8kDxofMWe2s8dDHfLW2XVfk
         OubPOBqAOOp8zbS+kawxrC7NPS5njpPNS4Yr2rC1v1F8Uc6epdDfRdb21yQ7nClyl9+s
         QQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=xwjsIpjDVQTLXOURbJxAwsG5lamWs2lFH+xIMZoFUP4=;
        b=JxJOTyQUpkuIU18afjHuigfvWAKhD/ZkoNeAqmwom6Qnms/vRj0RrS2qMlXFvoAWHL
         5tzxftU8e8kddiorDMWZH6rlEdqC43bjaU5rq74QY8tUja8phuYLf0I5/UaI7fTnJDyK
         LDToZ09OPminHv2rAxOk8Hx38cwpwugXx06c6mFSjOb17ygbSC58MUIi23KTgE6IncpR
         oD1yRK/YkeByB21bvFrtrs4rxE+wUI5wtTaE3lvrg7OBdYy2UWbULLokLlPIFdgPBqrN
         6g0cpgswFkqi+roeeMmuErc/CDmx3RHl4QnBagwTHyZPy5dDxa3oS71A3RIhCJgVDvsk
         sb5Q==
X-Gm-Message-State: APjAAAVLGPPSuinFUPLac0lmZqZ2FghH9i1spzcpnYEs7OZM7W5wIqZz
        N28bBt8E/IEZ53MSyzDkaE2PbQ==
X-Google-Smtp-Source: APXvYqwH4ebVIHgYHJKaMXUEYUCPM1pT8Q4XEwrXLVnzqEwF5g/49zEwvE7PvOdvLlBeOGRQlLVrmA==
X-Received: by 2002:a2e:9d90:: with SMTP id c16mr16918246ljj.264.1579679329441;
        Tue, 21 Jan 2020 23:48:49 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id f22sm19875406ljh.74.2020.01.21.23.48.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Jan 2020 23:48:48 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
References: <20191127203114.766709977@linuxfoundation.org>
        <CA+G9fYuAY+14aPiRVUcXLbsr5zJ-GLjULX=s9jcGWcw_vb5Kzw@mail.gmail.com>
        <20191128073623.GE3317872@kroah.com>
        <CAKXUXMy_=gVVw656AL5Rih_DJrdrFLoURS-et0+dpJ2cKaw6SQ@mail.gmail.com>
        <20191129085800.GF3584430@kroah.com>
Date:   Wed, 22 Jan 2020 09:48:47 +0200
In-Reply-To: <20191129085800.GF3584430@kroah.com> (Greg Kroah-Hartman's
        message of "Fri, 29 Nov 2019 09:58:00 +0100")
Message-ID: <87sgk8szhc.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>> > Now queued up, I'll push out -rc2 versions with this fix.
>> >
>> > greg k-h
>>=20
>> We have also been informed about another regression these two commits
>> are causing:
>>=20
>> https://lore.kernel.org/lkml/ace19af4-7cae-babd-bac5-cd3505dcd874@I-love=
.SAKURA.ne.jp/
>>=20
>> I suggest to drop these two patches from this queue, and give us a
>> week to shake out the regressions of the change, and once ready, we
>> can include the complete set of fixes to stable (probably in a week or
>> two).
>
> Ok, thanks for the information, I've now dropped them from all of the
> queues that had them in them.
>
> greg k-h

I have now run more extensive Syzkaller testing on following patches:

cb626bf566eb net-sysfs: Fix reference count leak
ddd9b5e3e765 net-sysfs: Call dev_hold always in rx_queue_add_kobject
e0b60903b434 net-sysfs: Call dev_hold always in netdev_queue_add_kobje
48a322b6f996 net-sysfs: fix netdev_queue_add_kobject() breakage
b8eb718348b8 net-sysfs: Fix reference count leak in rx|netdev_queue_add_kob=
ject

These patches are fixing couple of memory leaks including this one found
by Syzbot: https://syzkaller.appspot.com/bug?extid=3Dad8ca40ecd77896d51e2

I can reproduce these memory leaks in following stable branches: 4.14,
4.19, and 5.4.

These are all now merged into net/master tree and based on my testing
they are ready to be taken into stable branches as well.

Best Regards,

Jouni H=C3=B6gander
