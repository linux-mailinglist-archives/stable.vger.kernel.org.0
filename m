Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E4D11515C
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 14:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfLFNvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 08:51:53 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21118 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfLFNvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 08:51:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575640311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3cPjTncpDFw41fx9F5xYvf+N54ckom4KcOA71nUG8Pg=;
        b=Aao+uZzdx1GePeoNLiQYMkFhoyiFL6vjKUHlq81YY/CFY535e8liFUEJSbkzXdXUiISrHi
        4M3/++NIxCWjmLBdDCbN4/y0G0yd4yK2Sa6JQbGrtFPFsabL6nMviNSCED0T/yvfZAdQ9X
        iD+/w9W+FFEOX7dbAKxva8kLU4jU0Yk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-yYYx37AnMIqwoh4u5a545A-1; Fri, 06 Dec 2019 08:51:50 -0500
Received: by mail-wr1-f70.google.com with SMTP id b2so3197571wrj.9
        for <stable@vger.kernel.org>; Fri, 06 Dec 2019 05:51:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hBPfAz5d6cicO7lOtm3rsxxZRjo5sqJZor8zQVBqKpc=;
        b=Zg3eE3Sk3UYlLWQ3Hk23p50BLp3ZGEbKuvxZs87NCrUkLJx1rxk5ht374DB7dZMCLp
         XucALuwo9z9mL21WqsG0k8YcHg/W4OG3uh92P87pKe818ZwgWeIfSXKc4GG8bfVTuZ7y
         HzlE8FA0FWGP9QzA+GeQJgNVV56yKOnwm1hKZMI0cEbrTzo12I2uGMuoBmk//PIFbRxK
         VgtVwdrCkpbc8oHlO3uRsVnKRP5g9O7eO+rfS2WIovrW0D1PGgr+lmNcPITJwgQ6ljQB
         o7lDXtgNWfG4rSoocQ06f5R2dYin+PByCO2C6XBO6d6R0yTdH9DfiVciTFCL+8grjAYa
         WZfw==
X-Gm-Message-State: APjAAAVRGk+EW5dGtKFgdgEEZqPrnhBQMscCm0zRMa/zn33qpoIO3ucG
        +3f2MtX5S/sE7NQJhAkPFlp5RUTFlRWzlYG/B52JNSb7MAOb40AlScVJB7EzJ46RxeI1mYeqzeq
        yNY8p31U5gqdr7Oyn
X-Received: by 2002:a05:600c:204c:: with SMTP id p12mr10876579wmg.61.1575640308099;
        Fri, 06 Dec 2019 05:51:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqwpWiFZTu2cRvelChSMS4nkUKyMuIPCV3x4l7zHobMJy/hcS33YDoKGgKGPEBCEJymenIdYjw==
X-Received: by 2002:a05:600c:204c:: with SMTP id p12mr10876553wmg.61.1575640307831;
        Fri, 06 Dec 2019 05:51:47 -0800 (PST)
Received: from [10.201.49.168] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id b10sm16337198wrt.90.2019.12.06.05.51.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 05:51:47 -0800 (PST)
Subject: Re: [PATCH] KVM: Radim is no longer available as KVM maintainer
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rkrcmar@redhat.com, radimkrcmar@gmail.com, drjones@redhat.com,
        stable@vger.kernel.org, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
References: <20191206134511.20036-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2640ebbd-06b9-812f-7ba7-704fdb470220@redhat.com>
Date:   Fri, 6 Dec 2019 14:51:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191206134511.20036-1-thuth@redhat.com>
Content-Language: en-US
X-MC-Unique: yYYx37AnMIqwoh4u5a545A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/12/19 14:45, Thomas Huth wrote:
> Radim's mail address @redhat.com is not valid anymore, so we should
> remove this line from the MAINTAINERS file to avoid that people send
> mails to this address in vain.
>=20
> Thank you very much for all your work on KVM during the past years,
> Radim!
>=20
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 067cae5bde23..54cf6e242e54 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9043,7 +9043,6 @@ F:=09include/linux/umh.h
> =20
>  KERNEL VIRTUAL MACHINE (KVM)
>  M:=09Paolo Bonzini <pbonzini@redhat.com>
> -M:=09Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
>  L:=09kvm@vger.kernel.org
>  W:=09http://www.linux-kvm.org
>  T:=09git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
> @@ -9115,7 +9114,6 @@ F:=09tools/testing/selftests/kvm/*/s390x/
> =20
>  KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
>  M:=09Paolo Bonzini <pbonzini@redhat.com>
> -M:=09Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
>  R:=09Sean Christopherson <sean.j.christopherson@intel.com>
>  R:=09Vitaly Kuznetsov <vkuznets@redhat.com>
>  R:=09Wanpeng Li <wanpengli@tencent.com>
>=20

Queued, thanks.

Paolo

