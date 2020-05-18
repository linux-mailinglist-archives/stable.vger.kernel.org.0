Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD841D87C7
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 21:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgERTDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 15:03:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42170 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726367AbgERTDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 15:03:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589828581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dB0Qo+JNBG9WYUkCFvlpzWBybhEjTR6hXldc9GYGyjI=;
        b=c7195JtGaCW/It0FBpK9bffyCddUlFTAMGDpin5QegwNN/KDVG1lnOiwIxPCbf3G46EGkh
        bqki8hy9ATDPxvNOSGY+mj1siEN24JlChH5IXLdBFtLEOHNAbTe6tZJopoxsCXHDYtlJD+
        BNjcgtqjYOMDWEoIOAWBK3El4Et7JN8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-JrONENMqNfWFcekT2AF8fQ-1; Mon, 18 May 2020 15:01:37 -0400
X-MC-Unique: JrONENMqNfWFcekT2AF8fQ-1
Received: by mail-wr1-f71.google.com with SMTP id e14so6053343wrv.11
        for <stable@vger.kernel.org>; Mon, 18 May 2020 12:01:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dB0Qo+JNBG9WYUkCFvlpzWBybhEjTR6hXldc9GYGyjI=;
        b=Zhk1lxsQ8PjYq0AdGshogX6b/OFXhXBDzmfFQFIuyO+UVmypR2mlbx7D9kPl+EwJjI
         smqnm/O1D7e9+4Ep1+IMi1QJBzgmf3LLIS8sFszP5bkj2NUj9Lhj62OqQWQE4b49H8cd
         R+0ypwIXWPn7b3yw/QdSCOo+/7bAB2QOAZWIHqUaDKq4V56Vsp0Aa9o17mNDIXOPI9mA
         cM019FKmVG0RUy4AQtPM2Ah6Uun1lq3QoJ5L1gvEirQfj2wGyZODhKRYJD5of1POWyd5
         UHX8DkkZmBXy+3LNqrBvCmumFkBMN8tUE2xeo7G6byw+PxBuOzr2Z+Pyo7SDXw20aCpQ
         /gnw==
X-Gm-Message-State: AOAM5321G4YF6LowfVz1MKY5pDGgnRzabhsCRL2IOaX6wm6fVqfbUi+d
        Y9Oaa+XcTZZo5n1SITUYzBusSzUeiQgvnmOfAZvsWALhhxtjDCTA82nqvKK9GgPLOWVQp9lGz8f
        zyn9VUIYyAqiQNeLW
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr21528272wrn.356.1589828496591;
        Mon, 18 May 2020 12:01:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWXn5iCQ7ZCr9JdLyAg/9GiqyqKy5Iy2POGW8ZKKcQWYZrFcemvQuudg0bOhgWfeBwbXnX7w==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr21528249wrn.356.1589828496364;
        Mon, 18 May 2020 12:01:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:80b4:c788:c2c5:81c2? ([2001:b07:6468:f312:80b4:c788:c2c5:81c2])
        by smtp.gmail.com with ESMTPSA id o15sm13761448wrw.65.2020.05.18.12.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 12:01:35 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] KVM: x86: Fix pkru save/restore when guest
 CR4.PKE=0, move it" failed to apply to 5.4-stable tree
To:     Babu Moger <babu.moger@amd.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jmattson@google.com" <jmattson@google.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <158980917424929@kroah.com>
 <12fc0ba0-dc72-11cb-5e9f-e34a7c561bf3@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3e21cd7a-43bf-12b3-cabb-e086b9743f1f@redhat.com>
Date:   Mon, 18 May 2020 21:01:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <12fc0ba0-dc72-11cb-5e9f-e34a7c561bf3@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/05/20 16:46, Babu Moger wrote:
> Jim, Paolo,
> Do you guys want me to take care of this? Let me know.
> Thanks
> Babu

That would be great, thanks.

Paolo

