Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A44B57381F
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 15:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiGMN6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 09:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiGMN6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 09:58:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D50F3BA
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 06:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657720714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/KaBUzMJAb8ELoURf+aDcmgxflG4+mAlNx4MhWPAnms=;
        b=EoFNHBLHnVVd0/TqUZaISAtoJKFvVaooaz4fAR2FgVOKYornUFFxTqaGNZASrfUvHy/aLS
        wqTOJSTh331kfdbjkW7JJz4B45ngXczyXH0NFLPjCaI0M0CTOm1y26H6eh1hslHYg6ZqwJ
        duZ4kyMPK0ikGy2gQfj0I4yPbh6Opro=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-iXYDArJ2Pq2tnmG_TwCikw-1; Wed, 13 Jul 2022 09:58:31 -0400
X-MC-Unique: iXYDArJ2Pq2tnmG_TwCikw-1
Received: by mail-ed1-f72.google.com with SMTP id z20-20020a05640240d400b0043a82d9d65fso8341868edb.0
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 06:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to;
        bh=/KaBUzMJAb8ELoURf+aDcmgxflG4+mAlNx4MhWPAnms=;
        b=QedwSaK3UPjWTGcZP5OwcjJZb5aUEumuId3G+id4tmjyMiEaqNClWMw7mk8ZIgR0FT
         wFpzAMjvIFuGD4N1QqIAn/okuHebsCLAoA+0EKkIn2KcxrOF9xlLRB/9zkf51/47oz0k
         CsnizZ7AN0NM+Hfueh1EyJLUy1Phb203wPWbxaPsOe8s/WctmApjcGxs1y6mBUH0bNZA
         QEAxbhnRV0pqE0dIra8xm2WKGzdir4heNpocNIcFFV3e8uaHH+SbXRvY4bWOjsQHAkVC
         BYhPKINnE6OJVYydUOUQNOi+7S3KobhfySKPEr45ggXEMKN+ZvodvY0mpMZ9ZPDvQGsk
         ynpw==
X-Gm-Message-State: AJIora8K02UU2lPiCcF2dfcLw612Q1YSEIvRkqpAXrY/wafMG8NaupBY
        hGU16G/i5xfQL/Ox7N1gFxZJw49Ym+HEq2AjxY1eFAqvC7ArLFiISAsJSFvSUB4CrP1nU3ml4FO
        iQG/y3WfOehQflCU9
X-Received: by 2002:a17:907:9605:b0:6f5:c66:7c13 with SMTP id gb5-20020a170907960500b006f50c667c13mr3718846ejc.66.1657720710394;
        Wed, 13 Jul 2022 06:58:30 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vMuFzYBhnUEpQjzR0GE0q5vpz83dYF6EUDZYybFG7bY9u68mWywkzQ+aLih1ks9mgLlfrtcg==
X-Received: by 2002:a17:907:9605:b0:6f5:c66:7c13 with SMTP id gb5-20020a170907960500b006f50c667c13mr3718821ejc.66.1657720710145;
        Wed, 13 Jul 2022 06:58:30 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id w21-20020a50fa95000000b0043a8f40a038sm7997545edr.93.2022.07.13.06.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 06:58:29 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------LEBEnV2skDghZQRyUOjQNnwZ"
Message-ID: <2f32f2f5-2c78-9860-5794-2cfd0a283702@redhat.com>
Date:   Wed, 13 Jul 2022 15:58:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [Regression] ACPI: video: Change how we determine if brightness
 key-presses are handled
Content-Language: en-US
From:   Hans de Goede <hdegoede@redhat.com>
To:     Ben Greening <bgreening@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        rafael@kernel.org, linux-acpi@vger.kernel.org
References: <CALF=6jEe5G8+r1Wo0vvz4GjNQQhdkLT5p8uCHn6ZXhg4nsOWow@mail.gmail.com>
 <02190bee-2e1b-bea3-b716-a7c7f5aa2ff0@redhat.com>
 <CALF=6jG5gmqqXo5cSFFRWRM96K0rzx3WabNdwAmdZQH=unFG7g@mail.gmail.com>
 <3ddcdb24-cab3-509d-d694-edd4ab85df0a@redhat.com>
In-Reply-To: <3ddcdb24-cab3-509d-d694-edd4ab85df0a@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------LEBEnV2skDghZQRyUOjQNnwZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi again,

On 7/13/22 15:29, Hans de Goede wrote:

<snip>

> So I plan to fix this part by adding a quirk to make native the default
> on your machine. Can you do:
> 
> sudo dmidecode > dmidecode.txt
> 
> And email me the generated dmidecode.txt (this will contain serialnumbers
> so you may want to send it off-list) ? Then I can also prepare a patch
> to add a quirk to make native the default on your model.

I have found a DMI decode for your model here:
https://github.com/linuxhw/DMI/

So I've written the quirk patch (attached) based on that.

Please give this a try. With a 5.18.1x kernel with both patches applied,
everything should work without needing to specify anything on the kernel
commandline.

Regards,

Hans
--------------LEBEnV2skDghZQRyUOjQNnwZ
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-ACPI-video-Use-native-backlight-on-Dell-Inspiron-N40.patch"
Content-Disposition: attachment;
 filename*0="0001-ACPI-video-Use-native-backlight-on-Dell-Inspiron-N40.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAxMmIyYWU2Y2JiMzY4NjBmOTk2YTVjYTM4MmJiMWRkYTQzYTRmYjhiIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBIYW5zIGRlIEdvZWRlIDxoZGVnb2VkZUByZWRoYXQu
Y29tPgpEYXRlOiBXZWQsIDEzIEp1bCAyMDIyIDE1OjUzOjA4ICswMjAwClN1YmplY3Q6IFtQ
QVRDSF0gQUNQSTogdmlkZW86IFVzZSBuYXRpdmUgYmFja2xpZ2h0IG9uIERlbGwgSW5zcGly
b24gTjQwMTAKClRoZSBEZWxsIEluc3Bpcm9uIE40MDEwIGRvZXMgbm90IGhhdmUgQUNQSSBi
YWNrbGlnaHQgY29udHJvbCwKc28gYWNwaV92aWRlb19nZXRfYmFja2xpZ2h0X3R5cGUoKSdz
IGhldXJpc3RpY3MgcmV0dXJuIHZlbmRvciBhcwp0aGUgdHlwZSB0byB1c2UuCgpCdXQgdGhl
IHZlbmRvciBpbnRlcmZhY2UgaXMgYnJva2VuLCB3aGVyZSBhcyB0aGUgbmF0aXZlIChpbnRl
bF9iYWNrbGlnaHQpCndvcmtzIHdlbGwsIGFkZCBhIHF1aXJrIHRvIHVzZSBuYXRpdmUuCgpM
aW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yZWdyZXNzaW9ucy9DQUxGPTZqRWU1Rzgr
cjFXbzB2dno0R2pOUVFoZGtMVDVwOHVDSG42WlhoZzRuc09Xb3dAbWFpbC5nbWFpbC5jb20v
ClJlcG9ydGVkLWFuZC10ZXN0ZWQtYnk6IEJlbiBHcmVlbmluZyA8YmdyZWVuaW5nQGdtYWls
LmNvbT4KU2lnbmVkLW9mZi1ieTogSGFucyBkZSBHb2VkZSA8aGRlZ29lZGVAcmVkaGF0LmNv
bT4KLS0tCiBkcml2ZXJzL2FjcGkvdmlkZW9fZGV0ZWN0LmMgfCA4ICsrKysrKysrCiAxIGZp
bGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9hY3Bp
L3ZpZGVvX2RldGVjdC5jIGIvZHJpdmVycy9hY3BpL3ZpZGVvX2RldGVjdC5jCmluZGV4IGJl
Y2MxOThlNGMyMi4uNDA5OTE0MGJiZDVmIDEwMDY0NAotLS0gYS9kcml2ZXJzL2FjcGkvdmlk
ZW9fZGV0ZWN0LmMKKysrIGIvZHJpdmVycy9hY3BpL3ZpZGVvX2RldGVjdC5jCkBAIC0zNDcs
NiArMzQ3LDE0IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZG1pX3N5c3RlbV9pZCB2aWRlb19k
ZXRlY3RfZG1pX3RhYmxlW10gPSB7CiAJCURNSV9NQVRDSChETUlfUFJPRFVDVF9OQU1FLCAi
TWFjQm9va1BybzEyLDEiKSwKIAkJfSwKIAl9LAorCXsKKwkgLmNhbGxiYWNrID0gdmlkZW9f
ZGV0ZWN0X2ZvcmNlX25hdGl2ZSwKKwkgLyogRGVsbCBJbnNwaXJvbiBONDAxMCAqLworCSAu
bWF0Y2hlcyA9IHsKKwkJRE1JX01BVENIKERNSV9TWVNfVkVORE9SLCAiRGVsbCBJbmMuIiks
CisJCURNSV9NQVRDSChETUlfUFJPRFVDVF9OQU1FLCAiSW5zcGlyb24gTjQwMTAiKSwKKwkJ
fSwKKwl9LAogCXsKIAkgLmNhbGxiYWNrID0gdmlkZW9fZGV0ZWN0X2ZvcmNlX25hdGl2ZSwK
IAkgLyogRGVsbCBWb3N0cm8gVjEzMSAqLwotLSAKMi4zNi4wCgo=

--------------LEBEnV2skDghZQRyUOjQNnwZ--

