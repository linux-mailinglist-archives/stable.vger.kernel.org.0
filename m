Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817EC43B521
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 17:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbhJZPLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 11:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbhJZPLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 11:11:02 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B51BC061745
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 08:08:39 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e65so14431204pgc.5
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 08:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=ILEXfsQZbjkiZ1EINfoqBqlPLBWNViKLnco+joRCi2M=;
        b=FubO98vdAy5wGUjPPlmZwTb0yGKiVjzQCZMXCXiA4gi0uu+dxNl8P4xnkA6gNhuIHj
         N65zEBQ3HWIImix75xqpGLpRKb0TQjeKtKK76ipBBUtfuN/m41Y8cirGr/8FVmdf4CMr
         vUsh+sBpaa0zeV/GsyG8dlGP5qk0HdkX+8rc5KPVjQJT7DxR2CKih/A34RdLFDZu5etc
         uaqNJp/Skic6S3iF75sr8SjAi1xD6bwR28lKrkN4+b+8nxHm27pchuPfKbCyJ9XKv/uf
         hnXDNACLD6+1FSyy+3xfJauUR45CPfR28HzclkAFRHSQjD7b4nsuR9woyKaV9PeOhowa
         5sIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=ILEXfsQZbjkiZ1EINfoqBqlPLBWNViKLnco+joRCi2M=;
        b=k9fCEEitSunQuRXnRUNcOlAWlCqkC1nCB65N4+I0iHl/YMGjYDQ5qw5moow/CET7JT
         XbBdeF3RB/tBfX3ljAtrNSfdk4PIpolYMxNUbqIAJq8JnoXHlJ/L3KP3CbUr8BUFhpOn
         ycD9rY/f898n3SDT7/cKB1kK5sj+Jm1qJ97SBgZqxzIvFnjm+oGQz8OSWHAQNHoMXXwQ
         ZsPrXPD8z37WQOpiSqJlnTjgWDn6HOspzYiiP85BGIOHn/781Rm2ogJGSrCdiNV1Q2RR
         7doQ7LdHdiplBxdrS/NSxj90g4qhEiIfuNXorHC+6I0vkWIKuXAfhsMWeXL/LBd4AWB3
         GllQ==
X-Gm-Message-State: AOAM532mFL9VgfYjwlrokg3dc+K8etm6rXw5CrmtlsmPL881DCT8JiUj
        ZoqAjSA4wunvkpYg/h9RjUyesA==
X-Google-Smtp-Source: ABdhPJx6Nkr+pPMtX2cFEqueSY4dj+SM7csXJl8FJ3YjiaPyILOVvFlfC/rgBM0JBWrhG2ouX+qQXg==
X-Received: by 2002:a63:2b85:: with SMTP id r127mr19721479pgr.215.1635260918578;
        Tue, 26 Oct 2021 08:08:38 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id s3sm26116439pfu.84.2021.10.26.08.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 08:08:38 -0700 (PDT)
Message-ID: <6e76d1d0-fb73-13b4-0881-6bdd8b69588f@linaro.org>
Date:   Tue, 26 Oct 2021 08:08:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] usbnet: sanity check for maxpacket
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <e3ae5f6e-1e96-9d7e-c126-6b4fb00f83a0@linaro.org>
 <YXeVmDtzkC1sUBCv@kroah.com>
 <68be83ab-c0b1-78f7-0234-8e915339d570@linaro.org>
 <YXgY2cirSesI+L+E@kroah.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <YXgY2cirSesI+L+E@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------90cl33J00FG8dxxFY1E0Shnu"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------90cl33J00FG8dxxFY1E0Shnu
Content-Type: multipart/mixed; boundary="------------4CH4tv0WzzPX7FaZEHApQMsk";
 protected-headers="v1"
From: Tadeusz Struk <tadeusz.struk@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
 Jakub Kicinski <kuba@kernel.org>
Message-ID: <6e76d1d0-fb73-13b4-0881-6bdd8b69588f@linaro.org>
Subject: Re: [PATCH] usbnet: sanity check for maxpacket
References: <e3ae5f6e-1e96-9d7e-c126-6b4fb00f83a0@linaro.org>
 <YXeVmDtzkC1sUBCv@kroah.com>
 <68be83ab-c0b1-78f7-0234-8e915339d570@linaro.org>
 <YXgY2cirSesI+L+E@kroah.com>
In-Reply-To: <YXgY2cirSesI+L+E@kroah.com>

--------------4CH4tv0WzzPX7FaZEHApQMsk
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMjYvMjEgMDg6MDMsIEdyZWcgS0ggd3JvdGU6DQo+IE9uIFR1ZSwgT2N0IDI2LCAy
MDIxIGF0IDA3OjUyOjAwQU0gLTA3MDAsIFRhZGV1c3ogU3RydWsgd3JvdGU6DQo+PiBPbiAx
MC8yNS8yMSAyMjo0MywgR3JlZyBLSCB3cm90ZToNCj4+Pj4gSXQgc2hvdWxkIGJlIGFwcGxp
ZWQgdG8gc3RhYmxlIGtlcm5lbHM6IDUuMTQsIDUuMTAsIDUuNCwgNC4xOSwgNC4xNCwgNC45
LCA0LjQNCj4+PiBJdCdzIGFscmVhZHkgaW4gdGhlIGxhdGVzdCBzdGFibGUgLXJjIHJlbGVh
c2VzLCBkbyB5b3Ugbm90IHNlZSBpdCB0aGVyZT8NCj4+DQo+PiBJIGhhdmVuJ3QgY2hlY2tl
ZCB0aGUgcmMgcmVsZWFzZXMsIGp1c3QgdGhlIGxhdGVzdCBzdGFibGUgdmVyc2lvbnMuDQo+
PiBOb3cgSSBhbHNvIHNlZSBTYXNoYSBMZXZpbidzIHN1Ym1pc3Npb25zIG9uIHRoZSBzdGFi
bGUgbWFpbGluZyBsaXN0IGFyY2hpdmUuDQo+PiBBbGwgZ29vZC4gU29ycnkgZm9yIHRoZSBu
b2lzZS4NCj4gDQo+IEFsc28gbm90ZSB0aGF0IHRoZXJlIGlzIGEgYnVnIGluIHRoaXMgY29t
bWl0LCBzbyBpdCB3YXMgZHJvcHBlZCBmcm9tIHRoZQ0KPiBzdGFibGUgcXVldWVzIHVudGls
IHRoZSBmaXggZm9yIHRoaXMgaGl0cyBMaW51cydzIHRyZWUuDQo+IA0KDQpHb29kIHRvIGtu
b3cuIElkZWFsbHkgd2UgY291bGQgYWxzbyBhZGQgc29tZSBuZXRpZl93YXJuKCkgbWVzc2Fn
ZSBmb3IgdGhlIHVzZXIuDQoNCi0tIA0KVGhhbmtzLA0KVGFkZXVzeg0K

--------------4CH4tv0WzzPX7FaZEHApQMsk--

--------------90cl33J00FG8dxxFY1E0Shnu
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEb3ghm5bfkfSeegvwo0472xuDAo4FAmF4GfUFAwAAAAAACgkQo0472xuDAo7J
0w//fWej+sr7rPB3Mfvj9QmHsdwn9ztx44oT57Hx+TplFPk+dJIfpN5XM95YhbiiofaE/Fsvo5p2
VLfP1G3okDnTq0PYeYtc5GYHeIpmsUlx6M3bwRR2Oi+p14QD/DE2SugHHL8er4MeKGbooRNn6hx5
CvAGQrGiB42z8bYBlHeuaGRrfJdG4gOolF/0/DAE8R1e6a9nQAcnQGRxOUIpy9hmtRaVsVbJ+xBy
buXPE/ImouYGPjSyQvRnwhdFdNjjd9873XxHVQoGGKg29PzdykxBx75VkicM782tM+AsBw00vCJc
LGWoiLDpXjNKIzWNQLN6DAP8fi++1Hqyro8821l8wz1hIBugxDQeGLLR3H1CyQKUfIhVRD51EyW/
tUWJ6T3qyN7j7Xo4t76cML2jKU+AVqGKue/+CDa9Q2CVLEZxv0+8ubOe8+Qj8+0/Tuu3XepcI4gi
SEAUs2ypmyGX2WML/Xr3AvzOPQyjKnRsZG9PtKnCfn9mrnceVqMgrVwLy4PKTTO2Tq56XbuOalcS
8QsV7yEpARQPVArSmR0A0ienNs2W/3gpWQ4pWsHREl8C9uHGQKydHX46ssC1LQ+Zm2rlOPlDK5Pu
8pH2YTI0sLdfwGxbMlOW1PTDsDqcN+tPRaAmS4Z3YKDIJteARtW0UKXvB0YoQAP9OOOZH2ixo6BO
Xdo=
=lhiC
-----END PGP SIGNATURE-----

--------------90cl33J00FG8dxxFY1E0Shnu--
