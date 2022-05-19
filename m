Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26FB852D217
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 14:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbiESMJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 08:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbiESMJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 08:09:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82472B8BF2
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:09:42 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id fw21-20020a17090b129500b001df9f62edd6so4339918pjb.0
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject;
        bh=hRf12vDJDNsmhHD/sq0Yz0A0wT4aO82EG3hrjRFZcd8=;
        b=AXBDd7HxOMjPkyIS6CsGRdAGoMsTZUMZ1RbUbh5DLPXgkiZ4XhKq8DdU/FdpHAAki4
         m4WuXUzdvBbibFfbMoo4faRwYFjrd7L7QEvuLoLOxE7Go7QHKGYd2GF5Ahi4aDOteQcc
         kfpbY7sP7gsVi1lGEA7PGBMfUB6B/3E3r+MMtvy1oOuNt3vYo5OWAkEFR6SRXJQHSD6n
         cjumLZj5T0vBhqzyJ/CLb8Bc3rl2xe+E3k8OY6C8w8KQt1OZphd+XrXIoUk04SrmsBSb
         IreCUw83Bf/CpxB/P3AB34JLpCPSqIcHFNa1QUHjBIeWuX4qdPTGKwhBmU97olHOBp06
         u+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject;
        bh=hRf12vDJDNsmhHD/sq0Yz0A0wT4aO82EG3hrjRFZcd8=;
        b=7LvwNmSdzIwn3Fpbkqy1Dh6CzuDDVFIi/zp3EuaWBftxb5mOf8K3LDAalgGVbR61Wx
         /xpJvRI9S9o0CF3eIl8BlA41KNuNktXajCWYWAa8D6PKpP2tZ+/ekVdAT2ky/ZvIgGjN
         h8GcC/wxGvQypx2ZJGx0FUKAaCKtCt9CcxXq9FlpLJ+lvHcaHpmmgg0BS9SDuqciE8l7
         m6TxItnrmA4An2glnQJg2iLGp2LbPTai8FFLMaVSdWfM9uqrckvXZ80FA0rwbbDIjJgc
         nFs89ZMcKflVAXV0dtLcLvaRpOkpXfawZU8qE407/af5s4qyPriG3V9MbSZwYeV4P3Ur
         5+LA==
X-Gm-Message-State: AOAM531Qr9gmGrLuTokubMqotSeJNL10QH7uRGhxCHeRi/m9c4AXh7bC
        DcITphSn3ijSpqRL+zDPAXHryp/t05ZFhw==
X-Google-Smtp-Source: ABdhPJzEivDwV+etbhbFj86T0/4rI4Y8ZB7fSzGXjy8GiSL5XANpErbdddtoHZr0rXXtgU+GWvrf+A==
X-Received: by 2002:a17:90a:4b0c:b0:1df:112:fe49 with SMTP id g12-20020a17090a4b0c00b001df0112fe49mr4883370pjh.155.1652962181532;
        Thu, 19 May 2022 05:09:41 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jh1-20020a170903328100b0015e8d4eb269sm3576688plb.179.2022.05.19.05.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 05:09:40 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------a03h1eKyH0BFG9Fr1v7AWOLV"
Message-ID: <543c3909-a7b6-23ac-2c2e-ce10dd2433e8@kernel.dk>
Date:   Thu, 19 May 2022 06:09:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lee Jones <lee.jones@linaro.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: Patch for 5.10-stable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------a03h1eKyH0BFG9Fr1v7AWOLV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

Can we get this queued up for 5.10-stable? Thanks!

-- 
Jens Axboe

--------------a03h1eKyH0BFG9Fr1v7AWOLV
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-always-grab-file-table-for-deferred-statx.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-always-grab-file-table-for-deferred-statx.patc";
 filename*1="h"
Content-Transfer-Encoding: base64

RnJvbSBiMWRhMjExODdkZTEyMWUyZWQyZGMyZTBjNzBkNWFhYmNlNDY5NjkxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFRodSwgMTkgTWF5IDIwMjIgMDY6MDU6MjcgLTA2MDAKU3ViamVjdDogW1BBVENIXSBp
b191cmluZzogYWx3YXlzIGdyYWIgZmlsZSB0YWJsZSBmb3IgZGVmZXJyZWQgc3RhdHgKCkxl
ZSByZXBvcnRzIHRoYXQgdGhlcmUncyBhIHVzZS1hZnRlci1mcmVlIG9mIHRoZSBwcm9jZXNz
IGZpbGUgdGFibGUuClRoZXJlJ3MgYW4gYXNzdW1wdGlvbiB0aGF0IHdlIGRvbid0IG5lZWQg
dGhlIGZpbGUgdGFibGUgZm9yIHNvbWUKdmFyaWFudHMgb2Ygc3RhdHggaW52b2NhdGlvbiwg
YnV0IHRoYXQgdHVybnMgb3V0IHRvIGJlIGZhbHNlIGFuZCB3ZQplbmQgdXAgd2l0aCBub3Qg
Z3JhYmJpbmcgYSByZWZlcmVuY2UgZm9yIHRoZSByZXF1ZXN0IGV2ZW4gaWYgdGhlCmRlZmVy
cmVkIGV4ZWN1dGlvbiB1c2VzIGl0LgoKR2V0IHJpZCBvZiB0aGUgUkVRX0ZfTk9fRklMRV9U
QUJMRSBvcHRpbWl6YXRpb24gZm9yIHN0YXR4LCBhbmQgYWx3YXlzCmdyYWIgdGhhdCByZWZl
cmVuY2UuCgpUaGlzIGlzc3VlcyBkb2Vzbid0IGV4aXN0IHVwc3RyZWFtIHNpbmNlIHRoZSBu
YXRpdmUgd29ya2VycyBnb3QKaW50cm9kdWNlZCB3aXRoIDUuMTIuCgpMaW5rOiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9pby11cmluZy9Zb09KJTJGVDRRUktDK2ZBWkVAZ29vZ2xlLmNv
bS8KUmVwb3J0ZWQtYnk6IExlZSBKb25lcyA8bGVlLmpvbmVzQGxpbmFyby5vcmc+ClNpZ25l
ZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KLS0tCiBmcy9pb191cmlu
Zy5jIHwgNiArLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgNSBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9pb191cmluZy5jIGIvZnMvaW9fdXJpbmcuYwpp
bmRleCA0MzMwNjAzZWFlMzUuLjNlY2Y3MTE1MWZiMSAxMDA2NDQKLS0tIGEvZnMvaW9fdXJp
bmcuYworKysgYi9mcy9pb191cmluZy5jCkBAIC00MjUyLDEyICs0MjUyLDggQEAgc3RhdGlj
IGludCBpb19zdGF0eChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgYm9vbCBmb3JjZV9ub25ibG9j
aykKIAlzdHJ1Y3QgaW9fc3RhdHggKmN0eCA9ICZyZXEtPnN0YXR4OwogCWludCByZXQ7CiAK
LQlpZiAoZm9yY2Vfbm9uYmxvY2spIHsKLQkJLyogb25seSBuZWVkIGZpbGUgdGFibGUgZm9y
IGFuIGFjdHVhbCB2YWxpZCBmZCAqLwotCQlpZiAoY3R4LT5kZmQgPT0gLTEgfHwgY3R4LT5k
ZmQgPT0gQVRfRkRDV0QpCi0JCQlyZXEtPmZsYWdzIHw9IFJFUV9GX05PX0ZJTEVfVEFCTEU7
CisJaWYgKGZvcmNlX25vbmJsb2NrKQogCQlyZXR1cm4gLUVBR0FJTjsKLQl9CiAKIAlyZXQg
PSBkb19zdGF0eChjdHgtPmRmZCwgY3R4LT5maWxlbmFtZSwgY3R4LT5mbGFncywgY3R4LT5t
YXNrLAogCQkgICAgICAgY3R4LT5idWZmZXIpOwotLSAKMi4zNS4xCgo=

--------------a03h1eKyH0BFG9Fr1v7AWOLV--
