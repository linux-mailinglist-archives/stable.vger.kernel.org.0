Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2043E5FF322
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 19:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiJNRuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 13:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiJNRuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 13:50:13 -0400
Received: from usm.uni-muenchen.de (mxusm3.usm.uni-muenchen.de [IPv6:2001:4ca0:4101:0:81:bb:cc:cc])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E34147BA3
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 10:50:09 -0700 (PDT)
Received: from auth (localhost [127.0.0.1]) by usm.uni-muenchen.de (8.16.1/8.16.0.21) with ESMTPSA id 29EHo1sM022010
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 19:50:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=usm.lmu.de;
        s=default; t=1665769801;
        bh=V24OtiCU2m+nFjOY/Z9Z8G6qP5vZ/CoThOaG0XPSsFY=;
        h=Date:From:To:Subject;
        b=F2BBPTP99NevLqNu2WpSI07DUuorhlyUJ1gOHB9RiVmfZthNlXhNIYkC4Cb16ttbr
         1vmmDKxprkD86DxSw5O2mgUIztWrgJdjJnVydmrdNOObdxsiFevowPb4fOEP3CHoMT
         Uheb0bBxZHrOtljYe4hmVHWYBX0LJQtPe9NOdyQs=
Received: from [2606:54c0:1e40:b0::1d8:1c6] ([2606:54c0:1e40:b0::1d8:1c6])
 by www.usm.uni-muenchen.de (Horde Framework) with HTTPS; Fri, 14 Oct 2022
 17:49:21 +0000
Date:   Fri, 14 Oct 2022 17:49:21 +0000
Message-ID: <20221014174921.Horde.Sode83dfrecpOpnn8Z6gguY@www.usm.uni-muenchen.de>
From:   rug@usm.lmu.de
To:     stable@vger.kernel.org
Subject: Infiniband problem
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (usm.uni-muenchen.de [129.187.204.73]); Fri, 14 Oct 2022 19:50:01 +0200 (MEST)
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi to whom it may concern,

We are getting on a 6.0.0 (and also on 5.10 up) the following Mellanox  
infiniband problem (see below).
Can you please help (this is on a running ia64 cluster).

Regards,

Rudi Gabler

[   31.915749] Unable to handle kernel NULL pointer dereference  
(address 0000000000000010)
[   31.915749] kworker/u17:0[44]: Oops 11012296146944 [1]
[   31.915749] Modules linked in: af_packet ib_iser libiscsi  
scsi_transport_iscsi nf_tables nfnetlink rpcrdma sunrpc ib_ipoib tg3  
libphy ib_mthca fuse configfs dm_round_robin qla2xxx firmware_class  
dm_mirror dm_region_hash dm_log dm_multipath efivarfs

[   31.915749] CPU: 0 PID: 44 Comm: kworker/u17:0 Not tainted  
6.0.0-gentoo-ia64 #5
[   31.915749] Hardware name: hp server BL860c                   ,  
BIOS 04.32                                                             
05/21/2013
[   31.915749] Workqueue: ib-comp-unb-wq ib_cq_poll_work
[   31.915749] psr : 0000121008522030 ifs : 8000000000000ca1 ip  :  
[<a00000020036ba21>]    Not tainted (6.0.0-gentoo-ia64)
[   31.915749] ip is at mthca_poll_cq+0xc41/0x1620 [ib_mthca]
[   31.915749] unat: 0000000000000000 pfs : 0000000000000ca1 rsc :  
0000000000000003
[   31.915749] rnat: 0000000000000000 bsps: 0000000000000000 pr  :  
0000000000015555
[   31.915749] ldrs: 0000000000000000 ccv : 0000000000000000 fpsr:  
0009804c8a70433f
[   31.915749] csd : 0000000000000000 ssd : 0000000000000000
[   31.915749] b0  : a00000020036b290 b6  : a00000020036ade0 b7  :  
a00000010000bce0
[   31.915749] f6  : 1003ee000000106bf1c50 f7  : 1003e61c8864680b583eb
[   31.915749] f8  : 1003e73ad788c017bed70 f9  : 1003e0000000000015ab9
[   31.915749] f10 : 1003e000000000000b76a f11 : 1003e0000000000000000
[   31.915749] r1  : a00000020037b480 r2  : 0000000000000000 r3  :  
00000000000000d0
[   31.915749] r8  : e000000107d85100 r9  : 0000000000000000 r10 :  
0000000000000000
[   31.915749] r11 : 0000000000000000 r12 : e000000100507d40 r13 :  
e000000100500000
[   31.915749] r14 : e000000100ce9e00 r15 : 0000000000000000 r16 :  
0000000000000010
[   31.915749] r17 : 0000000000040000 r18 : 8080808080808080 r19 :  
e00000010012cb74
[   31.915749] r20 : 000000000000012c r21 : 73ad788c017bed70 r22 :  
0000040000000000
[   31.915749] r23 : e000000106bd4c10 r24 : 0000000000010000 r25 :  
000000000000ffff
[   31.915749] r26 : 0000000000000400 r27 : e00000010786b018 r28 :  
e000000107d85148
[   31.915749] r29 : e000000107d852f0 r30 : 0000000400000000 r31 :  
e000000107d85314
[   31.915749]
                Call Trace:
[   31.915749]  [<a000000100013170>] show_stack.part.0+0x30/0x50
                                                sp=e000000100507990  
bsp=e000000100501430
[   31.915749]  [<a000000100013720>] show_stack+0x30/0xa0
                                                sp=e000000100507990  
bsp=e000000100501400
[   31.915749]  [<a000000100014110>] show_regs+0x980/0x990
                                               sp=e000000100507b60  
bsp=e0000001005013a8
[   31.915749]  [<a000000100022340>] die+0x180/0x2e0
                                                sp=e000000100507b60  
bsp=e000000100501360
[   31.915749]  [<a000000100045a90>] ia64_do_page_fault+0x850/0xa20
                                                sp=e000000100507b60  
bsp=e0000001005012d8
[   31.915749]  [<a00000010000c4c0>] ia64_leave_kernel+0x0/0x270
                                                sp=e000000100507b70  
bsp=e0000001005012d8
[   31.915749]  [<a00000020036ba20>] mthca_poll_cq+0xc40/0x1620 [ib_mthca]
                                                sp=e000000100507d40  
bsp=e0000001005011c8
[   31.915749]  [<a000000100ad0f30>] __ib_process_cq+0xc0/0x210
                                                sp=e000000100507e30  
bsp=e000000100501150
[   31.915749]  [<a000000100ad1430>] ib_cq_poll_work+0x40/0x100
                                                sp=e000000100507e30  
bsp=e000000100501120
[   31.915749]  [<a000000100081820>] process_one_work+0x3b0/0x4c0
                                                sp=e000000100507e30  
bsp=e0000001005010a0
[   31.915749]  [<a000000100081f30>] worker_thread+0x580/0x670
                                               sp=e000000100507e30  
bsp=e000000100501008
[   31.915749]  [<a000000100090580>] kthread+0x1d0/0x1f0
                                                sp=e000000100507e30  
bsp=e000000100500fb8
[   31.915749]  [<a00000010000c2b0>] call_payload+0x50/0x80
                                                sp=e000000100507e30  
bsp=e000000100500fa0
[   31.915749] Disabling lock debugging due to kernel taint

