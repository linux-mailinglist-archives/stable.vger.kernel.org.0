Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31118591416
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 18:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbiHLQk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 12:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237759AbiHLQkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 12:40:53 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507FE1AF35
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 09:40:52 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso8792017pjf.5
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 09:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc;
        bh=I8jP91HSWqsiJOxltV4bzLv1lQgc2oaLk8W7m9K3HoU=;
        b=cpvZg8qjep16fuPFOMgIVCVZm4yOJwhnyoJ9GMdcbP4ncIfavxFRZH0Np1ph6ef7Nj
         C4GrzR7rR2KDYcHOmlLSvx723BT5vb0wF1I8wLFVDRy0W5e/zxbkf3MUylygXSBJcUck
         pybgrq9vhcYLpQoiDqpk57OOkoH2TronBgR899sHLKVuy38tGlT5qYfo491kKJFU/ph1
         A3mo9aTAa6xs7Pusgqa0TlZ4sCqtPjCSYDzWzqijNW1EcNNHo3LWwk4pk9i9d8bb7hH0
         3lWvc7FtQMCcLbRWDPpFj92FxWE/w0vehGo5s0XH1iDC1SAOUC4ZtJo0GKKHow0bIjSE
         fuGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc;
        bh=I8jP91HSWqsiJOxltV4bzLv1lQgc2oaLk8W7m9K3HoU=;
        b=BMYW1ktWya+DSiZZ9ovj9mQ9aHt1GgVZYz+7GAodmdmkOeEzDhuaTblXhcB8NaCLAZ
         +n+FkT8gB3iyW1O/N3ZUxiiFiCQ249QO9/zZh3vH1xWJA2bV8Pr8TprkdcnoaRDR2JCE
         qvLuOnb1zcBdFJTNaxx/Aq5+GsFdlmqDoG2o7oh0PVWdiXRS1bQSll0o+wwRzDpjvR/x
         ZuzESdkcqK2rCLaMdbmxnRiQHNOisP6C6Q8e1UlafB13V/5qzsYH7KbgYmkg66V5F5/N
         /eU0/mKR+Ku0BihcIoaZNjq78+TzIxd/yKkZomyXWscDyJq1jOIomUftpPGsXmisvJzv
         XCvg==
X-Gm-Message-State: ACgBeo38OFU/ALy2zWt88kV6AGOEklRepTbjVLcWj6UXoLKxqsL8PRqT
        /qK2RT7f/b5PPmyb2yUXXvXi9A==
X-Google-Smtp-Source: AA6agR7jpvw8OwTi3cm2CkefYKkcJTXRFwit+HJOAKynR1VETTIbGvYBcHk/A73AiiuILkGL0uPQSA==
X-Received: by 2002:a17:90b:180b:b0:1f5:50fd:15ac with SMTP id lw11-20020a17090b180b00b001f550fd15acmr5047389pjb.25.1660322451714;
        Fri, 12 Aug 2022 09:40:51 -0700 (PDT)
Received: from localhost ([50.221.140.186])
        by smtp.gmail.com with ESMTPSA id d23-20020a170902b71700b0016bdcb8fbcdsm1961573pls.47.2022.08.12.09.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 09:40:51 -0700 (PDT)
Date:   Fri, 12 Aug 2022 09:40:51 -0700 (PDT)
X-Google-Original-Date: Fri, 12 Aug 2022 09:40:47 PDT (-0700)
Subject:     Re: Apply f2928e224d85e7cc139009ab17cefdfec2df5d11 to 5.15 and 5.10?
In-Reply-To: <YvZzjmVDDyWzIUDb@kroah.com>
CC:     re@w6rz.net, nathan@kernel.org, sashal@kernel.org,
        dimitri.ledkov@canonical.com, anup@brainfault.org,
        stable@vger.kernel.org, linux-riscv@lists.infradead.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Message-ID: <mhng-f5bbfb9c-755f-4abe-affd-5c40efd11105@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 12 Aug 2022 08:36:46 PDT (-0700), Greg KH wrote:
> On Thu, Aug 11, 2022 at 08:23:21PM -0700, Ron Economos wrote:
>> On 8/11/22 5:24 PM, Nathan Chancellor wrote:
>> > Hi all,
>> >
>> > Would it be reasonable to apply commit f2928e224d85 ("riscv: set default
>> > pm_power_off to NULL") to 5.10 and 5.15? I see the following issue when
>> > testing OpenSUSE's RISC-V configuration in QEMU and it is resolved with
>> > that change.
>> >
>> > Requesting system poweroff
>> > [    4.497128][  T177] reboot: Power down
>> > [   32.045207][    C0] watchdog: BUG: soft lockup - CPU#0 stuck for 26s! [init:177]
>> > [   32.045785][    C0] Modules linked in:
>> > [   32.046166][    C0] CPU: 0 PID: 177 Comm: init Not tainted 5.15.60-default #1 5b276f06901b1c37142db73337a1816290810c90
>> > [   32.046814][    C0] Hardware name: riscv-virtio,qemu (DT)
>> > [   32.047256][    C0] epc : default_power_off+0x1a/0x20
>> > [   32.047667][    C0]  ra : machine_power_off+0x22/0x2a
>> > [   32.047979][    C0] epc : ffffffff80004a4a ra : ffffffff80004abe sp : ffffffd000bc3d50
>> > [   32.048405][    C0]  gp : ffffffff81bec160 tp : ffffffe002080000 t0 : ffffffff80490964
>> > [   32.048827][    C0]  t1 : 0720072007200720 t2 : 50203a746f6f6265 s0 : ffffffd000bc3d60
>> > [   32.049245][    C0]  s1 : 000000004321fedc a0 : 0000000000000004 a1 : ffffffff81b073c8
>> > [   32.049676][    C0]  a2 : 0000000000000010 a3 : 00000000000000ab a4 : e0b1d187e51c7400
>> > [   32.050115][    C0]  a5 : ffffffff80004a30 a6 : c0000000ffffdfff a7 : ffffffff804ea464
>> > [   32.050555][    C0]  s2 : 0000000000000000 s3 : ffffffff81a20390 s4 : fffffffffee1dead
>> > [   32.051009][    C0]  s5 : ffffffff81bee0c8 s6 : 0000003feff55a70 s7 : 0000002acc09bf08
>> > [   32.051427][    C0]  s8 : 0000000000000001 s9 : 0000000000000000 s10: 0000002b0a4db6e0
>> > [   32.051849][    C0]  s11: 0000000000000000 t3 : ffffffe001e2bf00 t4 : ffffffe001e2bf00
>> > [   32.052274][    C0]  t5 : ffffffe001e2b000 t6 : ffffffd000bc3ac8
>> > [   32.052604][    C0] status: 0000000000000120 badaddr: 0000000000000000 cause: 8000000000000005
>> > qemu-system-riscv64: terminating on signal 15 from pid 2356237 (timeout)
>> >
>> > I am not sure if there is any regression potential with that change,
>> > hence this email. That change applies cleanly to both trees and I don't
>> > see any additional problems from it.
>> >
>> > Cheers,
>> > Nathan
>>
>> Should be fine. I apply this patch to all of my 5.15.x stable builds to
>> enable warm reboot on the HiFive Unmatched.
>>
>
> Now queued up, thanks.

Thanks, though on a sort of related note: are folks actually running 
5.10-based kernels on RISC-V?  I generally don't worry too much about 
trying to backport stuff that far.
