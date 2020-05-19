Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C69D1D93D5
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 11:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgESJyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 05:54:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53440 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726055AbgESJyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 05:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589882039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cvIV3vDVu50EKGTE0ExyLYC7ZHTNf8xvglZAbmNlT5Y=;
        b=PP81f7VSIlCAIr0Eb7bSWucZmRPCt8JebU2TxSc5/dtdIWy5+X1NuLmrsmZnKJTZj8Jfd0
        PnGPCzUhrWyxWumFJDXehOjCIzWeX81r6aVYA1UOClQrJYr5t/+wpRXeIQTjNtjxryiI0d
        z06aJcVrgfj/xz1itOPY7yczKtm18QQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-DMiDLuzRPZKrrAHdrHZ71w-1; Tue, 19 May 2020 05:53:57 -0400
X-MC-Unique: DMiDLuzRPZKrrAHdrHZ71w-1
Received: by mail-wm1-f72.google.com with SMTP id f62so1200259wme.3
        for <stable@vger.kernel.org>; Tue, 19 May 2020 02:53:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cvIV3vDVu50EKGTE0ExyLYC7ZHTNf8xvglZAbmNlT5Y=;
        b=RaD0aLrzmqtOWyV15ztqFdxQLFr4f5F6VcHck99fiii3mlZz9NcaEjfyK039YXVvqI
         aFbVbrJ/TH/SAwvUbK49PSUTHwu3ckM3eGtvAu1nMZwEEe2j3AJ/Wa+L//EKs5IOJmcp
         Z7k0z/m3bgjxnrR6Qh7Vu3xjy70WvHbO/fIXYJ0uT7zMXJRwoo4H38hs65SKUSdj00kV
         5xUg1tPdQzQbEM0dVDKiSWXqEmb0NjuU1tIKBLcHntMBSMK+8ImLws2y21vGqbkElFEf
         XGE8z7pxpJRs7XUo/L7SWWG3Js41t3/3GJlbzcOWqvCpb1z5s5JKXY1U2aph520jHHDw
         InBg==
X-Gm-Message-State: AOAM533UJCqepy55kSlwvabim6WNt56SfUbJe6QjCurDavVWU1BrlHPm
        U0DzOqZsPSpISvhaFodCAfAV+3UjMVuBEpBylLAqr4iA9UGgpUOu27Cs+6YIrPrPMCQ0LNoDZDm
        Mh3pFIODYLVm9xjhv
X-Received: by 2002:adf:ea05:: with SMTP id q5mr23831810wrm.87.1589882036375;
        Tue, 19 May 2020 02:53:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQZexH2awQR/JGxRqWJdTlOnIoY3uS/b6HAro+cSKrJ0KaZSBOBeiBduWW771hfut6Adhj0A==
X-Received: by 2002:adf:ea05:: with SMTP id q5mr23831784wrm.87.1589882036120;
        Tue, 19 May 2020 02:53:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:80b4:c788:c2c5:81c2? ([2001:b07:6468:f312:80b4:c788:c2c5:81c2])
        by smtp.gmail.com with ESMTPSA id w9sm22400141wrc.27.2020.05.19.02.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 02:53:55 -0700 (PDT)
Subject: Re: [RHEL 8.3 BZ 1768622 PATCH 3/3] KVM: x86: use raw clock values
 consistently
To:     Greg KH <gregkh@linuxfoundation.org>,
        Frantisek Hrbata <fhrbata@redhat.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, rhkernel-list@redhat.com,
        Andrew Jones <drjones@redhat.com>, stable@vger.kernel.org,
        Bandan Das <bsd@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200518191516.165550666@fuller.cnet>
 <20200518191759.624834612@fuller.cnet>
 <20200519085852.GE20516@localhost.localdomain>
 <20200519091822.GA4143612@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7955c2f9-bbed-4c29-3d94-40703438dd5c@redhat.com>
Date:   Tue, 19 May 2020 11:53:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200519091822.GA4143612@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/05/20 11:18, Greg KH wrote:
> Gotta love private git repo discussions on a public mailing list :)

Somebody has forgotten their suppresscc=all.

Paolo

