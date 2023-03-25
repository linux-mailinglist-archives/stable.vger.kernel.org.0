Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F426C9066
	for <lists+stable@lfdr.de>; Sat, 25 Mar 2023 20:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbjCYTUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Mar 2023 15:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCYTUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Mar 2023 15:20:35 -0400
Received: from mout.web.de (mout.web.de [212.227.15.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA70137;
        Sat, 25 Mar 2023 12:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
        t=1679772011; i=dahms.tobias@web.de;
        bh=9GnQ0agAqq9zJaehh+qzvMWqTQpSNUMWmsXNMvvwwKs=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=sci8Ye01wQdLnia+8FJpj26pp4z3HbdooH2QakBf9RL3Bt3vNLSLysvegQI7l2UYt
         Mgw1yi4cEJF6YpW2kFyDax1dnh9h6skcw9x6TVsM2RvEqG1xtKWjmqX7NB9ipwg/f0
         G0isY0cj4jFdHWN5sxh7pZTnNt9xWk6Xkej/aDS8AUwtzdXo7RAS2c49PdGSNlSJXT
         uWdoErj0TzMb5zj4H18NUNzKDQItznbVrdmTJwr3hn+84yG2N6mA7DGUIg2xYIkErY
         JgbcmyUvXFF8ycslcDCVrAx6BeGH6BdVWIH7kt5uKFjgdb84zm7HapGkGfsbQNXsC9
         1qW04BqmuUK7Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.2.2] ([92.206.224.50]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MbTH3-1qD0D42Bcv-00boE0; Sat, 25
 Mar 2023 20:20:11 +0100
Message-ID: <fcecf6fc-bf18-73a0-9fc1-6850e183323a@web.de>
Date:   Sat, 25 Mar 2023 20:20:09 +0100
MIME-Version: 1.0
Subject: Re: kernel error at led trigger "phy0tpt"
To:     Sean Wang <sean.wang@mediatek.com>,
        angelogioacchino.delregno@collabora.com
Cc:     stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-leds@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Linux regressions mailing list <regressions@lists.linux.dev>
References: <91feceb2-0df4-19b9-5ffa-d37e3d344fdf@web.de>
 <3fcc707b-f757-e74b-2800-3b6314217868@leemhuis.info>
Content-Language: de-DE
From:   Tobias Dahms <dahms.tobias@web.de>
In-Reply-To: <3fcc707b-f757-e74b-2800-3b6314217868@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dXDzvdYSMjaMg+OQd9MfaUmMIxA6oS7PhLqDCeDUsnMBZ2ay5Ly
 ENrJem/EupGajYOCRi26axSJItqLp2nhsPsjQNvQUp4Xto9iaokZExDti2y/iIfpkOMCS3n
 bX08efXYcIupb0tkkBQe0L9tRIyZBLRjoitCLGwMLvL1qJTU3+lkpL7lUdAfk/W2N1j1GWW
 4rAnQ07R6SIskz8SmWt+w==
UI-OutboundReport: notjunk:1;M01:P0:+b2d7amIkS8=;6HIhXk6pRPLfhy0JQJX455kIRJG
 MTzqVnM0v8klF2egTnh5y8PKcErAFYq1yW/w8wAou1qA00LtGRilPJBIzcXP9BnyMfStBny89
 63Q+5pSPpMmYjtXedYVnn79uRtgYtarutoGVcdjWy4PuOrKlACzVQPjl7ERnIBX62DQyDJC35
 fPh6AAepEur3oBYJVsa0Tp03jdQCIK7cu/MUVqqrg4MnTIKbLRZ3LclB/Aj4V2g0QfI//rV0i
 DzfpksQOOf1OFstT+gtIfnT1Lz30SHVEgf+4SK3arPq9fY29OzbyE8vvPi2QV+uWyHuZ4Je0P
 u1A+HdXiV18y7a91jSBdIQ/FIJFaRu+tCspxIFUOWCLmuGG6pX0EwK44+FeVP4KkpypXH6aGF
 epX8h8rsALb6ehokljR2Nx98kb4JXxfY+VPG70ulggsLTyAtvHsKOBvUEFLcyGEoXluwgHten
 kkr9hL1xQijV3mGtDNmKlP7FnGm7J8Y7gZwqAMBPKy5fwIv0KJIBt+LKiNlz3eZ0Ygnm8CrdY
 ywYoLGfoBqZ+MSO5hLbiOSYs5493LDJjvDjMfQj4t0RqpIItVAdbSVBrFCuRNH25REQfrakzp
 vW2ATgXEJmQgnJs5ORAHtC+l1y57QUvcgoRKoRUs+mIx+wITSO9z84fzNyFEN7VFSxPEN1cYD
 a9JuJ3xr5igFxvxkVoUHtTmqpQlrOqpjBi7/1E2VpnxHKNkbAzRiuew1t9xr4to5jn6S3uwSX
 dHE2e6rimh6ls7hHrXP6s4e6KDDE8eM2TvNLAHtUUTdKzQfz8cCuIE01l8efrwPFNVPnEAALh
 vlvf7ON0Hmh0lpkCP4vfRPxHIrwxbWvsfhcsFflstk3kQNv/uYTnK7TLoMZnZZQDmOCIpAclq
 hLvG9RFKkRHpMc9lW/B5D+2/kxVt26E7aDS+3xrcK/DjenL9OEMZ5JA6ajlQXul1Bz5mXzt4m
 6drdctrf1McRTMw/D/kuKJmcahA=
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

the bisection gives following result:
=2D-------------------------------------------------------------------
18c7deca2b812537aa4d928900e208710f1300aa is the first bad commit
commit 18c7deca2b812537aa4d928900e208710f1300aa
Author: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.co=
m>
Date:   Tue May 17 12:47:08 2022 +0200

     soc: mediatek: pwrap: Use readx_poll_timeout() instead of custom
function

     Function pwrap_wait_for_state() is a function that polls an address
     through a helper function, but this is the very same operation that
     the readx_poll_timeout macro means to do.
     Convert all instances of calling pwrap_wait_for_state() to instead
     use the read_poll_timeout macro.

     Signed-off-by: AngeloGioacchino Del Regno
<angelogioacchino.delregno@collabora.com>
     Reviewed-by: N=C3=ADcolas F. R. A. Prado <nfraprado@collabora.com>
     Tested-by: N=C3=ADcolas F. R. A. Prado <nfraprado@collabora.com>
     Link:
https://lore.kernel.org/r/20220517104712.24579-2-angelogioacchino.delregno=
@collabora.com
     Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>

  drivers/soc/mediatek/mtk-pmic-wrap.c | 60
++++++++++++++++++++----------------
  1 file changed, 33 insertions(+), 27 deletions(-)
=2D-------------------------------------------------------------------

regards
Tobias


Am 22.03.23 um 17:59 schrieb Linux regression tracking (Thorsten Leemhuis)=
:
> [adding the maintainer for drivers/leds/leds-mt6323.c as well as the LED
> subsystem maintainers to the list of recipients]
>
> Note, I first thought this might have been a vendor kernel, but it's
> not, as Tobias clarified (thx!):
> https://lore.kernel.org/all/f8f7d7ae-7e4b-e0fb-6a21-1d4fdcc22035@web.de/
>
> [TLDR for the rest of this mail: I'm adding below report to the list of
> tracked Linux kernel regressions; the text you find below is based on a
> few templates paragraphs you might have encountered already in similar
> form. See link in footer if these mails annoy you.]
>
> On 20.03.23 20:44, Tobias Dahms wrote:
>> Hello,
>>
>> since some kernel versions I get a kernel errror while setting led
>> trigger to phy0tpt.
>>
>> command to reproduce:
>> echo phy0tpt > /sys/class/leds/bpi-r2\:isink\:blue/trigger
>>
>> same trigger, other led location =3D> no error:
>> echo phy0tpt > /sys/class/leds/bpi-r2\:pio\:blue/trigger
>>
>> other trigger, same led location =3D> no error:
>> echo phy0tx > /sys/class/leds/bpi-r2\:isink\:blue/trigger
>>
>> last good kernel:
>> bpi-r2 5.19.17-bpi-r2
>>
>> error at kernel versions:
>> bpi-r2 6.0.19-bpi-r2
>> up to
>> bpi-r2 6.3.0-rc1-bpi-r2+
>>
>> wireless lan card:
>> 01:00.0 Network controller: MEDIATEK Corp. MT7612E 802.11acbgn PCI
>> Express Wireless Network Adapter
>>
>> distribution:
>> Arch-Linux-ARM (with vanilla kernel instead of original distribution
>> kernel)
>>
>> board:
>> BananaPi-R2
>>
>> log messages:
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: BUG: scheduling while atomic:
>> swapper/0/0/0x00000100
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: Modules linked in: aes_arm_bs crypt=
o_simd
>> cryptd nft_masq nft_ct nf_log_syslog nft_log nft_chain_nat nf_nat
>> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink mt76x2e
>> mt76x2_common mt76x02_lib mt76 spi_mt65xx pwm_mediatek mt6577_auxadc
>> sch_fq_codel fuse configfs ip_tables x_tables
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: CPU: 0 PID: 0 Comm: swapper/0 Not t=
ainted
>> 6.3.0-rc1-bpi-r2+ #1
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: Hardware name: Mediatek Cortex-A7 (=
Device
>> Tree)
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: Backtrace:
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 dump_backtrace from show_stac=
k+0x20/0x24
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r7:c14ab340 r6:00000000 r5:c1=
2507fc
>> r4:600f0113
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 show_stack from dump_stack_lv=
l+0x48/0x54
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 dump_stack_lvl from dump_stac=
k+0x18/0x1c
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r5:c1508fc0 r4:00000000
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 dump_stack from __schedule_bu=
g+0x60/0x70
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 __schedule_bug from __schedul=
e+0x6b0/0x904
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r5:c1508fc0 r4:eed9d340
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 __schedule from schedule+0x6c=
/0xe8
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:c1501ba0 r9:00000000 r8:0=
0001b58
>> r7:c1508fc0 r6:00001b58 r5:0000004a
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:c1508fc0
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 schedule from
>> schedule_hrtimeout_range_clock+0xec/0x14c
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r5:0000004a r4:47ac1837
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 schedule_hrtimeout_range_cloc=
k from
>> schedule_hrtimeout_range+0x28/0x30
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:c1501c50 r9:c1508fc0 r8:0=
0000002
>> r7:00000000 r6:c1501ba0 r5:00000000
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:00001b58
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 schedule_hrtimeout_range from
>> usleep_range_state+0x6c/0x90
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 usleep_range_state from
>> pwrap_read16+0xfc/0x2a0
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r9:0000004a r8:4844840c r7:00=
00004a
>> r6:48447f8a r5:01980000 r4:c2703940
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 pwrap_read16 from
>> pwrap_regmap_read+0x24/0x28
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:00001f00 r9:00000000 r8:0=
0000f00
>> r7:c2703940 r6:c1501c50 r5:00000330
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:c196e000 r3:c06f3fbc
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 pwrap_regmap_read from
>> _regmap_read+0x70/0x160
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 _regmap_read from
>> _regmap_update_bits+0xc8/0x108
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:00001f00 r9:00000000 r8:0=
0000f00
>> r7:c1508fc0 r6:00000330 r5:00000000
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:c196e000 r3:00000000
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 _regmap_update_bits from
>> regmap_update_bits_base+0x60/0x84
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:00000000 r9:00000f00 r8:0=
0000000
>> r7:00001f00 r6:00000000 r5:00000330
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:c196e000
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 regmap_update_bits_base from
>> mt6323_led_set_blink+0xf0/0x148
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:eed94800 r9:c16998c0 r8:c=
196e000
>> r7:c31f0c48 r6:c2456f48 r5:00000000
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:0000014e
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 mt6323_led_set_blink from
>> led_blink_setup+0x3c/0x110
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r9:c16998c0 r8:00000770 r7:c1=
501d60
>> r6:c1501d5c r5:c1501d60 r4:c31f0c48
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 led_blink_setup from
>> led_blink_set+0x60/0x64
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r7:c1501d60 r6:c1501d5c r5:c3=
1f0c58
>> r4:c31f0c48
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 led_blink_set from
>> led_trigger_blink+0x44/0x58
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r7:c1501d60 r6:c1501d5c r5:c5=
b69740
>> r4:c31f0c48
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 led_trigger_blink from
>> tpt_trig_timer+0x10c/0x130
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r7:c0df71f0 r6:c1508fc0 r5:c5=
b685a0
>> r4:c597b628
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 tpt_trig_timer from
>> call_timer_fn+0x48/0x168
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r6:c597b628 r5:00000100 r4:c1=
6998c0
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 call_timer_fn from
>> run_timer_softirq+0x600/0x6c8
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r9:c16998c0 r8:00000000 r7:00=
000770
>> r6:00000000 r5:c1501de4 r4:c597b628
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 run_timer_softirq from
>> __do_softirq+0x140/0x34c
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:00000082 r9:00000100 r8:c=
1698481
>> r7:c1698f60 r6:00000001 r5:00000002
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:c1503084
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 __do_softirq from irq_exit+0x=
b8/0xe8
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:10c5387d r9:c1508fc0 r8:c=
1698481
>> r7:c1501f0c r6:00000000 r5:c1501ed8
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:c14aaf58
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 irq_exit from
>> generic_handle_arch_irq+0x48/0x4c
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r5:c1501ed8 r4:c14aaf58
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 generic_handle_arch_irq from
>> __irq_svc+0x88/0xb0
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: Exception stack(0xc1501ed8 to 0xc15=
01f20)
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: 1ec0:
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 000862f4 2d8f2000
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: 1ee0: c1508fc0 00000000 c1699cc0 c1=
504f10
>> c1504f70 00000001 c1698481 c123a9b4
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: 1f00: 10c5387d c1501f3c 00000001 c1=
501f28
>> c0e36fa0 c0e3767c 600f0013 ffffffff
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r7:c1501f0c r6:ffffffff r5:60=
0f0013
>> r4:c0e3767c
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 default_idle_call from do_idl=
e+0xc4/0x124
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r5:c1504f10 r4:00000001
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 do_idle from cpu_startup_entr=
y+0x28/0x2c
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r9:efffcd40 r8:00000000 r7:00=
000045
>> r6:c1326068 r5:c16fb9b8 r4:000000ec
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 cpu_startup_entry from rest_i=
nit+0xc0/0xc4
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 rest_init from
>> arch_post_acpi_subsys_init+0x0/0x30
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r5:c16fb9b8 r4:c16cc038
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 arch_call_rest_init from
>> start_kernel+0x6c0/0x704
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 start_kernel from 0x0
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: bad: scheduling from the idle threa=
d!
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: CPU: 0 PID: 0 Comm: swapper/0 Taint=
ed: G
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 6.3.0-rc1-bpi-r2+ #1
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: Hardware name: Mediatek Cortex-A7 (=
Device
>> Tree)
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: Backtrace:
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 dump_backtrace from show_stac=
k+0x20/0x24
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r7:c14ab340 r6:00000001 r5:c1=
2507fc
>> r4:60070013
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 show_stack from dump_stack_lv=
l+0x48/0x54
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 dump_stack_lvl from dump_stac=
k+0x18/0x1c
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r5:c1508fc0 r4:eed9d340
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 dump_stack from dequeue_task_=
idle+0x30/0x44
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 dequeue_task_idle from
>> __schedule+0x4bc/0x904
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r5:c1508fc0 r4:eed9d340
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 __schedule from schedule+0x6c=
/0xe8
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:c1501ba0 r9:00000000 r8:0=
0001b58
>> r7:c1508fc0 r6:00001b58 r5:0000004a
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:c1508fc0
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 schedule from
>> schedule_hrtimeout_range_clock+0xec/0x14c
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r5:0000004a r4:492d8817
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 schedule_hrtimeout_range_cloc=
k from
>> schedule_hrtimeout_range+0x28/0x30
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:c1501c50 r9:c1508fc0 r8:0=
0000002
>> r7:00000000 r6:c1501ba0 r5:00000000
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:00001b58
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 schedule_hrtimeout_range from
>> usleep_range_state+0x6c/0x90
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 usleep_range_state from
>> pwrap_read16+0xfc/0x2a0
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r9:0000004a r8:49c5f439 r7:00=
00004a
>> r6:49c5f0eb r5:01990000 r4:c2703940
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 pwrap_read16 from
>> pwrap_regmap_read+0x24/0x28
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:0000ffff r9:00000000 r8:0=
000014d
>> r7:c2703940 r6:c1501c50 r5:00000332
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:c196e000 r3:c06f3fbc
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 pwrap_regmap_read from
>> _regmap_read+0x70/0x160
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 _regmap_read from
>> _regmap_update_bits+0xc8/0x108
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:0000ffff r9:00000000 r8:0=
000014d
>> r7:c1508fc0 r6:00000332 r5:00000000
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:c196e000 r3:00000000
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 _regmap_update_bits from
>> regmap_update_bits_base+0x60/0x84
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:00000000 r9:0000014d r8:0=
0000000
>> r7:0000ffff r6:00000000 r5:00000332
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:c196e000
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 regmap_update_bits_base from
>> mt6323_led_set_blink+0x138/0x148
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:eed94800 r9:00000000 r8:c=
196e000
>> r7:c31f0c48 r6:c2456f48 r5:00000000
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:0000014e
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 mt6323_led_set_blink from
>> led_blink_setup+0x3c/0x110
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r9:c16998c0 r8:00000770 r7:c1=
501d60
>> r6:c1501d5c r5:c1501d60 r4:c31f0c48
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 led_blink_setup from
>> led_blink_set+0x60/0x64
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r7:c1501d60 r6:c1501d5c r5:c3=
1f0c58
>> r4:c31f0c48
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 led_blink_set from
>> led_trigger_blink+0x44/0x58
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r7:c1501d60 r6:c1501d5c r5:c5=
b69740
>> r4:c31f0c48
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 led_trigger_blink from
>> tpt_trig_timer+0x10c/0x130
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r7:c0df71f0 r6:c1508fc0 r5:c5=
b685a0
>> r4:c597b628
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 tpt_trig_timer from
>> call_timer_fn+0x48/0x168
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r6:c597b628 r5:00000100 r4:c1=
6998c0
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 call_timer_fn from
>> run_timer_softirq+0x600/0x6c8
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r9:c16998c0 r8:00000000 r7:00=
000770
>> r6:00000000 r5:c1501de4 r4:c597b628
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 run_timer_softirq from
>> __do_softirq+0x140/0x34c
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:00000082 r9:00000100 r8:c=
1698481
>> r7:c1698f60 r6:00000001 r5:00000002
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:c1503084
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 __do_softirq from irq_exit+0x=
b8/0xe8
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r10:10c5387d r9:c1508fc0 r8:c=
1698481
>> r7:c1501f0c r6:00000000 r5:c1501ed8
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r4:c14aaf58
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 irq_exit from
>> generic_handle_arch_irq+0x48/0x4c
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r5:c1501ed8 r4:c14aaf58
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 generic_handle_arch_irq from
>> __irq_svc+0x88/0xb0
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: Exception stack(0xc1501ed8 to 0xc15=
01f20)
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: 1ec0:
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 000862f4 2d8f2000
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: 1ee0: c1508fc0 00000000 c1699cc0 c1=
504f10
>> c1504f70 00000001 c1698481 c123a9b4
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: 1f00: 10c5387d c1501f3c 00000001 c1=
501f28
>> c0e36fa0 c0e3767c 600f0013 ffffffff
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r7:c1501f0c r6:ffffffff r5:60=
0f0013
>> r4:c0e3767c
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 default_idle_call from do_idl=
e+0xc4/0x124
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r5:c1504f10 r4:00000001
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 do_idle from cpu_startup_entr=
y+0x28/0x2c
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r9:efffcd40 r8:00000000 r7:00=
000045
>> r6:c1326068 r5:c16fb9b8 r4:000000ec
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 cpu_startup_entry from rest_i=
nit+0xc0/0xc4
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 rest_init from
>> arch_post_acpi_subsys_init+0x0/0x30
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 r5:c16fb9b8 r4:c16cc038
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 arch_call_rest_init from
>> start_kernel+0x6c0/0x704
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel:=C2=A0 start_kernel from 0x0
>> M=C3=A4r 12 12:54:55 bpi-r2 kernel: ------------[ cut here ]-----------=
-
>
> Thanks for the report. To be sure the issue doesn't fall through the
> cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
> tracking bot:
>
> #regzbot ^introduced v5.19..v6.0
> #regzbot title led: kernel bug when setting trigger to "phy0tpt"
> #regzbot ignore-activity
>
> This isn't a regression? This issue or a fix for it are already
> discussed somewhere else? It was fixed already? You want to clarify when
> the regression started to happen? Or point out I got the title or
> something else totally wrong? Then just reply and tell me -- ideally
> while also telling regzbot about it, as explained by the page listed in
> the footer of this mail.
>
> Developers: When fixing the issue, remember to add 'Link:' tags pointing
> to the report (the parent of this mail). See page linked in footer for
> details.
>
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> --
> Everything you wanna know about Linux kernel regression tracking:
> https://linux-regtracking.leemhuis.info/about/#tldr
> That page also explains what to do if mails like this annoy you.
