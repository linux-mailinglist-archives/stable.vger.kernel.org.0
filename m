Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C81E5AC5CA
	for <lists+stable@lfdr.de>; Sun,  4 Sep 2022 19:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbiIDRif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Sep 2022 13:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiIDRif (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Sep 2022 13:38:35 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C299B31DCB
        for <stable@vger.kernel.org>; Sun,  4 Sep 2022 10:38:33 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u9so12996751ejy.5
        for <stable@vger.kernel.org>; Sun, 04 Sep 2022 10:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Q5N+J8wBw1AV+GwgbfKt4HyLOFEJ+Iwg2EMe1QjH8o4=;
        b=sVRyryW0LBQVSRFhnUymCGEkUse3TDO7H2zM3EuqvRchgIhcdd2V9Mi6vJ9LD/VMIi
         G+o4EG+Lm9nUMrkuZOrQPF0B5Qsla55APj0w1TPQGQIWfI6mSQM+/fw8+HUGlvclfwJJ
         /3VZB2n5BOQYxBXTviSAujGhYrgcl+Bws/0IqdQWFrcPqiMPFmljDE/tGp4lyAgzgdaB
         A5Z3/tvULOxuw7hYeWZyMDOtUF9NJBDL5ZWHpvYQZ8dbeTxdPP9rot1IAAikygwl3fM4
         OWkg5Rq4UfOCemQNBBCe3E3BtDgY9/i+cIDslpx3Pl5rxEd/glN5xy7AJf1a6ahEmnPX
         CbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Q5N+J8wBw1AV+GwgbfKt4HyLOFEJ+Iwg2EMe1QjH8o4=;
        b=0bP4yD/exMCMAT68cnA4whVIl8Dhfm87mBiee1ed6xZXkWCgROcKmXdO+wQW8FgBwd
         WCKVdfJMY3s8+c2pn7GpBRZ8aG2ny+hSQP5rUfaYW5bhNkzDRfIGv5FuecH/GVbCpdak
         yUj2Rm2DvieG7LOAgk+1I98ma6O9gKTssMOBw7DGDZNrub9/Z3PAOZyAg2OM6rbjwJjC
         zM+2Eo4WM7TcOjoBmv9KYr5Sy6s8xUC31dOXGRLSi/pkYLONo2usDRGHVPFow88Ibrg4
         l55xT9nT8tE5HsrF6ESUNvQRIEkw593lcLnhP72ehrPNg+WT5gkX9GFoHLyt7NvC4H8M
         FJNg==
X-Gm-Message-State: ACgBeo0I3tVBJQ8Q4YIz53xaZbebm6nCEmIYdmoPYKmEpv00R419+5+0
        VfKe+FUW3XZCUFsxlAL8cY55AA==
X-Google-Smtp-Source: AA6agR4XRuvmXNdEnkZFQbrlQGH5TeJOBJrqI6M+MiObIIZgh443V8UPUPw/OzVmzE7PJmYFQHhPUg==
X-Received: by 2002:a17:907:9812:b0:742:2865:eca8 with SMTP id ji18-20020a170907981200b007422865eca8mr18416152ejc.537.1662313112297;
        Sun, 04 Sep 2022 10:38:32 -0700 (PDT)
Received: from ?IPV6:2003:d9:971d:3600:c0da:98ce:2525:c9a0? (p200300d9971d3600c0da98ce2525c9a0.dip0.t-ipconnect.de. [2003:d9:971d:3600:c0da:98ce:2525:c9a0])
        by smtp.googlemail.com with ESMTPSA id w8-20020a170906384800b0074a82932e3bsm3898693ejc.77.2022.09.04.10.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Sep 2022 10:38:31 -0700 (PDT)
Message-ID: <b94f08a6-a2e2-c719-37ac-7c412fe1b519@colorfullife.com>
Date:   Sun, 4 Sep 2022 19:38:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: Request to cherry-pick 20401d1058f3f841f35a594ac2fc1293710e55b9
 to v5.10 and v5.4
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Varsha Teratipally <teratipally@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Rafael Aquini <aquini@redhat.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220902135912.816188-1-teratipally@google.com>
 <YxIS4jWE03E5pZjS@kroah.com>
Content-Language: en-US
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <YxIS4jWE03E5pZjS@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 9/2/22 16:27, Greg Kroah-Hartman wrote:
> On Fri, Sep 02, 2022 at 01:59:11PM +0000, Varsha Teratipally wrote:
>> Hi all,
>>
>> Commit 20401d1058f3f841f35a594ac2fc1293710e55b9("ipc: replace costly
>> bailout check in sysvipc_find_ipc()" fixes a high cve and optimizes the
>> costly loop by adding a checkpoint, which I think might be a good
>> candidate for the stable branches
> What do you mean by "high cve"?
>
> And that feels like it's an artificial benchmark fixup, what real
> workload benefits from this change?

Standard ipcs end up parsing /proc/sysvipc/*, thus there are real users 
where the performance of /proc/sysvsem/* matters.

But:

The performance of the function was bad since 2007, i.e. why is is now 
urgent? I do not see a bug that must be fixed.

Initial patch:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/ipc/util.c?id=7ca7e564e049d8b350ec9d958ff25eaa24226352

(core issue: The code needs to find the next entry in an idr. And 
instead of using idr_get_next(), it uses idr_find() in a for(;;id++) loop.)

<<<

[manfred@localhost Input]$ rpm -qf /usr/bin/ipcs
util-linux-core-2.38-1.fc36.x86_64


[manfred@localhost Input]$ strace -e openat /usr/bin/ipcs
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/en_US.UTF-8/LC_TIME", 
O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/locale/en_US.utf8/LC_TIME", 
O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib64/gconv/gconv-modules.cache", O_RDONLY) = 3

openat(AT_FDCWD, 
"/usr/share/locale/en_US.UTF-8/LC_MESSAGES/util-linux.mo", O_RDONLY) = 
-1 ENOENT (No such file or directory)
openat(AT_FDCWD, 
"/usr/share/locale/en_US.utf8/LC_MESSAGES/util-linux.mo", O_RDONLY) = -1 
ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en_US/LC_MESSAGES/util-linux.mo", 
O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en.UTF-8/LC_MESSAGES/util-linux.mo", 
O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en.utf8/LC_MESSAGES/util-linux.mo", 
O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en/LC_MESSAGES/util-linux.mo", 
O_RDONLY) = -1 ENOENT (No such file or directory)
------ Message Queues --------
key        msqid      owner      perms      used-bytes messages
openat(AT_FDCWD, "/proc/sysvipc/msg", O_RDONLY) = 3

------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch status
openat(AT_FDCWD, "/proc/sysvipc/shm", O_RDONLY) = 3
openat(AT_FDCWD, "/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/etc/passwd", O_RDONLY|O_CLOEXEC) = 3
0x00000000 18         manfred    600        524288     2 dest
openat(AT_FDCWD, "/etc/passwd", O_RDONLY|O_CLOEXEC) = 3
0x5125004a 19         manfred    600        3208 1

------ Semaphore Arrays --------
key        semid      owner      perms      nsems
openat(AT_FDCWD, "/proc/sysvipc/sem", O_RDONLY) = 3
openat(AT_FDCWD, "/etc/passwd", O_RDONLY|O_CLOEXEC) = 3
0x51250047 0          manfred    600        1
openat(AT_FDCWD, "/etc/passwd", O_RDONLY|O_CLOEXEC) = 3
0x51250049 2          manfred    600        1

 >>>

