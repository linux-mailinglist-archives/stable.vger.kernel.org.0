Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB196C21DE
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 20:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjCTTrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 15:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjCTTq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 15:46:28 -0400
Received: from mout.web.de (mout.web.de [212.227.15.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221A35FD4;
        Mon, 20 Mar 2023 12:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
        t=1679341455; i=dahms.tobias@web.de;
        bh=a/n+thNIXUcZypDfhpuLLwIvD4myGe61u3M/CvvvoPs=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=oSNMFUuvjMe1EcdJw/Ye3+GYXWdg2S/YxQE7SwIkDLC+nXaFOwLWIq2XtP3TFmZMw
         zqYIFd9TD5CVpZCeriVYvws1i00E/qIfciM985QZo6W2ZkDSQgSoSEWY3orGqX+T3h
         NiXpnCP7Iinq7udtjnVsn284IWUhQ/QuDLE8eKYyKw/MyugYxOqlMolGfnE+eqN3ol
         xJqPcD1denGavuA97UP6aLnFFLPO/IU9fBs+/7G4ZWy3rilxVv10sowWFDTPE2zhD5
         w6pZ/6CUOb4hVbRxPNqo4YwqszBMNISQQBqWEMQ3VcMer/eXL2jXkhgX8EsC8sshF/
         s5h3w+XVyROrg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.2.2] ([92.206.138.245]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MPKFF-1pqm2d3gS5-00PJ8L; Mon, 20
 Mar 2023 20:44:14 +0100
Message-ID: <91feceb2-0df4-19b9-5ffa-d37e3d344fdf@web.de>
Date:   Mon, 20 Mar 2023 20:44:14 +0100
MIME-Version: 1.0
Content-Language: de-DE
From:   Tobias Dahms <dahms.tobias@web.de>
Subject: kernel error at led trigger "phy0tpt"
To:     stable@vger.kernel.org, regressions@lists.linux.dev
Cc:     linux-wireless@vger.kernel.org, linux-leds@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EKz2ncYlbrA3KTGuuGo8u1i2EB5MQCnPXXrj2jWHFUiaaKHOhHH
 32WugPA9FRNqyD4jk37nF+KTgXb1Astb7Lm0sM+vKmgAdghkPe0zHJG8A/qCBGMN8DzKaM0
 EiYZwuL+rJBW+u+ind4fTepuPabjKBrnrM4XOTI92sjI8W3DhnsqeJrYSPbHmmV7Uv1liqs
 eajL6PHyvX3weKPktQPTw==
UI-OutboundReport: notjunk:1;M01:P0:jwsb+qBHvNc=;ThiRc4HiGoYccLxQIfcqzhvP0LT
 +ZmovAZwFJKN4F3JKfJ3/DLaIYZLBVCwJdaWpXZIqSWBPfvXd4ck44KQF6PWTnSngIucRQyVV
 5sBadMXUHCiEMF4jQ7OdQFLkMEJkjl2milGDSnGadRhsS7PaZw/2ljHqIH2vzXdkeF42qyu72
 mYoFyNkB9HE71/j5vCfZ4IHbUZQJJSUDf8ZEk6ahJwAK7Iu9f9lwng0CnDqXsjyUXlJiJWcpP
 hGNV0HKzlFtZOWqv+gLUOQv4/iEry8M8hNkvekNkI1R8/HQ+3ZhyOlpXssd82ke7fw6kMYlMY
 mTbWvxEBjlKt9t6W7W01vBFpo8qhWEY3E7diE4GnxpN5Dd3gCnwfwLy9TnZ746o1JqTuJrXV7
 +MlYyuoP2q8ys1Zvk8U6VZklZsXtueOuaFtLxyQJ2UNY3crPKNfEVoomBKivEE2lvh/PNzwUe
 pIwg7muWZ2NLStH+5GMkh25r+iTiEljYYAIQBB6aKuJuLxUW4WSh9deim2MYrk9NuHfVZbcPA
 tUB/8UbhfEw3fZU9R2m+aGoR/RlSFQU1oqN8W9ZSUta62yZixJJauobWr9mbLzQNE5VNCVGU7
 Dq5FQs+9q7B/1yByLDdul2DNo6XuaBqrsvnRvaXBhqPWEcpVH7wT+OuhWGdLvhZBXQ0/3Ni2M
 mv8OqY6wb+UmWpxDIGIa4Eo6klVGNcdVuSgHlEUzwzvjXPo9sK7vVd1oIz6Cbv2CLsgVHq4wO
 PcvphLBGBH7BXaoBwEkmw+Abp5ML5yyQuo0cNeYSpdosQ+xrMg5dK6RFxdg+L+qz7GcKH6J5P
 DkTVJTbIGGJmdocOFdU/Wo7U4j98Fp0HI9wgpdQrXK5oeLznNF3Zyi0LaZuaIx6dtN2W9A7c9
 amPdWOQ7BTh42an8FNMKbZbefmTIUXIDq+zqLo96NHpR8z+VGpB5OUwnK8bHojOn8THGucu8x
 bEDrmUcsF2ugS2kNN7/WPPgkasc=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

since some kernel versions I get a kernel errror while setting led
trigger to phy0tpt.

command to reproduce:
echo phy0tpt > /sys/class/leds/bpi-r2\:isink\:blue/trigger

same trigger, other led location =3D> no error:
echo phy0tpt > /sys/class/leds/bpi-r2\:pio\:blue/trigger

other trigger, same led location =3D> no error:
echo phy0tx > /sys/class/leds/bpi-r2\:isink\:blue/trigger

last good kernel:
bpi-r2 5.19.17-bpi-r2

error at kernel versions:
bpi-r2 6.0.19-bpi-r2
up to
bpi-r2 6.3.0-rc1-bpi-r2+

wireless lan card:
01:00.0 Network controller: MEDIATEK Corp. MT7612E 802.11acbgn PCI
Express Wireless Network Adapter

distribution:
Arch-Linux-ARM (with vanilla kernel instead of original distribution kerne=
l)

board:
BananaPi-R2

log messages:
M=C3=A4r 12 12:54:55 bpi-r2 kernel: BUG: scheduling while atomic:
swapper/0/0/0x00000100
M=C3=A4r 12 12:54:55 bpi-r2 kernel: Modules linked in: aes_arm_bs crypto_s=
imd
cryptd nft_masq nft_ct nf_log_syslog nft_log nft_chain_nat nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink mt76x2e
mt76x2_common mt76x02_lib mt76 spi_mt65xx pwm_mediatek mt6577_auxadc
sch_fq_codel fuse configfs ip_tables x_tables
M=C3=A4r 12 12:54:55 bpi-r2 kernel: CPU: 0 PID: 0 Comm: swapper/0 Not tain=
ted
6.3.0-rc1-bpi-r2+ #1
M=C3=A4r 12 12:54:55 bpi-r2 kernel: Hardware name: Mediatek Cortex-A7 (Dev=
ice
Tree)
M=C3=A4r 12 12:54:55 bpi-r2 kernel: Backtrace:
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  dump_backtrace from show_stack+0x20/0=
x24
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r7:c14ab340 r6:00000000 r5:c12507fc
r4:600f0113
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  show_stack from dump_stack_lvl+0x48/0=
x54
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  dump_stack_lvl from dump_stack+0x18/0=
x1c
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r5:c1508fc0 r4:00000000
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  dump_stack from __schedule_bug+0x60/0=
x70
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  __schedule_bug from __schedule+0x6b0/=
0x904
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r5:c1508fc0 r4:eed9d340
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  __schedule from schedule+0x6c/0xe8
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:c1501ba0 r9:00000000 r8:00001b58
r7:c1508fc0 r6:00001b58 r5:0000004a
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:c1508fc0
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  schedule from
schedule_hrtimeout_range_clock+0xec/0x14c
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r5:0000004a r4:47ac1837
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  schedule_hrtimeout_range_clock from
schedule_hrtimeout_range+0x28/0x30
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:c1501c50 r9:c1508fc0 r8:00000002
r7:00000000 r6:c1501ba0 r5:00000000
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:00001b58
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  schedule_hrtimeout_range from
usleep_range_state+0x6c/0x90
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  usleep_range_state from
pwrap_read16+0xfc/0x2a0
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r9:0000004a r8:4844840c r7:0000004a
r6:48447f8a r5:01980000 r4:c2703940
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  pwrap_read16 from
pwrap_regmap_read+0x24/0x28
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:00001f00 r9:00000000 r8:00000f00
r7:c2703940 r6:c1501c50 r5:00000330
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:c196e000 r3:c06f3fbc
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  pwrap_regmap_read from
_regmap_read+0x70/0x160
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  _regmap_read from
_regmap_update_bits+0xc8/0x108
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:00001f00 r9:00000000 r8:00000f00
r7:c1508fc0 r6:00000330 r5:00000000
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:c196e000 r3:00000000
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  _regmap_update_bits from
regmap_update_bits_base+0x60/0x84
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:00000000 r9:00000f00 r8:00000000
r7:00001f00 r6:00000000 r5:00000330
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:c196e000
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  regmap_update_bits_base from
mt6323_led_set_blink+0xf0/0x148
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:eed94800 r9:c16998c0 r8:c196e000
r7:c31f0c48 r6:c2456f48 r5:00000000
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:0000014e
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  mt6323_led_set_blink from
led_blink_setup+0x3c/0x110
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r9:c16998c0 r8:00000770 r7:c1501d60
r6:c1501d5c r5:c1501d60 r4:c31f0c48
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  led_blink_setup from led_blink_set+0x=
60/0x64
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r7:c1501d60 r6:c1501d5c r5:c31f0c58
r4:c31f0c48
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  led_blink_set from
led_trigger_blink+0x44/0x58
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r7:c1501d60 r6:c1501d5c r5:c5b69740
r4:c31f0c48
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  led_trigger_blink from
tpt_trig_timer+0x10c/0x130
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r7:c0df71f0 r6:c1508fc0 r5:c5b685a0
r4:c597b628
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  tpt_trig_timer from call_timer_fn+0x4=
8/0x168
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r6:c597b628 r5:00000100 r4:c16998c0
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  call_timer_fn from
run_timer_softirq+0x600/0x6c8
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r9:c16998c0 r8:00000000 r7:00000770
r6:00000000 r5:c1501de4 r4:c597b628
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  run_timer_softirq from
__do_softirq+0x140/0x34c
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:00000082 r9:00000100 r8:c1698481
r7:c1698f60 r6:00000001 r5:00000002
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:c1503084
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  __do_softirq from irq_exit+0xb8/0xe8
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:10c5387d r9:c1508fc0 r8:c1698481
r7:c1501f0c r6:00000000 r5:c1501ed8
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:c14aaf58
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  irq_exit from
generic_handle_arch_irq+0x48/0x4c
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r5:c1501ed8 r4:c14aaf58
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  generic_handle_arch_irq from
__irq_svc+0x88/0xb0
M=C3=A4r 12 12:54:55 bpi-r2 kernel: Exception stack(0xc1501ed8 to 0xc1501f=
20)
M=C3=A4r 12 12:54:55 bpi-r2 kernel: 1ec0:
                   000862f4 2d8f2000
M=C3=A4r 12 12:54:55 bpi-r2 kernel: 1ee0: c1508fc0 00000000 c1699cc0 c1504=
f10
c1504f70 00000001 c1698481 c123a9b4
M=C3=A4r 12 12:54:55 bpi-r2 kernel: 1f00: 10c5387d c1501f3c 00000001 c1501=
f28
c0e36fa0 c0e3767c 600f0013 ffffffff
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r7:c1501f0c r6:ffffffff r5:600f0013
r4:c0e3767c
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  default_idle_call from do_idle+0xc4/0=
x124
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r5:c1504f10 r4:00000001
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  do_idle from cpu_startup_entry+0x28/0=
x2c
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r9:efffcd40 r8:00000000 r7:00000045
r6:c1326068 r5:c16fb9b8 r4:000000ec
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  cpu_startup_entry from rest_init+0xc0=
/0xc4
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  rest_init from
arch_post_acpi_subsys_init+0x0/0x30
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r5:c16fb9b8 r4:c16cc038
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  arch_call_rest_init from
start_kernel+0x6c0/0x704
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  start_kernel from 0x0
M=C3=A4r 12 12:54:55 bpi-r2 kernel: bad: scheduling from the idle thread!
M=C3=A4r 12 12:54:55 bpi-r2 kernel: CPU: 0 PID: 0 Comm: swapper/0 Tainted:=
 G
       W          6.3.0-rc1-bpi-r2+ #1
M=C3=A4r 12 12:54:55 bpi-r2 kernel: Hardware name: Mediatek Cortex-A7 (Dev=
ice
Tree)
M=C3=A4r 12 12:54:55 bpi-r2 kernel: Backtrace:
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  dump_backtrace from show_stack+0x20/0=
x24
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r7:c14ab340 r6:00000001 r5:c12507fc
r4:60070013
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  show_stack from dump_stack_lvl+0x48/0=
x54
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  dump_stack_lvl from dump_stack+0x18/0=
x1c
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r5:c1508fc0 r4:eed9d340
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  dump_stack from dequeue_task_idle+0x3=
0/0x44
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  dequeue_task_idle from
__schedule+0x4bc/0x904
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r5:c1508fc0 r4:eed9d340
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  __schedule from schedule+0x6c/0xe8
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:c1501ba0 r9:00000000 r8:00001b58
r7:c1508fc0 r6:00001b58 r5:0000004a
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:c1508fc0
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  schedule from
schedule_hrtimeout_range_clock+0xec/0x14c
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r5:0000004a r4:492d8817
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  schedule_hrtimeout_range_clock from
schedule_hrtimeout_range+0x28/0x30
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:c1501c50 r9:c1508fc0 r8:00000002
r7:00000000 r6:c1501ba0 r5:00000000
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:00001b58
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  schedule_hrtimeout_range from
usleep_range_state+0x6c/0x90
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  usleep_range_state from
pwrap_read16+0xfc/0x2a0
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r9:0000004a r8:49c5f439 r7:0000004a
r6:49c5f0eb r5:01990000 r4:c2703940
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  pwrap_read16 from
pwrap_regmap_read+0x24/0x28
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:0000ffff r9:00000000 r8:0000014d
r7:c2703940 r6:c1501c50 r5:00000332
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:c196e000 r3:c06f3fbc
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  pwrap_regmap_read from
_regmap_read+0x70/0x160
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  _regmap_read from
_regmap_update_bits+0xc8/0x108
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:0000ffff r9:00000000 r8:0000014d
r7:c1508fc0 r6:00000332 r5:00000000
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:c196e000 r3:00000000
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  _regmap_update_bits from
regmap_update_bits_base+0x60/0x84
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:00000000 r9:0000014d r8:00000000
r7:0000ffff r6:00000000 r5:00000332
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:c196e000
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  regmap_update_bits_base from
mt6323_led_set_blink+0x138/0x148
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:eed94800 r9:00000000 r8:c196e000
r7:c31f0c48 r6:c2456f48 r5:00000000
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:0000014e
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  mt6323_led_set_blink from
led_blink_setup+0x3c/0x110
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r9:c16998c0 r8:00000770 r7:c1501d60
r6:c1501d5c r5:c1501d60 r4:c31f0c48
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  led_blink_setup from led_blink_set+0x=
60/0x64
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r7:c1501d60 r6:c1501d5c r5:c31f0c58
r4:c31f0c48
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  led_blink_set from
led_trigger_blink+0x44/0x58
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r7:c1501d60 r6:c1501d5c r5:c5b69740
r4:c31f0c48
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  led_trigger_blink from
tpt_trig_timer+0x10c/0x130
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r7:c0df71f0 r6:c1508fc0 r5:c5b685a0
r4:c597b628
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  tpt_trig_timer from call_timer_fn+0x4=
8/0x168
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r6:c597b628 r5:00000100 r4:c16998c0
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  call_timer_fn from
run_timer_softirq+0x600/0x6c8
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r9:c16998c0 r8:00000000 r7:00000770
r6:00000000 r5:c1501de4 r4:c597b628
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  run_timer_softirq from
__do_softirq+0x140/0x34c
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:00000082 r9:00000100 r8:c1698481
r7:c1698f60 r6:00000001 r5:00000002
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:c1503084
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  __do_softirq from irq_exit+0xb8/0xe8
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r10:10c5387d r9:c1508fc0 r8:c1698481
r7:c1501f0c r6:00000000 r5:c1501ed8
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r4:c14aaf58
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  irq_exit from
generic_handle_arch_irq+0x48/0x4c
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r5:c1501ed8 r4:c14aaf58
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  generic_handle_arch_irq from
__irq_svc+0x88/0xb0
M=C3=A4r 12 12:54:55 bpi-r2 kernel: Exception stack(0xc1501ed8 to 0xc1501f=
20)
M=C3=A4r 12 12:54:55 bpi-r2 kernel: 1ec0:
                   000862f4 2d8f2000
M=C3=A4r 12 12:54:55 bpi-r2 kernel: 1ee0: c1508fc0 00000000 c1699cc0 c1504=
f10
c1504f70 00000001 c1698481 c123a9b4
M=C3=A4r 12 12:54:55 bpi-r2 kernel: 1f00: 10c5387d c1501f3c 00000001 c1501=
f28
c0e36fa0 c0e3767c 600f0013 ffffffff
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r7:c1501f0c r6:ffffffff r5:600f0013
r4:c0e3767c
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  default_idle_call from do_idle+0xc4/0=
x124
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r5:c1504f10 r4:00000001
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  do_idle from cpu_startup_entry+0x28/0=
x2c
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r9:efffcd40 r8:00000000 r7:00000045
r6:c1326068 r5:c16fb9b8 r4:000000ec
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  cpu_startup_entry from rest_init+0xc0=
/0xc4
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  rest_init from
arch_post_acpi_subsys_init+0x0/0x30
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  r5:c16fb9b8 r4:c16cc038
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  arch_call_rest_init from
start_kernel+0x6c0/0x704
M=C3=A4r 12 12:54:55 bpi-r2 kernel:  start_kernel from 0x0
M=C3=A4r 12 12:54:55 bpi-r2 kernel: ------------[ cut here ]------------

best regards
Tobias Dahms
