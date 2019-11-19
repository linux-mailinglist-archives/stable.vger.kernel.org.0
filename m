Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F06D102490
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 13:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfKSMhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 07:37:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31700 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725798AbfKSMhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 07:37:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574167034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G3EtirPwXrks+8Nq5kNr5BRwyb9uMvSetfdHyZbYKWI=;
        b=Y5Dii0OsJztA7syvY0Zw3vpi/0nP5ZMExVAoUV1kZ+Sb1epwG3TN5GMtFahAZ3Q+yqwOvq
        +7Z42iFwKVU53kr6SxcfNsbR0ffi4qxIazNwH5Odp8HrJTRrsHiCvGholumGDggu9PPF5J
        amxEYMBJ/TrXGKopFcSXfdRR3qUM0A4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-YG9VSbHRPdOIYv3gvEShFQ-1; Tue, 19 Nov 2019 07:37:13 -0500
Received: by mail-qk1-f200.google.com with SMTP id c4so13494044qkl.6
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 04:37:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S27Gzs/Jf5mwMbq9ymmLUYi3vTLFy9DXDQaUGTR/iB8=;
        b=da+meF93PafRfBoYbLzk++1Ws3Vq33IlQu/2omganlflZWwNH9Iuef7zke54rJ17Rx
         y4xs5cOUOozA+lLIKQgbIFSk5/IFMDFm1ssObSvHgBGPpsa86YeaqSWzkycIj6aiKGZo
         EW63770qSwittZ5kVvLo3NVbt0gwinSgB8FgrFTPdN1V0NoX9vuZsHbFhWxULVuaIb0I
         g2rGgCebWrVaREfKIgfgpx+YbkuFZMeMd2oIbTXAkezNrPdjZieilu4G8Rk2Axv581WY
         FNARa9dSdyFByYcp1Dyx+3SBiBvqaJR16TOvzECWBDiR3UqpcPmit7SUO3n/Ppq6gXXD
         LnGA==
X-Gm-Message-State: APjAAAWTpB/D77ndanCcPdEZqYxloLS03SK1P83hsFN5xHX9DiOUG5oS
        C8ItnYmhY8vsu/YZdWjE9vSbS5GdJHFh1hO8ndXrixy4zU8w4SFOeUHtgQ6BEYC2b9uMGnaKh/f
        wEbo8M8wf8Hl92Hds
X-Received: by 2002:ac8:36d2:: with SMTP id b18mr32537417qtc.172.1574167032438;
        Tue, 19 Nov 2019 04:37:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqzt17Q7/WVVtwtkbcMISY2OYOIuERaSVHpqKsdlWOisJHs5yuJhv7OTT83NSnP7tAcHzoJ8+w==
X-Received: by 2002:ac8:36d2:: with SMTP id b18mr32537392qtc.172.1574167031988;
        Tue, 19 Nov 2019 04:37:11 -0800 (PST)
Received: from [192.168.1.157] (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id k129sm10179757qke.128.2019.11.19.04.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 04:37:11 -0800 (PST)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Stable_queue=3a_queue-5=2e3?=
To:     Rachel Sibley <rasibley@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Cc:     Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>
References: <cki.042792963E.5VOWULC1Q9@redhat.com>
 <8e0fa6de-b6b1-23ac-9e77-d425c8d1ba22@redhat.com>
From:   Laura Abbott <labbott@redhat.com>
Message-ID: <c326c35e-453e-2dae-391c-5324803e6112@redhat.com>
Date:   Tue, 19 Nov 2019 07:37:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8e0fa6de-b6b1-23ac-9e77-d425c8d1ba22@redhat.com>
Content-Language: en-US
X-MC-Unique: YG9VSbHRPdOIYv3gvEShFQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/18/19 7:07 PM, Rachel Sibley wrote:
>=20
> On 11/18/19 10:00 AM, CKI Project wrote:
>> Hello,
>>
>> We ran automated tests on a patchset that was proposed for merging into =
this
>> kernel tree. The patches were applied to:
>>
>>         Kernel repo:https://git.kernel.org/pub/scm/linux/kernel/git/stab=
le/linux.git
>>              Commit: 116a395b7061 - Linux 5.3.11
>>
>> The results of these automated tests are provided below.
>>
>>      Overall result: FAILED (see details below)
>>               Merge: OK
>>             Compile: OK
>>               Tests: FAILED
>>
>> All kernel binaries, config files, and logs are available for download h=
ere:
>>
>>    https://artifacts.cki-project.org/pipelines/293063
>>
>> One or more kernel tests failed:
>>
>>      aarch64:
>>       =E2=9D=8C LTP lite
>=20
> I see a panic when installing the LTP dependencies
>=20
> [  690.625060] Call trace:
> [  690.627495]  bfq_find_set_group+0x8c/0xf0
> [  690.631491]  bfq_bic_update_cgroup+0xbc/0x218
> [  690.635834]  bfq_init_rq+0xac/0x808
> [  690.639309]  bfq_insert_request.isra.0+0xe0/0x200
> [  690.643999]  bfq_insert_requests+0x68/0x88
> [  690.648085]  blk_mq_sched_insert_requests+0x84/0x140
> [  690.653036]  blk_mq_flush_plug_list+0x170/0x2b0
> [  690.657555]  blk_flush_plug_list+0xec/0x100
> [  690.661725]  blk_mq_make_request+0x200/0x5e8
> [  690.665982]  generic_make_request+0x94/0x270
> [  690.670239]  submit_bio+0x34/0x168
> [  690.673712]  xfs_submit_ioend.isra.0+0x9c/0x180 [xfs]
> [  690.678798]  xfs_do_writepage+0x234/0x458 [xfs]
> [  690.683318]  write_cache_pages+0x1a4/0x3f8
> [  690.687442]  xfs_vm_writepages+0x84/0xb8 [xfs]
> [  690.691874]  do_writepages+0x3c/0xe0
> [  690.695438]  __writeback_single_inode+0x48/0x440
> [  690.700042]  writeback_sb_inodes+0x1ec/0x4b0
> [  690.704298]  __writeback_inodes_wb+0x50/0xe8
> [  690.708555]  wb_writeback+0x264/0x388
> [  690.712204]  wb_do_writeback+0x300/0x358
> [  690.716113]  wb_workfn+0x80/0x1e0
> [  690.719418]  process_one_work+0x1bc/0x3e8
> [  690.723414]  worker_thread+0x54/0x440
> [  690.727064]  kthread+0x104/0x130
> [  690.730281]  ret_from_fork+0x10/0x18
> [  690.733847] Code: eb00007f 54000220 b4000040 f8568022 (f9401c42)
> [  690.739928] ---[ end trace d3fd392f569e86d3 ]---
>=20
> https://artifacts.cki-project.org/pipelines/293063/logs/aarch64_host_2_co=
nsole.log
>=20

This looks like that same issue
https://bugzilla.redhat.com/show_bug.cgi?id=3D1767539

I don't think the BFQ fix has been sent to stable yet, or at least
it was not in 5.3.11

>> We hope that these logs can help you find the problem quickly. For the f=
ull
>> detail on our testing procedures, please scroll to the bottom of this me=
ssage.
>>
>> Please reply to this email if you have any questions about the tests tha=
t we
>> ran or if you have any suggestions on how to make future tests more effe=
ctive.
>>
>>          ,-.   ,-.
>>         ( C ) ( K )  Continuous
>>          `-',-.`-'   Kernel
>>            ( I )     Integration
>>             `-'
>> ________________________________________________________________________=
______
>>
>> Merge testing
>> -------------
>>
>> We cloned this repository and checked out the following commit:
>>
>>    Repo:https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>>    Commit: 116a395b7061 - Linux 5.3.11
>>
>>
>> We grabbed the c4a7b00e0626 commit of the stable queue repository.
>>
>> We then merged the patchset with `git am`:
>>
>>    scsi-core-handle-drivers-which-set-sg_tablesize-to-zero.patch
>>    ax88172a-fix-information-leak-on-short-answers.patch
>>    devlink-disallow-reload-operation-during-device-cleanup.patch
>>    ipmr-fix-skb-headroom-in-ipmr_get_route.patch
>>    mlxsw-core-enable-devlink-reload-only-on-probe.patch
>>    net-gemini-add-missed-free_netdev.patch
>>    net-smc-fix-fastopen-for-non-blocking-connect.patch
>>    net-usb-qmi_wwan-add-support-for-foxconn-t77w968-lte-modules.patch
>>    slip-fix-memory-leak-in-slip_open-error-path.patch
>>    tcp-remove-redundant-new-line-from-tcp_event_sk_skb.patch
>>    dpaa2-eth-free-already-allocated-channels-on-probe-defer.patch
>>    devlink-add-method-for-time-stamp-on-reporter-s-dump.patch
>>    net-smc-fix-refcount-non-blocking-connect-part-2.patch
>>
>> Compile testing
>> ---------------
>>
>> We compiled the kernel for 3 architectures:
>>
>>      aarch64:
>>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>>
>>      ppc64le:
>>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>>
>>      x86_64:
>>        make options: -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
>>
>>
>> Hardware testing
>> ----------------
>> We booted each kernel and ran the following tests:
>>
>>    aarch64:
>>      Host 1:
>>         =E2=9C=85 Boot test
>>         =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
>>
>>      Host 2:
>>         =E2=9C=85 Boot test
>>         =E2=9C=85 Podman system integration test (as root)
>>         =E2=9C=85 Podman system integration test (as user)
>>         =E2=9D=8C LTP lite
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 jvm test suite
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 AMTU (Abstract Machine Test Utility)
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 LTP: openposix test suite
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Ethernet drivers sanity
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Networking socket: fuzz
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 audit: audit testsuite test
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 httpd: mod_ssl smoke sanity
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 iotop: sanity
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 tuned: tune-processes-through-perf
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: SCSI VPD
>>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 stress: stress-ng
>>
>>    ppc64le:
>>
>>      =E2=9A=A1 Internal infrastructure issues prevented one or more test=
s (marked
>>      with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architecture=
.
>>      This is not the fault of the kernel that was tested.
>>
>>    x86_64:
>>      Host 1:
>>         =E2=9C=85 Boot test
>>         =F0=9F=9A=A7 =E2=9C=85 selinux-policy: serge-testsuite
>>
>>      Host 2:
>>         =E2=9C=85 Boot test
>>         =E2=9C=85 Podman system integration test (as root)
>>         =E2=9C=85 Podman system integration test (as user)
>>         =E2=9C=85 LTP lite
>>         =E2=9C=85 jvm test suite
>>         =E2=9C=85 AMTU (Abstract Machine Test Utility)
>>         =E2=9C=85 LTP: openposix test suite
>>         =E2=9C=85 Ethernet drivers sanity
>>         =E2=9C=85 Networking socket: fuzz
>>         =E2=9C=85 audit: audit testsuite test
>>         =E2=9C=85 httpd: mod_ssl smoke sanity
>>         =E2=9C=85 iotop: sanity
>>         =E2=9C=85 tuned: tune-processes-through-perf
>>         =E2=9C=85 pciutils: sanity smoke test
>>         =E2=9C=85 storage: SCSI VPD
>>         =E2=9C=85 stress: stress-ng
>>
>>    Test sources:https://github.com/CKI-project/tests-beaker
>>      =F0=9F=92=9A Pull requests are welcome for new tests or improvement=
s to existing tests!
>>
>> Waived tests
>> ------------
>> If the test run included waived tests, they are marked with =F0=9F=9A=A7=
. Such tests are
>> executed but their results are not taken into account. Tests are waived =
when
>> their results are not reliable enough, e.g. when they're just introduced=
 or are
>> being fixed.
>>
>> Testing timeout
>> ---------------
>> We aim to provide a report within reasonable timeframe. Tests that haven=
't
>> finished running are marked with =E2=8F=B1. Reports for non-upstream ker=
nels have
>> a Beaker recipe linked to next to each host.
>>

