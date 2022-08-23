Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D93959CDF7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 03:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbiHWBh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 21:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbiHWBh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 21:37:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEC45A2F1
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 18:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67805611F9
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 01:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC715C43140
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 01:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661218645;
        bh=fgm9S8tCGPAr/kD1wEHM2iEwr8xK6oZUIl8jToFIQ2E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SD2tnQUXe9cJ0XNWuaVUZvB9mMTE5Op7suCZeKiCc3p+qKFbuuNMtq5HTcijwNuVa
         CobMu+uDMl2x9m6pjcl9v4nUSDH4G0ZtNcvxEihqisqQy/8/bYSm1V/gwBoN+1H0KH
         JVL7xWFSYeeCnHopPLI2Vbvo/Cve8rScEcT0VKH71iIf5UZx05PrFlcWqA1dtNQHsj
         0XqAOCoX6At6i4dt6oBIRIh4s02HmZng3XV2oVDJurqmz1ODlDek7g+R03wKS9YRD9
         WI4n5Rv6UcptJNI5dia2RBCV5bn+ZXpoWSTHecopRf0YFR4dO6sbMUT9e17DKJrMmH
         7w/LLHMVYpCmg==
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-33387bf0c4aso341662077b3.11
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 18:37:25 -0700 (PDT)
X-Gm-Message-State: ACgBeo0OIeBTC3oXaKMgw7YmrrVu9jS7xuojyW6P7YNT9vIz1jBpkkZP
        beAeLTHKBrIGl2Bwnz7w73l0lnURXrT+hocv3LQ=
X-Google-Smtp-Source: AA6agR5BSl8EIxa5lQl8uzjvDsifgoiR1AVGW6TCb98oDQh+LknaM/1nvm+R16EcMrec6tv8Jf5QPGAdFsnLCqCTgow=
X-Received: by 2002:a25:6003:0:b0:68c:870b:2405 with SMTP id
 u3-20020a256003000000b0068c870b2405mr21898418ybb.9.1661218644826; Mon, 22 Aug
 2022 18:37:24 -0700 (PDT)
MIME-Version: 1.0
References: <000401d8a746$3eaca200$bc05e600$@whissi.de> <000001d8ad7e$c340ad70$49c20850$@whissi.de>
 <2a2d1075-aa22-8c4d-ca21-274200dce2fc@leemhuis.info> <0FBCAB10-545E-45E2-A0C8-D7620817651D@digitalocean.com>
 <CAPhsuW5f9QD+gzJ9eBhn5irsHvrsvkWjSnA4MPaHsQjjLMypXg@mail.gmail.com>
 <43e678ca-3fc3-6c08-f035-2c31a34dd889@whissi.de> <701f3fc0-2f0c-a32c-0d41-b489a9a59b99@whissi.de>
 <0192a465-d75d-c09a-732a-eb2215bf3479@whissi.de> <CAPhsuW6yLLcj3GtA+4mUFooQmfGo3cVTYn-xBEY2KuP1wwmQNA@mail.gmail.com>
 <b903abd4-d101-e6a5-06a0-667853286308@whissi.de> <4f69659f-7160-7854-0ed5-6867e3eb2edb@whissi.de>
 <CAPhsuW6Bq8rkiCzsWW7bkrCbYYEwFWtKaswOZcXsyk8tu3C5Dg@mail.gmail.com>
 <be8542cf-9b58-8861-11b5-8eeaa08f1421@whissi.de> <CAPhsuW45eYTjmA4C_wc_Z=ELbw9NStGpX6Mkf=tn1AEBknDg4Q@mail.gmail.com>
In-Reply-To: <CAPhsuW45eYTjmA4C_wc_Z=ELbw9NStGpX6Mkf=tn1AEBknDg4Q@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 22 Aug 2022 18:37:13 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7zdynykfXnz8X4CDEusHSHm9Vr01yiQSpEvizGwBUDkQ@mail.gmail.com>
Message-ID: <CAPhsuW7zdynykfXnz8X4CDEusHSHm9Vr01yiQSpEvizGwBUDkQ@mail.gmail.com>
Subject: Re: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs
To:     Thomas Deutschmann <whissi@whissi.de>
Cc:     Vishal Verma <vverma@digitalocean.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 3:59 PM Song Liu <song@kernel.org> wrote:
>
> On Mon, Aug 22, 2022 at 3:44 PM Thomas Deutschmann <whissi@whissi.de> wro=
te:
> >
> > On 2022-08-22 23:52, Song Liu wrote:
> > > Hmm.. I still cannot repro the hang in my test. I have:
> > >
> > > [root@eth50-1 ~]# mount | grep mnt
> > > /dev/md0 on /root/mnt type ext4 (rw,relatime,stripe=3D384)
> > > [root@eth50-1 ~]# lsblk
> > > NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
> > > sr0      11:0    1 1024M  0 rom
> > > vda     253:0    0   32G  0 disk
> > > =E2=94=9C=E2=94=80vda1  253:1    0    2G  0 part  /boot
> > > =E2=94=94=E2=94=80vda2  253:2    0   30G  0 part  /
> > > nvme0n1 259:0    0    4G  0 disk
> > > =E2=94=94=E2=94=80md0     9:0    0   12G  0 raid5 /root/mnt
> > > nvme2n1 259:1    0    4G  0 disk
> > > =E2=94=94=E2=94=80md0     9:0    0   12G  0 raid5 /root/mnt
> > > nvme3n1 259:2    0    4G  0 disk
> > > =E2=94=94=E2=94=80md0     9:0    0   12G  0 raid5 /root/mnt
> > > nvme1n1 259:3    0    4G  0 disk
> > > =E2=94=94=E2=94=80md0     9:0    0   12G  0 raid5 /root/mnt
> > >
> > > [root@eth50-1 ~]# history
> > >    381  fio iou/repro.fio
> > >    382  fsfreeze --freeze /root/mnt
> > >    383  fsfreeze --unfreeze /root/mnt
> > >    384  fio iou/repro.fio
> > >    385  fsfreeze --freeze /root/mnt
> > >    386  fsfreeze --unfreeze /root/mnt
> > > ^^^^^^^^^^^^^^ all works fine.
> > >
> > > Did I miss something?
> >
> > No :(
> >
> > I am currently not testing against the mdraid but this shouldn't matter=
.
> >
> > However, it looks like you don't test on bare metal, do you?
> >
> > I tried to test on VMware Workstation 16 myself but VMware's nvme
> > implementation is currently broken
> > (https://github.com/vmware/open-vm-tools/issues/579).
>
> I am testing with QEMU emulator version 6.2.0. I can also test with
> bare metal.

OK, now I got a repro with bare metal: nvme+xfs.

This is a 5.19 based kernel, the stack is

[  867.091579] INFO: task fsfreeze:49972 blocked for more than 122 seconds.
[  867.104969]       Tainted: G S
5.19.0-0_fbk0_rc1_gc225658be66e #1
[  867.119750] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  867.135381] task:fsfreeze        state:D stack:    0 pid:49972
ppid: 22571 flags:0x00004000
[  867.135388] Call Trace:
[  867.135390]  <TASK>
[  867.135394]  __schedule+0x3d7/0x700
[  867.135404]  schedule+0x39/0x90
[  867.135409]  percpu_down_write+0x234/0x270
[  867.135414]  freeze_super+0x8a/0x160
[  867.135422]  do_vfs_ioctl+0x8b5/0x920
[  867.135430]  __x64_sys_ioctl+0x52/0xb0
[  867.135435]  do_syscall_64+0x3d/0x90
[  867.135441]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  867.135447] RIP: 0033:0x7f034f23fcdb
[  867.135453] RSP: 002b:00007ffe2bdfebf8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  867.135457] RAX: ffffffffffffffda RBX: 0000000000000066 RCX: 00007f034f2=
3fcdb
[  867.135460] RDX: 0000000000000000 RSI: 00000000c0045877 RDI: 00000000000=
00003
[  867.135463] RBP: 0000000000000003 R08: 0000000000000001 R09: 00000000000=
00000
[  867.135466] R10: 0000000000001000 R11: 0000000000000246 R12: 00007ffe2bd=
ff334
[  867.135469] R13: 00005650ff68dc40 R14: ffffffff00000000 R15: 00005650ff6=
8c0f5
[  867.135474]  </TASK>

I am not very familiar with this code, so I will need more time to look int=
o it.

Thomas, have you tried to bisect with the fio repro?

Thanks,
Song
