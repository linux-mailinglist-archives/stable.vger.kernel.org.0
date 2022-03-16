Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6464DB586
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 17:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240477AbiCPQBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 12:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237312AbiCPQBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 12:01:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D493F46640
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647446436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fpm1syxt/668a84vrAP57Sr17b94ynmh10cvSiUgK9Q=;
        b=L/CFSx4HyNpnxT0ci68eG1XP6fU/2si17A++fQ5XtDofu8nEll0hzHNA7Y77esFVROcSuG
        SLGvM5dYWxjV6W022lK8ynYykpdOnyyAeylA5BSjWFMMUvwPVwleiu5IGPIlUXrx1Aw/9Q
        EI7OYjsXl8llSY3JPXwwrncEKOpqMCs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-pgbFC8rtMgyfHxretRn76w-1; Wed, 16 Mar 2022 12:00:33 -0400
X-MC-Unique: pgbFC8rtMgyfHxretRn76w-1
Received: by mail-ed1-f70.google.com with SMTP id cf6-20020a0564020b8600b00415e9b35c81so1563700edb.9
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:00:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fpm1syxt/668a84vrAP57Sr17b94ynmh10cvSiUgK9Q=;
        b=f5eXBnpXx8qbYLqR1I9q4bkgXKph5zL1xxPsHr+k31N+sNNsLDadKKLmWJTryOoy5T
         eIKZAZG7k1Wl1T2Q0qSX6O471wyMWsxxrJLHP/Is5/1iaKwwR2lCPWQvh2yCMC/NCfII
         N0lWfaO/IsU1rm6/+u83aQPc9f5H0CpylCp62xiWY2x/ga0GtW03wr4RMADk39gW4taD
         6Lr5hTYkaQdlFklxeiEWXAanYOWOpWLJvE6Lrftc4MscnMn5Wb0mD5VgGVV5nev+aYY6
         NXa2F6GN910m1UOWkQQ0ziiRPnXNhSvYgc2wx08l4LlmwhCQwyHz+SZPxAwFnYiOLlxU
         BMdA==
X-Gm-Message-State: AOAM533z7WZQLyvX/dl9JKt+dJn7DipSNZD52hFkaRJMlqVVSzHO2/NM
        8UBrPhGGXXivgtGdxDIA6P5Q3SDpH13MPv5t9jvxcG7ikXXGfoKlz1LXYbD9Flbv1TyN7pI6qSA
        KlOF6CZOzcGOOfg1q
X-Received: by 2002:a17:907:7f23:b0:6de:6ac2:93c with SMTP id qf35-20020a1709077f2300b006de6ac2093cmr575150ejc.462.1647446432001;
        Wed, 16 Mar 2022 09:00:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlB7LYYCh9S/mTWzBMqQ7g5VxJEALZHNJjeZJne97yd3oQfZ+UdtxkWSZrNaP55HxNrbBWUw==
X-Received: by 2002:a17:907:7f23:b0:6de:6ac2:93c with SMTP id qf35-20020a1709077f2300b006de6ac2093cmr575116ejc.462.1647446431725;
        Wed, 16 Mar 2022 09:00:31 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:cdb2:2781:c55:5db0? (2001-1c00-0c1e-bf00-cdb2-2781-0c55-5db0.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:cdb2:2781:c55:5db0])
        by smtp.gmail.com with ESMTPSA id h30-20020a056402095e00b00412b81dd96esm1173739edz.29.2022.03.16.09.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 09:00:31 -0700 (PDT)
Message-ID: <b559b406-006e-05e6-6378-4665ff721666@redhat.com>
Date:   Wed, 16 Mar 2022 17:00:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
Content-Language: en-US
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
References: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
 <CAJZ5v0hQifvD+U8q1O7p_5QeicG_On4=CrgNj0RsbPSbkY8Hww@mail.gmail.com>
 <ad3b77f8-7e75-1dfa-8ee4-1077336911aa@redhat.com>
 <CAJZ5v0js8Vr7dW09WGyR_JTn4kMybDhaTWt4yziqwSM+oAXUNA@mail.gmail.com>
 <CAJZ5v0imJfOp-Uw=tH2dimSQzb-EgHu_yEU_0LScmrQ43t3pbw@mail.gmail.com>
 <c9a1adb5-17b7-c7ed-d23f-6b6523a4771a@redhat.com>
 <CAJZ5v0gB2ZCWe3MeGnw6_CNu_Ds0QEPZ6X6jnA7dQbZe6gKZ8w@mail.gmail.com>
 <5fb0cbe8-5f9d-1c75-ae0a-5909624189d3@redhat.com>
 <ce781d92-f269-aaf5-1733-25de85f05b7b@amd.com>
 <CAJZ5v0irKgmSQ7YegP=US1ACUfqVMCNitu2azMbMAqm2f+cXTg@mail.gmail.com>
 <BL1PR12MB51572AA41E116C59FE0D5698E2119@BL1PR12MB5157.namprd12.prod.outlook.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <BL1PR12MB51572AA41E116C59FE0D5698E2119@BL1PR12MB5157.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/16/22 14:37, Limonciello, Mario wrote:
> [Public]
> 
>>> Just FWIW this fix that was backported to stable also fixed keyboard
>>> wakeup from s2idle on a number of HP laptops too.  I know for sure that
>>> it fixed it on the AMD versions of them, and Kai Heng Feng suspected it
>>> will also fix it for the Intel versions.  So if there is another commit
>>> that can be backported from 5.17 to make it safer for the other systems,
>>> I think we should consider doing that to solve it too.
>>
>> There is a series of ACPI EC driver commits that are present in
>> 5.17-rc, but have not been included in any "stable" series:
>>
>> befd9b5b0c62 ACPI: EC: Relocate acpi_ec_create_query() and drop
>> acpi_ec_delete_query()
>> c33676aa4824 ACPI: EC: Make the event work state machine visible
>> c793570d8725 ACPI: EC: Avoid queuing unnecessary work in
>> acpi_ec_submit_event()
>> eafe7509ab8c ACPI: EC: Rename three functions
>> a105acd7e384 ACPI: EC: Simplify locking in acpi_ec_event_handler()
>> 388fb77dcf97 ACPI: EC: Rearrange the loop in acpi_ec_event_handler()
>> 98d364509d77 ACPI: EC: Fold acpi_ec_check_event() into
>> acpi_ec_event_handler()
>> 1f2350443dd2 ACPI: EC: Pass one argument to acpi_ec_query()
>> ca8283dcd933 ACPI: EC: Call advance_transaction() from
>> acpi_ec_dispatch_gpe()
>>
>> It is likely that they prevent the problem exposed by the problematic
>> commit from occurring, but I'm not sure which ones do that.  Some of
>> them are clearly cosmetic, but the ordering matters.
> 
> Hans,
> 
> Do you think you could get one of the folks who reported this regression to do
> a bisect to see which one "fixed" it?

We already know which commit is causing the regression. As Rafael already
said the question is why things are not broken in 5.17 and that is not
a straight forward bisect. So figuring this out is going to be a lot
of work and I'm not sure of that it is worth it. I certainly don't
have time to help users with debugging this.

> If we get lucky we can come down to
> some smaller hunks of code that can come back to stable instead of reverting.

5.17 is almost done and in a couple of weeks Fedora (and Arch and other
distros tracking the mainline kernel) will move to 5.17 resolving the
wakeup by keyboard issue not working there.

5.16 is not a LTS kernel, so for other distros we would at a minimum
figure out what needs to be backported to make things work with 5.15
making the delta / set of possible patches we need even bigger.
So as already said IMHO this is not worth it, at least assuming that
nothing bad happens when attempting wakeup by keyboard, iow it
just does not work and does not put the laptop in some bad state?

Regards,

Hans

