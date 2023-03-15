Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B6A6BB913
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 17:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbjCOQHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 12:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjCOQHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 12:07:33 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D7995BEC;
        Wed, 15 Mar 2023 09:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1678896402; i=rwarsow@gmx.de;
        bh=Q0lkwGgO83E/5RtgGb3NhLL2Nxe4OQmkZlz8l0EMptU=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=tQzHErBAF9sbzff4a7bJCxMwj9dnmyfh7fL5mm6Eu8dh8xrSlnRri3sUjwaBmMHSY
         vra8KEo9GptsXEbeZEt0XgHiwUgtHdVooZAMEUJO7yBtJwVzWg2lOvXmfNJcurtvbW
         Tgy54guoeRtsVAk2dRRTWadxIOiAkzzc2PjbFH1fEw+p0wTtYKQDJn1Hty++OQmHr0
         MRD5G/9/IFKBam7enqiHOrfIdGKZj8IILauZAuI8yWVu/gyHXtnjpQnueuqWdiFQUO
         JiGi8XpWpC5TNZZTJZ5+PV/q+RWw0ECIRDeKz4Nxn0N/BQZesr58P/Ov4vprlyNUpz
         cF0vFt9sxg5AA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.34.249]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MHXBj-1pgaAg0o9x-00DViV; Wed, 15
 Mar 2023 17:01:27 +0100
Message-ID: <dc9c9c4b-809a-bb08-b3af-ddaf4518cdf8@gmx.de>
Date:   Wed, 15 Mar 2023 17:01:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.2 000/141] 6.2.7-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:u+B9bZGmdldEsze8rqYJK05WueHo6klnMRbd36Y/gEikfvgee0e
 swxa+XBjrjFaR9s+EhHXi2JSUTawO4yjn58VwbA1t7+XHoLDrJ5LJhpGKqqUIm6Ib+yMx20
 08xbhSxI7QWilAYVEBXpqHpivWjolvuhDUdbtf1i30l1Sa4zxgf884Jg7cY23c/p895oK8L
 iiUZlY1WPsLpGh6VO3IyQ==
UI-OutboundReport: notjunk:1;M01:P0:pV195Y8FVeY=;u/8TCuoauZnQf+IA3uFZRpjs/qO
 tT4MhYuX4ZMJ/pdSEU2vAnmFus+t+p8dC/dj9o8ZSpaf5Qk6Zx508ThyIkaZywpkpriI/XNKN
 e7QARcCfIirOZStHt8FzFSrf1TdqQcsM3kBpne5UbQuJTN3LdGchUtpM3E7yhoz6kJOZYMc/w
 R0WX2b9XshQPFhWRWn5O+tcRw01ihXtd7znIjxhTdIB3JQyod17SqxtcpkMDqra4y2MO3nkN2
 n7mIbkFe23EZZ3Ebs16FJaySnoHcFgWFFuVzJmSO4bRdPVVVlwprDjcriR+Cjknhz1gSQYbhh
 4cipd4+ckim0gQZ+YhYS4p0bjMaUOaWrijASgxHYrsKZIOpZElOg3hktfdiBfXS8sCrRygUL7
 X4BgHO47ECnDIjsl/ovOi5kPBptHksuv68tdRdKNHK4BB7vIfnMHd3eEQJCbUlnYJstIMEoPP
 r5XaJGUiOCbh8+FNQH5p0IwLki9pC+eRG85jQQ4phiNnQEBLf0LGubo0KF/RXwm3rZUXCv8Aa
 ZQi/aUj9FI1qeMhCruPF8Bbes64gKW5uJQ1KzpOIAL1H9j5hjoaq+2pcK1EUyGi0GYBsubZTs
 thmvoP7vt3tboP5jstXnTldfGxIOmRm4MjmVLJjBdJzMCXS2xZANyWxz8Xz127eYG8+UJ4GQ0
 JGoL6VWTgTaK5d3US950GzwaPGWRF8G8pdHhWXg4idQtCW7jWyFxP/EH6IcaBrQh581YwD7qf
 7taSDnt28ZhCnW5+v/iUuuvvVlXG+tge+ZuYHNjA48JBH6TihigDFWOqfVO2A9/bnY7qMdgBb
 vOovwd2TLNu6eGZ9pos0XCsSkNSK5yotkoYz8guuYaoRwjOaR2lJGEpxeRxU+vBiwe71F/Tbs
 04TNbNUnAbuUygdj5yAkkdFoLJBP5ApZFUMBv9hXy8L6qQDrIF8+6pd7P9tswZtaFtKQA/nfz
 v3gU12NSqRq46zHbmzhbnRHjP58=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.2.7-rc1

compiles [1], boots and runs here on x86_64
(Intel i5-11400, Fedora 38 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


[1]
compiles *not* without warnings since compiler version change from
Fedora 37 =3D> Fedora 38 *Beta*

It's *not* a regression from kernel 6.2.6 =3D> 6.2.7-rc1 !

cause I'm no developer I can't decide what it is: code or compiler.

anyway I I filled a Red Hat bug report:
https://bugzilla.redhat.com/show_bug.cgi?id=3D2178317

and place the warnings here in case it is coding.
if so, please let me know, so I could suggest to close the bug report !


compilers
=3D=3D=3D=3D=3D=3D=3D=3D=3D
F38: gcc version 13.0.1 20230310 (Red Hat 13.0.1-0) (GCC)
F37: gcc-12.2.1-4.fc37

output compiling 6.2.7-rc1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D

  CC      fs/f2fs/file.o
In function =E2=80=98btrfs_show_u64=E2=80=99,
     inlined from =E2=80=98btrfs_space_info_show_disk_total=E2=80=99 at
fs/btrfs/sysfs.c:836:1:
fs/btrfs/sysfs.c:636:13: warning: array subscript -35 is outside array
bounds of =E2=80=98struct kobject[144115188075855871]=E2=80=99 [-Warray-bo=
unds=3D]
   636 |         val =3D *value_ptr;
       |         ~~~~^~~~~~~~~~~~
In function =E2=80=98btrfs_show_u64=E2=80=99,
     inlined from =E2=80=98btrfs_space_info_show_bytes_may_use=E2=80=99 at
fs/btrfs/sysfs.c:832:1:
fs/btrfs/sysfs.c:636:13: warning: array subscript -44 is outside array
bounds of =E2=80=98struct kobject[144115188075855871]=E2=80=99 [-Warray-bo=
unds=3D]
   636 |         val =3D *value_ptr;
       |         ~~~~^~~~~~~~~~~~
In function =E2=80=98btrfs_show_u64=E2=80=99,
     inlined from =E2=80=98btrfs_space_info_show_bytes_readonly=E2=80=99 a=
t
fs/btrfs/sysfs.c:833:1:
fs/btrfs/sysfs.c:636:13: warning: array subscript -43 is outside array
bounds of =E2=80=98struct kobject[144115188075855871]=E2=80=99 [-Warray-bo=
unds=3D]
   636 |         val =3D *value_ptr;
       |         ~~~~^~~~~~~~~~~~
In function =E2=80=98btrfs_show_u64=E2=80=99,
     inlined from =E2=80=98btrfs_space_info_show_bytes_zone_unusable=E2=80=
=99 at
fs/btrfs/sysfs.c:834:1:
fs/btrfs/sysfs.c:636:13: warning: array subscript -41 is outside array
bounds of =E2=80=98struct kobject[144115188075855871]=E2=80=99 [-Warray-bo=
unds=3D]
   636 |         val =3D *value_ptr;
       |         ~~~~^~~~~~~~~~~~
In function =E2=80=98btrfs_show_u64=E2=80=99,
     inlined from =E2=80=98btrfs_space_info_show_disk_used=E2=80=99 at
fs/btrfs/sysfs.c:835:1:
fs/btrfs/sysfs.c:636:13: warning: array subscript -36 is outside array
bounds of =E2=80=98struct kobject[144115188075855871]=E2=80=99 [-Warray-bo=
unds=3D]
   636 |         val =3D *value_ptr;
       |         ~~~~^~~~~~~~~~~~
In function =E2=80=98btrfs_show_u64=E2=80=99,
     inlined from =E2=80=98btrfs_space_info_show_flags=E2=80=99 at fs/btrf=
s/sysfs.c:827:1:
fs/btrfs/sysfs.c:636:13: warning: array subscript -34 is outside array
bounds of =E2=80=98struct kobject[144115188075855871]=E2=80=99 [-Warray-bo=
unds=3D]
   636 |         val =3D *value_ptr;
       |         ~~~~^~~~~~~~~~~~
In function =E2=80=98btrfs_show_u64=E2=80=99,
     inlined from =E2=80=98btrfs_space_info_show_total_bytes=E2=80=99 at
fs/btrfs/sysfs.c:828:1:
fs/btrfs/sysfs.c:636:13: warning: array subscript -48 is outside array
bounds of =E2=80=98struct kobject[144115188075855871]=E2=80=99 [-Warray-bo=
unds=3D]
   636 |         val =3D *value_ptr;
       |         ~~~~^~~~~~~~~~~~
In function =E2=80=98btrfs_show_u64=E2=80=99,
     inlined from =E2=80=98btrfs_space_info_show_bytes_used=E2=80=99 at
fs/btrfs/sysfs.c:829:1:
fs/btrfs/sysfs.c:636:13: warning: array subscript -47 is outside array
bounds of =E2=80=98struct kobject[144115188075855871]=E2=80=99 [-Warray-bo=
unds=3D]
   636 |         val =3D *value_ptr;
       |         ~~~~^~~~~~~~~~~~
In function =E2=80=98btrfs_show_u64=E2=80=99,
     inlined from =E2=80=98btrfs_space_info_show_bytes_pinned=E2=80=99 at
fs/btrfs/sysfs.c:830:1:
fs/btrfs/sysfs.c:636:13: warning: array subscript -46 is outside array
bounds of =E2=80=98struct kobject[144115188075855871]=E2=80=99 [-Warray-bo=
unds=3D]
   636 |         val =3D *value_ptr;
       |         ~~~~^~~~~~~~~~~~
In function =E2=80=98btrfs_show_u64=E2=80=99,
     inlined from =E2=80=98btrfs_space_info_show_bytes_reserved=E2=80=99 a=
t
fs/btrfs/sysfs.c:831:1:
fs/btrfs/sysfs.c:636:13: warning: array subscript -45 is outside array
bounds of =E2=80=98struct kobject[144115188075855871]=E2=80=99 [-Warray-bo=
unds=3D]
   636 |         val =3D *value_ptr;
       |         ~~~~^~~~~~~~~~~~

...

   CC      drivers/usb/core/devio.o
fs/super.c: In function =E2=80=98alloc_super=E2=80=99:
fs/super.c:234:21: warning: array subscript 2 is outside the bounds of
an interior zero-length array =E2=80=98struct lock_class_key[3]=E2=80=99
[-Wzero-length-bounds]
   234 |                 if (__percpu_init_rwsem(&s->s_writers.rw_sem[i],
       |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   235 |                                         sb_writers_name[i],
       |                                         ~~~~~~~~~~~~~~~~~~~
   236 |                                         &type->s_writers_key[i]))
       |                                         ~~~~~~~~~~~~~~~~~~~~~~~~
In file included from ./include/linux/highmem.h:5,
                  from ./include/linux/bvec.h:10,
                  from ./include/linux/blk_types.h:10,
                  from ./include/linux/blkdev.h:9,
                  from fs/super.c:26:
./include/linux/fs.h:2549:31: note: while referencing =E2=80=98s_writers_k=
ey=E2=80=99
  2549 |         struct lock_class_key s_writers_key[SB_FREEZE_LEVELS];
       |                               ^~~~~~~~~~~~

...

