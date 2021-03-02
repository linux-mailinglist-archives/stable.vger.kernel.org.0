Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B324E32AED4
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbhCCAGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836817AbhCBHVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 02:21:03 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7DEC06178C
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 23:13:42 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id do6so33254786ejc.3
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 23:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I+qmKjMEWnJQQCjAQbTHhcu0VbfoLpjr9qsukOsrxOY=;
        b=R1Dx2DYrkJxqEZ5c1OAFGfyNA7OWb5qNqrITEn5UVu1NTsYZQ0ynKYjUiRuBbCXNEx
         BuRp84dxbSs9Qz3BpW50ZR4AEJek5qII0BMvN/zVOU+L3S59zzFwU2e9Gn4XWZ4QS+jY
         bocFMbi/s36+z2TYdNWeQQpsNis2wyeNMYBfU1/m5nWLVi3ByfLNMZy+AhWue0HjSmY2
         yKxYTyMHEFEC4jwhiD5hiyJKkLS/75Yb0ZSkJOpI4GVsPeMK7W2tTNUM/KdeTHLHpWdq
         uAx0Zxo9DfjVsiPI3XO+to9ZbVs5PmOcoPS3Pn/5E2i3yfIWje8NivxlxDgMnFmqW0t7
         3nYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I+qmKjMEWnJQQCjAQbTHhcu0VbfoLpjr9qsukOsrxOY=;
        b=oG1TTJCpzyW+FQgpIeJkOC7elMUzstnXgu+4LrrpWLMXpfHqM5jW3gYcR/VHVrRibd
         EcyGtKkNYQ7h8aO59UIuGmOFktPMsmMDY/TsADz3Nc8QBlu1pD0UznyECAsPMe3hJDKM
         UjaoA8ARhWx7Zf40YQ9o8QqYBnITCmyAY9On99t+UtNDJnTiefJcobX7/pfvLzuMoYqd
         OerGZ3UTMu7xbNpEuKpKSH3twkTl1xw7cVZP86/S+qg703JvU1TvSzJaZAwuWaly7Gk1
         3yFvubwfut7tc7TJcVN6pGTrGabmFjt+Dwd5Sa4hZFGpUZYHFz/9aNH4EJBo8VR08B5F
         M/rg==
X-Gm-Message-State: AOAM531btsQ/nhCMTp0g4ipioGu4y/fZiJ2DVcPynK6ZD0KG8H6rfTM2
        qsztYYs5Y5l2nMLa80PhRaaGyuh5YtpKwsmc2dMD0Q==
X-Google-Smtp-Source: ABdhPJx3b6y6Czut5bDOqwM38L5CP34Sx0yQQZqRpVLowXaYLguUM3tvtqhOpV01u+b0puHGgmsaenEnx0+5vhYA0uY=
X-Received: by 2002:a17:906:7b8d:: with SMTP id s13mr19667271ejo.247.1614669221225;
 Mon, 01 Mar 2021 23:13:41 -0800 (PST)
MIME-Version: 1.0
References: <20210301193729.179652916@linuxfoundation.org>
In-Reply-To: <20210301193729.179652916@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Mar 2021 12:43:29 +0530
Message-ID: <CA+G9fYs+RueaArJXTswcX_7O4xezuJXkOUVDgXnPrtkErp7Q1Q@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/774] 5.11.3-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        LTP List <ltp@lists.linux.it>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Slaby <jirislaby@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2 Mar 2021 at 01:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.3 release.
> There are 774 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Mar 2021 19:35:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.3-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions detected on all devices (arm64, arm, x86_64 and i386).

hangup01    1  TFAIL  :  hangup01.c:133: unexpected message 3

This failure is specific to stable-rc 5.10 and 5.11.
Test PASS on mainline and Linux next kernel.

Summary
------------------------------------------------------------------------

kernel: 5.11.3-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.11.y
git commit: 687a937c5987c23a8caf2466a827657c09dda0ca
git describe: v5.11.2-775-g687a937c5987
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11=
.y/build/v5.11.2-775-g687a937c5987

Regressions (compared to build v5.11.2)
------------------------------------------------------------------------

  ltp-pty-tests:
    * hangup01

hangup01    1  TFAIL  :  hangup01.c:133: unexpected message 3

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Strace output:
------------------

+ cd /opt/ltp/testcases/bin/
+ strace -f ./hangup01
execve(\"./hangup01\", [\"./hangup01\"], 0xbed15d14 /* 18 vars */) =3D 0
brk(NULL)                               =3D 0x43000
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) =3D 0xb6feb000
access(\"/etc/ld.so.preload\", R_OK)      =3D -1 ENOENT (No such file or
directory)
openat(AT_FDCWD, \"/etc/ld.so.cache\", O_RDONLY|O_CLOEXEC) =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D19813, ...}) =3D 0
mmap2(NULL, 19813, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0xb6fe6000
close(3)                                =3D 0
openat(AT_FDCWD, \"/lib/libc.so.6\", O_RDONLY|O_CLOEXEC) =3D 3
read(3, \"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\\r\1\0004\0\0\0\".=
..,
512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D1238788, ...}) =3D 0
mmap2(NULL, 1308016, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE,
3, 0) =3D 0xb6e7d000
mprotect(0xb6fa8000, 61440, PROT_NONE)  =3D 0
mmap2(0xb6fb7000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x12a000) =3D 0xb6fb7000
mmap2(0xb6fba000, 9584, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0xb6fba000
close(3)                                =3D 0
set_tls(0xb6febd10, 0xb6fec400, 0xb6fee000, 0xb6febd10, 0xb6fee000) =3D 0
mprotect(0xb6fb7000, 8192, PROT_READ)   =3D 0
mprotect(0x3c000, 4096, PROT_READ)      =3D 0
mprotect(0xb6fed000, 4096, PROT_READ)   =3D 0
munmap(0xb6fe6000, 19813)               =3D 0
openat(AT_FDCWD, \"/dev/ptmx\", O_RDWR)   =3D 3
ioctl(3, TCGETS, {B38400 opost isig icanon echo ...}) =3D 0
ioctl(3, TIOCGPTN, [0])                 =3D 0
stat64(\"/dev/pts/0\", {st_mode=3DS_IFCHR|0620, st_rdev=3Dmakedev(136, 0), =
...}) =3D 0
ioctl(3, TCGETS, {B38400 opost isig icanon echo ...}) =3D 0
ioctl(3, TIOCGPTN, [0])                 =3D 0
stat64(\"/dev/pts/0\", {st_mode=3DS_IFCHR|0620, st_rdev=3Dmakedev(136, 0), =
...}) =3D 0
getuid32()                              =3D 0
socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) =3D 4
connect(4, {sa_family=3DAF_UNIX, sun_path=3D\"/var/run/nscd/socket\"},
110) =3D -1 ENOENT (No such file or directory)
close(4)                                =3D 0
socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) =3D 4
connect(4, {sa_family=3DAF_UNIX, sun_path=3D\"/var/run/nscd/socket\"},
110) =3D -1 ENOENT (No such file or directory)
close(4)                                =3D 0
brk(NULL)                               =3D 0x43000
brk(0x64000)                            =3D 0x64000
openat(AT_FDCWD, \"/etc/nsswitch.conf\", O_RDONLY|O_CLOEXEC) =3D 4
fstat64(4, {st_mode=3DS_IFREG|0644, st_size=3D514, ...}) =3D 0
read(4, \"# /etc/nsswitch.conf\n#\n# Example\"..., 4096) =3D 514
read(4, \"\", 4096)                       =3D 0
close(4)                                =3D 0
openat(AT_FDCWD, \"/etc/ld.so.cache\", O_RDONLY|O_CLOEXEC) =3D 4
fstat64(4, {st_mode=3DS_IFREG|0644, st_size=3D19813, ...}) =3D 0
mmap2(NULL, 19813, PROT_READ, MAP_PRIVATE, 4, 0) =3D 0xb6fe6000
close(4)                                =3D 0
openat(AT_FDCWD, \"/lib/libnss_compat.so.2\", O_RDONLY|O_CLOEXEC) =3D 4
read(4, \"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\350\f\0\0004\0\0\0=
\"...,
512) =3D 512
fstat64(4, {st_mode=3DS_IFREG|0755, st_size=3D26332, ...}) =3D 0
mmap2(NULL, 91760, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4,
0) =3D 0xb6e66000
mprotect(0xb6e6c000, 61440, PROT_NONE)  =3D 0
mmap2(0xb6e7b000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x5000) =3D 0xb6e7b000
close(4)                                =3D 0
mprotect(0xb6e7b000, 4096, PROT_READ)   =3D 0
munmap(0xb6fe6000, 19813)               =3D 0
openat(AT_FDCWD, \"/etc/ld.so.cache\", O_RDONLY|O_CLOEXEC) =3D 4
fstat64(4, {st_mode=3DS_IFREG|0644, st_size=3D19813, ...}) =3D 0
mmap2(NULL, 19813, PROT_READ, MAP_PRIVATE, 4, 0) =3D 0xb6fe6000
close(4)                                =3D 0
openat(AT_FDCWD, \"/lib/libnss_nis.so.2\", O_RDONLY|O_CLOEXEC) =3D 4
read(4, \"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\350\27\0\0004\0\0\=
0\"...,
512) =3D 512
fstat64(4, {st_mode=3DS_IFREG|0755, st_size=3D38456, ...}) =3D 0
mmap2(NULL, 103004, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4,
0) =3D 0xb6e4c000
mprotect(0xb6e55000, 61440, PROT_NONE)  =3D 0
mmap2(0xb6e64000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x8000) =3D 0xb6e64000
close(4)                                =3D 0
openat(AT_FDCWD, \"/lib/libnsl.so.1\", O_RDONLY|O_CLOEXEC) =3D 4
read(4, \"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\334.\0\0004\0\0\0\=
"...,
512) =3D 512
fstat64(4, {st_mode=3DS_IFREG|0755, st_size=3D67384, ...}) =3D 0
mmap2(NULL, 141056, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4,
0) =3D 0xb6e29000
mprotect(0xb6e39000, 61440, PROT_NONE)  =3D 0
mmap2(0xb6e48000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0xf000) =3D 0xb6e48000
mmap2(0xb6e4a000, 5888, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0xb6e4a000
close(4)                                =3D 0
openat(AT_FDCWD, \"/lib/libnss_files.so.2\", O_RDONLY|O_CLOEXEC) =3D 4
read(4, \"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0008\32\0\0004\0\0\0=
\"...,
512) =3D 512
fstat64(4, {st_mode=3DS_IFREG|0755, st_size=3D38448, ...}) =3D 0
mmap2(NULL, 127752, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4,
0) =3D 0xb6e09000
mprotect(0xb6e12000, 61440, PROT_NONE)  =3D 0
mmap2(0xb6e21000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x8000) =3D 0xb6e21000
mmap2(0xb6e23000, 21256, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) =3D 0xb6e23000
close(4)                                =3D 0
mprotect(0xb6e21000, 4096, PROT_READ)   =3D 0
mprotect(0xb6e48000, 4096, PROT_READ)   =3D 0
mprotect(0xb6e64000, 4096, PROT_READ)   =3D 0
munmap(0xb6fe6000, 19813)               =3D 0
openat(AT_FDCWD, \"/etc/group\", O_RDONLY|O_CLOEXEC) =3D 4
_llseek(4, 0, [0], SEEK_CUR)            =3D 0
fstat64(4, {st_mode=3DS_IFREG|0644, st_size=3D756, ...}) =3D 0
mmap2(NULL, 756, PROT_READ, MAP_SHARED, 4, 0) =3D 0xb6fea000
_llseek(4, 756, [756], SEEK_SET)        =3D 0
munmap(0xb6fea000, 756)                 =3D 0
close(4)                                =3D 0
ioctl(3, TIOCSPTLCK, [0])               =3D 0
clone(child_stack=3DNULL,
flags=3DCLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD,
child_tidptr=3D0xb6feb8b8) =3D 366
nanosleep({tv_sec=3D1, tv_nsec=3D0}, strace: Process 366 attached
 <unfinished ...>
[pid   366] ioctl(3, TCGETS, {B38400 opost isig icanon echo ...}) =3D 0
[pid   366] ioctl(3, TIOCGPTN, [0])     =3D 0
[pid   366] stat64(\"/dev/pts/0\", {st_mode=3DS_IFCHR|0620,
st_rdev=3Dmakedev(136, 0), ...}) =3D 0
[pid   366] openat(AT_FDCWD, \"/dev/pts/0\", O_RDWR) =3D 4
[pid   366] write(4, \"I love Linux!\", 13) =3D 13
[pid   366] close(4)                    =3D 0
[pid   366] openat(AT_FDCWD, \"/dev/pts/0\", O_RDWR) =3D 4
[pid   366] write(4, \"Use the LTP for all your Linux t\"..., 45) =3D 45
[pid   366] close(4)                    =3D 0
[pid   366] openat(AT_FDCWD, \"/dev/pts/0\", O_RDWR) =3D 4
[pid   366] write(4, \"For the latest version of the LT\"..., 73) =3D 73
[pid   366] close(4)                    =3D 0
[pid   366] exit_group(0)               =3D ?
[pid   366] +++ exited with 0 +++
<... nanosleep resumed> {tv_sec=3D0, tv_nsec=3D957592940}) =3D ?
ERESTART_RESTARTBLOCK (Interrupted by signal)
--- SIGCHLD {si_signo=3DSIGCHLD, si_code=3DCLD_EXITED, si_pid=3D366,
si_uid=3D0, si_status=3D0, si_utime=3D0, si_stime=3D0} ---
nanosleep({tv_sec=3D0, tv_nsec=3D957592940}, 0xbeeceb48) =3D 0
poll([{fd=3D3, events=3DPOLLIN}], 1, -1)    =3D 1 ([{fd=3D3, revents=3DPOLL=
IN|POLLHUP}])
read(3, \"I love Linux!\", 13)            =3D 13
poll([{fd=3D3, events=3DPOLLIN}], 1, -1)    =3D 1 ([{fd=3D3, revents=3DPOLL=
IN|POLLHUP}])
read(3, \"Use the LTP for all your Linux t\"..., 45) =3D 45
poll([{fd=3D3, events=3DPOLLIN}], 1, -1)    =3D 1 ([{fd=3D3, revents=3DPOLL=
IN|POLLHUP}])
read(3, \"For the latest version of the LT\"..., 73) =3D 64
ioctl(1, TCGETS, {B115200 opost isig icanon echo ...}) =3D 0
fstat64(1, {st_mode=3DS_IFCHR|0600, st_rdev=3Dmakedev(204, 64), ...}) =3D 0
ioctl(1, TCGETS, {B115200 opost isig icanon echo ...}) =3D 0
write(1, \"hangup01    1  TFAIL \"..., 73hangup01    1  TFAIL  :
hangup01.c:133: unexpected message 3
) =3D 73


Test case link:
https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/pty/=
hangup01.c#L133

Full test log link,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11=
.2-775-g687a937c5987/testrun/4055638/suite/ltp-pty-tests/test/hangup01/log

Test results comparison between 5.10, 5.11, Linux mainline and Linux
next master.
https://qa-reports.linaro.org/_/comparetest/?project=3D651&project=3D597&pr=
oject=3D22&project=3D6&suite=3Dltp-pty-tests&test=3Dhangup01


--=20
Linaro LKFT
https://lkft.linaro.org
