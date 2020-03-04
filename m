Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8070E178CB7
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 09:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgCDInY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 03:43:24 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29795 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728319AbgCDInY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 03:43:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583311403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hce8JDdzVVDYBPGMxiJcDplsUovwlLc6eEvZfAZBcYY=;
        b=PP0s/RBI6fM9sMfqOfBrT4CgzgMpIwQrx7StD2uWxrPC9lfW8sE3Brr052P5NeS6kQrJsO
        QtdU71Sy1LvxLvkIYqjhYF4ax1NGktA9xQyOKW98fDoLGGdHAJn3BGLXY+/pF7gRVxsSWq
        o8phN1g9HPy0AXDWW6JDlVRymBWNNsk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-zt7nf1T2NxS7gjI0syZn9Q-1; Wed, 04 Mar 2020 03:43:22 -0500
X-MC-Unique: zt7nf1T2NxS7gjI0syZn9Q-1
Received: by mail-wr1-f70.google.com with SMTP id m13so564528wrw.3
        for <stable@vger.kernel.org>; Wed, 04 Mar 2020 00:43:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hce8JDdzVVDYBPGMxiJcDplsUovwlLc6eEvZfAZBcYY=;
        b=rdZNgejObEnVoM9V+K+GrA4Jj+SFTST/ksOlamP8EJRoomCXHJI40l8nKXWOPEIUGa
         oEDRVxEpSe6hMB4H9Y8BAjWuzKYdxmW76d0eYbZvrTnMDjwCsOk/YWBFgcQuSItM4cmp
         Ji/KVRAeZTc6ymxOyofFe9Y67Fx/F/F+V6APpBWs1P3s89BLK6MDyI1tpiYLgDGPuvNX
         5gueMsX7Vq2qt/IOwd3H7clJOJW5KzOQIxkLSA61q4tOdh6JHuCQ0ySBUueRz7VvrJDX
         etULRXo3aVIKoptC4HYbB4/DbIu+WaGyZ2dGizTrO+Y9UNLLgeo2RvyIyGsqEHhclkSY
         nqhw==
X-Gm-Message-State: ANhLgQ0VoV5RwZUPyjYuu0l7Kc7jiP7c4fyl+5elomDSh0LHEY7HwZ+1
        x/Nw1VVd/oF4cscqtaH+uMCowB3Opiltez5ZLPAjeuGzLybN8CKz7JCPU9MwpQwRDVcrMuxvYJB
        g3H8hyxpGzlAhEtrF
X-Received: by 2002:a05:6000:4b:: with SMTP id k11mr2908840wrx.362.1583311400827;
        Wed, 04 Mar 2020 00:43:20 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsIWAgYkF08JKNQU4lP4nFriej3ZoonWY+vx3f4wg2xML2eU/w1demead39U0sY7ItwcyunMQ==
X-Received: by 2002:a05:6000:4b:: with SMTP id k11mr2908812wrx.362.1583311400545;
        Wed, 04 Mar 2020 00:43:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id k63sm3042895wme.43.2020.03.04.00.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 00:43:20 -0800 (PST)
Subject: Re: [PATCH 5.5 111/176] KVM: nVMX: Emulate MTF when performing
 instruction emulation
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Oliver Upton <oupton@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
References: <20200303174304.593872177@linuxfoundation.org>
 <20200303174317.670749078@linuxfoundation.org>
 <8780cf08-374b-da06-0047-0fe8eeec0113@redhat.com>
 <CAOQ_QsjG32KrG6hVMaMenUYk1+Z+jhcCsGOk=t9i+-9oZRGWeA@mail.gmail.com>
 <20200304081001.GB1401372@kroah.com>
 <04e51276-1759-2793-3b45-168284cbaf67@redhat.com>
 <20200304082613.GA1407851@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cf7c6b2d-64eb-8d13-3e9a-09c40d2ecf95@redhat.com>
Date:   Wed, 4 Mar 2020 09:43:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304082613.GA1407851@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/03/20 09:26, Greg Kroah-Hartman wrote:
> On Wed, Mar 04, 2020 at 09:19:09AM +0100, Paolo Bonzini wrote:
>> On 04/03/20 09:10, Greg Kroah-Hartman wrote:
>>> I'll be glad to just put KVM into the "never apply any patches to
>>> stable unless you explicitly mark it as such", but the sad fact is that
>>> many recent KVM fixes for reported CVEs never had any "Cc: stable@vger"
>>> markings.
>>
>> Hmm, I did miss it in 433f4ba1904100da65a311033f17a9bf586b287e and
>> acff78477b9b4f26ecdf65733a4ed77fe837e9dc, but that's going back to
>> August 2018, so I can do better but it's not too shabby a record. :)
> 
> 35a571346a94 ("KVM: nVMX: Check IO instruction VM-exit conditions")
> e71237d3ff1a ("KVM: nVMX: Refactor IO bitmap checks into helper function")
> 
> Were both from a few weeks ago and needed to resolve CVE-2020-2732 :(

No, they weren't, only the patch that was CCed stable was needed to
resolve the CVE.

Remember that at this point a lot of bugfixes or vulnerabilities in KVM
exploit corner cases of the architecture and don't show up with the
usual guests (Linux, Windows, BSDs).  Since we didn't have full
information on the impact on guests that people do run, we started with
the bare minimum (the two patches above) but only for 5.6.  The idea was
to collect follow-up patches for 2-4 weeks, decide which subset was
stable-worthy, and only then post them as stable backport subsets.

Paolo

