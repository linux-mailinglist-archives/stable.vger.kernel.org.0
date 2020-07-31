Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883182344D4
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 13:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732900AbgGaLsm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 31 Jul 2020 07:48:42 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58535 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732512AbgGaLsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 07:48:41 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MJmCV-1kLcqK1s65-00K9g2; Fri, 31 Jul 2020 13:48:37 +0200
Received: by mail-qk1-f173.google.com with SMTP id 11so28483091qkn.2;
        Fri, 31 Jul 2020 04:48:37 -0700 (PDT)
X-Gm-Message-State: AOAM532fxZYZZrzbbqnwh6+hsj7UJaWYCp8jjUMKNHzCtu6quk1qogjJ
        4Jn9v06saX5oTDS6WwFs1bkhwa34zuq43HbOLAk=
X-Google-Smtp-Source: ABdhPJwcEKJafZ5JSrI2u+ZH256WK22JTB7v2sMg+5b+W0yNF7hpWcgNU81f/XjWI+3qr+Ul263PIBh+OIxCYQe6u9w=
X-Received: by 2002:a37:6351:: with SMTP id x78mr3576760qkb.394.1596196116005;
 Fri, 31 Jul 2020 04:48:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200730074420.502923740@linuxfoundation.org> <CA+G9fYvCPwwmF-k=Z9Z6P2KYrOMHurcORwa3RW2H1j6pq1QEDg@mail.gmail.com>
In-Reply-To: <CA+G9fYvCPwwmF-k=Z9Z6P2KYrOMHurcORwa3RW2H1j6pq1QEDg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 31 Jul 2020 13:48:19 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2wbGAMCdQ6tq0M9=uLxCBB=aqWd9-pQjfKXZ7Ou30H2A@mail.gmail.com>
Message-ID: <CAK8P3a2wbGAMCdQ6tq0M9=uLxCBB=aqWd9-pQjfKXZ7Ou30H2A@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/19] 5.4.55-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Shakeel Butt <shakeelb@google.com>,
        Hugh Dickins <hughd@google.com>,
        Christoph Lameter <cl@linux.com>, Roman Gushchin <guro@fb.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-mm <linux-mm@kvack.org>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Muchun Song <songmuchun@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LTP List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:IeZr8XNBBPx4TLxGucqUodvHUGXijwAES3w1xXCuqn1PwZPKPor
 DtCr/vOC2l6m3uxzNFD7XK961xR1ecGcW6tBDrkK9FP7AzaSKCrOJBe3ShzmA0r8D8zi9ZR
 fvPBzU5uhBYLVg47cUYxL4oJCcnIFgWG7rR8KaK4J98oY2TRpHBCk+0TTmQvAiXCr1STEhF
 GTCkuv7cyaqELjlJEcqpA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sOtfP+SyXRQ=:wxsFcNtw3sIsJWwxAis4tR
 1RjWFyl9JkP/RTk9rcwLsnNZ0xG81q5oXxdwo2bIQhfz4YQ0gJpmN8OZ/6QfrDQP+vM2k4HN+
 bqiNbhkLQhSvxi471Qmd9047HD7vF4THEu2qj7qiVjGz3MwB9rmNTXfK/7/ju1Jjh7uyJdRxp
 lXASXBo1udWWCVIG/Yks49LowVkTmbdUXymaFW1nQ2yId9O+1OLklgUuv8VFlBK6srTgeN8Ks
 drpc+KozCZzm6zo8Eh0koS0PjVd2vUYbycGan1wYB6IDiiculnmkgKAa77L7DqJmJUkM07jvX
 Gu7uwx9hPxDRBU3No5CJylJV4Ibx26/Um9TIw4jpUzZjIYtMtUk1o8cfK486XHjWuSg9wpNyu
 REQGXOkEDs2oHIHrovwlwWE6EhmAshOcleFKESX2cqfCQi59gJw/bXlpkmrGrnFdNUqQtW2r2
 fTrVgnVOOR5jt6cz7T8Vk7OAbq4bMnB6CoTFVVGCd6u8kjHcwNticENIQtrDl9nQ2Nc2H4JWK
 C5vwRdyJ00ELWovQxO4A2GWDNfOlnyytiWIWaj/BgcdhhGJYDmj/akWUj5AY1+ucTHgVh+05v
 /ppXqAn7lpRkgO7a5I1JrdqfQFM9IhKkYw+6k7/wbONS+H7LZxN5Bu5FG2aRBwEWAr39XjRjq
 V3uy/YuIkY1j9+fiOpfnNcjoN74TH1h4kZ54sLDLUhkQVmCpQ1AU0peDRaVH+v/sZmoLSIgar
 Y83ww3Vv2S333znbkRLYNqzki9bScE2agC7HLggOEnkW+7p5++OC1Hs21wWorCTQ9NEt0Sqkn
 Zt5lnbPK3lnKB1jxIsvdFdEIPsgsyB4WK6xlFmz0skWk2fdM0hSDHaRjNc+bdzEXUnM7ZduG7
 9mdFT6SLV89KQJzLHpx87oz4FCZnAtbDixLikFdtAwBFMNjCqRIXtiSfXxT2AwpHTpzIUpyiz
 1XvKtNo8b1dZ6N38R1YEbWeusmGJHBuuso/+kIbiMnrnyUHNW0zWv
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 31, 2020 at 12:32 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Thu, 30 Jul 2020 at 13:36, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.55 release.
> > There are 19 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.55-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Results from Linaro’s test farm.
> Regressions on arm64 Juno-r2 device running LTP controllers-tests
>
> CONFIG_ARM64_64K_PAGES=y
>
> Unable to handle kernel paging request at virtual address dead000000000108

This is LIST_POISON1+8, so something was following a list_head that got
deleted from a list.

> [dead000000000108] address between user and kernel address ranges
> Internal error: Oops: 96000044 [#1] PREEMPT SMP
>
> pc : get_page_from_freelist+0xa64/0x1030
> lr : get_page_from_freelist+0x9c4/0x1030
>
> We are trying to reproduce this kernel panic and trying to narrow down to
> specific test cases.
>
> Summary
> ------------------------------------------------------------------------
>
> kernel: 5.4.55-rc1
> git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> git branch: linux-5.4.y
> git commit: 6666ca784e9e47288180a15935061d88debc9e4b
> git describe: v5.4.54-20-g6666ca784e9e
> Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/build/v5.4.54-20-g6666ca784e9e
>
> arm64 kernel config and details:
> config: https://builds.tuxbuild.com/iIsSV-1_WtyDUTe88iKaqw/kernel.config
> vmlinux: https://builds.tuxbuild.com/iIsSV-1_WtyDUTe88iKaqw/vmlinux.xz
> System.map: https://builds.tuxbuild.com/iIsSV-1_WtyDUTe88iKaqw/System.map
>
> steps to reproduce:
> - boot juno-r2 with 64k page size config
> - run ltp controllers
>   # cd /opt/ltp
>   # ./runltp -f controllers
>
> memcg_process: shmget() failed: Invalid argument
> [  248.372285] Unable to handle kernel paging request at virtual
> address dead000000000108
> [  248.380223] Mem abort info:
> [  248.383015]   ESR = 0x96000044
> [  248.386071]   EC = 0x25: DABT (current EL), IL = 32 bits
> [  248.391387]   SET = 0, FnV = 0
> [  248.394440]   EA = 0, S1PTW = 0
> [  248.397580] Data abort info:
> [  248.400460]   ISV = 0, ISS = 0x00000044
> [  248.404296]   CM = 0, WnR = 1
> [  248.407264] [dead000000000108] address between user and kernel address ranges
> [  248.414410] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> [  248.419989] Modules linked in: tda998x drm_kms_helper drm crct10dif_ce fuse
> [  248.426975] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.55-rc1 #1
> [  248.433249] Hardware name: ARM Juno development board (r2) (DT)
> [  248.439178] pstate: a0000085 (NzCv daIf -PAN -UAO)
> [  248.443984] pc : get_page_from_freelist+0xa64/0x1030
> [  248.448955] lr : get_page_from_freelist+0x9c4/0x1030

The function is a little too long for me to see immediately which list this is.
Using addr2line should help.

> [  248.453923] sp : ffff80001000fbb0
> [  248.457238] x29: ffff80001000fbb0 x28: ffff00097fdbfe48
> [  248.462557] x27: 0000000000000010 x26: 0000000000000000
> [  248.467877] x25: ffff00097feabdc0 x24: 0000000000000000
> [  248.473196] x23: 0000000000000000 x22: 0000000000000000
> [  248.478515] x21: 0000fff680154180 x20: ffff00097fdbfe38
> [  248.483835] x19: 0000000000000000 x18: 0000000000000000
> [  248.489154] x17: 0000000000000000 x16: 0000000000000000
> [  248.494473] x15: 0000000000000000 x14: 0000000000000000
> [  248.499792] x13: 0000000000000000 x12: 0000000034d4d91d
> [  248.505111] x11: 0000000000000000 x10: 0000000000000000
> [  248.510430] x9 : ffff80096e790000 x8 : ffffffffffffff40
> [  248.515749] x7 : 0000000000000000 x6 : ffffffe002308b48
> [  248.521068] x5 : ffff00097fdbfe38 x4 : dead000000000100
> [  248.526387] x3 : 0000000000000000 x2 : 0000000000000000
> [  248.531706] x1 : 0000000000000000 x0 : ffffffe002308b40
> [  248.537026] Call trace:
> [  248.539475]  get_page_from_freelist+0xa64/0x1030
> [  248.544099]  __alloc_pages_nodemask+0x144/0x280
> [  248.548635]  page_frag_alloc+0x70/0x140
> [  248.552479]  __netdev_alloc_skb+0x158/0x188
> [  248.556667]  smsc911x_poll+0x90/0x268

This looks like a regular memory allocation, one common thing that may
have gone wrong here would be an earlier double-free.

There are not a lot of commits in v5.4.55-rc1, and most of these
are surely unrelated:

6666ca784e9e (HEAD, stable-rc/linux-5.4.y) Linux 5.4.55-rc1
ee4984bf5748 Revert "dpaa_eth: fix usage as DSA master, try 3"
783efa432aa4 PM: wakeup: Show statistics for deleted wakeup sources again
967783c61b31 regmap: debugfs: check count when read regmap file
3999cdbf89f0 drivers/net/wan/x25_asy: Fix to make it work
eb8b6691d757 AX.25: Prevent integer overflows in connect and sendmsg
3c3ae3e4c529 AX.25: Prevent out-of-bounds read in ax25_sendmsg()
e9380b1e9f82 AX.25: Fix out-of-bounds read in ax25_connect()
71e00f341e74 rxrpc: Fix sendmsg() returning EPIPE due to recvmsg()
returning ENODATA
a385dfd083fb ip6_gre: fix null-ptr-deref in ip6gre_init_net()
161727c98eb6 net-sysfs: add a newline when printing 'tx_timeout' by sysfs
a93155189546 qrtr: orphan socket in qrtr_release()

I don't think any of the above are in use on your machine.

1365360e789d udp: Improve load balancing for SO_REUSEPORT.
efb2848c55b3 udp: Copy has_conns in reuseport_grow().
829a46fae4fd sctp: shrink stream outq when fails to do addstream reconf
a4842355118b sctp: shrink stream outq only when new outcnt < old outcnt
e99e79382d46 tcp: allow at most one TLP probe per flight
66007a7d7f4b net: udp: Fix wrong clean up for IS_UDPLITE macro

These seem possible but unlikely to be the culprit

8508b3ca8595 rtnetlink: Fix memory(net_device) leak when ->newlink fails
c1efeaaebc74 dev: Defer free of skbs in flush_backlog

These both deal with memory allocation in some form, I would try reverting
the last one first.

       Arnd
