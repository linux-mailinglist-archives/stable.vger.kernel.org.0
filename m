Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE2B248A7E
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 17:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgHRPvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 11:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728208AbgHRPtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 11:49:42 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5498CC061389
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 08:49:42 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id j16so4239265ooc.7
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 08:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=omnibond-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=g3VwsJbTQXlr/xYyeQqiVNLJfIs4abMhrTO2rfcqbq4=;
        b=kut7EfFF9vaBIVd2T8e4HwkZZIRVh3ERLKLIrn9IF+C7z2iaAIhlj1DbEiDVzfqFLG
         7hzlzRKTBSxmBmB6QD1mJFk/qadGGWBlTS5tHn3xwxxPlOjeEaQ216+5SSgrS10HQvKG
         MNZy3rjh+5G4FmFBr+s7zF9RDS3w7Ll9ZuogDi76j2qy1VSCOK/ZI4h1ZMhu/hTw43P9
         EKTSAB+oFwxNYAin9Gw6mbLhnucCltCgLelJhHp46G8+jA6A8P5tuKV8rlp63xOkZodo
         lhcC+L4b+Ye7spIWf6XTGsb9ELOSj46iM2SG2Y93XpUIwJa44wuY45A3oY2fOaku32mH
         QKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=g3VwsJbTQXlr/xYyeQqiVNLJfIs4abMhrTO2rfcqbq4=;
        b=fPB7jj0o5y7ZveVmUQVpYHYyBpllKNnVDMXPk84+ibclq/OYq1XbA4vFvppUokY1sL
         oZJ1l78PyOAIdJw9GRhbrfu+3H4BqPwUt/vJv7+vRczgOZwl3yRMbPEAjsu+q6jwnaXE
         f39nBJyT1VaBTaMymRHaUA/R2fhsIBv+IePUNN57rNvl3x7bF7VBYky81jd0qriuZRBP
         LW8EekbvoxixXI+/GkPxn2RiQCOY9krE9Sfu5shmO7NxN0dQVZwWYJhKQIJSD38he0Si
         AK7VHoFskjS+AKkhkCv2NrJ34ZqXIlIw/z3g5oNfHKA0rcs/JLDIX2dzgDil8g4ssV+l
         4Yig==
X-Gm-Message-State: AOAM5316x0NoWa5FcAnawWQcONy40FHZWRV3ogWk2eeCMWoUnOLSo4uH
        WT2mWD9F6AMdkbCh8fSuQrOIU6oo0tKbTYttzktnrw6WAJkl8n7g
X-Google-Smtp-Source: ABdhPJxjrpFbzCUthA+sI2tjp/EhTJLdywWXL5HbsG9ZYEBXZ2qy4ixkC+yObUp3tPjhkxnQ+cgtD4ITf+ZLkuwccEw=
X-Received: by 2002:a4a:a201:: with SMTP id m1mr4054374ool.26.1597765780607;
 Tue, 18 Aug 2020 08:49:40 -0700 (PDT)
MIME-Version: 1.0
From:   Mike Marshall <hubcap@omnibond.com>
Date:   Tue, 18 Aug 2020 11:49:29 -0400
Message-ID: <CAOg9mSR=rOCGhxuR+L8YXzvwTrg4KyO285vx2TTm20fh9EdtMA@mail.gmail.com>
Subject: submission for 5.4 LTS
To:     stable@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

upstream commit id: ec95f1dedc9c64ac5a8b0bdb7c276936c70fdedd

I verified that ec95f1de "orangefs: get rid of knob code..."
will apply to 5.4 and I compiled and ran a patched 5.4 kernel
against my normal xfstests...  I wish that ec95f1de could be
in the 5.4 long term stable kernel.

ec95f1de went upstream in 5.7. When I sent up the patch it was
just a theoretical race condition to me: I accepted what Christoph
said about it. We now have experienced in-the-real-world how
important the patch is...

Someone was trying to read a whole large (more than 100 meg)
file from orangefs into some kind of cloud bucket. The
resulting read failed with a "Bad address" error. I
immediately thought of this patch. I reproduced the
"Bad address" error with dd in kernel versions that
lack ec95f1de. The "Bad address" error does not occur
in kernels that include ec95f1de:

5.7.11-100.fc31.x86_64:

$ ./wr.sh 10000000 > /pvfsmnt/wr.10000000
$ dd if=/pvfsmnt/wr.10000000 of=/tmp/wr.10000000 count=10 bs=419430400
$ ls -l /pvfsmnt/wr.10000000 /tmp/wr.10000000
-rw-rw-r--. 1 hubcap hubcap 498888897 Aug 14 15:41 /pvfsmnt/wr.10000000
-rw-rw-r--. 1 hubcap hubcap 498888897 Aug 14 16:51 /tmp/wr.10000000
$ md5sum /pvfsmnt/wr.10000000 /tmp/wr.10000000
669daa04f91f561f5fb2851fb30e4ffe  /pvfsmnt/wr.10000000
669daa04f91f561f5fb2851fb30e4ffe  /tmp/wr.10000000

5.6.0hubcap:

$ ./wr.sh 10000000 > /pvfsmnt/wr.10000000
$ dd if=/pvfsmnt/wr.10000000 of=/tmp/wr.10000000 count=10 bs=419430400
dd: error reading '/pvfsmnt/wr.10000000': Bad address
0+0 records in
0+0 records out
0 bytes copied, 10.3365 s, 0.0 kB/s

Thanks!

-Mike
