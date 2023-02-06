Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873C268C50C
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 18:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjBFRpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 12:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjBFRpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 12:45:54 -0500
Received: from bird.elm.relay.mailchannels.net (bird.elm.relay.mailchannels.net [23.83.212.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0CD2B2A8;
        Mon,  6 Feb 2023 09:45:41 -0800 (PST)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 8C10C7E153D;
        Mon,  6 Feb 2023 17:45:40 +0000 (UTC)
Received: from pdx1-sub0-mail-a221.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 0B9807E1BEB;
        Mon,  6 Feb 2023 17:45:40 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1675705540; a=rsa-sha256;
        cv=none;
        b=AHtYt9eUWyhODzXYwuV3PQOLHr1s+09m1S3W9O97t1j25yxzpX4YTpKmQEEbzBxITidfir
        Jg8M0fSGCiumRNk8QhciK3LrTZsOL4mx+7VTGMFcKL/NeQ8QYdkNLtXSEpTE/lUFU2xSV+
        hJKn81nfLKOhyNbxKZeGrBDuyQ5+l9vdnnEila/B+JNJKwFb/SdpqB4Wl+hRqfmSV7ZYAS
        yHU13jKHDUAjB9e5WD0IPiP34IFhA5R3OoAnBEdEMC4Ik3QO0al5gI+DF6zfw+HfA/BFmE
        bB/mpKkrd9MU+CfoXn7NWguMhcfdabE1OYzxVXYBCZPQVUp1sb23SxCQdCdseA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1675705540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=3RUNAXgDE0f/nNzbflUV5Av58uCfCjLXusvt31cTdrs=;
        b=lR2UwC/NwDHiWiJZnwKH2XopLuyRfnXiB74NKLhkLtgEWwSs4J6HM50fzt0Maf9sXvPNTE
        abwEWAj99wF/2m83UuAeCFxGxIPiZZaio0xNHclH17Wu1lt3EeXBk5jYkCJKQ7zpMmFmyE
        qIMufLSUdd1uDejOWivyVNyHSYbzcqZH80HaXvbcC/idOUU9zRZYX49uslVc0HUnZ2em8J
        x4W4PiNsWdr11qsCfRSlLT/Q7rfrNoPMW+AHAvamZv/BoPUlPqgkTXFGucNwog998QHr5o
        4NlY9xvqt8pqXspE8jMEYNMP/rqiyc+xqp70uimbkTJ5XyyVmEXyUg5JKyflIA==
ARC-Authentication-Results: i=1;
        rspamd-5fb8f68d88-vqvfk;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Left-Stretch: 637568a91d17b01c_1675705540379_1488037364
X-MC-Loop-Signature: 1675705540379:3862434003
X-MC-Ingress-Time: 1675705540379
Received: from pdx1-sub0-mail-a221.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.99.229.28 (trex/6.7.1);
        Mon, 06 Feb 2023 17:45:40 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a221.dreamhost.com (Postfix) with ESMTPSA id 4P9YZV6pWKz9t;
        Mon,  6 Feb 2023 09:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1675705539;
        bh=3RUNAXgDE0f/nNzbflUV5Av58uCfCjLXusvt31cTdrs=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=lkeL1n+OXLg2qI5yCtNhW4g+KfM4mm1JAbQ0etfFeY3E3oWAgamWc8cZA3AjTIZ5f
         i7yA3/x50s4lZSQWRUO2+KpD+/colHn4EhgkdknTVbTprtlOZJa84nVYB+2u6caBh4
         83esFO8jaNgIx3+bgKudk1SVjSWMO5hDRAa+6XOqplhILzmIguikBo4Q2CiobYtcbM
         fH3eQ9YpGWt2KQPk4p51VhotmWhYzBfUB6DxoziUdhGGwTErF0SCULEt4R9PCL7pyK
         XcHXdh5wBDYAf7FIWO5yjKQhZXEmsbnpItdISXIrI+ZwxiuyPQmYSr6cYbdjV7Cmnz
         +meMv/DFpL+Mw==
Date:   Mon, 6 Feb 2023 09:18:12 -0800
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Gregory Price <gregory.price@memverge.com>,
        linux-cxl@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <20230206171812.2kra5mqrqk26f6mf@offworld>
Mail-Followup-To: Dan Williams <dan.j.williams@intel.com>,
        Gregory Price <gregory.price@memverge.com>,
        linux-cxl@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
 <Y+CRyz0eFKfERZLD@memverge.com>
 <63e13907cffb9_ea22229458@dwillia2-xfh.jf.intel.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <63e13907cffb9_ea22229458@dwillia2-xfh.jf.intel.com.notmuch>
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 06 Feb 2023, Dan Williams wrote:

>Gregory Price wrote:
>[..]
>> Leverage the same QEMU branch, machine, and configuration as my prior
>> tests, i'm now experiencing a kernel panic on boot.  Will debug a bit
>> in the morning, but here is the stack trace i'm seeing
>>
>> Saw this in both 1 and 2 root port configurations
>>
>> (note: I also have the region reset issue previously discussed on top of
>> your branch).
>>
>> QEMU configuration:
>>
>> sudo /opt/qemu-cxl/bin/qemu-system-x86_64 \
>> -drive file=/var/lib/libvirt/images/cxl.qcow2,format=qcow2,index=0,media=disk,id=hd \
>> -m 2G,slots=4,maxmem=4G \
>> -smp 4 \
>> -machine type=q35,accel=kvm,cxl=on \
>> -enable-kvm \
>> -nographic \
>> -device pxb-cxl,id=cxl.0,bus=pcie.0,bus_nr=52 \
>> -device cxl-rp,id=rp0,bus=cxl.0,chassis=0,port=0,slot=0 \
>> -object memory-backend-file,id=mem0,mem-path=/tmp/mem0,size=1G,share=true \
>> -device cxl-type3,bus=rp0,volatile-memdev=mem0,id=cxl-mem0 \
>> -M cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.size=1G
>>
>[..]
>> [   15.162837] RIP: 0010:bus_add_device+0x5b/0x150
>
>I suspect cxl_bus_type is not intialized yet. I think this should
>address it:

Yep, thanks.

>
>diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
>index 0faeb1ffc212..6fe00702327f 100644
>--- a/drivers/cxl/core/port.c
>+++ b/drivers/cxl/core/port.c
>@@ -2011,6 +2011,6 @@ static void cxl_core_exit(void)
>	debugfs_remove_recursive(cxl_debugfs);
> }
>
>-module_init(cxl_core_init);
>+subsys_initcall(cxl_core_init);
> module_exit(cxl_core_exit);
> MODULE_LICENSE("GPL v2");
