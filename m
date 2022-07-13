Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE7A5737D5
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 15:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbiGMNta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 09:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236412AbiGMNtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 09:49:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C88A47665
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 06:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657720162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/ftiE6vcoK0AtWUaUskL45BO7278A1ajPsM36ag7x0Y=;
        b=UFFfB5qrNHe5XR3PkGhIvp+opURvriWHebfCDuGQjz+DBqOZjwLCMe0F148Azi+QeuRgHz
        yOSsMgwKpvK8wjabETs14uB6xvJUpg92z+nEaurzX2f27CmNq15ijYpUvEJc5onuMHuKB7
        eTQf8tcislB61Ao/1tLTGS8SM1VhzEU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-Tfl8_dUWPi6NMgmkHfil9A-1; Wed, 13 Jul 2022 09:49:21 -0400
X-MC-Unique: Tfl8_dUWPi6NMgmkHfil9A-1
Received: by mail-ej1-f72.google.com with SMTP id gr1-20020a170906e2c100b006fefea3ec0aso3440763ejb.14
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 06:49:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to;
        bh=/ftiE6vcoK0AtWUaUskL45BO7278A1ajPsM36ag7x0Y=;
        b=A4vX4RBg74H1aJhm7Pe+suqugfoRw7YmStKf8ez9VoqSrl64hk+06nLSOWbo/Bgyyd
         mPKd29EssVwqT0gtw6hsafCMP1DrfMtCIsrsamM/VI3oecuNlRnnAXKzu6IeylugtscB
         9tSMK2A5vBYqtPfP9AMQzjtvBy6/nFY+g4gEJF0Cv8jeeArjqKVBxtIHHht5YFRC6szt
         c6kqfMtjpu/I1GeT8XqEajVcw5VbsGQ5L3vva+qmBUWdrZs26jTlcJ1YfP5DKYA7Y/8l
         /YirHbgkt/eIu2FvAKgnu0C9amUb1QlbLEOkMUmFpJEGL5m8k/oSIzlHlbGEym9v9da1
         tKOg==
X-Gm-Message-State: AJIora//ae7aWvSJm/HJBBq3S083/Opk2Ny/P3btPNx2AQWTPvNYuWxF
        D6UdxI8W917INeFHT2WA7f+fiZAgt08UGuEa40j8uzZnYed+IEIUQoWzHfKO0obkuD/jipFETFO
        8eUiEl4XGwNYZEs26
X-Received: by 2002:a05:6402:3681:b0:43a:7c29:466a with SMTP id ej1-20020a056402368100b0043a7c29466amr5000138edb.367.1657720160335;
        Wed, 13 Jul 2022 06:49:20 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uhybMB1tiAkd3DOySL1/d9VtRr5lV3sjwDBH9zbcUwhYZDlUOKrzxJyQDQcBP7zJDMvywbrg==
X-Received: by 2002:a05:6402:3681:b0:43a:7c29:466a with SMTP id ej1-20020a056402368100b0043a7c29466amr5000109edb.367.1657720160108;
        Wed, 13 Jul 2022 06:49:20 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id ay26-20020a056402203a00b0043b0951f7b1sm1538003edb.41.2022.07.13.06.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 06:49:19 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------dK1ZCpYMJQZBsTspUIPpAYxr"
Message-ID: <eb760bcd-8817-65ed-471e-60e8d9bdae79@redhat.com>
Date:   Wed, 13 Jul 2022 15:49:18 +0200
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------dK1ZCpYMJQZBsTspUIPpAYxr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ben,

On 7/13/22 15:29, Hans de Goede wrote:
> Hi,
> 
> On 7/13/22 15:08, Ben Greening wrote:
>> Hi Hans, thanks for getting back to me.
>>
>> evemu-record shows events for both "Video Bus" and "Dell WMI hotkeys":
>>
>> Video Bus
>> E: 0.000001 0001 00e0 0001 # EV_KEY / KEY_BRIGHTNESSDOWN   1
>> E: 0.000001 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
>> E: 0.000020 0001 00e0 0000 # EV_KEY / KEY_BRIGHTNESSDOWN   0
>> E: 0.000020 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
>>
>> Dell WMI hotkeys
>> E: 0.000001 0004 0004 57349 # EV_MSC / MSC_SCAN             57349
>> E: 0.000001 0001 00e0 0001 # EV_KEY / KEY_BRIGHTNESSDOWN   1
>> E: 0.000001 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
>> E: 0.000020 0001 00e0 0000 # EV_KEY / KEY_BRIGHTNESSDOWN   0
>> E: 0.000020 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
>>
>> Adding video.report_key_events=1 with acpi_backlight=video makes
>> things work like you said it would.
>>
>>
>> With acpi_backlight=video just has intel_backlight.
>>
>> Without acpi_backlight=video:
>>     intel_backlight:
>>         max_brightness: 4882
>>         backlight control works with echo
>>         brightness keys make no change to brightness value
>>
>>     dell_backlight:
>>         max_brightness: 15
>>         backlight control doesn't work immediately, but does on reboot
>> to set brightness at POST.
>>         brightness keys change brightness value, but you don't see the
>> change until reboot.	
> 
> Ok, so your system lacks ACPI video backlight control, yet still reports
> brightness keypresses through the ACPI Video Bus. Interesting (weird)...
> 
> I think I believe I know how to fix the regression, 1 patch coming up.

Can you please give the attached patch a try, with
video.report_key_events=1 *removed* from the commandline ?

It would also be interesting if you can start evemu-record on the
Dell WMI Hotkeys device before pressing any of the brightness keys.

There might still be a single duplicate event reported there on
the first press. I don't really see a way around that (without causing
all brightness key presses on some panasonic models to be duplicated),
but I'm curious if it is a problem at all...

Regards,

Hans






--------------dK1ZCpYMJQZBsTspUIPpAYxr
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-ACPI-video-Change-how-we-determine-if-brightness-key.patch"
Content-Disposition: attachment;
 filename*0="0001-ACPI-video-Change-how-we-determine-if-brightness-key.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAxMmRhMDUxYmVlYTZkZTNlMmZkNDk1ZmQ4YjgyYWNjZTlkZmIzZWI1IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBIYW5zIGRlIEdvZWRlIDxoZGVnb2VkZUByZWRoYXQu
Y29tPgpEYXRlOiBXZWQsIDEzIEp1bCAyMDIyIDE1OjMxOjE0ICswMjAwClN1YmplY3Q6IFtQ
QVRDSF0gQUNQSTogdmlkZW86IENoYW5nZSBob3cgd2UgZGV0ZXJtaW5lIGlmIGJyaWdodG5l
c3MKIGtleS1wcmVzc2VzIGFyZSBoYW5kbGVkIGFnYWluCgpDb21taXQgM2EwY2Y3YWI4ZGYz
ICgiQUNQSTogdmlkZW86IENoYW5nZSBob3cgd2UgZGV0ZXJtaW5lIGlmIGJyaWdodG5lc3MK
a2V5LXByZXNzZXMgYXJlIGhhbmRsZWQiKSBtYWRlIGFjcGlfdmlkZW9faGFuZGxlc19icmln
aHRuZXNzX2tleV9wcmVzc2VzKCkKcmVwb3J0IGZhbHNlIHdoZW4gbm9uZSBvZiB0aGUgQUNQ
SSBWaWRlbyBEZXZpY2VzIHN1cHBvcnQgYmFja2xpZ2h0IGNvbnRyb2wuCgpCdXQgaXQgdHVy
bnMgb3V0IHRoYXQgYXQgbGVhc3Qgb24gYSBEZWxsIEluc3Bpcm9uIG40MDEwIHRoZXJlIGlz
IG5vIEFDUEkKYmFja2xpZ2h0IGNvbnRyb2wsIHlldCBicmlnaHRuZXNzIGhvdGtleXMgYXJl
IHN0aWxsIHJlcG9ydGVkIHRocm91Z2gKdGhlIEFDUEkgVmlkZW8gQnVzOyBhbmQgc2luY2Ug
YWNwaV92aWRlb19oYW5kbGVzX2JyaWdodG5lc3Nfa2V5X3ByZXNzZXMoKQpub3cgcmV0dXJu
cyBmYWxzZSwgYnJpZ2h0bmVzcyBrZXlwcmVzc2VzIGFyZSBub3cgcmVwb3J0ZWQgdHdpY2Uu
CgpUbyBmaXggdGhpcyByZW5hbWUgdGhlIGhhc19iYWNrbGlnaHQgZmxhZyB0byBtYXlfcmVw
b3J0X2JyaWdodG5lc3Nfa2V5cyBhbmQKYWxzbyBzZXQgaXQgdGhlIGZpcnN0IHRpbWUgYSBi
cmlnaHRuZXNzIGtleSBwcmVzcyBldmVudCBpcyByZWNlaXZlZC4KCkRlcGVuZGluZyBvbiB0
aGUgZGVsaXZlcnkgb2YgdGhlIG90aGVyIEFDUEkgKFdNSSkgZXZlbnQgdnMgdGhlIEFDUEkg
VmlkZW8KQnVzIGV2ZW50IHRoaXMgbWVhbnMgdGhhdCB0aGUgZmlyc3QgYnJpZ2h0bmVzcyBr
ZXkgcHJlc3MgbWlnaHQgc3RpbGwgZ2V0CnJlcG9ydGVkIHR3aWNlLCBidXQgYWxsIGZ1cnRo
ZXIga2V5cHJlc3NlcyB3aWxsIGJlIGZpbHRlcmVkIGFzIGJlZm9yZS4KCk5vdGUgdGhhdCB0
aGlzIHJlbGllcyBvbiBvdGhlciBkcml2ZXJzIHJlcG9ydGluZyBicmlnaHRuZXNzIGtleSBl
dmVudHMKY2FsbGluZyBhY3BpX3ZpZGVvX2hhbmRsZXNfYnJpZ2h0bmVzc19rZXlfcHJlc3Nl
cygpIHdoZW4gZGVsaXZlcmluZwp0aGUgZXZlbnRzIChyYXRoZXIgdGhlbiBvbmNlIGR1cmlu
ZyBkcml2ZXIgcHJvYmUpLiBUaGlzIGlzIGFscmVhZHkKcmVxdWlyZWQgYW5kIGRvY3VtZW50
ZWQgaW4gaW5jbHVkZS9hY3BpL3ZpZGVvLmg6CgovKgogKiBOb3RlOiBUaGUgdmFsdWUgcmV0
dXJuZWQgYnkgYWNwaV92aWRlb19oYW5kbGVzX2JyaWdodG5lc3Nfa2V5X3ByZXNzZXMoKQog
KiBtYXkgY2hhbmdlIG92ZXIgdGltZSBhbmQgc2hvdWxkIG5vdCBiZSBjYWNoZWQuCiAqLwoK
Rml4ZXM6IDNhMGNmN2FiOGRmMyAoIkFDUEk6IHZpZGVvOiBDaGFuZ2UgaG93IHdlIGRldGVy
bWluZSBpZiBicmlnaHRuZXNzIGtleS1wcmVzc2VzIGFyZSBoYW5kbGVkIikKTGluazogaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcmVncmVzc2lvbnMvQ0FMRj02akVlNUc4K3IxV28wdnZ6
NEdqTlFRaGRrTFQ1cDh1Q0huNlpYaGc0bnNPV293QG1haWwuZ21haWwuY29tLwpSZXBvcnRl
ZC1hbmQtdGVzdGVkLWJ5OiBCZW4gR3JlZW5pbmcgPGJncmVlbmluZ0BnbWFpbC5jb20+ClNp
Z25lZC1vZmYtYnk6IEhhbnMgZGUgR29lZGUgPGhkZWdvZWRlQHJlZGhhdC5jb20+Ci0tLQog
ZHJpdmVycy9hY3BpL2FjcGlfdmlkZW8uYyB8IDExICsrKysrKystLS0tCiAxIGZpbGUgY2hh
bmdlZCwgNyBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvYWNwaS9hY3BpX3ZpZGVvLmMgYi9kcml2ZXJzL2FjcGkvYWNwaV92aWRlby5jCmlu
ZGV4IGRjM2MwMzdkNjMxMy4uMWEzNTA1NDNhNmJmIDEwMDY0NAotLS0gYS9kcml2ZXJzL2Fj
cGkvYWNwaV92aWRlby5jCisrKyBiL2RyaXZlcnMvYWNwaS9hY3BpX3ZpZGVvLmMKQEAgLTc5
LDcgKzc5LDcgQEAgbW9kdWxlX3BhcmFtKGRldmljZV9pZF9zY2hlbWUsIGJvb2wsIDA0NDQp
Owogc3RhdGljIGludCBvbmx5X2xjZCA9IC0xOwogbW9kdWxlX3BhcmFtKG9ubHlfbGNkLCBp
bnQsIDA0NDQpOwogCi1zdGF0aWMgYm9vbCBoYXNfYmFja2xpZ2h0Oworc3RhdGljIGJvb2wg
bWF5X3JlcG9ydF9icmlnaHRuZXNzX2tleXM7CiBzdGF0aWMgaW50IHJlZ2lzdGVyX2NvdW50
Owogc3RhdGljIERFRklORV9NVVRFWChyZWdpc3Rlcl9jb3VudF9tdXRleCk7CiBzdGF0aWMg
REVGSU5FX01VVEVYKHZpZGVvX2xpc3RfbG9jayk7CkBAIC0xMjMyLDcgKzEyMzIsNyBAQCBh
Y3BpX3ZpZGVvX2J1c19nZXRfb25lX2RldmljZShzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmlj
ZSwKIAlhY3BpX3ZpZGVvX2RldmljZV9maW5kX2NhcChkYXRhKTsKIAogCWlmIChkYXRhLT5j
YXAuX0JDTSAmJiBkYXRhLT5jYXAuX0JDTCkKLQkJaGFzX2JhY2tsaWdodCA9IHRydWU7CisJ
CW1heV9yZXBvcnRfYnJpZ2h0bmVzc19rZXlzID0gdHJ1ZTsKIAogCW11dGV4X2xvY2soJnZp
ZGVvLT5kZXZpY2VfbGlzdF9sb2NrKTsKIAlsaXN0X2FkZF90YWlsKCZkYXRhLT5lbnRyeSwg
JnZpZGVvLT52aWRlb19kZXZpY2VfbGlzdCk7CkBAIC0xNzAxLDYgKzE3MDEsOSBAQCBzdGF0
aWMgdm9pZCBhY3BpX3ZpZGVvX2RldmljZV9ub3RpZnkoYWNwaV9oYW5kbGUgaGFuZGxlLCB1
MzIgZXZlbnQsIHZvaWQgKmRhdGEpCiAJCWJyZWFrOwogCX0KIAorCWlmIChrZXljb2RlKQor
CQltYXlfcmVwb3J0X2JyaWdodG5lc3Nfa2V5cyA9IHRydWU7CisKIAlhY3BpX25vdGlmaWVy
X2NhbGxfY2hhaW4oZGV2aWNlLCBldmVudCwgMCk7CiAKIAlpZiAoa2V5Y29kZSAmJiAocmVw
b3J0X2tleV9ldmVudHMgJiBSRVBPUlRfQlJJR0hUTkVTU19LRVlfRVZFTlRTKSkgewpAQCAt
MjI4MCw3ICsyMjgzLDcgQEAgdm9pZCBhY3BpX3ZpZGVvX3VucmVnaXN0ZXIodm9pZCkKIAkJ
Y2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZ2aWRlb19idXNfcmVnaXN0ZXJfYmFja2xpZ2h0
X3dvcmspOwogCQlhY3BpX2J1c191bnJlZ2lzdGVyX2RyaXZlcigmYWNwaV92aWRlb19idXMp
OwogCQlyZWdpc3Rlcl9jb3VudCA9IDA7Ci0JCWhhc19iYWNrbGlnaHQgPSBmYWxzZTsKKwkJ
bWF5X3JlcG9ydF9icmlnaHRuZXNzX2tleXMgPSBmYWxzZTsKIAl9CiAJbXV0ZXhfdW5sb2Nr
KCZyZWdpc3Rlcl9jb3VudF9tdXRleCk7CiB9CkBAIC0yMjk5LDcgKzIzMDIsNyBAQCBFWFBP
UlRfU1lNQk9MKGFjcGlfdmlkZW9fcmVnaXN0ZXJfYmFja2xpZ2h0KTsKIAogYm9vbCBhY3Bp
X3ZpZGVvX2hhbmRsZXNfYnJpZ2h0bmVzc19rZXlfcHJlc3Nlcyh2b2lkKQogewotCXJldHVy
biBoYXNfYmFja2xpZ2h0ICYmCisJcmV0dXJuIG1heV9yZXBvcnRfYnJpZ2h0bmVzc19rZXlz
ICYmCiAJICAgICAgIChyZXBvcnRfa2V5X2V2ZW50cyAmIFJFUE9SVF9CUklHSFRORVNTX0tF
WV9FVkVOVFMpOwogfQogRVhQT1JUX1NZTUJPTChhY3BpX3ZpZGVvX2hhbmRsZXNfYnJpZ2h0
bmVzc19rZXlfcHJlc3Nlcyk7Ci0tIAoyLjM2LjAKCg==

--------------dK1ZCpYMJQZBsTspUIPpAYxr--

