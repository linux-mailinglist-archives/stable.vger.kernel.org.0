Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5C56DDE82
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 16:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjDKOv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 10:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjDKOvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 10:51:22 -0400
Received: from mail.tty42.de (mail.tty42.de [94.130.190.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9534F101
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 07:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=pisquaredover6.de;
        s=dkim; t=1681224676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zoRC/zEO9j2rC4owJixlP5gUqobcVT5q3JNAtqf3MLY=;
        b=5nztzYXtsyikAuVj456WkKKQ/23763sUvz0s9rLkEMdggGi8Lqhnso8HOzWyNmjp+UkogF
        EPqYbQOEYPbwQJCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pisquaredover6.de;
        s=rsa; t=1681224676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zoRC/zEO9j2rC4owJixlP5gUqobcVT5q3JNAtqf3MLY=;
        b=OsZ+8oouE9nCzQncH/dnTxEEQ6vGu3U+bhMdQP1gwCJ8i7lxXxx57BaIXtc5hqVd2Vrdc8
        uPU7F90WS1bmQLJCk2cyDgMurw0OgABzbgRUdHNrJm7vOxncYsxN6IMlWxEW7zDHLXffaH
        5mlffz6kj4L87i4lXxCIZclA6AXM22fyq1S3ugdL2YoQNlgqPwTIojJgQHTV0VlMdyz+v7
        47FHRoK9Qs+f9AlBpqZvnOEAukfdFXc95uM1G2pbjJ++RRO31lM/jDmGvuBNTm1dPN0rKZ
        7KOdQL9yKjNJzYKtpH8l4sXKieDJ1z9GVvoLOzpGfAbG0Q7DKuSLp0/x1h7zww==
Received: by mail.tty42.de (OpenSMTPD) with ESMTPSA id 3b857a83 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 11 Apr 2023 14:51:16 +0000 (UTC)
Content-Type: multipart/mixed; boundary="------------MSk1ah8oc8XSTtmdl3tEu7Lz"
Message-ID: <9520740d-c014-22e3-84b2-f93121027698@pisquaredover6.de>
Date:   Tue, 11 Apr 2023 16:51:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: Regression in 6.2.10 monitors connected via MST hub stay black
Content-Language: en-US
To:     Mario Limonciello <mario.limonciello@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <8e90142e-cdc3-a4a0-754a-4c7a2388940b@pisquaredover6.de>
 <MN0PR12MB61014AE52F7F84A86F909717E2959@MN0PR12MB6101.namprd12.prod.outlook.com>
 <MN0PR12MB61011B4C8FF79D3035963095E2959@MN0PR12MB6101.namprd12.prod.outlook.com>
 <5d0f31da-add5-b0b4-2a91-57859529dd88@pisquaredover6.de>
 <fec3d50f-8d4e-6828-b480-e9ff2531faaa@amd.com>
From:   Veronika Schwan <veronika@pisquaredover6.de>
In-Reply-To: <fec3d50f-8d4e-6828-b480-e9ff2531faaa@amd.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------MSk1ah8oc8XSTtmdl3tEu7Lz
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I applied the patch to 6.2.10 and it works.

To be able to apply it, I had to adapt slightly (renamed 
'mst_output_port' to 'port'). I attached the patch I applied.

Thanks you for working on the issue!

On 11/04/2023 02.47, Mario Limonciello wrote:
> That's great, thanks!  So we do have a path to getting this fixed 
> without a revert then, it just might be a few steps.
> 
> Can you try to apply that directly to 6.2.y as well to see if it helps 
> there too?
> 
> On 4/10/23 16:35, Veronika Schwan wrote:
>> Hi,
>>
>> 6.3-rc6 alone fails the same way.
>> When the commit is added, it works.
>>
>> On 10/04/2023 21.22, Limonciello, Mario wrote:
>>> [Public]
>>>
>>> And if 6.3-rc6 fails the same way, please one more check with 6.3-rc6 
>>> + this commit:
>>> https://gitlab.freedesktop.org/agd5f/linux/-/commit/c7c4fe5d0b0a
>>>
>>>> Hi,
>>>>
>>>> Can you by chance cross reference 6.3-rc6?
>>>> It's quite possible we're missing some other commits to backport at 
>>>> the same
>>>> time.
>>>>
>>>> Thanks,
>>>>
>>>>> -----Original Message-----
>>>>> From: Veronika Schwan <veronika@pisquaredover6.de>
>>>>> Sent: Monday, April 10, 2023 14:15
>>>>> To: Zuo, Jerry <Jerry.Zuo@amd.com>
>>>>> Cc: stable@vger.kernel.org; Limonciello, Mario
>>>>> <Mario.Limonciello@amd.com>
>>>>> Subject: Regression in 6.2.10 monitors connected via MST hub stay 
>>>>> black
>>>>>
>>>>> I found a regression while updating from 6.2.9 to 6.2.10 (Arch Linux).
>>>>> After upgrading to 6.2.10, my external monitors stopped working (no
>>>>> input) when starting my display manager.
>>>>> My hardware:
>>>>> Lenovo T14s AMD gen 1
>>>>> Lenovo USB-C Dock Gen 2 40AS (firmware up to date: 13.24)
>>>>> 2 monitors connected via dock and thus via an MST hub
>>>>>
>>>>> Reverting commit d7b5638bd3374a47f0b038449118b12d8d6e391c fixes the
>>>>> issue.
>>>>>
>>>>> Best regards,
>>>>> Veronika
--------------MSk1ah8oc8XSTtmdl3tEu7Lz
Content-Type: text/x-patch; charset=UTF-8; name="c7c4fe5d0b0a.patch"
Content-Disposition: attachment; filename="c7c4fe5d0b0a.patch"
Content-Transfer-Encoding: base64

RnJvbSBjN2M0ZmU1ZDBiMGFmM2U3ZTM5ODkwNDUzZTkyMjAwNzk4MzFmZmUxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBXYXluZSBMaW4gPFdheW5lLkxpbkBhbWQuY29tPgpE
YXRlOiBGcmksIDE3IEZlYiAyMDIzIDEzOjI2OjU2ICswODAwClN1YmplY3Q6IFtQQVRDSF0g
ZHJtL2FtZC9kaXNwbGF5OiBQYXNzIHRoZSByaWdodCBpbmZvIHRvIGRybV9kcF9yZW1vdmVf
cGF5bG9hZAoKW1doeSAmIEhvd10KZHJtX2RwX3JlbW92ZV9wYXlsb2FkKCkgaW50ZXJmYWNl
IHdhcyBjaGFuZ2VkLiBDb3JyZWN0IGFtZGdwdSBkbSBjb2RlCnRvIHBhc3MgdGhlIHJpZ2h0
IHBhcmFtZXRlciB0byB0aGUgZHJtIGhlbHBlciBmdW5jdGlvbi4KClJldmlld2VkLWJ5OiBK
ZXJyeSBadW8gPEplcnJ5Llp1b0BhbWQuY29tPgpBY2tlZC1ieTogUWluZ3FpbmcgWmh1byA8
cWluZ3Fpbmcuemh1b0BhbWQuY29tPgpTaWduZWQtb2ZmLWJ5OiBXYXluZSBMaW4gPFdheW5l
LkxpbkBhbWQuY29tPgpUZXN0ZWQtYnk6IERhbmllbCBXaGVlbGVyIDxkYW5pZWwud2hlZWxl
ckBhbWQuY29tPgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVj
aGVyQGFtZC5jb20+Ci0tLQogLi4uL2FtZC9kaXNwbGF5L2FtZGdwdV9kbS9hbWRncHVfZG1f
aGVscGVycy5jIHwgNTcgKysrKysrKysrKysrKysrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDUw
IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9n
cHUvZHJtL2FtZC9kaXNwbGF5L2FtZGdwdV9kbS9hbWRncHVfZG1faGVscGVycy5jIGIvZHJp
dmVycy9ncHUvZHJtL2FtZC9kaXNwbGF5L2FtZGdwdV9kbS9hbWRncHVfZG1faGVscGVycy5j
CmluZGV4IDFiZTA0YzYxM2RlYi4uOGQ1OThiMzIyZTViIDEwMDY0NAotLS0gYS9kcml2ZXJz
L2dwdS9kcm0vYW1kL2Rpc3BsYXkvYW1kZ3B1X2RtL2FtZGdwdV9kbV9oZWxwZXJzLmMKKysr
IGIvZHJpdmVycy9ncHUvZHJtL2FtZC9kaXNwbGF5L2FtZGdwdV9kbS9hbWRncHVfZG1faGVs
cGVycy5jCkBAIC0xNzcsNiArMTc3LDQwIEBAIHZvaWQgZG1faGVscGVyc19kcF91cGRhdGVf
YnJhbmNoX2luZm8oCiAJY29uc3Qgc3RydWN0IGRjX2xpbmsgKmxpbmspCiB7fQogCitzdGF0
aWMgdm9pZCBkbV9oZWxwZXJzX2NvbnN0cnVjdF9vbGRfcGF5bG9hZCgKKwkJCXN0cnVjdCBk
Y19saW5rICpsaW5rLAorCQkJaW50IHBibl9wZXJfc2xvdCwKKwkJCXN0cnVjdCBkcm1fZHBf
bXN0X2F0b21pY19wYXlsb2FkICpuZXdfcGF5bG9hZCwKKwkJCXN0cnVjdCBkcm1fZHBfbXN0
X2F0b21pY19wYXlsb2FkICpvbGRfcGF5bG9hZCkKK3sKKwlzdHJ1Y3QgbGlua19tc3Rfc3Ry
ZWFtX2FsbG9jYXRpb25fdGFibGUgY3VycmVudF9saW5rX3RhYmxlID0KKwkJCQkJCQkJCWxp
bmstPm1zdF9zdHJlYW1fYWxsb2NfdGFibGU7CisJc3RydWN0IGxpbmtfbXN0X3N0cmVhbV9h
bGxvY2F0aW9uICpkY19hbGxvYzsKKwlpbnQgaTsKKworCSpvbGRfcGF5bG9hZCA9ICpuZXdf
cGF5bG9hZDsKKworCS8qIFNldCBjb3JyZWN0IHRpbWVfc2xvdHMvUEJOIG9mIG9sZCBwYXls
b2FkLgorCSAqIG90aGVyIGZpZWxkcyAoZGVsZXRlICYgZHNjX2VuYWJsZWQpIGluCisJICog
c3RydWN0IGRybV9kcF9tc3RfYXRvbWljX3BheWxvYWQgYXJlIGRvbid0IGNhcmUgZmllbGRz
CisJICogd2hpbGUgY2FsbGluZyBkcm1fZHBfcmVtb3ZlX3BheWxvYWQoKQorCSAqLworCWZv
ciAoaSA9IDA7IGkgPCBjdXJyZW50X2xpbmtfdGFibGUuc3RyZWFtX2NvdW50OyBpKyspIHsK
KwkJZGNfYWxsb2MgPQorCQkJJmN1cnJlbnRfbGlua190YWJsZS5zdHJlYW1fYWxsb2NhdGlv
bnNbaV07CisKKwkJaWYgKGRjX2FsbG9jLT52Y3BfaWQgPT0gbmV3X3BheWxvYWQtPnZjcGkp
IHsKKwkJCW9sZF9wYXlsb2FkLT50aW1lX3Nsb3RzID0gZGNfYWxsb2MtPnNsb3RfY291bnQ7
CisJCQlvbGRfcGF5bG9hZC0+cGJuID0gZGNfYWxsb2MtPnNsb3RfY291bnQgKiBwYm5fcGVy
X3Nsb3Q7CisJCQlicmVhazsKKwkJfQorCX0KKworCS8qIG1ha2Ugc3VyZSB0aGVyZSBpcyBh
biBvbGQgcGF5bG9hZCovCisJQVNTRVJUKGkgIT0gY3VycmVudF9saW5rX3RhYmxlLnN0cmVh
bV9jb3VudCk7CisKK30KKwogLyoKICAqIFdyaXRlcyBwYXlsb2FkIGFsbG9jYXRpb24gdGFi
bGUgaW4gaW1tZWRpYXRlIGRvd25zdHJlYW0gZGV2aWNlLgogICovCkBAIC0xODgsNyArMjIy
LDcgQEAgYm9vbCBkbV9oZWxwZXJzX2RwX21zdF93cml0ZV9wYXlsb2FkX2FsbG9jYXRpb25f
dGFibGUoCiB7CiAJc3RydWN0IGFtZGdwdV9kbV9jb25uZWN0b3IgKmFjb25uZWN0b3I7CiAJ
c3RydWN0IGRybV9kcF9tc3RfdG9wb2xvZ3lfc3RhdGUgKm1zdF9zdGF0ZTsKLQlzdHJ1Y3Qg
ZHJtX2RwX21zdF9hdG9taWNfcGF5bG9hZCAqcGF5bG9hZDsKKwlzdHJ1Y3QgZHJtX2RwX21z
dF9hdG9taWNfcGF5bG9hZCAqdGFyZ2V0X3BheWxvYWQsICpuZXdfcGF5bG9hZCwgb2xkX3Bh
eWxvYWQ7CiAJc3RydWN0IGRybV9kcF9tc3RfdG9wb2xvZ3lfbWdyICptc3RfbWdyOwogCiAJ
YWNvbm5lY3RvciA9IChzdHJ1Y3QgYW1kZ3B1X2RtX2Nvbm5lY3RvciAqKXN0cmVhbS0+ZG1f
c3RyZWFtX2NvbnRleHQ7CkBAIC0yMDQsMTcgKzIzOCwyNiBAQCBib29sIGRtX2hlbHBlcnNf
ZHBfbXN0X3dyaXRlX3BheWxvYWRfYWxsb2NhdGlvbl90YWJsZSgKIAltc3Rfc3RhdGUgPSB0
b19kcm1fZHBfbXN0X3RvcG9sb2d5X3N0YXRlKG1zdF9tZ3ItPmJhc2Uuc3RhdGUpOwogCiAJ
LyogSXQncyBPSyBmb3IgdGhpcyB0byBmYWlsICovCi0JcGF5bG9hZCA9IGRybV9hdG9taWNf
Z2V0X21zdF9wYXlsb2FkX3N0YXRlKG1zdF9zdGF0ZSwgYWNvbm5lY3Rvci0+cG9ydCk7Ci0J
aWYgKGVuYWJsZSkKLQkJZHJtX2RwX2FkZF9wYXlsb2FkX3BhcnQxKG1zdF9tZ3IsIG1zdF9z
dGF0ZSwgcGF5bG9hZCk7Ci0JZWxzZQotCQlkcm1fZHBfcmVtb3ZlX3BheWxvYWQobXN0X21n
ciwgbXN0X3N0YXRlLCBwYXlsb2FkLCBwYXlsb2FkKTsKKwluZXdfcGF5bG9hZCA9IGRybV9h
dG9taWNfZ2V0X21zdF9wYXlsb2FkX3N0YXRlKG1zdF9zdGF0ZSwgYWNvbm5lY3Rvci0+cG9y
dCk7CisKKwlpZiAoZW5hYmxlKSB7CisJCXRhcmdldF9wYXlsb2FkID0gbmV3X3BheWxvYWQ7
CisKKwkJZHJtX2RwX2FkZF9wYXlsb2FkX3BhcnQxKG1zdF9tZ3IsIG1zdF9zdGF0ZSwgbmV3
X3BheWxvYWQpOworCX0gZWxzZSB7CisJCS8qIGNvbnN0cnVjdCBvbGQgcGF5bG9hZCBieSBW
Q1BJKi8KKwkJZG1faGVscGVyc19jb25zdHJ1Y3Rfb2xkX3BheWxvYWQoc3RyZWFtLT5saW5r
LCBtc3Rfc3RhdGUtPnBibl9kaXYsCisJCQkJCQluZXdfcGF5bG9hZCwgJm9sZF9wYXlsb2Fk
KTsKKwkJdGFyZ2V0X3BheWxvYWQgPSAmb2xkX3BheWxvYWQ7CisKKwkJZHJtX2RwX3JlbW92
ZV9wYXlsb2FkKG1zdF9tZ3IsIG1zdF9zdGF0ZSwgJm9sZF9wYXlsb2FkLCBuZXdfcGF5bG9h
ZCk7CisJfQogCiAJLyogbXN0X21nci0+LT5wYXlsb2FkcyBhcmUgVkMgcGF5bG9hZCBub3Rp
ZnkgTVNUIGJyYW5jaCB1c2luZyBEUENEIG9yCiAJICogQVVYIG1lc3NhZ2UuIFRoZSBzZXF1
ZW5jZSBpcyBzbG90IDEtNjMgYWxsb2NhdGVkIHNlcXVlbmNlIGZvciBlYWNoCiAJICogc3Ry
ZWFtLiBBTUQgQVNJQyBzdHJlYW0gc2xvdCBhbGxvY2F0aW9uIHNob3VsZCBmb2xsb3cgdGhl
IHNhbWUKIAkgKiBzZXF1ZW5jZS4gY29weSBEUk0gTVNUIGFsbG9jYXRpb24gdG8gZGMgKi8K
LQlmaWxsX2RjX21zdF9wYXlsb2FkX3RhYmxlX2Zyb21fZHJtKHN0cmVhbS0+bGluaywgZW5h
YmxlLCBwYXlsb2FkLCBwcm9wb3NlZF90YWJsZSk7CisJZmlsbF9kY19tc3RfcGF5bG9hZF90
YWJsZV9mcm9tX2RybShzdHJlYW0tPmxpbmssIGVuYWJsZSwgdGFyZ2V0X3BheWxvYWQsIHBy
b3Bvc2VkX3RhYmxlKTsKIAogCXJldHVybiB0cnVlOwogfQotLSAKR2l0TGFiCgo=

--------------MSk1ah8oc8XSTtmdl3tEu7Lz--
