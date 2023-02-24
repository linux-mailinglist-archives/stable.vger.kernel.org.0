Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B766A232B
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 21:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjBXUiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 15:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBXUiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 15:38:19 -0500
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Feb 2023 12:38:18 PST
Received: from zimbra.cs.ucla.edu (zimbra.cs.ucla.edu [131.179.128.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396531689B;
        Fri, 24 Feb 2023 12:38:18 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.cs.ucla.edu (Postfix) with ESMTP id B49C816007D;
        Fri, 24 Feb 2023 12:20:25 -0800 (PST)
Received: from zimbra.cs.ucla.edu ([127.0.0.1])
        by localhost (zimbra.cs.ucla.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id QG1sxi3-GO96; Fri, 24 Feb 2023 12:20:24 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.cs.ucla.edu (Postfix) with ESMTP id 8D919160081;
        Fri, 24 Feb 2023 12:20:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.9.2 zimbra.cs.ucla.edu 8D919160081
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.ucla.edu;
        s=78364E5A-2AF3-11ED-87FA-8298ECA2D365; t=1677270024;
        bh=+I+riTDtbBzhWt5sJpH7wqPIRmijrbIey5uSacAFgT4=;
        h=Content-Type:Message-ID:Date:MIME-Version:To:From:Subject;
        b=deVCVUcrJbVSwJywGU2CXVd+lLOnnOZ1iT3/KNpmyTSqk723C0jpVDzzkTh2be5M3
         xzU+bd71itubXnQ0wq5BmRyKEtQn82P8HEx+/MtNf1Ko+/NzLX5zvjsJXptH6P3oR8
         BWb8vbDe6QFlt1PnBvJpzNtTS08Z0L2ryeH1nk6c=
X-Virus-Scanned: amavisd-new at zimbra.cs.ucla.edu
Received: from zimbra.cs.ucla.edu ([127.0.0.1])
        by localhost (zimbra.cs.ucla.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bhkfZAvkwQkB; Fri, 24 Feb 2023 12:20:24 -0800 (PST)
Received: from [192.168.1.9] (cpe-172-91-119-151.socal.res.rr.com [172.91.119.151])
        by zimbra.cs.ucla.edu (Postfix) with ESMTPSA id 1DA4016007D;
        Fri, 24 Feb 2023 12:20:24 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------LZMUtxjI2VCeALvdg7n3PklB"
Message-ID: <03dac14b-ed62-3e2b-878f-b145383ea9f8@cs.ucla.edu>
Date:   Fri, 24 Feb 2023 12:20:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>, patches@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jim Meyering <meyering@fb.com>
References: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
From:   Paul Eggert <eggert@cs.ucla.edu>
Organization: UCLA Computer Science Department
Subject: Re: diffutils file mode (was Re: [PATCH 5.15 00/37] 5.15.96-rc2
 review)
In-Reply-To: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------LZMUtxjI2VCeALvdg7n3PklB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2023-02-24 11:16, Linus Torvalds wrote:
>   GNU diffutils have never actually grown the
> ability to generate those extensions

Thanks for pointing this out. I added this to our list of things to do, 
by installing the attached patch to the GNU diffutils TODO file. If this 
patch's wording isn't right, please let me know, as I haven't read this 
whole email thread, just the three emails sent directly to me.
--------------LZMUtxjI2VCeALvdg7n3PklB
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-maint-add-diff-git-TODO.patch"
Content-Disposition: attachment; filename="0001-maint-add-diff-git-TODO.patch"
Content-Transfer-Encoding: base64

RnJvbSAzZmE3MjE4NTY3YmRjZjk1OGYxMzQyYzEzYzg0OGM5ZTJmMmQzOGM1IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBQYXVsIEVnZ2VydCA8ZWdnZXJ0QGNzLnVjbGEuZWR1
PgpEYXRlOiBGcmksIDI0IEZlYiAyMDIzIDEyOjEzOjEyIC0wODAwClN1YmplY3Q6IFtQQVRD
SF0gbWFpbnQ6IGFkZCAnZGlmZiAtLWdpdCcgVE9ETwoKKiBUT0RPOiBTdWdnZXN0IGJldHRl
ciBjb21wYXRpYmlsaXR5IHdpdGggJ2dpdCBkaWZmIC1wJy4KRnJvbSBhIHN1Z2dlc3Rpb24g
YnkgTGludXMgVG9ydmFsZHMKPGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDIzLzIvMjQvNzk3
Pi4KLS0tCiBUT0RPIHwgNiArKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMo
KykKCmRpZmYgLS1naXQgYS9UT0RPIGIvVE9ETwppbmRleCA1MTMyZGU4Li4yNWZjMjJiIDEw
MDY0NAotLS0gYS9UT0RPCisrKyBiL1RPRE8KQEAgLTEsMyArMSw5IEBACitBZGQgLS1naXQg
b3B0aW9uIHRvIGdlbmVyYXRlIG91dHB1dCBjb21wYXRpYmxlIHdpdGggJ2dpdCBkaWZmIC1w
Jy4KK1RoaXMgd291bGQgYmVoYXZlIGxpa2UgJ2RpZmYgLXAnLCBleGNlcHQgdGhhdCBpdCB3
b3VsZCBhbHNvIGdlbmVyYXRlCit0aGUgZXh0ZW5kZWQgaGVhZGVycyAnb2xkIG1vZGUnLCAn
bmV3IG1vZGUnLCAnZGVsZXRlZCBmaWxlIG1vZGUnLCBhbmQKKyduZXcgZmlsZSBtb2RlJywg
YW5kIGl0IHdvdWxkIHF1b3RlIGZpbGUgbmFtZXMgd2l0aCB1bnVzdWFsIGNoYXJhY3RlcnMu
CitHTlUgcGF0Y2ggYWxyZWFkeSBwYXJzZXMgdGhpcyBmb3JtYXQuCisKIEFkZCAtLWluY2x1
ZGUgb3B0aW9uIChvcHBvc2l0ZSBvZiAtLWV4Y2x1ZGUpLgogCiBMb29rIGludG8gc2RpZmYg
aW1wcm92ZW1lbnQgaGVyZToKLS0gCjIuMzcuMgoK

--------------LZMUtxjI2VCeALvdg7n3PklB--
