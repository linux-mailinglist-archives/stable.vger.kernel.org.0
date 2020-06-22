Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B7820429B
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 23:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgFVVXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 17:23:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48685 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730637AbgFVVXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 17:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592861028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MTHI+zaTja3E38VDd9Y3uerP656NmZrcxbA5irF/MwM=;
        b=a5dWimx7sNnxymwCHYFlR7JIBsG/84tSf2XeePRqoq4pu0p6V3mXw6e3UQqEIvFbvdAFeM
        VlC7ynkRv3LrAzv3RiJ7JXvzAPB2CGOAE+uWFh7+SejJHLZVHVa7epL/ZCgWI5kEG1F1L2
        dY6c+NrDDp/4H8/zzaSnDmefI4wJxWE=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-KE7ETK6eMladM-fFjSHzNg-1; Mon, 22 Jun 2020 17:23:45 -0400
X-MC-Unique: KE7ETK6eMladM-fFjSHzNg-1
Received: by mail-lj1-f199.google.com with SMTP id h14so2481727ljk.7
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 14:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MTHI+zaTja3E38VDd9Y3uerP656NmZrcxbA5irF/MwM=;
        b=HEFPTcMkosZOkp5oL8S4v77zP4yYDSjrCb3yMb+352pACHQDvOx/WrwUXcto6ms60C
         htIemit42Omwb2B6ZQ8iS3FM98hjDQalN6gDDGnw6sgJOSp75buy5N1acxE+ujKe5rN0
         2cuzCR7ok6L3n8Z3LYNREXvnwUyXlrqfPTkbQtI/3zUQiIWpEXJGOYaqUIs3R78N2B76
         f860zR/mWBnWhNeH/I8T/dSE5ihRWLWzyc42xiE0AWLFAS8jcqJNUq67rwka51bQwATb
         Zv3WHNVhKwYHxM3AyhLMtD31CptioCcgQKJ1ANkWmxdzq+kR7LO1y4xAsHqwPpY5TYxF
         +0Bw==
X-Gm-Message-State: AOAM533LF26j2WTtzPTIsSCsp5EA06HfB0k99fk/ZjU4Vo+eIXzRQ8eY
        0ynXpsf/qC6aff5TIu/EIo67VgVsLs3drsdme+hJDlIBP73uk0Ht/a3KE32oSAstNGh1X6T3d6Y
        F00bplykEIqa9cZGYlDPeLJrEr7EZWWJ1
X-Received: by 2002:a19:11:: with SMTP id 17mr10957245lfa.125.1592861024087;
        Mon, 22 Jun 2020 14:23:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2LznLexVe/R0g+fNa5jqrcvFo87DBjuKk4ROfy3S3QPgV/RN7a15kY2app7FvJIIbGRO2ynAzo0IYC7z4Xd0=
X-Received: by 2002:a19:11:: with SMTP id 17mr10957231lfa.125.1592861023809;
 Mon, 22 Jun 2020 14:23:43 -0700 (PDT)
MIME-Version: 1.0
References: <cki.F024F9B69C.ZR0DRUTWUW@redhat.com>
In-Reply-To: <cki.F024F9B69C.ZR0DRUTWUW@redhat.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 22 Jun 2020 23:23:32 +0200
Message-ID: <CAFqZXNtj8aBpsHNXDcPsP26Xp3Fumx9e4-=dvOdATSGw6cxV3w@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IPCfkqUgUEFOSUNLRUQ6IFRlc3QgcmVwb3J0IGZvciBrZXJuZWwgNS43LjUtZDFjNA==?=
        =?UTF-8?B?OGRiLmNraSAoc3RhYmxlLXF1ZXVlKQ==?=
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Milos Malik <mmalik@redhat.com>,
        Jeff Bastian <jbastian@redhat.com>,
        Major Hayden <major@redhat.com>, Xiaowu Wu <xiawu@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>,
        David Arcari <darcari@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 10:59 PM CKI Project <cki-project@redhat.com> wrote=
:
> Hello,
>
> We ran automated tests on a recent commit from this kernel tree:
>
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stabl=
e/linux-stable-rc.git
>             Commit: d1c48dba15e7 - pinctrl: qcom: ipq6018 Add missing pin=
s in qpic pin group
>
> The results of these automated tests are provided below.
>
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: PANICKED
>
> All kernel binaries, config files, and logs are available for download he=
re:
>
>   https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=3Dda=
tawarehouse/2020/06/22/607452
>
> One or more kernel tests failed:
>
>     s390x:
>       selinux-policy: serge-testsuite
>      =E2=9D=8C stress: stress-ng
>       Podman system integration test - as root
>
>     ppc64le:
>       selinux-policy: serge-testsuite
>       Podman system integration test - as root
>
>     aarch64:
>       Podman system integration test - as root
>       selinux-policy: serge-testsuite
>
>     x86_64:
>       Podman system integration test - as root
>       selinux-policy: serge-testsuite

It seems the panics are caused by this commit:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
commit/fs?h=3Dlinux-5.7.y&id=3D7bdb075348e33d757bd8cdf017a255a090e87b8f

Apparently, the "if (flags & ~(O_ACCMODE | O_LARGEFILE))" check is
being hit during mount(2):
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/=
tree/fs/overlayfs/util.c?h=3Dd1c48db#n465

[ 8149.093006] ------------[ cut here ]------------
[ 8149.097614] kernel BUG at fs/overlayfs/util.c:466!
[ 8149.102386] Internal error: Oops - BUG: 0 [#1] SMP
[ 8149.107155] Modules linked in: overlay xt_CONNSECMARK xt_SECMARK
nft_counter xt_state xt_conntrack nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4
nft_compat nf_tables nfnetlink ah6 ah4 sctp dm_log_writes dm_flakey
rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache
rfkill
sunrpc xgene_enet xgene_hwmon xgene_edac vfat fat at803x mdio_xgene
xgene_rng mailbox_xgene_slimpro drm ip_tables xfs libcrc32c
sdhci_of_arasan
sdhci_pltfm gpio_dwapb i2c_xgene_slimpro crct10dif_ce sdhci cqhci
gpio_xgene_sb xhci_plat_hcd gpio_keys aes_neon_bs
[ 8149.154907] CPU: 5 PID: 498222 Comm: mount Kdump: loaded Not
tainted 5.7.5-d1c48db.cki #1
[ 8149.163043] Hardware name: AmpereComputing(R) Mustang/Mustang, BIOS
0ACDY027 12/12/2018
[ 8149.171008] pstate: 80400005 (Nzcv daif +PAN -UAO)
[ 8149.175786] pc : ovl_path_open+0xbc/0xc0 [overlay]
[ 8149.180558] lr : ovl_check_d_type_supported+0x48/0x100 [overlay]
[ 8149.186533] sp : ffff800013463ab0
[ 8149.189829] x29: ffff800013463ab0 x28: ffff000379622040
[ 8149.195114] x27: 0000000000000000 x26: 0000000000000000
[ 8149.200399] x25: ffff000376d80240 x24: ffff000376d80b40
[ 8149.205684] x23: ffff0003da083e20 x22: ffff800013463cd8
[ 8149.210969] x21: ffff00039cae0540 x20: ffff800013463cd8
[ 8149.216252] x19: 0000000000004000 x18: 0000000000000010
[ 8149.221536] x17: 0000000000000000 x16: 0000000000000000
[ 8149.226820] x15: 095a041701101c00 x14: 745f73656c69665f
[ 8149.232104] x13: 7265746e756f6d5f x12: 79616c7265766f5f
[ 8149.237387] x11: 747365743a725f74 x10: 00000000000fffff
[ 8149.242672] x9 : ffff80000943df20 x8 : ffff0003e2f7f188
[ 8149.247956] x7 : 0000000000000000 x6 : ffff800011d65be8
[ 8149.253240] x5 : ffff0003d20cfbc8 x4 : 61c8864680b583eb
[ 8149.258523] x3 : ffff800011d56180 x2 : ffff80000943c470
[ 8149.263808] x1 : ffff000376d80b40 x0 : 0000000000004000
[ 8149.269091] Call trace:
[ 8149.271531]  ovl_path_open+0xbc/0xc0 [overlay]
[ 8149.275958]  ovl_check_d_type_supported+0x48/0x100 [overlay]
[ 8149.281593]  ovl_make_workdir+0xd0/0x460 [overlay]
[ 8149.286364]  ovl_fill_super+0x298/0xb98 [overlay]
[ 8149.291047]  mount_nodev+0x58/0xb8
[ 8149.294435]  ovl_mount+0x24/0x30 [overlay]
[ 8149.298512]  legacy_get_tree+0x38/0x68
[ 8149.302241]  vfs_get_tree+0x30/0xf8
[ 8149.305712]  do_mount+0x55c/0xa80
[ 8149.309010]  __arm64_sys_mount+0x94/0x100
[ 8149.312998]  el0_svc_common.constprop.0+0x7c/0x188
[ 8149.317763]  do_el0_svc+0x2c/0x98
[ 8149.321061]  el0_sync_handler+0x184/0x204
[ 8149.325049]  el0_sync+0x17c/0x180
[ 8149.328349] Code: a8c37bfd d50323bf d65f03c0 d4210000 (d4210000)
[ 8149.334413] ---[ end trace bc6ed2af25e97165 ]---
[ 8149.339375] ------------[ cut here ]------------

--
Ondrej Mosnacek
Software Engineer, Platform Security - SELinux kernel
Red Hat, Inc.

