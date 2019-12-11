Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C63AC11C0C9
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 00:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfLKXtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 18:49:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48260 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727024AbfLKXtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 18:49:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576108188;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=eZ6Qbamhyp6RLhy20TpwKVCBIKcGB4S+juUY4aaY00E=;
        b=RzZxNYP374suPIvn1VvvPJJvBXLnvXgLBHsO3TQMV4uJSFD+FnCrG158WKyEfTqTS71ktH
        tDRUKyotfb4yAjFmOFSmaGSpkbO+F1C8Nwmg8RPRJd+BNF6nEqKBiObUq7/WyPNkRcz3jT
        AYV5estexCTN1IlPuCiOZRp/BqRk+zk=
Received: from mail-yw1-f69.google.com (mail-yw1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-ynOrBxsnNbeXO2ROaWBGWA-1; Wed, 11 Dec 2019 18:49:47 -0500
X-MC-Unique: ynOrBxsnNbeXO2ROaWBGWA-1
Received: by mail-yw1-f69.google.com with SMTP id i70so506972ywe.23
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 15:49:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=eZ6Qbamhyp6RLhy20TpwKVCBIKcGB4S+juUY4aaY00E=;
        b=swDWvpKilPR5IcceYN5W9h0FrP40pYMMjP9XnZTdGPxK2M9rfjznKyF3XAUC+XubeC
         9molqsfl0lL3y9mBGTxEODzNBAkPQRpSWMQDM2NhSyWqRTH3wQPSY+/Mlld6i/Uzah37
         q1bgdcIibW2l1CJIZMvWoU+G7TNu0bUHFXbrdJ/zRNm7/CCZ35akAXIXDLYDOrC7xAh5
         TWe4mu7vu6oWM7uEauR0Tc2tORd4b+6ytC0Zjep8lYpT5BNmHqttHd2oynd/8qgbDWbN
         3ED045k5YVqxyZ1emR/Eb56YLEn3ij/1IQcKnYbRKDSjA/18qNbxd1kAzNtPpYKqfd5t
         Au6g==
X-Gm-Message-State: APjAAAXz81XajrC/63rxZffQVYMpy1lwR1Xl+zbjC0ORjdXEymKrcMh/
        AtOBsLTW5NJwleC5Ak+YKYO09gkhpjMvZbTddT8UWPXbUFDy5AU4jyRXIgQC2ZbqpnfcMBFAX2Q
        mXgbJVjnxaUwELfvf
X-Received: by 2002:a25:4192:: with SMTP id o140mr2186049yba.70.1576108187112;
        Wed, 11 Dec 2019 15:49:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqxLClP3vQPgqPh+Fd3ZVpB9+8LETd8k7MLAJik00X30raCPVWSm3eDeNxxwc6b60J3biJil5w==
X-Received: by 2002:a25:4192:: with SMTP id o140mr2186040yba.70.1576108186854;
        Wed, 11 Dec 2019 15:49:46 -0800 (PST)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id x184sm1816777ywg.4.2019.12.11.15.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 15:49:46 -0800 (PST)
Date:   Wed, 11 Dec 2019 16:49:29 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
Subject: Re: [PATCH] tpm_tis: reserve chip for duration of tpm_tis_core_init
Message-ID: <20191211234929.in7mrh3wq4pkhvsm@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mail-Followup-To: Dan Williams <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Bundy <christianbundy@fraction.io>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
References: <20191211231758.22263-1-jsnitsel@redhat.com>
 <20191211232612.miaizaxxikhlgvfj@cantor>
 <CAPcyv4iwJoX6tVVBUc0dSwHUwsu2duoUFayOnAhDEd5SjYug8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <CAPcyv4iwJoX6tVVBUc0dSwHUwsu2duoUFayOnAhDEd5SjYug8g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed Dec 11 19, Dan Williams wrote:
>On Wed, Dec 11, 2019 at 3:27 PM Jerry Snitselaar <jsnitsel@redhat.com> wrote:
>>
>> On Wed Dec 11 19, Jerry Snitselaar wrote:
>> >Instead of repeatedly calling tpm_chip_start/tpm_chip_stop when
>> >issuing commands to the tpm during initialization, just reserve the
>> >chip after wait_startup, and release it when we are ready to call
>> >tpm_chip_register.
>> >
>> >Cc: Christian Bundy <christianbundy@fraction.io>
>> >Cc: Dan Williams <dan.j.williams@intel.com>
>> >Cc: Peter Huewe <peterhuewe@gmx.de>
>> >Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> >Cc: Jason Gunthorpe <jgg@ziepe.ca>
>> >Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>
>> >Cc: stable@vger.kernel.org
>> >Cc: linux-intergrity@vger.kernel.org
>>
>> Typo on the list address, do you want me to resend Jarkko?
>>
>> >Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
>> >Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
>> >---
>>
>> I did some initial testing with both a 1.2 device and a 2.0 device here.
>> Christian, can you verify that this still solves your timeouts problem
>> you were seeing? Dan, can you try this on the internal system with
>> the interrupt issues? I will see if I can get the t490s owner to run
>> it as well.
>
>Will do. I assume you'd also want to add 'Fixes: 5b359c7c4372
>("tpm_tis_core: Turn on the TPM before probing IRQ's")' if it works?
>

Yes. I'm not certain this deals with the interrupt issue though, so
didn't want to stick it on there yet. I guess it should go on there
anyways since it is replacing that code. I'll post a v2.

